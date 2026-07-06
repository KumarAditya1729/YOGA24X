import { Injectable } from "@nestjs/common";
import { PrismaService } from "../../prisma/prisma.module";

@Injectable()
export class EventRepository {
  constructor(private prisma: PrismaService) {}
}
