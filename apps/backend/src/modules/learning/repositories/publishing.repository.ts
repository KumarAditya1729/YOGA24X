import { Injectable } from "@nestjs/common";
import { PrismaService } from "../../prisma/prisma.module";

@Injectable()
export class PublishingRepository {
  constructor(private prisma: PrismaService) {}
}
