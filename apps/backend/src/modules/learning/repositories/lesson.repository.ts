
import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.module';

@Injectable()
export class LessonRepository {
  constructor(private prisma: PrismaService) {}
}
