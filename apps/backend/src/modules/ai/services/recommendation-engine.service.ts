import { Injectable, Logger } from "@nestjs/common";
import { PrismaService } from "../../prisma/prisma.module";
import { CourseLevel, CourseVisibility } from "@prisma/client";

@Injectable()
export class RecommendationEngineService {
  private readonly logger = new Logger(RecommendationEngineService.name);

  constructor(private readonly prisma: PrismaService) {}

  /**
   * Deterministic Course Recommendation
   * Does NOT rely on AI or vector similarity. Uses raw SQL/Prisma matching.
   */
  async recommendCourses(userId: string, limit: number = 5) {
    // 1. Fetch user preferences (Dosha, Level, Goals)
    const profile = await this.prisma.studentProfile.findUnique({
      where: { userId },
    });

    if (!profile) {
      // Fallback to top-rated generic courses
      return this.prisma.course.findMany({
        where: { visibility: CourseVisibility.PUBLISHED },
        orderBy: { createdAt: "desc" },
        take: limit,
      });
    }

    // 2. Score courses based on rules
    // Rule: Match User Skill Level
    const targetLevel =
      profile.experienceLevel === "BEGINNER"
        ? CourseLevel.BEGINNER
        : profile.experienceLevel === "INTERMEDIATE"
          ? CourseLevel.INTERMEDIATE
          : CourseLevel.ADVANCED;

    const recommended = await this.prisma.course.findMany({
      where: {
        visibility: CourseVisibility.PUBLISHED,
        level: { in: [targetLevel, CourseLevel.ALL_LEVELS] },
      },
      orderBy: [{ createdAt: "desc" }],
      take: limit,
    });

    return recommended;
  }

  /**
   * Deterministic Teacher Recommendation
   */
  async recommendTeachers(userId: string, limit: number = 3) {
    // Rule based: find teachers with the highest rating
    return this.prisma.teacherProfile.findMany({
      orderBy: { yearsExperience: "desc" },
      take: limit,
      include: {
        user: { select: { firstName: true, lastName: true, avatarUrl: true } },
      },
    });
  }
}
