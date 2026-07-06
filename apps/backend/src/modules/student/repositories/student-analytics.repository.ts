import { Injectable } from "@nestjs/common";
import { PrismaService } from "../../prisma/prisma.module";
import { Prisma } from "@prisma/client";

@Injectable()
export class StudentAnalyticsRepository {
  constructor(private readonly prisma: PrismaService) {}

  async getSnapshots(userId: string, limit: number = 7) {
    return this.prisma.studentAnalyticsSnapshot.findMany({
      where: { userId },
      orderBy: { snapshotDate: "desc" },
      take: limit,
    });
  }

  async saveSnapshot(
    data: Prisma.StudentAnalyticsSnapshotUncheckedCreateInput,
  ) {
    return this.prisma.studentAnalyticsSnapshot.create({
      data,
    });
  }
}
