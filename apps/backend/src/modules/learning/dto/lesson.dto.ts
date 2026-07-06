
import { IsString, IsOptional, IsEnum, IsArray, IsNumber, IsBoolean, IsDateString } from 'class-validator';

export class CreateLessonDto {
  @IsString()
  title: string;
}
