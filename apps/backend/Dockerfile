# ==============================================================================
# Yoga24X Backend — Production Multi-Stage Dockerfile
# Stage 1: deps       - Install production dependencies
# Stage 2: builder    - Compile TypeScript
# Stage 3: runner     - Minimal production image (non-root user)
# ==============================================================================

# ── Stage 1: Dependency Installation ─────────────────────────────────────────
FROM node:20-alpine AS deps
WORKDIR /app

# Install pnpm
RUN corepack enable && corepack prepare pnpm@9.4.0 --activate

# Copy workspace files for pnpm
COPY package.json pnpm-workspace.yaml pnpm-lock.yaml ./
COPY packages/ ./packages/
COPY apps/backend/package.json ./apps/backend/

# Install only production deps for the backend workspace
RUN pnpm install --frozen-lockfile --filter @yoga24x/backend

# ── Stage 2: Build ────────────────────────────────────────────────────────────
FROM node:20-alpine AS builder
WORKDIR /app

RUN corepack enable && corepack prepare pnpm@9.4.0 --activate

COPY package.json pnpm-workspace.yaml pnpm-lock.yaml ./
COPY packages/ ./packages/
COPY apps/backend/ ./apps/backend/

# Install all deps (including devDeps for build)
RUN pnpm install --frozen-lockfile --filter @yoga24x/backend

# Generate Prisma client
RUN cd apps/backend && npx prisma generate

# Build NestJS app
RUN cd apps/backend && pnpm run build

# ── Stage 3: Production Runner ────────────────────────────────────────────────
FROM node:20-alpine AS runner
WORKDIR /app

# Security: run as non-root user
RUN addgroup --system --gid 1001 yoga24x \
  && adduser --system --uid 1001 --ingroup yoga24x nestjs

# Set production environment
ENV NODE_ENV=production
ENV PORT=3001

# Copy only what's needed from builder
COPY --from=builder --chown=nestjs:yoga24x /app/apps/backend/dist ./dist
COPY --from=builder --chown=nestjs:yoga24x /app/apps/backend/node_modules ./node_modules
COPY --from=builder --chown=nestjs:yoga24x /app/apps/backend/prisma ./prisma
COPY --from=builder --chown=nestjs:yoga24x /app/node_modules/.prisma /app/node_modules/.prisma
COPY --from=builder --chown=nestjs:yoga24x /app/node_modules/@prisma /app/node_modules/@prisma

# Switch to non-root user
USER nestjs

# Expose backend port
EXPOSE 3001

# Health check for Docker / Docker Compose
HEALTHCHECK --interval=30s --timeout=10s --start-period=15s --retries=3 \
  CMD wget -qO- http://localhost:3001/health || exit 1

# Start the server
CMD ["node", "dist/main"]
