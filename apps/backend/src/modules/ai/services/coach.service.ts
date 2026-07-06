import { Injectable, Logger, BadRequestException, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.module';
import { AiProviderRegistry } from '../providers/ai-provider.registry';
import { PromptManagerService } from './prompt-manager.service';
import { AiChatRequest } from '../interfaces/ai-provider.interface';
import { CoachSpecialty, AiModelRole } from '@prisma/client';
import { AiSafetyService } from './ai-safety.service';

@Injectable()
export class CoachService {
  private readonly logger = new Logger(CoachService.name);

  constructor(
    private readonly prisma: PrismaService,
    private readonly providerRegistry: AiProviderRegistry,
    private readonly promptManager: PromptManagerService,
    private readonly safetyService: AiSafetyService,
  ) {}

  /**
   * Main entrypoint for chatting with a coach
   */
  async chatWithCoach(userId: string, conversationId: string, message: string) {
    // 1. Safety Guardrails (PII & Medical)
    const sanitizedMessage = await this.safetyService.validateAndSanitize(userId, message);

    // 2. Fetch or create Conversation
    let conversation = await this.prisma.aiConversation.findUnique({
      where: { id: conversationId },
      include: { messages: { orderBy: { createdAt: 'asc' } } },
    });

    if (!conversation) {
      throw new NotFoundException('Conversation not found');
    }

    if (conversation.userId !== userId) {
      throw new BadRequestException('Unauthorized access to conversation');
    }

    // 3. Save User Message
    await this.prisma.aiMessage.create({
      data: {
        conversationId,
        role: 'user',
        content: sanitizedMessage,
      }
    });

    // 4. Build Context (System Prompt + History)
    const systemPrompt = await this.promptManager.getCoachSystemPrompt(conversation.specialty, {
      user_id: userId,
    });

    const chatRequest: AiChatRequest = {
      messages: [
        { role: 'system', content: systemPrompt },
        ...conversation.messages.map((m: any) => ({ role: m.role as any, content: m.content })),
        { role: 'user', content: sanitizedMessage }
      ],
      userId,
    };

    // 5. Select Best Available Provider (Fallback Chain: Cloud -> Local -> Mock)
    const provider = await this.providerRegistry.getBestAvailableProvider(AiModelRole.COACH);

    // 6. Execute Chat
    this.logger.debug(`Executing chat via ${provider.getProviderType()} for conversation ${conversationId}`);
    const response = await provider.chat(chatRequest);

    // 7. Save Assistant Response
    const savedMessage = await this.prisma.aiMessage.create({
      data: {
        conversationId,
        role: 'assistant',
        content: response.content,
        providerUsed: response.provider,
        tokensUsed: response.tokensUsed,
        latencyMs: response.latencyMs,
      }
    });

    return savedMessage;
  }
}
