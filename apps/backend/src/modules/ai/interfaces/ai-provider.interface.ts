import { AiProviderType, AiModelRole } from '@prisma/client';

export interface AiMessageParams {
  role: 'user' | 'assistant' | 'system';
  content: string;
}

export interface AiChatRequest {
  messages: AiMessageParams[];
  temperature?: number;
  maxTokens?: number;
  userId?: string;
}

export interface AiChatResponse {
  content: string;
  provider: AiProviderType;
  tokensUsed?: number;
  latencyMs?: number;
}

export interface AiProvider {
  /**
   * Type of provider (OpenAI, Gemini, Mock, RuleBased, etc.)
   */
  getProviderType(): AiProviderType;

  /**
   * Check if provider is available and healthy
   */
  isAvailable(): Promise<boolean>;

  /**
   * Get supported roles for this provider
   */
  getSupportedRoles(): AiModelRole[];

  /**
   * Main chat interface
   */
  chat(request: AiChatRequest): Promise<AiChatResponse>;

  /**
   * Get provider priority (lower is higher priority)
   */
  getPriority(): number;
}
