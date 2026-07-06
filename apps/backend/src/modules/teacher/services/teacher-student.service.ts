import { Injectable } from '@nestjs/common';
import { TeacherStudentRepository } from '../repositories/teacher-student.repository';
import {
  UpdateRosterDto, CreateStudentNoteDto, MarkAttendanceDto,
} from '../dto/teacher-operations.dto';

@Injectable()
export class TeacherStudentService {
  constructor(private readonly studentRepo: TeacherStudentRepository) {}

  async getRoster(teacherUserId: string) {
    return this.studentRepo.getRoster(teacherUserId);
  }

  async getRosterDetail(teacherUserId: string, studentUserId: string) {
    return this.studentRepo.getRosterDetail(teacherUserId, studentUserId);
  }

  async updateRoster(teacherUserId: string, studentUserId: string, data: UpdateRosterDto) {
    return this.studentRepo.updateRoster(teacherUserId, studentUserId, data);
  }

  async createNote(teacherUserId: string, studentUserId: string, data: CreateStudentNoteDto) {
    return this.studentRepo.createNote(teacherUserId, studentUserId, data);
  }

  async markAttendance(teacherUserId: string, bookingId: string, data: MarkAttendanceDto) {
    return this.studentRepo.markAttendance(teacherUserId, bookingId, data);
  }
}
