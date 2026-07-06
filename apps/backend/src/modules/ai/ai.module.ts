import { Module, OnModuleInit } from "@nestjs/common";
import { PrismaModule } from "../prisma/prisma.module";
import { AiProviderRegistry } from "./providers/ai-provider.registry";
import { MockProvider } from "./providers/mock.provider";
import { RuleBasedProvider } from "./providers/rule-based.provider";
import { TemplateProvider } from "./providers/template.provider";
import { OpenAiProvider } from "./providers/openai.provider";
import { OllamaProvider } from "./providers/ollama.provider";
import { PromptManagerService } from "./services/prompt-manager.service";
import { KnowledgeEngineService } from "./services/knowledge-engine.service";
import { RecommendationEngineService } from "./services/recommendation-engine.service";
import { AiSafetyService } from "./services/ai-safety.service";
import { CoachService } from "./services/coach.service";
import { AiController } from "./controllers/ai.controller";

@Module({
  imports: [PrismaModule],
  controllers: [AiController],
  providers: [
    AiProviderRegistry,
    MockProvider,
    RuleBasedProvider,
    TemplateProvider,
    OpenAiProvider,
    OllamaProvider,
    PromptManagerService,
    KnowledgeEngineService,
    RecommendationEngineService,
    AiSafetyService,
    CoachService,
  ],
  exports: [CoachService, RecommendationEngineService],
})
export class AiModule implements OnModuleInit {
  constructor(
    private registry: AiProviderRegistry,
    private mockProvider: MockProvider,
    private ruleProvider: RuleBasedProvider,
    private templateProvider: TemplateProvider,
    private openAiProvider: OpenAiProvider,
    private ollamaProvider: OllamaProvider,
  ) {}

  onModuleInit() {
    // Register fallback chain
    this.registry.registerProvider(this.mockProvider);
    this.registry.registerProvider(this.ruleProvider);
    this.registry.registerProvider(this.templateProvider);
    this.registry.registerProvider(this.ollamaProvider);
    this.registry.registerProvider(this.openAiProvider);
  }
}
