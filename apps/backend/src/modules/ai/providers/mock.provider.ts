import { Injectable } from "@nestjs/common";
import {
  AiProvider,
  AiChatRequest,
  AiChatResponse,
} from "../interfaces/ai-provider.interface";
import { AiProviderType, AiModelRole } from "@prisma/client";

@Injectable()
export class MockProvider implements AiProvider {
  getProviderType(): AiProviderType {
    return AiProviderType.MOCK;
  }

  getPriority(): number {
    return 1000; // Lowest priority, absolute last resort fallback
  }

  getSupportedRoles(): AiModelRole[] {
    return [AiModelRole.CHAT, AiModelRole.COACH, AiModelRole.REASONING];
  }

  async isAvailable(): Promise<boolean> {
    return true; // Mock provider is ALWAYS available
  }

  async chat(request: AiChatRequest): Promise<AiChatResponse> {
    const lastMessage = request.messages[request.messages.length - 1];

    // Simulate slight delay
    await new Promise((resolve) => setTimeout(resolve, 300));

    return {
      content: `[MOCK] I received your message: "${lastMessage.content}". This is a fallback deterministic response since no real AI provider is configured or available.`,
      provider: AiProviderType.MOCK,
      tokensUsed: 10,
      latencyMs: 300,
    };
  }
}
