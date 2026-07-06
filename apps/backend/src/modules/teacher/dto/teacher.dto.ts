// ==============================================================================
// Yoga24X — Teacher DTOs
// All request/response DTOs with class-validator decorators
// ==============================================================================
import {
  IsString, IsOptional, IsInt, IsBoolean, IsArray, IsEnum,
  IsUrl, MaxLength, Min, Max, IsDateString, IsUUID, ValidateNested, IsNumber,
} from 'class-validator';
import { Type } from 'class-transformer';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  CertificationType, YogaSpecialization, TeachingMode,
  TeachingFormat, TeacherAgeGroup, TeacherSkillLevel, PortfolioItemType,
} from '@prisma/client';

// ── Create / Update Teacher Profile ──────────────────────────────────────────

export class CreateTeacherProfileDto {
  @ApiProperty({ example: 'RYT500 Vinyasa & Prenatal Yoga Specialist' })
  @IsString() @MaxLength(255)
  headline!: string;

  @ApiProperty({ example: 'I have been teaching yoga for 10+ years...' })
  @IsString()
  bio!: string;

  @ApiPropertyOptional()
  @IsString() @IsOptional() @MaxLength(2000)
  teachingPhilosophy?: string;

  @ApiProperty({ example: 8 })
  @IsInt() @Min(0) @Max(60)
  yearsExperience!: number;

  @ApiProperty({ example: ['English', 'Hindi'] })
  @IsArray() @IsString({ each: true })
  teachingLanguages!: string[];

  @ApiPropertyOptional({ example: 'Indian' })
  @IsString() @IsOptional() @MaxLength(100)
  nationality?: string;

  @ApiPropertyOptional({ example: 'IN' })
  @IsString() @IsOptional() @MaxLength(10)
  countryCode?: string;

  @ApiPropertyOptional({ example: 'Mumbai, Maharashtra' })
  @IsString() @IsOptional() @MaxLength(150)
  cityState?: string;

  @ApiPropertyOptional({ example: 'Asia/Kolkata' })
  @IsString() @IsOptional() @MaxLength(60)
  timezone?: string;

  @ApiPropertyOptional()
  @IsUrl() @IsOptional()
  websiteUrl?: string;
}

export class UpdateTeacherProfileDto {
  @ApiPropertyOptional()
  @IsString() @IsOptional() @MaxLength(255)
  headline?: string;

  @ApiPropertyOptional()
  @IsString() @IsOptional()
  bio?: string;

  @ApiPropertyOptional()
  @IsString() @IsOptional() @MaxLength(2000)
  teachingPhilosophy?: string;

  @ApiPropertyOptional()
  @IsInt() @Min(0) @Max(60) @IsOptional()
  yearsExperience?: number;

  @ApiPropertyOptional()
  @IsArray() @IsString({ each: true }) @IsOptional()
  teachingLanguages?: string[];

  @ApiPropertyOptional()
  @IsString() @IsOptional() @MaxLength(100)
  nationality?: string;

  @ApiPropertyOptional()
  @IsString() @IsOptional() @MaxLength(10)
  countryCode?: string;

  @ApiPropertyOptional()
  @IsString() @IsOptional() @MaxLength(150)
  cityState?: string;

  @ApiPropertyOptional()
  @IsString() @IsOptional() @MaxLength(60)
  timezone?: string;

  @ApiPropertyOptional()
  @IsUrl() @IsOptional()
  websiteUrl?: string;

  @ApiPropertyOptional()
  @IsUrl() @IsOptional()
  introVideoUrl?: string;

  @ApiPropertyOptional()
  @IsBoolean() @IsOptional()
  isPublic?: boolean;
}

// ── Teaching Preferences ──────────────────────────────────────────────────────

export class UpdateTeachingPreferenceDto {
  @ApiPropertyOptional({ enum: TeachingMode, isArray: true })
  @IsArray() @IsEnum(TeachingMode, { each: true }) @IsOptional()
  teachingModes?: TeachingMode[];

  @ApiPropertyOptional({ enum: TeachingFormat, isArray: true })
  @IsArray() @IsEnum(TeachingFormat, { each: true }) @IsOptional()
  teachingFormats?: TeachingFormat[];

  @ApiPropertyOptional({ enum: TeacherAgeGroup, isArray: true })
  @IsArray() @IsEnum(TeacherAgeGroup, { each: true }) @IsOptional()
  ageGroups?: TeacherAgeGroup[];

