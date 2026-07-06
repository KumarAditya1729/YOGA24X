import { Injectable, NotFoundException } from "@nestjs/common";
import { StudentHealthRepository } from "../repositories/student-health.repository";
import { UpdateMedicalVisibilityDto } from "../dto/student.dto";
import { Prisma } from "@prisma/client";

@Injectable()
export class StudentHealthService {
  constructor(private readonly healthRepository: StudentHealthRepository) {}

  async getHealthProfile(userId: string) {
    const profile = await this.healthRepository.getHealthProfile(userId);
    if (!profile) throw new NotFoundException("Health profile not found");
    return profile;
  }

  async getWellnessAssessments(userId: string) {
    return this.healthRepository.getWellnessAssessments(userId);
  }

  async getTimelineLogs(userId: string) {
    return this.healthRepository.getTimelineLogs(userId);
  }

  async addTimelineLog(userId: string, data: any) {
    return this.healthRepository.addTimelineLog({
      userId,
      ...data,
      logDate: new Date(),
    });
  }

  async getMedicalVisibility(userId: string) {
    return this.healthRepository.getMedicalVisibility(userId);
  }

  async updateMedicalVisibility(
    userId: string,
    dto: UpdateMedicalVisibilityDto,
  ) {
    return this.healthRepository.updateMedicalVisibility(userId, {
      ...dto,
      restrictedFieldsJson: dto.restrictedFields
        ? JSON.stringify(dto.restrictedFields)
        : undefined,
    });
  }
}
