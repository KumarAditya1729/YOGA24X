import { Injectable, Logger, OnModuleInit } from "@nestjs/common";
import { AiProvider } from "../interfaces/ai-provider.interface";
import { AiModelRole } from "@prisma/client";

@Injectable()
export class AiProviderRegistry implements OnModuleInit {
  private readonly logger = new Logger(AiProviderRegistry.name);
  private providers: AiProvider[] = [];

  onModuleInit() {
    this.logger.log("AiProviderRegistry initialized");
  }

  /**
   * Register a new AI Provider (e.g. Mock, RuleBased, OpenAI, Ollama)
   */
  registerProvider(provider: AiProvider) {
    this.providers.push(provider);
    this.logger.log(
      `Registered AI Provider: ${provider.getProviderType()} (Priority: ${provider.getPriority()})`,
    );

    // Sort providers by priority (lowest number = highest priority)
    this.providers.sort((a, b) => a.getPriority() - b.getPriority());
  }

  /**
   * Get all registered providers
   */
  getProviders(): AiProvider[] {
    return this.providers;
  }

  /**
   * Find the best available provider for a specific role based on priority and health
   */
  async getBestAvailableProvider(
    role: AiModelRole = AiModelRole.CHAT,
  ): Promise<AiProvider> {
    for (const provider of this.providers) {
      if (provider.getSupportedRoles().includes(role)) {
        try {
          const isAvailable = await provider.isAvailable();
          if (isAvailable) {
            this.logger.debug(
              `Selected provider ${provider.getProviderType()} for role ${role}`,
            );
            return provider;
          }
        } catch (error) {
          this.logger.warn(
            `Provider ${provider.getProviderType()} is unavailable: ${error.message}`,
          );
        }
      }
    }

    throw new Error(
      `No available AI providers for role: ${role}. System requires at least a Mock or Rule-based fallback provider.`,
    );
  }
}
