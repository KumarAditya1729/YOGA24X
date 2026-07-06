# Yoga24X AI Engineering OS

![Yoga24X](https://via.placeholder.com/1200x300.png?text=Yoga24X+Enterprise+Super+App)

Yoga24X is a production-grade, AI-powered Enterprise Wellness Super App. It provides a comprehensive ecosystem for yoga students, teachers, studios, and communities, seamlessly integrated with a Sovereign AI Platform that requires zero external paid API dependencies.

## 🚀 Key Features

### 14 Bounded Contexts (Micro-Modular Architecture)

- **Auth & Identity:** Multi-factor authentication, device fingerprinting, and secure session management.
- **Security (RBAC/ABAC):** Granular role-based and attribute-based access control with wildcard support.
- **Wellness:** Health metrics, sleep tracking, nutrition, and integration with Apple Health / Google Fit.
- **Teacher Platform:** Portfolio, certification verification, schedule management, and earnings.
- **Learning Platform:** Course creation, video hosting, quizzes, and progress tracking.
- **Booking Platform:** Live class scheduling, waitlists, and Zoom integration.
- **Student Platform:** Personalized dashboards, goals, and class history.
- **Community Platform:** Forums, groups, private messaging, and content moderation.
- **Commerce Platform:** Stripe/Razorpay integration, subscriptions, one-time payments, and refunds.
- **Sovereign AI Platform:** Local AI inference (Ollama), pluggable providers (OpenAI/Gemini optional), AI Coaching, and AI Safety filters.
- **Enterprise Administration:** CMS, CRM, Support Desk, Business Intelligence, and Analytics.
- **IAM:** Identity and Access Management for organizations and B2B clients.

### 🛡️ Enterprise-Grade Security

- OWASP ASVS Level 2 compliance (Helmet headers, strict CORS, XSS protection).
- Global rate limiting (10 req/s burst, 200 req/min sustained).
- JWT Access (15m) + Refresh (7d) rotation with HTTP-only cookies.
- CI/CD Security Pipeline (TruffleHog secret scanning, Trivy container scanning, OWASP Dependency Check).
- Non-root Docker containers and Kubernetes security contexts.

### ⚡ Performance & Scalability

- Redis caching for ABAC policies, feature flags, and API responses.
- Prisma connection pooling.
- Pagination and database indexing on all list endpoints.
- Kubernetes Horizontal Pod Autoscaler (HPA) ready.

### 👁️ Observability

- Structured JSON logging with Trace IDs and Correlation IDs.
- Liveness (`/health`) and Readiness (`/ready`) Kubernetes probes.
- Centralized error categorization and handling.

## 🛠️ Technology Stack

- **Backend:** NestJS, TypeScript, Node.js
- **Database:** PostgreSQL, Prisma ORM
- **Caching / PubSub:** Redis
- **Mobile App:** Flutter, Riverpod (State Management)
- **AI Inference:** Ollama (Llama 3, Phi-3), OpenAI, Gemini
- **Infrastructure:** Docker, Kubernetes (K8s), GitHub Actions
- **Monorepo Tooling:** Turborepo, pnpm

## 📦 Repository Structure

```text
├── apps/
│   ├── backend/        # NestJS API
│   └── mobile/         # Flutter Mobile App
├── docs/               # Engineering Bible, PRD, Architecture Specs
├── infra/
│   ├── docker/         # Docker Compose files (Dev & Prod)
│   └── k8s/            # Kubernetes Manifests
├── packages/           # Shared types and utilities
└── .github/workflows/  # CI/CD and Security pipelines
```

## 🚀 Getting Started (Local Development)

### Prerequisites

- Node.js >= 20
- pnpm >= 9.4
- Docker & Docker Compose
- Flutter SDK >= 3.19

### 1. Clone the repository

```bash
git clone https://github.com/KumarAditya1729/YOGA24X.git
cd YOGA24X
```

### 2. Install dependencies

```bash
pnpm install
```

### 3. Start Infrastructure (PostgreSQL, Redis, LocalStack)

```bash
docker compose -f infra/docker/docker-compose.yml up -d
```

### 4. Configure Environment

```bash
cp apps/backend/.env.example apps/backend/.env
# Update .env with local database credentials if needed
```

### 5. Setup Database

```bash
cd apps/backend
npx prisma generate
npx prisma migrate dev
```

### 6. Start Backend Server

```bash
pnpm --filter @yoga24x/backend run start:dev
```

API runs on `http://localhost:3000` (or `3001` depending on `.env`). Swagger Docs available at `http://localhost:3000/api/docs`.

### 7. Run Mobile App

```bash
cd apps/mobile
flutter pub get
flutter run
```

## 🚢 Production Deployment

Refer to the complete [Deployment Guide](./docs/DEPLOYMENT_GUIDE.md) and [Production Checklist](./docs/PRODUCTION_CHECKLIST.md) for deploying to Kubernetes or Docker Compose.

- **CI/CD:** Automatic builds and Docker image pushes to GHCR via GitHub Actions on `main`.
- **Container:** Multi-stage, non-root Alpine Docker image provided in `apps/backend/Dockerfile`.

## 🧪 Testing

```bash
# Run backend unit tests
pnpm --filter @yoga24x/backend run test

# Run backend smoke tests (requires live server)
pnpm --filter @yoga24x/backend run test:e2e
```

## 📜 Documentation

- [Product Requirements Document (PRD)](./docs/PRODUCT_REQUIREMENTS_DOCUMENT.md)
- [Engineering Bible](./docs/ENGINEERING_BIBLE.md)
- [Database Architecture](./docs/DATABASE_ARCHITECTURE.md)
- [Infrastructure Architecture](./docs/INFRASTRUCTURE_ARCHITECTURE.md)
- [Operations Runbook](./docs/RUNBOOK.md)

---

_Built with Antigravity AI Engineering OS_
