import { AiProviderRegistry } from "../ai-provider.registry";
import {
  AiProvider,
  AiChatRequest,
  AiChatResponse,
} from "../../interfaces/ai-provider.interface";
import { AiProviderType, AiModelRole } from "@prisma/client";

class StubProvider implements AiProvider {
  constructor(
    private priority: number,
    private available: boolean,
    private type: AiProviderType,
    private roles: AiModelRole[] = [AiModelRole.CHAT, AiModelRole.COACH],
  ) {}

  getProviderType() {
    return this.type;
  }
  getPriority() {
    return this.priority;
  }
  async isAvailable() {
    return this.available;
  }
  getSupportedRoles() {
    return this.roles;
  }
  async chat(request: AiChatRequest): Promise<AiChatResponse> {
    return {
      content: "stub",
      provider: this.type,
      tokensUsed: 10,
      latencyMs: 100,
    };
  }
}

describe("AiProviderRegistry", () => {
  let registry: AiProviderRegistry;

  beforeEach(() => {
    registry = new AiProviderRegistry();
  });

  it("should sort providers by priority on registration", () => {
    registry.registerProvider(new StubProvider(100, true, AiProviderType.MOCK));
    registry.registerProvider(
      new StubProvider(10, true, AiProviderType.OPENAI),
    );
    registry.registerProvider(
      new StubProvider(50, true, AiProviderType.OLLAMA),
    );

    const providers = registry.getProviders();
    expect(providers[0].getProviderType()).toBe(AiProviderType.OPENAI);
    expect(providers[1].getProviderType()).toBe(AiProviderType.OLLAMA);
    expect(providers[2].getProviderType()).toBe(AiProviderType.MOCK);
  });

  it("should return the best available provider for a role", async () => {
    // OpenAI is highest priority but unavailable
    registry.registerProvider(
      new StubProvider(10, false, AiProviderType.OPENAI),
    );

    // Ollama is available
    registry.registerProvider(
      new StubProvider(50, true, AiProviderType.OLLAMA),
    );

    // Mock is available
    registry.registerProvider(new StubProvider(100, true, AiProviderType.MOCK));

    const provider = await registry.getBestAvailableProvider(AiModelRole.COACH);
    expect(provider.getProviderType()).toBe(AiProviderType.OLLAMA);
  });

  it("should fallback to mock if all higher priority providers are unavailable", async () => {
    registry.registerProvider(
      new StubProvider(10, false, AiProviderType.OPENAI),
    );
    registry.registerProvider(
      new StubProvider(50, false, AiProviderType.OLLAMA),
    );
    registry.registerProvider(new StubProvider(100, true, AiProviderType.MOCK));

    const provider = await registry.getBestAvailableProvider(AiModelRole.COACH);
    expect(provider.getProviderType()).toBe(AiProviderType.MOCK);
  });

  it("should throw an error if no provider is available", async () => {
    registry.registerProvider(
      new StubProvider(10, false, AiProviderType.OPENAI),
    );
    registry.registerProvider(
      new StubProvider(50, false, AiProviderType.OLLAMA),
    );

    await expect(
      registry.getBestAvailableProvider(AiModelRole.COACH),
    ).rejects.toThrow("No available AI providers");
  });

  it("should skip providers that do not support the requested role", async () => {
    // Available but only supports TEXT_TO_IMAGE
    registry.registerProvider(
      new StubProvider(10, true, AiProviderType.OPENAI, [
        AiModelRole.EMBEDDING,
      ]),
    );

    // Lower priority, available, supports COACH
    registry.registerProvider(
      new StubProvider(50, true, AiProviderType.OLLAMA, [AiModelRole.COACH]),
    );

    const provider = await registry.getBestAvailableProvider(AiModelRole.COACH);
    expect(provider.getProviderType()).toBe(AiProviderType.OLLAMA);
  });
});
