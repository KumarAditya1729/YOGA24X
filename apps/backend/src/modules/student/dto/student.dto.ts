import { ApiProperty, ApiPropertyOptional } from "@nestjs/swagger";
import {
  IsString,
  IsOptional,
  IsEnum,
  IsBoolean,
  IsArray,
  IsInt,
  IsUrl,
  IsObject,
} from "class-validator";
import {
  RelationshipType,
  AchievementType,
  CourseLevel,
  DoshaType,
} from "@prisma/client";

export class UpdateStudentProfileDto {
  @ApiPropertyOptional({ enum: DoshaType })
  @IsEnum(DoshaType)
  @IsOptional()
  ayurvedicDosha?: DoshaType;

  @ApiPropertyOptional({ enum: CourseLevel })
  @IsEnum(CourseLevel)
  @IsOptional()
  experienceLevel?: CourseLevel;
}

export class CreateGuardianDto {
  @ApiProperty()
  @IsString()
  guardianUserId: string;

  @ApiProperty({ enum: RelationshipType })
  @IsEnum(RelationshipType)
  relationship: RelationshipType;

  @ApiPropertyOptional()
  @IsBoolean()
  @IsOptional()
  hasFullAccess?: boolean;
}

export class CreateEmergencyContactDto {
  @ApiProperty()
  @IsString()
  name: string;

  @ApiProperty({ enum: RelationshipType })
  @IsEnum(RelationshipType)
  relationship: RelationshipType;

  @ApiProperty()
  @IsString()
  phone: string;

  @ApiPropertyOptional()
  @IsString()
  @IsOptional()
  email?: string;

  @ApiPropertyOptional()
  @IsBoolean()
  @IsOptional()
  isPrimary?: boolean;
}

export class UpdateMedicalVisibilityDto {
  @ApiPropertyOptional()
  @IsBoolean()
  @IsOptional()
  shareWithTeachers?: boolean;

  @ApiPropertyOptional()
  @IsBoolean()
  @IsOptional()
  shareWithDoctors?: boolean;

  @ApiPropertyOptional()
  @IsBoolean()
  @IsOptional()
  shareWithNutritionist?: boolean;

  @ApiPropertyOptional()
  @IsBoolean()
  @IsOptional()
  allowAiAnalysis?: boolean;

  @ApiPropertyOptional()
  @IsArray()
  @IsOptional()
  restrictedFields?: string[];
}

export class UpdateStudentPreferenceDto {
  @ApiPropertyOptional()
  @IsArray()
  @IsOptional()
  preferredTeacherIds?: string[];

  @ApiPropertyOptional()
  @IsArray()
  @IsOptional()
  preferredStyles?: string[];

  @ApiPropertyOptional()
  @IsArray()
  @IsOptional()
  preferredClassTimes?: string[];

  @ApiPropertyOptional()
  @IsArray()
  @IsOptional()
  preferredLanguages?: string[];

  @ApiPropertyOptional()
  @IsArray()
  @IsOptional()
  musicPreferences?: string[];

  @ApiPropertyOptional()
  @IsObject()
  @IsOptional()
  notificationPreferences?: Record<string, any>;
}

export class CreateStudentAchievementDto {
  @ApiProperty({ enum: AchievementType })
  @IsEnum(AchievementType)
  achievementType: AchievementType;

  @ApiProperty()
  @IsString()
  title: string;

  @ApiPropertyOptional()
  @IsString()
  @IsOptional()
  description?: string;

  @ApiPropertyOptional()
  @IsUrl()
  @IsOptional()
  iconUrl?: string;

  @ApiPropertyOptional()
  @IsInt()
  @IsOptional()
  xpEarned?: number;

  @ApiPropertyOptional()
  @IsInt()
  @IsOptional()
  levelReached?: number;
}
