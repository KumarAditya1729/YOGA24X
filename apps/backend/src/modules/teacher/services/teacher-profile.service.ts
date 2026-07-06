// ==============================================================================
// Yoga24X — Teacher Profile Service
// Core business logic for professional profile management
// ==============================================================================
import {
  Injectable, NotFoundException, ConflictException, ForbiddenException,
} from '@nestjs/common';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { TeacherProfileRepository } from '../repositories/teacher-profile.repository';
import {
  CreateTeacherProfileDto, UpdateTeacherProfileDto,
  UpdateTeachingPreferenceDto, UpsertSpecializationDto,
  UpsertSocialLinkDto, TeacherListQueryDto,
} from '../dto/teacher.dto';
import { TeacherEventType } from '../events/teacher.events';
import { randomUUID } from 'crypto';

@Injectable()
export class TeacherProfileService {
  constructor(
    private readonly repo: TeacherProfileRepository,
    private readonly events: EventEmitter2,
  ) {}

  async createProfile(userId: string, dto: CreateTeacherProfileDto) {
    const existing = await this.repo.findByUserId(userId);
    if (existing) throw new ConflictException('Teacher profile already exists');

    const profile = await this.repo.create(userId, dto);

    this.events.emit(TeacherEventType.PROFILE_CREATED, {
      type: TeacherEventType.PROFILE_CREATED,
      userId,
      timestamp: new Date(),
      correlationId: randomUUID(),
    });

    return profile;
  }

  async getOwnProfile(userId: string) {
    const profile = await this.repo.findByUserId(userId);
    if (!profile) throw new NotFoundException('Teacher profile not found');
    return profile;
  }

  async getPublicProfile(userId: string) {
    const profile = await this.repo.findPublicById(userId);
    if (!profile) throw new NotFoundException('Teacher profile not found or not yet approved');
    return profile;
  }

  async updateProfile(userId: string, dto: UpdateTeacherProfileDto) {
    await this.ensureProfileExists(userId);
    const updated = await this.repo.update(userId, dto);

    // Recalculate profile completion
    const completion = this.computeProfileCompletion(updated as any);
    await this.repo.updateProfileCompletion(userId, completion);

    this.events.emit(TeacherEventType.PROFILE_UPDATED, {
      type: TeacherEventType.PROFILE_UPDATED,
      userId,
      timestamp: new Date(),
      correlationId: randomUUID(),
    });

    return { ...updated, profileCompletion: completion };
  }

  async listTeachers(query: TeacherListQueryDto) {
    return this.repo.list(query);
  }

  async upsertSpecialization(userId: string, dto: UpsertSpecializationDto) {
    await this.ensureProfileExists(userId);
    return this.repo.upsertSpecialization(userId, dto);
  }

  async removeSpecialization(userId: string, specialization: string) {
    await this.ensureProfileExists(userId);
    return this.repo.removeSpecialization(userId, specialization);
  }

  async upsertTeachingPreference(userId: string, dto: UpdateTeachingPreferenceDto) {
    await this.ensureProfileExists(userId);
    return this.repo.upsertTeachingPreference(userId, dto);
  }

  async upsertSocialLink(userId: string, dto: UpsertSocialLinkDto) {
    await this.ensureProfileExists(userId);
    return this.repo.upsertSocialLink(userId, dto);
  }

  async removeSocialLink(userId: string, platform: string) {
    return this.repo.removeSocialLink(userId, platform);
  }

  async pinFeaturedContent(userId: string, contentType: string, contentId: string, order: number) {
    await this.ensureProfileExists(userId);
    return this.repo.pinFeaturedContent(userId, contentType, contentId, order);
  }

  async unpinFeaturedContent(userId: string, contentId: string) {
    return this.repo.unpinFeaturedContent(userId, contentId);
  }

  // ── Private helpers ──────────────────────────────────────────────────────────

  private async ensureProfileExists(userId: string) {
    const profile = await this.repo.findByUserId(userId);
    if (!profile) throw new NotFoundException('Teacher profile not found. Create it first.');
    return profile;
  }

  private computeProfileCompletion(profile: {
    headline?: string | null;
    bio?: string | null;
    teachingPhilosophy?: string | null;
    introVideoUrl?: string | null;
    certifications?: unknown[];
    specializations?: unknown[];
    portfolioItems?: unknown[];
    socialLinks?: unknown[];
    teachingPreference?: unknown | null;
    timezone?: string | null;
    nationality?: string | null;
    countryCode?: string | null;
  }): number {
    const checks: boolean[] = [
      Boolean(profile.headline),
      Boolean(profile.bio && profile.bio.length > 100),
      Boolean(profile.teachingPhilosophy),
      Boolean(profile.introVideoUrl),
      (profile.certifications?.length ?? 0) > 0,
      (profile.specializations?.length ?? 0) >= 2,
      (profile.portfolioItems?.length ?? 0) >= 3,
      (profile.socialLinks?.length ?? 0) > 0,
      Boolean(profile.teachingPreference),
      Boolean(profile.timezone),
      Boolean(profile.nationality),
      Boolean(profile.countryCode),
    ];
    const completed = checks.filter(Boolean).length;
    return Math.round((completed / checks.length) * 100);
  }
}
