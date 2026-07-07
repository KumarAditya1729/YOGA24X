import { Controller, Get, Query, UseGuards } from "@nestjs/common";
import { ApiTags, ApiOperation, ApiBearerAuth } from "@nestjs/swagger";
import { JwtAuthGuard } from "../../auth/guards/jwt-auth.guard";
import { RequirePermissions } from "../../security/decorators/authorization.decorators";
import { PERMISSIONS } from "../../security/constants/permissions.registry";
import { LeaderboardService } from "../services/leaderboard.service";

@ApiTags("Leaderboard")
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller("leaderboards")
export class LeaderboardController {
  constructor(private readonly leaderboardService: LeaderboardService) {}

  @Get()
  @ApiOperation({ summary: "Get a leaderboard by category" })
  @RequirePermissions(PERMISSIONS.LEADERBOARD_READ)
  async getLeaderboard(
    @Query("category") category: string = "global",
    @Query("limit") limit: string = "100",
  ) {
    return this.leaderboardService.getLeaderboard(
      category,
      parseInt(limit, 10),
    );
  }
}
