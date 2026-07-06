// ==============================================================================
// Yoga24X — Teacher Certification Repository
// All DB operations for TeacherCertification
// ==============================================================================
import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.module';
import { AddCertificationDto, UpdateCertificationDto } from '../dto/teacher.dto';

@Injectable()
export class TeacherCertificationRepository {
  constructor(private readonly prisma: PrismaService) {}

  async addCertification(userId: string, dto: AddCertificationDto) {
    return this.prisma.teacherCertification.create({
      data: {
        userId,
        certificationType: dto.certificationType,
        certificationName: dto.certificationName,
        issuingOrganization: dto.issuingOrganization,
        certificationNumber: dto.certificationNumber,
        issuedAt: dto.issuedAt ? new Date(dto.issuedAt) : undefined,
        expiresAt: dto.expiresAt ? new Date(dto.expiresAt) : undefined,
        documentUrl: dto.documentUrl,
        displayOrder: dto.displayOrder ?? 0,
      },
    });
  }

  async updateCertification(id: string, userId: string, dto: UpdateCertificationDto) {
    return this.prisma.teacherCertification.update({
      where: { id },
      data: {
        ...dto,
        issuedAt: dto.issuedAt ? new Date(dto.issuedAt) : undefined,
        expiresAt: dto.expiresAt ? new Date(dto.expiresAt) : undefined,
        updatedAt: new Date(),
      },
    });
  }

  async removeCertification(id: string, userId: string) {
    return this.prisma.teacherCertification.deleteMany({
      where: { id, userId },
    });
  }

  async listByUser(userId: string) {
    return this.prisma.teacherCertification.findMany({
      where: { userId, isActive: true },
      orderBy: { displayOrder: 'asc' },
    });
  }

  async findById(id: string) {
    return this.prisma.teacherCertification.findUnique({ where: { id } });
  }

  async verifyCertification(id: string, verifiedBy: string, notes?: string) {
    return this.prisma.teacherCertification.update({
      where: { id },
      data: {
        isVerified: true,
        verifiedAt: new Date(),
        verifiedBy,
        verificationNotes: notes,
      },
    });
  }

  async unverify(id: string, notes?: string) {
    return this.prisma.teacherCertification.update({
      where: { id },
      data: {
        isVerified: false,
        verifiedAt: null,
        verifiedBy: null,
        verificationNotes: notes,
      },
    });
  }

  async countVerified(userId: string): Promise<number> {
    return this.prisma.teacherCertification.count({
      where: { userId, isActive: true, isVerified: true },
    });
  }
}
