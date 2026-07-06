import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.module';
import { CoachSpecialty } from '@prisma/client';

@Injectable()
export class PromptManagerService {
  constructor(private readonly prisma: PrismaService) {}

  /**
   * Fetch a prompt template by name and substitute variables
   */
  async getPrompt(name: string, variables: Record<string, string> = {}): Promise<string> {
    const template = await this.prisma.promptTemplate.findUnique({
      where: { name },
    });

    if (!template || !template.isActive) {
      throw new NotFoundException(`Active prompt template ${name} not found`);
    }

    let content = template.content;

    // Substitute variables like {{user_name}}
    for (const variable of template.variables) {
      const value = variables[variable] || '';
      content = content.replace(new RegExp(`{{${variable}}}`, 'g'), value);
    }

    return content;
  }

  /**
   * Get the system prompt for a specific coach persona
   */
  async getCoachSystemPrompt(specialty: CoachSpecialty, variables: Record<string, string> = {}): Promise<string> {
    const templates = await this.prisma.promptTemplate.findMany({
      where: {
        specialty,
        isActive: true,
      },
      orderBy: { createdAt: 'desc' },
      take: 1,
    });

    if (templates.length === 0) {
      return `You are a specialized ${specialty} coach. Be helpful, concise, and safe.`;
    }

    let content = templates[0].content;
    for (const variable of templates[0].variables) {
      const value = variables[variable] || '';
      content = content.replace(new RegExp(`{{${variable}}}`, 'g'), value);
    }

    return content;
  }
}
