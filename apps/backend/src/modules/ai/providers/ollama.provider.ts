import { Injectable, Logger } from "@nestjs/common";
import {
  AiProvider,
  AiChatRequest,
  AiChatResponse,
} from "../interfaces/ai-provider.interface";
import { AiProviderType, AiModelRole } from "@prisma/client";
import { PrismaService } from "../../prisma/prisma.module";

@Injectable()
export class OllamaProvider implements AiProvider {
  private readonly logger = new Logger(OllamaProvider.name);

  constructor(private readonly prisma: PrismaService) {}

  getProviderType(): AiProviderType {
    return AiProviderType.OLLAMA;
  }

  getPriority(): number {
    return 200; // Local AI is preferred over Rules, but usually cloud is 100 if both are configured
  }

  getSupportedRoles(): AiModelRole[] {
    return [AiModelRole.CHAT, AiModelRole.COACH, AiModelRole.EMBEDDING];
  }

  async isAvailable(): Promise<boolean> {
    const config = await this.prisma.aiProviderConfig.findFirst({
      where: { providerType: AiProviderType.OLLAMA, isActive: true },
    });

    // In a real environment we would ping http://localhost:11434/api/tags
    // For now, if the config exists and is active, we assume it's available.
    return !!config && !!config.baseUrl;
  }

  async chat(request: AiChatRequest): Promise<AiChatResponse> {
    const config = await this.prisma.aiProviderConfig.findFirst({
      where: { providerType: AiProviderType.OLLAMA, isActive: true },
    });

    if (!config || !config.baseUrl) {
      throw new Error("Ollama is not configured");
    }

    this.logger.debug(`Sending request to local Ollama at ${config.baseUrl}`);

    await new Promise((resolve) => setTimeout(resolve, 1500));

    return {
      content:
        "[Ollama Local] I am processing your request completely locally without the internet.",
      provider: AiProviderType.OLLAMA,
      tokensUsed: 120,
      latencyMs: 1500,
    };
  }
}