  @ApiPropertyOptional({ enum: TeacherSkillLevel, isArray: true })
  @IsArray() @IsEnum(TeacherSkillLevel, { each: true }) @IsOptional()
  skillLevels?: TeacherSkillLevel[];

  @ApiPropertyOptional()
  @IsInt() @Min(1) @IsOptional()
  maxGroupSize?: number;

  @ApiPropertyOptional()
  @IsInt() @Min(1) @IsOptional()
  minGroupSize?: number;

  @ApiPropertyOptional()
  @IsInt() @Min(0) @IsOptional()
  travelRadius?: number;

  @ApiPropertyOptional()
  @IsBoolean() @IsOptional()
  onlineOnly?: boolean;

  @ApiPropertyOptional()
  @IsArray() @IsInt({ each: true }) @IsOptional()
  classDurationMins?: number[];

  @ApiPropertyOptional()
  @IsArray() @IsString({ each: true }) @IsOptional()
  preferredLanguages?: string[];
}

// ── Certifications ────────────────────────────────────────────────────────────

export class AddCertificationDto {
  @ApiProperty({ enum: CertificationType })
  @IsEnum(CertificationType)
  certificationType!: CertificationType;

  @ApiProperty({ example: 'RYT 500 Certificate' })
  @IsString() @MaxLength(255)
  certificationName!: string;

  @ApiProperty({ example: 'Yoga Alliance' })
  @IsString() @MaxLength(255)
  issuingOrganization!: string;

  @ApiPropertyOptional({ example: 'YA-RYT500-2024-12345' })
  @IsString() @MaxLength(100) @IsOptional()
  certificationNumber?: string;

  @ApiPropertyOptional({ example: '2022-03-15' })
  @IsDateString() @IsOptional()
  issuedAt?: string;

  @ApiPropertyOptional({ example: '2025-03-15' })
  @IsDateString() @IsOptional()
  expiresAt?: string;

  @ApiPropertyOptional()
  @IsUrl() @IsOptional()
  documentUrl?: string;

  @ApiPropertyOptional()
  @IsInt() @Min(0) @IsOptional()
  displayOrder?: number;
}

export class UpdateCertificationDto {
  @ApiPropertyOptional()
  @IsString() @MaxLength(255) @IsOptional()
  certificationName?: string;

  @ApiPropertyOptional()
  @IsString() @MaxLength(255) @IsOptional()
  issuingOrganization?: string;

  @ApiPropertyOptional()
  @IsString() @MaxLength(100) @IsOptional()
  certificationNumber?: string;

  @ApiPropertyOptional()
  @IsDateString() @IsOptional()
  issuedAt?: string;

  @ApiPropertyOptional()
  @IsDateString() @IsOptional()
  expiresAt?: string;

  @ApiPropertyOptional()
  @IsUrl() @IsOptional()
  documentUrl?: string;

  @ApiPropertyOptional()
  @IsBoolean() @IsOptional()
  isActive?: boolean;

  @ApiPropertyOptional()
  @IsInt() @Min(0) @IsOptional()
  displayOrder?: number;
}

// ── Specializations ───────────────────────────────────────────────────────────

export class UpsertSpecializationDto {
  @ApiProperty({ enum: YogaSpecialization })
  @IsEnum(YogaSpecialization)
  specialization!: YogaSpecialization;

  @ApiPropertyOptional()
  @IsInt() @Min(0) @IsOptional()
  proficiencyYears?: number;

  @ApiPropertyOptional()
  @IsBoolean() @IsOptional()
  isPrimary?: boolean;

  @ApiPropertyOptional()
  @IsInt() @Min(0) @IsOptional()
  displayOrder?: number;
}

// ── Portfolio ─────────────────────────────────────────────────────────────────

export class AddPortfolioItemDto {
  @ApiProperty({ enum: PortfolioItemType })
  @IsEnum(PortfolioItemType)
  itemType!: PortfolioItemType;

  @ApiProperty({ example: 'International Yoga Day 2024' })
  @IsString() @MaxLength(255)
  title!: string;

  @ApiPropertyOptional()
  @IsString() @IsOptional()
  description?: string;

  @ApiPropertyOptional()
  @IsUrl() @IsOptional()
  mediaUrl?: string;

  @ApiPropertyOptional()
  @IsUrl() @IsOptional()
  externalUrl?: string;

