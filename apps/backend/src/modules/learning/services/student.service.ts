
import { Injectable } from '@nestjs/common';
import { StudentRepository } from '../repositories/student.repository';

@Injectable()
export class StudentService {
  constructor(private readonly repository: StudentRepository) {}
}
