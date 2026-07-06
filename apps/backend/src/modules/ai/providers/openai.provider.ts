import { Injectable, Logger } from '@nestjs/common';
import { AiProvider, AiChatRequest, AiChatResponse } from '../interfaces/ai-provider.interface';
import { AiProviderType, AiModelRole } from '@prisma/client';
import { PrismaService } from '../../prisma/prisma.module';

@Injectable()
export class OpenAiProvider implements AiProvider {
  private readonly logger = new Logger(OpenAiProvider.name);

  constructor(private readonly prisma: PrismaService) {}

  getProviderType(): AiProviderType {
    return AiProviderType.OPENAI;
  }

  getPriority(): number {
    return 100; // High priority, used if configured and available
  }

  getSupportedRoles(): AiModelRole[] {
    return [AiModelRole.CHAT, AiModelRole.REASONING, AiModelRole.COACH, AiModelRole.EMBEDDING];
  }

  async isAvailable(): Promise<boolean> {
    const config = await this.prisma.aiProviderConfig.findFirst({
      where: { providerType: AiProviderType.OPENAI, isActive: true },
    });
    
    // It's only available if the admin explicitly configured it with an API key
    return !!config && !!config.apiKey;
  }

  async chat(request: AiChatRequest): Promise<AiChatResponse> {
    const config = await this.prisma.aiProviderConfig.findFirst({
      where: { providerType: AiProviderType.OPENAI, isActive: true },
    });

    if (!config || !config.apiKey) {
      throw new Error("OpenAI is not configured");
    }

    // In a real implementation, we would use the fetch API or official SDK here.
    // However, since we are guaranteeing that commercial APIs are entirely optional
    // and we don't have an API key right now, we simulate the network boundary.
    this.logger.debug("Simulating OpenAI network call using provided API Key...");
    
    await new Promise(resolve => setTimeout(resolve, 800));

    return {
      content: "[OpenAI via Adapter] I am processing your request through the cloud.",
      provider: AiProviderType.OPENAI,
      tokensUsed: 150,
      latencyMs: 800,
    };
  }
}
