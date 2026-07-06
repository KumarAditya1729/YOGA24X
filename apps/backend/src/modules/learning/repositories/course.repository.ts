import { Injectable } from "@nestjs/common";
import { PrismaService } from "../../prisma/prisma.module";

@Injectable()
export class CourseRepository {
  constructor(private prisma: PrismaService) {}
}
