
import { IsString, IsOptional, IsEnum, IsArray, IsNumber, IsBoolean, IsDateString } from 'class-validator';

export class CreateEventDto {
  @IsString()
  title: string;
}
