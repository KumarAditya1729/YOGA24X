import { Injectable, Logger } from "@nestjs/common";
import { PrismaService } from "../../prisma/prisma.module";
import { AiProviderRegistry } from "../../ai/providers/ai-provider.registry";
import { AiModelRole } from "@prisma/client";

@Injectable()
export class AiInsightsService {
  private readonly logger = new Logger(AiInsightsService.name);

  constructor(
    private readonly prisma: PrismaService,
    private readonly providerRegistry: AiProviderRegistry,
  ) {}

  async generateChurnPrediction(tenantId: string) {
    this.logger.log(`Generating churn prediction for tenant ${tenantId}...`);
    // Uses the deterministic logic without paid APIs
    const provider = await this.providerRegistry.getBestAvailableProvider(
      AiModelRole.REASONING,
    );
    if (!provider) {
      throw new Error("No AI provider available for Reasoning tasks");
    }

    const res = await provider.chat({
      messages: [
        {
          role: "system",
          content: "You are an AI Business Analyst. Return JSON.",
        },
        {
          role: "user",
          content: "Analyze this sample engagement data and predict churn.",
        },
      ],
    });
    return res;
  }
}
