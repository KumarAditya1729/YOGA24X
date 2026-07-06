# ==============================================================================
# Yoga24X Backend — Production Multi-Stage Dockerfile
# Stage 1: builder    - Compile TypeScript and deploy with pnpm deploy
# Stage 2: runner     - Minimal production image (non-root user)
# ==============================================================================

# ── Stage 1: Build & Deploy ───────────────────────────────────────────────────
FROM node:20-alpine AS builder
WORKDIR /app

# Install openssl for Prisma engine
RUN apk add --no-cache openssl

RUN corepack enable && corepack prepare pnpm@9.4.0 --activate

# Copy the entire workspace
COPY package.json pnpm-workspace.yaml pnpm-lock.yaml ./
COPY packages/ ./packages/
COPY apps/backend/ ./apps/backend/

# Install all deps (including devDeps for build)
RUN pnpm install --frozen-lockfile

# Generate Prisma client for build
RUN cd apps/backend && npx prisma generate

# Build shared packages
RUN pnpm --filter @yoga24x/shared-types run build

# Build NestJS app
RUN pnpm --filter @yoga24x/backend run build

# Deploy the backend app to an isolated folder (only production deps)
RUN pnpm deploy --filter @yoga24x/backend --prod /app/out

# Copy the generated Prisma client to the deployed node_modules
# We use cp -LR to dereference symlinks from the pnpm virtual store
RUN cp -LR node_modules/.pnpm/@prisma+client*/node_modules/.prisma /app/out/node_modules/ || true
RUN cp -LR node_modules/.pnpm/@prisma+client*/node_modules/@prisma /app/out/node_modules/ || true

# ── Stage 2: Production Runner ────────────────────────────────────────────────
FROM node:20-alpine AS runner
WORKDIR /app

# Install openssl for Prisma engine in runner
RUN apk add --no-cache openssl

# Security: run as non-root user
RUN addgroup --system --gid 1001 yoga24x \
  && adduser --system --uid 1001 --ingroup yoga24x nestjs

# Set production environment
ENV NODE_ENV=production
ENV PORT=3001

# Copy the standalone deployed app from builder
COPY --from=builder --chown=nestjs:yoga24x /app/out ./

# Switch to non-root user
USER nestjs

# Expose backend port
EXPOSE 3001

# Health check for Docker / Docker Compose
HEALTHCHECK --interval=30s --timeout=10s --start-period=15s --retries=3 \
  CMD wget -qO- http://localhost:3001/health || exit 1

# Start the server
CMD ["node", "dist/main"]