  @ApiPropertyOptional()
  @IsDateString() @IsOptional()
  issuedAt?: string;

  @ApiPropertyOptional()
  @IsBoolean() @IsOptional()
  isFeatured?: boolean;

  @ApiPropertyOptional()
  @IsInt() @Min(0) @IsOptional()
  displayOrder?: number;
}

// ── Social Links ──────────────────────────────────────────────────────────────

export class UpsertSocialLinkDto {
  @ApiProperty({ example: 'instagram' })
  @IsString() @MaxLength(50)
  platform!: string;

  @ApiProperty({ example: 'https://instagram.com/yoga_teacher' })
  @IsUrl()
  url!: string;

  @ApiPropertyOptional()
  @IsBoolean() @IsOptional()
  isPublic?: boolean;
}

// ── Verification ──────────────────────────────────────────────────────────────

export class SubmitVerificationDto {
  @ApiProperty({ description: 'Government ID document URL (signed CDN URL)' })
  @IsUrl()
  identityDocumentUrl!: string;

  @ApiProperty({ description: 'Secondary identity document URL' })
  @IsUrl()
  identityDocumentSecondaryUrl!: string;

  @ApiPropertyOptional({ description: 'Yoga Alliance registration number for cross-check' })
  @IsString() @IsOptional()
  yogaAllianceNumber?: string;

  @ApiPropertyOptional({ description: 'Additional notes for the reviewer' })
  @IsString() @IsOptional()
  applicantNotes?: string;
}

export class ReviewVerificationDto {
  @ApiProperty({ enum: ['APPROVED', 'REJECTED'] })
  @IsEnum(['APPROVED', 'REJECTED'])
  decision!: 'APPROVED' | 'REJECTED';

  @ApiPropertyOptional()
  @IsString() @IsOptional()
  reviewNotes?: string;

  @ApiPropertyOptional()
  @IsString() @IsOptional()
  rejectionReason?: string;

  @ApiPropertyOptional()
  @IsBoolean() @IsOptional()
  identityVerified?: boolean;

  @ApiPropertyOptional()
  @IsBoolean() @IsOptional()
  certificateVerified?: boolean;
}

// ── Reviews ───────────────────────────────────────────────────────────────────

export class CreateReviewDto {
  @ApiProperty()
  @IsUUID()
  teacherUserId!: string;

  @ApiProperty({ minimum: 1, maximum: 5 })
  @IsInt() @Min(1) @Max(5)
  rating!: number;

  @ApiPropertyOptional()
  @IsString() @IsOptional()
  reviewText?: string;

  @ApiPropertyOptional({ minimum: 1, maximum: 5 })
  @IsInt() @Min(1) @Max(5) @IsOptional()
  communicationRating?: number;

  @ApiPropertyOptional({ minimum: 1, maximum: 5 })
  @IsInt() @Min(1) @Max(5) @IsOptional()
  knowledgeRating?: number;

  @ApiPropertyOptional({ minimum: 1, maximum: 5 })
  @IsInt() @Min(1) @Max(5) @IsOptional()
  punctualityRating?: number;

  @ApiPropertyOptional()
  @IsUUID() @IsOptional()
  bookingId?: string;
}

export class ReplyToReviewDto {
  @ApiProperty()
  @IsString() @MaxLength(2000)
  replyText!: string;
}

// ── Query DTOs ────────────────────────────────────────────────────────────────

export class TeacherListQueryDto {
  @ApiPropertyOptional()
  @IsInt() @Min(1) @IsOptional() @Type(() => Number)
  page?: number = 1;

  @ApiPropertyOptional()
  @IsInt() @Min(1) @Max(100) @IsOptional() @Type(() => Number)
  limit?: number = 20;

  @ApiPropertyOptional({ enum: YogaSpecialization })
  @IsEnum(YogaSpecialization) @IsOptional()
  specialization?: YogaSpecialization;

  @ApiPropertyOptional({ enum: TeachingMode })
  @IsEnum(TeachingMode) @IsOptional()
  teachingMode?: TeachingMode;

  @ApiPropertyOptional()
  @IsString() @IsOptional()
  countryCode?: string;

  @ApiPropertyOptional()
  @IsString() @IsOptional()
  language?: string;

  @ApiPropertyOptional()
  @IsNumber() @IsOptional() @Type(() => Number)
  minRating?: number;

  @ApiPropertyOptional()
  @IsString() @IsOptional()
  search?: string;
}
