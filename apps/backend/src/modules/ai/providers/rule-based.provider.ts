import { Injectable } from "@nestjs/common";
import {
  AiProvider,
  AiChatRequest,
  AiChatResponse,
} from "../interfaces/ai-provider.interface";
import { AiProviderType, AiModelRole } from "@prisma/client";

@Injectable()
export class RuleBasedProvider implements AiProvider {
  getProviderType(): AiProviderType {
    return AiProviderType.RULE_BASED;
  }

  getPriority(): number {
    return 900; // Low priority, used when better models fail
  }

  getSupportedRoles(): AiModelRole[] {
    return [AiModelRole.CHAT, AiModelRole.COACH];
  }

  async isAvailable(): Promise<boolean> {
    return true; // Always available since it's local logic
  }

  async chat(request: AiChatRequest): Promise<AiChatResponse> {
    const lastMessage =
      request.messages[request.messages.length - 1].content.toLowerCase();
    let responseContent =
      "I'm not sure I understand. Could you rephrase your question regarding your wellness journey?";

    if (
      lastMessage.includes("yoga") ||
      lastMessage.includes("pose") ||
      lastMessage.includes("asana")
    ) {
      responseContent =
        "It sounds like you're asking about Yoga practice. As your rule-based coach, I recommend starting with basic foundational poses like Mountain Pose (Tadasana) and Downward Dog (Adho Mukha Svanasana). Ensure you listen to your body and never push into pain.";
    } else if (
      lastMessage.includes("meditation") ||
      lastMessage.includes("mindfulness") ||
      lastMessage.includes("stress")
    ) {
      responseContent =
        "For meditation and stress relief, a simple 5-minute breathing exercise is a great start. Focus on inhaling for 4 seconds, holding for 4, and exhaling for 6 seconds. This deterministic advice is always available offline.";
    } else if (
      lastMessage.includes("nutrition") ||
      lastMessage.includes("diet") ||
      lastMessage.includes("food")
    ) {
      responseContent =
        "Nutrition is key to recovery. Please consult a registered dietitian for personalized advice, but generally, focus on whole foods, adequate protein, and staying hydrated.";
    } else if (lastMessage.includes("sleep") || lastMessage.includes("tired")) {
      responseContent =
        "Sleep hygiene is essential. Try to maintain a consistent sleep schedule, avoid screens an hour before bed, and keep your room cool and dark.";
    }

    return {
      content: responseContent,
      provider: AiProviderType.RULE_BASED,
      tokensUsed: 0, // Deterministic rules don't use tokens
      latencyMs: 10,
    };
  }
}
