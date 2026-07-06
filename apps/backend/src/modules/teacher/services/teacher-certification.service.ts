// ==============================================================================
// Yoga24X — Teacher Certification Service
// Business logic for certification lifecycle management
// ==============================================================================
import {
  Injectable,
  NotFoundException,
  ForbiddenException,
} from "@nestjs/common";
import { TeacherCertificationRepository } from "../repositories/teacher-certification.repository";
import {
  AddCertificationDto,
  UpdateCertificationDto,
} from "../dto/teacher.dto";
import { EventEmitter2 } from "@nestjs/event-emitter";
import { TeacherEventType } from "../events/teacher.events";

@Injectable()
export class TeacherCertificationService {
  constructor(
    private readonly certRepo: TeacherCertificationRepository,
    private readonly events: EventEmitter2,
  ) {}

  async addCertification(userId: string, dto: AddCertificationDto) {
    const cert = await this.certRepo.addCertification(userId, dto);
    this.events.emit(TeacherEventType.CERT_ADDED, {
      userId,
      certificationId: cert.id,
    });
    return cert;
  }

  async updateCertification(
    id: string,
    userId: string,
    dto: UpdateCertificationDto,
  ) {
    await this.assertOwnership(id, userId);
    return this.certRepo.updateCertification(id, userId, dto);
  }

  async removeCertification(id: string, userId: string) {
    await this.assertOwnership(id, userId);
    await this.certRepo.removeCertification(id, userId);
    this.events.emit(TeacherEventType.CERT_REMOVED, {
      userId,
      certificationId: id,
    });
    return { success: true };
  }

  async listCertifications(userId: string) {
    return this.certRepo.listByUser(userId);
  }

  async adminVerifyCertification(id: string, adminId: string, notes?: string) {
    const cert = await this.certRepo.findById(id);
    if (!cert) throw new NotFoundException("Certification not found");
    const updated = await this.certRepo.verifyCertification(id, adminId, notes);
    this.events.emit(TeacherEventType.CERT_VERIFIED, {
      certificationId: id,
      verifiedBy: adminId,
    });
    return updated;
  }

  async adminUnverifyCertification(
    id: string,
    adminId: string,
    notes?: string,
  ) {
    const cert = await this.certRepo.findById(id);
    if (!cert) throw new NotFoundException("Certification not found");
    return this.certRepo.unverify(id, notes);
  }

  private async assertOwnership(certId: string, userId: string) {
    const cert = await this.certRepo.findById(certId);
    if (!cert) throw new NotFoundException("Certification not found");
    if (cert.userId !== userId)
      throw new ForbiddenException("You do not own this certification");
  }
}
