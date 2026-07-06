import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.module';

@Injectable()
export class KnowledgeEngineService {
  private readonly logger = new Logger(KnowledgeEngineService.name);

  constructor(private readonly prisma: PrismaService) {}

  /**
   * Semantic search fallback to deterministic keyword matching
   * Ensures the system works even if vector DB or embedding models are unavailable.
   */
  async searchKnowledgeBase(query: string, limit: number = 3): Promise<string[]> {
    const keywords = query.toLowerCase().split(' ').filter(word => word.length > 3);
    
    // Fallback: Naive deterministic string matching in Postgres
    // In a real env with pgvector, we'd do an embedding cosine distance check here.
    const allChunks = await this.prisma.knowledgeChunk.findMany({
      take: 100, // Limit to prevent massive loads
    });

    // Score chunks based on keyword matching
    const scoredChunks = allChunks.map((chunk: any) => {
      let score = 0;
      const content = chunk.content.toLowerCase();
      keywords.forEach(kw => {
        if (content.includes(kw)) score++;
      });
      return { ...chunk, score };
    });

    scoredChunks.sort((a: any, b: any) => b.score - a.score);
    
    // Return top N chunks that have at least some relevance
    const relevant = scoredChunks.filter((c: any) => c.score > 0).slice(0, limit);
    
    return relevant.map((c: any) => c.content);
  }
}
