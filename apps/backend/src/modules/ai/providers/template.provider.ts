import { Injectable } from '@nestjs/common';
import { AiProvider, AiChatRequest, AiChatResponse } from '../interfaces/ai-provider.interface';
import { AiProviderType, AiModelRole } from '@prisma/client';
import { PrismaService } from '../../prisma/prisma.module';

@Injectable()
export class TemplateProvider implements AiProvider {
  constructor(private readonly prisma: PrismaService) {}

  getProviderType(): AiProviderType {
    return AiProviderType.TEMPLATE;
  }

  getPriority(): number {
    return 800; // Better than mock and rule-based, but worse than actual LLMs
  }

  getSupportedRoles(): AiModelRole[] {
    return [AiModelRole.CHAT, AiModelRole.COACH];
  }

  async isAvailable(): Promise<boolean> {
    return true; 
  }

  async chat(request: AiChatRequest): Promise<AiChatResponse> {
    const lastMessage = request.messages[request.messages.length - 1].content.toLowerCase();
    
    // We will look for a template match in the DB based on keywords in the prompt content.
    // Since we don't have a semantic engine running, we do a basic LIKE search for deterministic results.
    const templates = await this.prisma.promptTemplate.findMany({
      where: { isActive: true },
    });

    let bestMatch = templates.find((t: any) => 
      t.variables.some((v: any) => lastMessage.includes(v.toLowerCase()))
    );

    let responseContent = bestMatch 
      ? `[Template matched: ${bestMatch.name}] \n${bestMatch.content}` 
      : "I cannot find a matching template for your request. Please try rephrasing.";

    return {
      content: responseContent,
      provider: AiProviderType.TEMPLATE,
      tokensUsed: 0,
      latencyMs: 50,
    };
  }
}
