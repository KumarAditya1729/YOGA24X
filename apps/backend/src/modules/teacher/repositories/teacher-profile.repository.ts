// ==============================================================================
// Yoga24X — Teacher Profile Repository
// All DB operations for TeacherProfile, specializations, preferences, social links
// ==============================================================================
import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.module';
import {
  CreateTeacherProfileDto, UpdateTeacherProfileDto,
  UpdateTeachingPreferenceDto, UpsertSpecializationDto,
  UpsertSocialLinkDto, TeacherListQueryDto,
} from '../dto/teacher.dto';

const FULL_PROFILE_INCLUDE = {
  certifications: { where: { isActive: true }, orderBy: { displayOrder: 'asc' as const } },
  specializations: { orderBy: { displayOrder: 'asc' as const } },
  teachingPreference: true,
  portfolioItems: { orderBy: { displayOrder: 'asc' as const } },
  socialLinks: { where: { isPublic: true } },
  stats: true,
  verification: { select: { status: true, identityVerified: true, certificateVerified: true, lastSubmittedAt: true } },
  featuredContent: { orderBy: { displayOrder: 'asc' as const } },
  user: { select: { firstName: true, lastName: true, avatarUrl: true, email: true } },
} as const;

@Injectable()
export class TeacherProfileRepository {
  constructor(private readonly prisma: PrismaService) {}

  async create(userId: string, dto: CreateTeacherProfileDto) {
    return this.prisma.teacherProfile.create({
      data: {
        userId,
        headline: dto.headline,
        bio: dto.bio,
        teachingPhilosophy: dto.teachingPhilosophy,
        yearsExperience: dto.yearsExperience,
        teachingLanguages: dto.teachingLanguages,
        nationality: dto.nationality,
        countryCode: dto.countryCode,
        cityState: dto.cityState,
        timezone: dto.timezone,
        websiteUrl: dto.websiteUrl,
        stats: { create: {} }, // Initialize stats row
      },
      include: FULL_PROFILE_INCLUDE,
    });
  }

  async findByUserId(userId: string) {
    return this.prisma.teacherProfile.findUnique({
      where: { userId },
      include: FULL_PROFILE_INCLUDE,
    });
  }

  async findPublicById(userId: string) {
    return this.prisma.teacherProfile.findFirst({
      where: { userId, isPublic: true, verificationStatus: 'APPROVED' },
      include: FULL_PROFILE_INCLUDE,
    });
  }

  async update(userId: string, dto: UpdateTeacherProfileDto) {
    return this.prisma.teacherProfile.update({
      where: { userId },
      data: {
        ...dto,
        updatedAt: new Date(),
      },
      include: FULL_PROFILE_INCLUDE,
    });
  }

  async updateProfileCompletion(userId: string, percentage: number) {
    return this.prisma.teacherProfile.update({
      where: { userId },
      data: { profileCompletion: Math.min(100, Math.max(0, percentage)) },
    });
  }

  async list(query: TeacherListQueryDto) {
    const { page = 1, limit = 20, specialization, teachingMode, countryCode, language, minRating, search } = query;
    const skip = (page - 1) * limit;

    const where: Record<string, unknown> = {
      isPublic: true,
      verificationStatus: 'APPROVED',
    };

    if (countryCode) where['countryCode'] = countryCode;
    if (language) where['teachingLanguages'] = { has: language };
    if (minRating) where['stats'] = { averageRating: { gte: minRating } };
    if (specialization) {
      where['specializations'] = { some: { specialization } };
    }
    if (teachingMode) {
      where['teachingPreference'] = { teachingModes: { has: teachingMode } };
    }
    if (search) {
      where['OR'] = [
        { headline: { contains: search, mode: 'insensitive' } },
        { bio: { contains: search, mode: 'insensitive' } },
        { user: { firstName: { contains: search, mode: 'insensitive' } } },
        { user: { lastName: { contains: search, mode: 'insensitive' } } },
      ];
    }

    const [data, total] = await Promise.all([
      this.prisma.teacherProfile.findMany({
        where,
        skip,
        take: limit,
        orderBy: [{ isFeatured: 'desc' }, { stats: { averageRating: 'desc' } }],
        include: {
          specializations: { take: 3, orderBy: { isPrimary: 'desc' } },
          stats: true,
          user: { select: { firstName: true, lastName: true, avatarUrl: true } },
          verification: { select: { status: true } },
        },
      }),
      this.prisma.teacherProfile.count({ where }),
    ]);

    return { data, total, page, limit, totalPages: Math.ceil(total / limit) };
  }

  async upsertSpecialization(userId: string, dto: UpsertSpecializationDto) {
    return this.prisma.teacherSpecialization.upsert({
      where: { uq_teacher_specialization: { userId, specialization: dto.specialization } },
      create: {
        userId,
        specialization: dto.specialization,
        proficiencyYears: dto.proficiencyYears ?? 0,
        isPrimary: dto.isPrimary ?? false,
        displayOrder: dto.displayOrder ?? 0,
      },
      update: {
        proficiencyYears: dto.proficiencyYears,
        isPrimary: dto.isPrimary,
        displayOrder: dto.displayOrder,
      },
    });
  }

  async removeSpecialization(userId: string, specialization: string) {
    return this.prisma.teacherSpecialization.deleteMany({
      where: { userId, specialization: specialization as any },
    });
  }

  async upsertTeachingPreference(userId: string, dto: UpdateTeachingPreferenceDto) {
    return this.prisma.teacherTeachingPreference.upsert({
      where: { userId },
      create: { userId, ...dto },
      update: { ...dto },
    });
  }

  async upsertSocialLink(userId: string, dto: UpsertSocialLinkDto) {
    return this.prisma.teacherSocialLink.upsert({
      where: { uq_teacher_social_platform: { userId, platform: dto.platform } },
      create: { userId, platform: dto.platform, url: dto.url, isPublic: dto.isPublic ?? true },
      update: { url: dto.url, isPublic: dto.isPublic },
    });
  }

  async removeSocialLink(userId: string, platform: string) {
    return this.prisma.teacherSocialLink.deleteMany({ where: { userId, platform } });
  }

  async pinFeaturedContent(userId: string, contentType: string, contentId: string, displayOrder: number) {
    return this.prisma.teacherFeaturedContent.upsert({
      where: { uq_teacher_featured_content: { userId, contentType, contentId } },
      create: { userId, contentType, contentId, displayOrder },
      update: { displayOrder },
    });
  }

  async unpinFeaturedContent(userId: string, contentId: string) {
    return this.prisma.teacherFeaturedContent.deleteMany({ where: { userId, contentId } });
  }

  async setVerificationStatus(
    userId: string,
    status: string,
    extra?: { approvedBy?: string; rejectionReason?: string },
  ) {
    return this.prisma.teacherProfile.update({
      where: { userId },
      data: {
        verificationStatus: status as any,
        approvedAt: status === 'APPROVED' ? new Date() : undefined,
        approvedBy: extra?.approvedBy,
        rejectionReason: extra?.rejectionReason,
      },
    });
  }
}
