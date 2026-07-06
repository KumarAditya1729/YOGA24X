// ==============================================================================
// Yoga24X — Teacher Profile Controller
// REST API: public listing, own profile CRUD, specializations, preferences
// ==============================================================================
import {
  Controller,
  Get,
  Post,
  Put,
  Delete,
  Body,
  Param,
  Query,
  UseGuards,
  Req,
  HttpCode,
  HttpStatus,
} from "@nestjs/common";
import { ApiBearerAuth, ApiOperation, ApiTags } from "@nestjs/swagger";
import { TeacherProfileService } from "../services/teacher-profile.service";
import {
  CreateTeacherProfileDto,
  UpdateTeacherProfileDto,
  UpdateTeachingPreferenceDto,
  UpsertSpecializationDto,
  UpsertSocialLinkDto,
  TeacherListQueryDto,
} from "../dto/teacher.dto";

@ApiTags("Teachers — Profile")
@ApiBearerAuth()
@Controller("api/v1/teachers")
export class TeacherProfileController {
  constructor(private readonly profileService: TeacherProfileService) {}

  // ── Public endpoints ────────────────────────────────────────────────────────

  @Get()
  @ApiOperation({ summary: "Browse approved teacher profiles (public)" })
  listTeachers(@Query() query: TeacherListQueryDto) {
    return this.profileService.listTeachers(query);
  }

  @Get(":userId")
  @ApiOperation({ summary: "Get a public teacher profile by userId" })
  getPublicProfile(@Param("userId") userId: string, @Req() req: any) {
    return this.profileService.getPublicProfile(userId);
  }

  // ── Authenticated — own profile ─────────────────────────────────────────────

  @Get("me/profile")
  @ApiOperation({
    summary: "Get own teacher profile (full, with draft fields)",
  })
  getOwnProfile(@Req() req: any) {
    return this.profileService.getOwnProfile(req.user.userId);
  }

  @Post("me/profile")
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: "Create teacher profile" })
  createProfile(@Req() req: any, @Body() dto: CreateTeacherProfileDto) {
    return this.profileService.createProfile(req.user.userId, dto);
  }

  @Put("me/profile")
  @ApiOperation({ summary: "Update teacher profile" })
  updateProfile(@Req() req: any, @Body() dto: UpdateTeacherProfileDto) {
    return this.profileService.updateProfile(req.user.userId, dto);
  }

  // ── Specializations ─────────────────────────────────────────────────────────

  @Post("me/specializations")
  @ApiOperation({ summary: "Add or update a specialization" })
  upsertSpecialization(@Req() req: any, @Body() dto: UpsertSpecializationDto) {
    return this.profileService.upsertSpecialization(req.user.userId, dto);
  }

  @Delete("me/specializations/:specialization")
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: "Remove a specialization" })
  removeSpecialization(
    @Req() req: any,
    @Param("specialization") specialization: string,
  ) {
    return this.profileService.removeSpecialization(
      req.user.userId,
      specialization,
    );
  }

  // ── Teaching Preferences ─────────────────────────────────────────────────────

  @Put("me/teaching-preferences")
  @ApiOperation({
    summary: "Update teaching mode/format/age/skill preferences",
  })
  updatePreferences(@Req() req: any, @Body() dto: UpdateTeachingPreferenceDto) {
    return this.profileService.upsertTeachingPreference(req.user.userId, dto);
  }

  // ── Social Links ─────────────────────────────────────────────────────────────

  @Post("me/social-links")
  @ApiOperation({ summary: "Add or update a social link" })
  upsertSocialLink(@Req() req: any, @Body() dto: UpsertSocialLinkDto) {
    return this.profileService.upsertSocialLink(req.user.userId, dto);
  }

  @Delete("me/social-links/:platform")
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: "Remove a social link" })
  removeSocialLink(@Req() req: any, @Param("platform") platform: string) {
    return this.profileService.removeSocialLink(req.user.userId, platform);
  }

  // ── Featured Content ──────────────────────────────────────────────────────────

  @Post("me/featured/:contentType/:contentId")
  @ApiOperation({ summary: "Pin a course or class to profile" })
  pinContent(
    @Req() req: any,
    @Param("contentType") contentType: string,
    @Param("contentId") contentId: string,
    @Query("order") order: string,
  ) {
    return this.profileService.pinFeaturedContent(
      req.user.userId,
      contentType,
      contentId,
      parseInt(order) || 0,
    );
  }

  @Delete("me/featured/:contentId")
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: "Unpin featured content" })
  unpinContent(@Req() req: any, @Param("contentId") contentId: string) {
    return this.profileService.unpinFeaturedContent(req.user.userId, contentId);
  }
}
