import { Injectable, NotFoundException } from '@nestjs/common';
import { StudentRepository } from '../repositories/student.repository';
import { 
  UpdateStudentProfileDto, 
  CreateGuardianDto, 
  CreateEmergencyContactDto,
  UpdateStudentPreferenceDto,
  CreateStudentAchievementDto
} from '../dto/student.dto';

@Injectable()
export class StudentService {
  constructor(private readonly studentRepository: StudentRepository) {}

  async getProfile(userId: string) {
    const profile = await this.studentRepository.getProfile(userId);
    if (!profile) throw new NotFoundException('Student profile not found');
    return profile;
  }

  async updateProfile(userId: string, dto: UpdateStudentProfileDto) {
    return this.studentRepository.updateProfile(userId, dto);
  }

  async getPreferences(userId: string) {
    return this.studentRepository.getPreferences(userId);
  }

  async updatePreferences(userId: string, dto: UpdateStudentPreferenceDto) {
    return this.studentRepository.updatePreferences(userId, dto);
  }

  async getAchievements(userId: string) {
    return this.studentRepository.getAchievements(userId);
  }

  async awardAchievement(userId: string, dto: CreateStudentAchievementDto) {
    return this.studentRepository.createAchievement({
      userId,
      ...dto,
    });
  }

  async getGuardians(userId: string) {
    return this.studentRepository.getGuardians(userId);
  }

  async setGuardian(userId: string, dto: CreateGuardianDto) {
    return this.studentRepository.setGuardian({
      studentUserId: userId,
      guardianUserId: dto.guardianUserId,
      relationship: dto.relationship,
      hasFullAccess: dto.hasFullAccess ?? true,
    });
  }

  async getEmergencyContacts(userId: string) {
    return this.studentRepository.getEmergencyContacts(userId);
  }

  async addEmergencyContact(userId: string, dto: CreateEmergencyContactDto) {
    return this.studentRepository.addEmergencyContact({
      userId,
      ...dto,
    });
  }
}
