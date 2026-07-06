import { Injectable } from "@nestjs/common";
import { PrismaService } from "../../prisma/prisma.module";

@Injectable()
export class StudentRepository {
  constructor(private prisma: PrismaService) {}
}
