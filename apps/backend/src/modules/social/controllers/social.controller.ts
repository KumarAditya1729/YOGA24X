import {
  Controller,
  Get,
  Post,
  Body,
  Param,
  Query,
  UseGuards,
  Request,
} from "@nestjs/common";
import { ApiTags, ApiOperation, ApiBearerAuth } from "@nestjs/swagger";
import { JwtAuthGuard } from "../../auth/guards/jwt-auth.guard";
import { RequirePermissions } from "../../security/decorators/authorization.decorators";
import { PERMISSIONS } from "../../security/constants/permissions.registry";
import { GroupService } from "../services/group.service";
import { FeedService } from "../services/feed.service";
import { CreateGroupDto } from "../dto/social.dto";

@ApiTags("Social & Community")
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller("api/v1/social")
export class SocialController {
  constructor(
    private readonly groupService: GroupService,
    private readonly feedService: FeedService,
  ) {}

  @Get("feed")
  @ApiOperation({ summary: "Get global community feed" })
  @RequirePermissions(PERMISSIONS.COMMUNITY_FEED_READ)
  async getFeed(@Query("limit") limit: string) {
    return this.feedService.getGlobalFeed(limit ? parseInt(limit, 10) : 20);
  }

  @Post("groups")
  @ApiOperation({ summary: "Create a community group" })
  @RequirePermissions(PERMISSIONS.COMMUNITY_GROUP_WRITE)
  async createGroup(@Body() data: CreateGroupDto) {
    return this.groupService.createGroup(data);
  }

  @Get("groups")
  @ApiOperation({ summary: "List community groups" })
  @RequirePermissions(PERMISSIONS.COMMUNITY_GROUP_READ)
  async listGroups(@Query("type") type?: string) {
    return this.groupService.getGroups(type);
  }

  @Post("groups/:groupId/join")
  @ApiOperation({ summary: "Join a community group" })
  @RequirePermissions(PERMISSIONS.COMMUNITY_GROUP_WRITE)
  async joinGroup(@Param("groupId") groupId: string, @Request() req: any) {
    return this.groupService.joinGroup(groupId, req.user.userId);
  }
}
