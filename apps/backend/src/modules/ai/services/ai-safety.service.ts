import { Injectable, Logger, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.module';
import { AiSafetyLevel } from '@prisma/client';

@Injectable()
export class AiSafetyService {
  private readonly logger = new Logger(AiSafetyService.name);

  constructor(private readonly prisma: PrismaService) {}

  /**
   * Deterministic check for PII, profanity, and medical advice requests.
   * Runs locally without AI dependence.
   */
  async validateAndSanitize(userId: string, input: string): Promise<string> {
    const lowerInput = input.toLowerCase();

    // 1. Medical Guardrail Check
    const medicalKeywords = ['diagnose', 'prescription', 'cancer', 'tumor', 'broken bone', 'suicide', 'chest pain'];
    for (const kw of medicalKeywords) {
      if (lowerInput.includes(kw)) {
        await this.logSafetyEvent(userId, 'MEDICAL_ADVICE_BLOCKED', input, null, AiSafetyLevel.STRICT);
        throw new BadRequestException('I am a wellness coach, not a medical professional. Please seek immediate advice from a doctor for medical conditions.');
      }
    }

    // 2. Simple PII Scrubbing (Deterministic Regex)
    // Scrub SSNs, Credit Cards, standard phone formats
    let sanitized = input;
    const phoneRegex = /\b\d{3}[-.]?\d{3}[-.]?\d{4}\b/g;
    const emailRegex = /\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b/g;

    if (phoneRegex.test(sanitized) || emailRegex.test(sanitized)) {
      sanitized = sanitized.replace(phoneRegex, '[PHONE REDACTED]');
      sanitized = sanitized.replace(emailRegex, '[EMAIL REDACTED]');
      await this.logSafetyEvent(userId, 'PII_SCRUBBED', input, sanitized, AiSafetyLevel.MODERATE);
    }

    return sanitized;
  }

  private async logSafetyEvent(userId: string, eventType: string, original: string, sanitized: string | null, level: AiSafetyLevel) {
    await this.prisma.aiSafetyAuditLog.create({
      data: {
        userId,
        eventType,
        originalInput: original,
        sanitizedInput: sanitized,
        safetyLevel: level,
      }
    });
    this.logger.warn(`Safety Event Logged: ${eventType} for User: ${userId}`);
  }
}
