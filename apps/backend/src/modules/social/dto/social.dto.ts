import { ApiProperty, ApiPropertyOptional } from "@nestjs/swagger";
import {
  IsString,
  IsOptional,
  IsEnum,
  IsArray,
  IsInt,
  IsUUID,
} from "class-validator";
import {
  GroupType,
  GroupRole,
  ChallengeType,
  ReportReason,
  ChatType,
} from "@prisma/client";

export class CreateGroupDto {
  @ApiProperty()
  @IsString()
  name: string;

  @ApiPropertyOptional()
  @IsString()
  @IsOptional()
  description?: string;

  @ApiProperty({ enum: GroupType })
  @IsEnum(GroupType)
  groupType: GroupType;
}

export class CreateChallengeDto {
  @ApiProperty()
  @IsString()
  title: string;

  @ApiPropertyOptional()
  @IsString()
  @IsOptional()
  description?: string;

  @ApiProperty({ enum: ChallengeType })
  @IsEnum(ChallengeType)
  challengeType: ChallengeType;

  @ApiProperty()
  @IsString()
  startDate: string;

  @ApiProperty()
  @IsString()
  endDate: string;

  @ApiPropertyOptional()
  @IsInt()
  @IsOptional()
  rewardsXp?: number;
}

export class CreateChatConversationDto {
  @ApiProperty({ enum: ChatType })
  @IsEnum(ChatType)
  chatType: ChatType;

  @ApiPropertyOptional()
  @IsString()
  @IsOptional()
  name?: string;

  @ApiProperty()
  @IsArray()
  participantIds: string[];
}

export class SendChatMessageDto {
  @ApiProperty()
  @IsUUID()
  conversationId: string;

  @ApiPropertyOptional()
  @IsString()
  @IsOptional()
  contentText?: string;

  @ApiPropertyOptional()
  @IsString()
  @IsOptional()
  attachmentUrl?: string;
}

export class ReportContentDto {
  @ApiProperty({ enum: ReportReason })
  @IsEnum(ReportReason)
  reason: ReportReason;

  @ApiPropertyOptional()
  @IsString()
  @IsOptional()
  details?: string;

  @ApiPropertyOptional()
  @IsUUID()
  @IsOptional()
  postId?: string;

  @ApiPropertyOptional()
  @IsUUID()
  @IsOptional()
  commentId?: string;
}
