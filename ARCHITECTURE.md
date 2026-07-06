# Yoga24X AI Engineering OS - Enterprise Architecture & Foundation Blueprint

> [!IMPORTANT]
> **Project Scope & Governance**: This document serves as the master engineering blueprint and foundation specification for **Yoga24X**, an AI-Powered Yoga & Wellness Super App. It defines the architecture, monorepo governance, clean architecture boundaries, feature modularization, DevOps pipelines, and sequential development roadmap across mobile, web, backend, database, and infrastructure layers.

---

## 1. Complete Folder Structure

The **Yoga24X** ecosystem is structured as an enterprise-grade hybrid monorepo. It unifies TypeScript/JavaScript full-stack applications (`apps/admin`, `apps/backend`), shared TypeScript contracts (`packages/*`), and mobile client development (`apps/mobile`) under a cohesive version-controlled repository.

```
yoga24x/
├── .github/
│   ├── workflows/
│   │   ├── ci-backend.yml              # NestJS CI pipeline (lint, test, build)
│   │   ├── ci-admin.yml                # Next.js 15 CI pipeline (lint, typecheck, build)
│   │   ├── ci-mobile.yml               # Flutter CI pipeline (analyze, test, build)
│   │   ├── cd-deploy-staging.yml       # Automated staging deployment
│   │   ├── cd-deploy-prod.yml          # Production release pipeline
│   │   └── security-audit.yml          # Dependabot, Snyk, & CodeQL analysis
│   ├── PULL_REQUEST_TEMPLATE.md
│   └── ISSUE_TEMPLATE/
├── apps/
│   ├── mobile/                         # Flutter Mobile Application (iOS & Android)
│   │   ├── android/
│   │   ├── ios/
│   │   ├── lib/
│   │   ├── test/
│   │   ├── pubspec.yaml
│   │   └── melos.yaml                  # Mobile workspace management
│   ├── admin/                          # Next.js 15 Admin Portal & CMS
│   │   ├── public/
│   │   ├── src/
│   │   ├── next.config.ts
│   │   ├── tailwind.config.ts
│   │   ├── tsconfig.json
│   │   └── package.json
│   └── backend/                        # NestJS API Gateway & Microservices
│   │       ├── prisma/                 # Database Schema & Migrations
│   │       ├── src/
│   │       ├── test/
│   │       ├── nest-cli.json
│   │       ├── tsconfig.json
│   │       └── package.json
├── packages/                           # Shared Monorepo Packages
│   ├── shared-types/                   # Shared TypeScript Interfaces, DTOs & Contracts
│   ├── shared-constants/               # Global Enums, Regex, Error Codes & Validation Rules
│   ├── shared-utils/                   # Pure Helper Functions (Date, Math, Crypto formatting)
│   ├── eslint-config/                  # Centralized ESLint & Prettier Rules
│   └── typescript-config/              # Shared tsconfig base definitions
├── infra/                              # Infrastructure as Code & Containerization
│   ├── docker/
│   │   ├── Dockerfile.backend
│   │   ├── Dockerfile.admin
│   │   ├── docker-compose.yml          # Local Dev Stack (Postgres, Redis, LocalStack S3)
│   │   └── docker-compose.prod.yml     # Production Swarm/K8s Manifests
│   ├── k8s/                            # Kubernetes Deployment Helm Charts / Manifests
│   └── terraform/                      # Cloud Infrastructure Provisioning (AWS/GCP)
├── docs/                               # Architectural Decision Records (ADRs) & API Specs
│   ├── adr/
│   ├── api-specs/                      # OpenAPI / Swagger JSON definitions
│   └── security/
├── scripts/                            # DevOps, CI/CD, and Build Automation Scripts
│   ├── setup-local-dev.sh
│   ├── db-migrate-all.sh
│   └── generate-ssl-certs.sh
├── .env.example                        # Global environment variables template
├── .gitignore
├── .editorconfig
├── .prettierrc
├── package.json                        # Monorepo root package configuration
├── pnpm-workspace.yaml                 # pnpm workspace definition
├── turbo.json                          # Turborepo task orchestration config
└── ARCHITECTURE.md                     # Architecture master specification
```

---

## 2. Monorepo Structure

We implement a **Hybrid Monorepo Strategy** leveraging **pnpm Workspaces** + **Turborepo** for the TypeScript/Node.js ecosystem (`backend`, `admin`, `packages/*`) and **Melos + FVM (Flutter Version Management)** for the Flutter mobile ecosystem (`apps/mobile`).

### Why this Architecture?
1. **Zero-Copy Type Safety**: TypeScript interfaces defined in `packages/shared-types` are directly imported by both `apps/backend` (NestJS) and `apps/admin` (Next.js 15), eliminating API contract drift.
2. **Intelligent Build Caching**: Turborepo caches build, lint, and test artifacts across workspaces. If `packages/shared-utils` doesn't change, dependent apps skip recompilation during CI/CD.
3. **Isolated Mobile Toolchain**: Flutter requires a specialized Dart SDK toolchain. By isolating mobile within `apps/mobile` while maintaining it in the same Git repository, mobile engineers gain visibility into backend schema changes without Node.js dependency entanglement.

### Monorepo Configuration (`pnpm-workspace.yaml`)
```yaml
packages:
  - 'apps/admin'
  - 'apps/backend'
  - 'packages/*'
```

### Task Orchestration (`turbo.json`)
```json
{
  "$schema": "https://turbo.build/schema.json",
  "globalDependencies": ["**/.env.*local"],
  "pipeline": {
    "build": {
      "dependsOn": ["^build"],
      "outputs": ["dist/**", ".next/**", "build/**"]
    },
    "test": {
      "dependsOn": ["build"],
      "outputs": ["coverage/**"],
      "cache": true
    },
    "lint": {
      "cache": true
    },
    "typecheck": {
      "cache": true
    },
    "dev": {
      "cache": false,
      "persistent": true
    }
  }
}
```

---

## 3. Clean Architecture

All applications across **Yoga24X** strictly adhere to **Clean Architecture (Robert C. Martin)** and **Domain-Driven Design (DDD)** principles. The architecture enforces strict unidirectional dependency rules: inner layers know nothing about outer layers.

```
+-----------------------------------------------------------------------+
|                       4. INFRASTRUCTURE LAYER                         |
|  (PostgreSQL / Prisma / Redis / Firebase FCM / Razorpay / S3 / HTTP)  |
+-----------------------------------------------------------------------+
                                   |
                                   v  (Implements Interfaces / Adapters)
+-----------------------------------------------------------------------+
|                    3. INTERFACE / PRESENTATION LAYER                  |
|     (NestJS Controllers / Next.js Pages / Flutter Widgets & BLoCs)    |
+-----------------------------------------------------------------------+
                                   |
                                   v  (Invokes Use Cases & DTOs)
+-----------------------------------------------------------------------+
|                        2. APPLICATION LAYER                           |
|          (Use Cases / Application Services / DTOs / Mappers)          |
+-----------------------------------------------------------------------+
                                   |
                                   v  (Manipulates Entities)
+-----------------------------------------------------------------------+
|                          1. DOMAIN LAYER                              |
|   (Core Entities / Value Objects / Domain Events / Repo Interfaces)   |
+-----------------------------------------------------------------------+
```

### Layer Breakdown & Responsibilities
1. **Domain Layer (Core - Zero Dependencies)**:
   - Contains pure business logic, enterprise rules, **Entities**, **Value Objects**, and **Repository Interfaces**.
   - Absolutely no framework dependencies (no NestJS decorators, no Flutter UI imports, no Prisma types).
2. **Application Layer (Use Cases)**:
   - Orchestrates domain entities to execute specific business workflows (e.g., `StartYogaSessionUseCase`, `CalculatePoseAccuracyUseCase`).
   - Defines **DTOs (Data Transfer Objects)** and boundary contracts.
3. **Interface / Presentation Layer**:
   - Handles HTTP/REST requests, WebSocket streams, GraphQL queries, and UI rendering.
   - Translates external data formats into Application DTOs.
4. **Infrastructure Layer**:
   - Implements Domain Repository Interfaces using concrete technologies (Prisma ORM for PostgreSQL, ioredis for Redis, AWS S3 SDK, Razorpay API SDK).

---

## 4. Feature Based Architecture

To prevent architectural degradation into a "Big Ball of Mud", **Yoga24X** organizes code by **Vertical Feature Slices** rather than horizontal technical layers. Each feature module is a self-contained domain unit with its own presentation, application, domain, and infrastructure components.

### Core Features of Yoga24X
1. **`identity`**: User Authentication, JWT/Refresh Token rotation, Google OAuth, OTP verification, Role-Based Access Control (RBAC).
2. **`wellness-catalog`**: Yoga courses, daily routines, meditation audio, difficulty grading, instructor profiles.
3. **`ai-pose-tracker`**: Real-time video stream ingestion, MLKit / TensorFlow Lite skeleton joint extraction, angle calculation, posture correction feedback.
4. **`sessions-tracker`**: Live class streaming, session history, calories burned calculation, biometric telemetry sync.
5. **`gamification`**: Streak tracking, achievement badges, leaderboards, karma points, community challenges.
6. **`nutrition-planner`**: AI-generated diet plans, caloric tracking, hydration reminders, Ayurvedic body-type (Dosha) mapping.
7. **`community`**: Live webinars, interactive forums, instructor Q&A, social sharing.
8. **`subscription-billing`**: Razorpay checkout integration, webhook processing, tier management (Free, Pro, Studio VIP), invoice generation.
9. **`notifications`**: Firebase Cloud Messaging (FCM) push notification scheduling, email digests, SMS alerts.
10. **`analytics-cms`**: Admin dashboard reporting, user engagement metrics, video upload pipeline, content moderation.

---

## 5. Database Folder Structure

The database layer is centralized in `apps/backend/prisma/` (with schema sharing capabilities via `packages/shared-types`). We utilize **Prisma ORM** with PostgreSQL.

```
apps/backend/prisma/
├── schema/                             # Modular Prisma Schema (Prisma 5.15+ feature)
│   ├── base.prisma                     # Generator and Datasource config
│   ├── identity.prisma                 # User, Role, Session, RefreshToken models
│   ├── wellness.prisma                 # Course, Session, Video, Instructor models
│   ├── ai_tracking.prisma              # PoseModel, FeedbackLog, AccuracyScore models
│   ├── gamification.prisma             # Badge, UserBadge, Streak, Leaderboard models
│   └── billing.prisma                  # Subscription, PaymentTransaction, Invoice models
├── migrations/                         # SQL migration history generated by Prisma
│   ├── 20260706000000_init_identity/
│   ├── 20260706010000_wellness_catalog/
│   └── ...
├── seeds/                              # Database seeding automation
│   ├── seed.ts                         # Main seed orchestrator
│   ├── data/
│   │   ├── roles.seed.ts
│   │   ├── instructors.seed.ts
│   │   ├── courses.seed.ts
│   │   └── badges.seed.ts
│   └── helpers/
│       └── faker.util.ts
├── sql/                                # Custom raw SQL scripts, functions, & views
│   ├── views/
│   │   └── user_activity_summary.sql
│   └── triggers/
│       └── update_timestamp.sql
└── schema.prisma                       # Compiled unified schema (or direct target)
```

---

## 6. Flutter Folder Structure

The mobile application (`apps/mobile`) follows a **Feature-First Clean Architecture** pattern powered by **Flutter Riverpod** for dependency injection and state management, and **GoRouter** for declarative navigation.

```
apps/mobile/lib/
├── main.dart                           # Entrypoint: ProviderScope & App initialization
├── app/
│   ├── app.dart                        # MaterialApp.router configuration
│   ├── router/
│   │   ├── app_router.dart             # GoRouter routes definition
│   │   └── route_names.dart
│   └── theme/
│       ├── app_colors.dart             # Curated HSL/RGB wellness color palette
│       ├── app_typography.dart         # Google Fonts (Inter, Outfit) styling
│       └── app_theme.dart              # Light & Dark Glassmorphism theme data
├── core/                               # Cross-cutting system capabilities
│   ├── constants/
│   │   └── api_endpoints.dart
│   ├── errors/
│   │   ├── exceptions.dart             # Infrastructure exceptions
│   │   └── failures.dart               # Domain failures (Either<Failure, T>)
│   ├── network/
│   │   ├── api_client.dart             # Dio HTTP client with JWT interceptors
│   │   └── web_socket_client.dart      # Real-time WebRTC/WebSocket connection
│   ├── storage/
│   │   ├── secure_storage.dart         # FlutterSecureStorage for JWT tokens
│   │   └── local_cache.dart            # Hive / SharedPreferences local cache
│   └── utils/
│       └── logger.dart                 # Custom structured logging
└── features/                           # Feature-Slices
    ├── identity/                       # Auth Feature
    │   ├── domain/
    │   │   ├── entities/user.dart
    │   │   ├── repositories/auth_repository.dart
    │   │   └── usecases/login_with_google_usecase.dart
    │   ├── data/
    │   │   ├── datasources/auth_remote_data_source.dart
    │   │   ├── datasources/auth_local_data_source.dart
    │   │   ├── models/user_model.dart  # JSON serialization (freezed/json_serializable)
    │   │   └── repositories/auth_repository_impl.dart
    │   └── presentation/
    │       ├── controllers/auth_controller.dart  # Riverpod StateNotifier/AsyncNotifier
    │       ├── states/auth_state.dart
    │       ├── pages/login_page.dart
    │       └── widgets/social_login_button.dart
    ├── ai_pose_tracker/                # AI Video & ML Pose Feature
    │   ├── domain/...
    │   ├── data/...
    │   └── presentation/
    │       ├── controllers/pose_detection_controller.dart
    │       ├── pages/live_session_page.dart
    │       └── widgets/skeleton_overlay_painter.dart # CustomCanvas skeleton drawing
    ├── wellness_catalog/...
    ├── gamification/...
    └── profile/...
```

---

## 7. Backend Folder Structure

The backend (`apps/backend`) is built on **NestJS** utilizing a strict modular hierarchy. Each domain module encapsulates its own controllers, use cases, domain services, repositories, and data transfer objects.

```
apps/backend/src/
├── main.ts                             # Bootstrap: Swagger, ValidationPipe, Global Filters
├── app.module.ts                       # Root application module
├── common/                             # Cross-cutting NestJS artifacts
│   ├── decorators/
│   │   ├── current-user.decorator.ts
│   │   └── roles.decorator.ts
│   ├── filters/
│   │   ├── http-exception.filter.ts    # Global RFC 7807 problem details formatter
│   │   └── prisma-client-exception.filter.ts
│   ├── guards/
│   │   ├── jwt-auth.guard.ts
│   │   ├── roles.guard.ts
│   │   └── throttle.guard.ts
│   ├── interceptors/
│   │   ├── logging.interceptor.ts      # Request/Response latency logging
│   │   ├── transform.interceptor.ts
│   │   └── timeout.interceptor.ts
│   └── pipes/
│       └── zod-validation.pipe.ts      # Strict Zod schema input validation
├── config/                             # Centralized environment configuration
│   ├── app.config.ts
│   ├── database.config.ts
│   ├── redis.config.ts
│   ├── jwt.config.ts
│   └── razorpay.config.ts
├── database/                           # Database providers & abstract repos
│   ├── prisma.service.ts               # PrismaClient lifecycle connection management
│   └── base.repository.ts
├── infra/                              # External service integrations
│   ├── redis/
│   │   ├── redis.module.ts
│   │   └── redis.service.ts            # Caching & Pub/Sub wrapper
│   ├── storage/
│   │   ├── s3-storage.service.ts       # S3 video/image upload & pre-signed URLs
│   │   └── storage.interface.ts
│   ├── notifications/
│   │   ├── fcm.service.ts              # Firebase Cloud Messaging push service
│   │   └── sms.service.ts              # OTP SMS delivery
│   └── payments/
│       └── razorpay.service.ts         # Razorpay checkout & webhook verification
└── modules/                            # Feature Modules (Vertical Slices)
    ├── auth/
    │   ├── auth.module.ts
    │   ├── auth.controller.ts
    │   ├── auth.service.ts
    │   ├── strategies/
    │   │   ├── jwt.strategy.ts
    │   │   ├── jwt-refresh.strategy.ts
    │   │   └── google.strategy.ts
    │   └── dto/
    │       ├── login.dto.ts
    │       ├── register.dto.ts
    │       └── refresh-token.dto.ts
    ├── users/
    │   ├── users.module.ts
    │   ├── users.controller.ts
    │   ├── users.service.ts
    │   ├── repositories/users.repository.ts
    │   └── entities/user.entity.ts
    ├── wellness/
    │   ├── courses.controller.ts
    │   ├── sessions.controller.ts
    │   └── ...
    ├── ai-tracking/
    │   ├── ai-tracking.gateway.ts      # WebSocket Gateway for real-time telemetry
    │   ├── ai-tracking.service.ts
    │   └── ...
    └── billing/
        ├── billing.controller.ts       # Razorpay webhook listener
        └── ...
```

---

## 8. Admin Folder Structure

The admin portal (`apps/admin`) uses **Next.js 15 (App Router)** with TypeScript, Tailwind CSS, and Shadcn UI components. It enforces strict separation between server components, server actions, client interactive components, and data fetching hooks.

```
apps/admin/src/
├── app/                                # Next.js App Router
│   ├── (auth)/                         # Unauthenticated layout group
│   │   ├── login/
│   │   │   └── page.tsx
│   │   └── layout.tsx
│   ├── (dashboard)/                    # Authenticated admin layout group
│   │   ├── layout.tsx                  # Sidebar, Topbar, & Session Provider
│   │   ├── page.tsx                    # Overview Analytics KPI Dashboard
│   │   ├── courses/
│   │   │   ├── page.tsx                # Course list server component
│   │   │   ├── [id]/
│   │   │   │   └── page.tsx            # Course editor & video manager
│   │   │   └── new/
│   │   │       └── page.tsx
│   │   ├── ai-models/                  # ML model versioning & accuracy logs
│   │   ├── users/                      # User management & moderation
│   │   ├── billing/                    # Revenue analytics & invoices
│   │   └── settings/
│   ├── api/                            # Next.js API route handlers (BFF / Webhooks)
│   │   └── auth/[...nextauth]/route.ts # NextAuth / Auth.js handler
│   ├── error.tsx                       # Global Error Boundary
│   ├── loading.tsx                     # Global Suspense skeleton loader
│   └── not-found.tsx
├── actions/                            # Next.js 15 Server Actions (Mutations)
│   ├── course-actions.ts               # Create/Update course server actions
│   ├── user-actions.ts
│   └── upload-actions.ts               # Generate S3 pre-signed upload URLs
├── components/
│   ├── ui/                             # Shadcn UI primitive components
│   │   ├── button.tsx
│   │   ├── dialog.tsx
│   │   ├── table.tsx
│   │   └── toast.tsx
│   ├── shared/                         # Reusable composite layout components
│   │   ├── admin-sidebar.tsx
│   │   ├── data-table.tsx
│   │   └── file-uploader.tsx
│   └── features/                       # Feature-specific complex UI components
│       ├── courses/
│       │   ├── course-form.tsx
│       │   └── video-chapter-editor.tsx
│       └── analytics/
│           ├── revenue-chart.tsx       # Recharts / Chart.js wrapper
│           └── user-retention-card.tsx
├── hooks/                              # Custom React Hooks
│   ├── use-debounce.ts
│   └── use-media-query.ts
├── lib/                                # Utility clients & helpers
│   ├── api-client.ts                   # Axios / Fetch client for NestJS API
│   ├── auth.ts                         # NextAuth configuration
│   └── utils.ts                        # Tailwind cn() class merger
└── types/                              # Admin-specific UI TypeScript interfaces
    └── navigation.ts
```

---

## 9. Shared Packages

The `packages/` directory contains code shared across frontend and backend, preventing duplication and ensuring 100% type synchronicity.

```
packages/
├── shared-types/
│   ├── src/
│   │   ├── index.ts
│   │   ├── auth/
│   │   │   ├── jwt-payload.interface.ts
│   │   │   └── auth-response.dto.ts
│   │   ├── wellness/
│   │   │   ├── course.interface.ts
│   │   │   ├── session-level.enum.ts
│   │   │   └── pose-joint.interface.ts
│   │   └── billing/
│   │       ├── subscription-tier.enum.ts
│   │       └── razorpay-webhook.interface.ts
│   ├── package.json
│   └── tsconfig.json
├── shared-constants/
│   ├── src/
│   │   ├── error-codes.ts              # Global error code enums (e.g., ERR_POSE_NOT_DETECTED)
│   │   ├── regex-patterns.ts           # Unified email, phone, and password regex
│   │   └── validation-rules.ts         # Max file sizes, string length limits
│   ├── package.json
│   └── tsconfig.json
├── shared-utils/
│   ├── src/
│   │   ├── date-formatting.ts          # Day.js / date-fns timezone helpers
│   │   ├── calorie-calculator.ts       # MET metabolic equivalent formula calculation
│   │   └── crypto-helpers.ts           # SHA256 / HMAC verification helpers
│   ├── package.json
│   └── tsconfig.json
├── eslint-config/
│   ├── nest.js
│   ├── next.js
│   └── base.js
└── typescript-config/
    ├── base.json
    ├── nestjs.json
    └── nextjs.json
```

---

## 10. Environment Strategy

We implement a strict 4-tier environment hierarchy: **Local**, **Development**, **Staging**, and **Production**.

### Secret & Variable Management
- **Zero Secrets in Git**: `.env` files are strictly ignored in `.gitignore`. Only `.env.example` templates with blank values are committed.
- **Runtime Validation**: On application startup, environment variables must pass schema validation using **Zod** (`@nestjs/config` validation schema in backend; `@t3-oss/env-nextjs` in Admin). If a required variable is missing or misformatted, the application halts execution immediately with a clear terminal error.
- **Secret Providers**: Production secrets are dynamically injected at runtime via **AWS Secrets Manager** / **GCP Secret Manager** or **GitHub Actions Secrets** during CI/CD deployment.

### Environment Variable Matrix

| Variable Name | Description | Local / Dev | Staging | Production |
| :--- | :--- | :--- | :--- | :--- |
| `NODE_ENV` | Runtime execution environment | `development` | `staging` | `production` |
| `PORT` | API Gateway listening port | `3000` | `3000` | `3000` |
| `DATABASE_URL` | PostgreSQL connection string | `postgresql://postgres:root@localhost:5432/yoga24x_dev` | `postgresql://user:pass@db-staging.aws:5432/yoga24x_stg` | `postgresql://user:pass@db-prod.aws:5432/yoga24x_prod?sslmode=require` |
| `REDIS_URL` | Redis caching & pub/sub URI | `redis://localhost:6379/0` | `redis://redis-staging.aws:6379/0` | `redis://redis-cluster-prod.aws:6379/0` |
| `JWT_ACCESS_SECRET` | RSA/HMAC Access Token secret | `dev_access_secret_32chars_min` | `stg_vault_injected_secret_key` | `prod_vault_injected_secret_key` |
| `JWT_REFRESH_SECRET`| Refresh Token secret | `dev_refresh_secret_32chars_min`| `stg_vault_injected_refresh_key`| `prod_vault_injected_refresh_key`|
| `JWT_ACCESS_EXPIRY` | Access token lifespan | `15m` | `15m` | `15m` |
| `JWT_REFRESH_EXPIRY`| Refresh token lifespan | `7d` | `7d` | `7d` |
| `GOOGLE_CLIENT_ID` | OAuth 2.0 Client ID | `mock_or_dev_gcp_id` | `staging_gcp_client_id` | `prod_gcp_client_id` |
| `RAZORPAY_KEY_ID` | Razorpay API Key | `rzp_test_xxxxxxxxx` | `rzp_test_xxxxxxxxx` | `rzp_live_xxxxxxxxx` |
| `RAZORPAY_KEY_SECRET`| Razorpay HMAC Webhook Secret| `dev_razorpay_secret` | `stg_razorpay_secret` | `prod_razorpay_secret` |
| `S3_BUCKET_NAME` | Media storage bucket | `yoga24x-dev-media` | `yoga24x-staging-media` | `yoga24x-prod-media` |
| `FCM_SERVER_KEY` | Firebase Cloud Messaging key | `fcm_dev_mock_key` | `fcm_staging_key` | `fcm_prod_live_key` |

---

## 11. Configuration Strategy

### 1. Backend Centralized Config (`apps/backend/src/config/`)
Configuration is encapsulated into type-safe, namespace-isolated TypeScript objects loaded asynchronously:
```typescript
// database.config.ts
import { registerAs } from '@nestjs/config';

export default registerAs('database', () => ({
  url: process.env.DATABASE_URL,
  maxConnections: parseInt(process.env.DB_MAX_CONNECTIONS || '20', 10),
  sslEnabled: process.env.NODE_ENV === 'production',
}));
```

### 2. Feature Flags & Dynamic Configuration
- **Dynamic Feature Toggling**: To support A/B testing and canary rollouts of experimental AI pose tracking models without redeploying code, we integrate a Redis-backed Dynamic Config pattern (compatible with PostHog or LaunchDarkly).
- **Flag Evaluation**:
  - `ENABLE_AI_V2_POSE_MODEL`: Toggles between lightweight TFLite model and advanced high-precision joint tracking.
  - `ENABLE_RAZORPAY_EMIS`: Toggles EMI installment payment options on the checkout screen.
  - `MAINTENANCE_MODE`: Instantly halts API processing and displays scheduled maintenance banners across mobile and web.

---

## 12. Git Branch Strategy

We enforce **Trunk-Based Development adapted with GitHub Flow / GitFlow governance** to ensure rapid iteration with rock-solid production stability.

```
[main]      ---------------------------------------------------> (Production Releases / Tags: v1.0.0)
               ^                                      ^
               | (PR Merge / CI Pass)                 | (Hotfix Merge)
[staging]   ---------------------------------------------------> (Staging Server / Pre-release QA)
               ^                        ^
               | (PR Merge)             |
[develop]   ---------------------------------------------------> (Integration Branch / Nightly Builds)
               ^                        |
               | (PR Merge)             +--- [feature/ai-pose-feedback]
               |                        |
               +--- [feature/razorpay-checkout]
                                        |
[hotfix/*]  ----------------------------+----------------------> (Emergency Production Fixes)
```

### Branch Roles & Protection Rules
1. `main`: Highly protected production branch. Direct pushes are **strictly disabled**. Requires at least **2 Senior Engineer approvals**, passing CI/CD pipelines, zero SonarQube vulnerabilities, and up-to-date branch status before merging.
2. `staging`: Mirror of the upcoming production release. Deploys automatically to staging Kubernetes cluster for QA regression testing and Product Manager sign-off.
3. `develop`: Main integration branch for active sprints. Developers branch off `develop` and merge back via PRs.
4. `feature/<ticket-id>-<short-description>`: Ephemeral feature branches (e.g., `feature/YOG-102-google-oauth-flow`).
5. `bugfix/<ticket-id>-<short-description>`: Non-critical bug resolutions.
6. `hotfix/<ticket-id>-<short-description>`: Critical production emergency patches branched directly from `main` and merged back into both `main` and `develop`.

### Commit Convention
Strict adherence to **Conventional Commits** enforced via Husky and `commitlint`:
- `feat(auth): add google oauth2 verification endpoint`
- `fix(ai-tracker): resolve elbow joint angle calculation drift`
- `docs(api): update swagger schema for razorpay webhooks`
- `chore(deps): upgrade prisma orm to v5.15.0`
- `refactor(mobile): migrate session controller to riverpod asyncnotifier`

---

## 13. Coding Standards

### TypeScript Standards (Backend & Admin)
- **Strict Typing**: `strict: true`, `noImplicitAny: true`, `strictNullChecks: true` enforced in `tsconfig.json`. The use of `any` is strictly prohibited; use `unknown` or generics if dynamic types are required.
- **Immutability & Pure Functions**: Prefer `const`, `readonly` properties, and immutable array operations (`map`, `filter`, `reduce`).
- **Explicit API Contracts**: All public controller methods and service functions must explicitly declare return types (e.g., `async getUser(id: string): Promise<UserResponseDto>`).
- **Asynchronous Safety**: Always use `async/await` over raw Promises. Avoid floating promises by enforcing `@typescript-eslint/no-floating-promises`.

### Dart & Flutter Standards (Mobile)
- **Lint Rules**: Enforce `very_good_analysis` or Flutter's official `flutter_lints` with maximum strictness.
- **Const Correctness**: Enforce `prefer_const_constructors` and `prefer_const_literals_to_create_immutables` to maximize widget rebuild performance and minimize GC memory pressure.
- **Widget Modularization**: Never build monolithic widgets exceeding 150 lines. Break complex UI down into private functional widgets or separate stateless component classes.
- **Zero Business Logic in UI**: Presentation widgets must only emit events and listen to state changes. Zero network calls, zero data transformations, and zero database queries inside widget `build()` methods.

### Automated Code Quality Tooling
- **Prettier**: Unified opinionated formatting across TS/JS/JSON/CSS/MD (`printWidth: 100`, `singleQuote: true`, `trailingComma: 'all'`).
- **ESLint**: Custom rule rulesets preventing unused variables, console logs in production, and circular dependencies.
- **Husky & Lint-Staged**: Pre-commit hooks automatically execute Prettier formatting, ESLint verification, and Dart static analysis on staged files prior to commit creation.

---

## 14. Naming Conventions

To maintain uniformity across a polyglot codebase, exact naming conventions are mandated:

| Element Type | Naming Convention | Example (TypeScript / Nest / Next) | Example (Dart / Flutter) | Example (Database / SQL) |
| :--- | :--- | :--- | :--- | :--- |
| **Files & Directories** | `kebab-case` (TS/JS) / `snake_case` (Dart) | `auth-controller.ts`, `user-card.tsx` | `auth_controller.dart`, `user_card.dart` | `create_users_table.sql` |
| **Classes & Interfaces**| `PascalCase` | `UserService`, `JwtPayloadInterface`| `AuthRepository`, `PoseJointModel`| `UserTable`, `CourseEntity` |
| **Variables & Functions**| `camelCase` | `calculateMET()`, `currentUser` | `calculateMet()`, `currentUser` | `current_user_id` |
| **Constants & Enums** | `UPPER_SNAKE_CASE` (Values) / `PascalCase` (Type)| `MAX_VIDEO_SIZE_MB = 500`, `Role.ADMIN`| `maxVideoSizeMb = 500`, `Role.admin`| `STATUS_ACTIVE = 'ACTIVE'` |
| **Database Tables** | Plural `snake_case` | `users`, `wellness_courses` | N/A | `users`, `wellness_courses` |
| **Database Columns** | Singular `snake_case` | `created_at`, `instructor_id` | N/A | `created_at`, `instructor_id`|
| **API Endpoints** | Plural `kebab-case` (RESTful)| `POST /api/v1/wellness-courses` | N/A | N/A |

---

## 15. Dependency Management Strategy

### Package Management & Hoisting
- **Web & Backend Ecosystem**: Managed exclusively via **pnpm** (v9+). We utilize pnpm's content-addressable storage and strict node_modules structure to eliminate phantom dependencies and reduce disk footprint.
- **Mobile Ecosystem**: Managed via **Dart Pub** and **FVM (Flutter Version Management)**. FVM guarantees that every engineer and CI/CD runner compiles the app using the exact same Flutter SDK version (e.g., Flutter 3.22.0 Stable).

### Automated Dependency Maintenance & Security
- **RenovateBot Integration**: Automated pull requests are generated weekly for minor and patch updates, and immediately for security vulnerabilities.
- **Lockfile Integrity**: `pnpm-lock.yaml` and `pubspec.lock` must be committed to version control. CI pipelines execute `pnpm install --frozen-lockfile` and `flutter pub get` to prevent silent transitive dependency drift.
- **Vulnerability Auditing**: CI/CD pipelines run `pnpm audit --audit-level=high` and `snyk test` on every PR. Any high or critical CVE immediately blocks PR merge.

---

## 16. Logging Strategy

We implement a **Structured JSON Logging Strategy** with end-to-end distributed tracing across all touchpoints.

### Backend Logging (NestJS - Pino)
- **Library**: `nestjs-pino` wrapped around **Pino** (high-performance JSON logger).
- **Correlation & Trace IDs**: Every incoming HTTP request is assigned a unique `x-correlation-id` (UUIDv4) via an HTTP Middleware/Interceptor. This ID is propagated across all asynchronous operations using Node.js `AsyncLocalStorage` (ClsModule) and included in every log entry and outgoing database/microservice call.
- **Log Levels**:
  - `error`: Unhandled exceptions, database connection failures, payment gateway errors.
  - `warn`: Rate limit breaches, deprecated API usage, authentication failures, slow query warnings (>500ms).
  - `info`: Successful user logins, subscription purchases, course completions, system startup.
  - `debug`: Detailed SQL query execution, AI pose calculation telemetry (disabled in production).

### Frontend & Mobile Logging
- **Production Crash Reporting**: **Sentry** and **Firebase Crashlytics** integrated into Flutter and Next.js.
- **Sanitized Logging**: Strict sanitization wrappers guarantee that **Personally Identifiable Information (PII)** (passwords, OTPs, credit card numbers, JWT tokens, user biometrics) is redacted before logs are emitted or transmitted to telemetry collectors.

### Log Aggregation & Observability Stack
- Logs are shipped asynchronously from Docker containers via FluentBit/Logstash to an **ELK Stack (Elasticsearch, Logstash, Kibana)** or **Datadog / AWS CloudWatch Logs** for real-time alerting, anomaly detection, and dashboard visualization.

---

## 17. Error Handling Strategy

A unified, predictable error boundary architecture guarantees graceful failure recovery and clear debugging diagnostics.

### Backend Error Architecture (RFC 7807 Problem Details)
All HTTP API responses return errors formatted according to the **RFC 7807 Problem Details for HTTP APIs** specification:
```json
{
  "type": "https://api.yoga24x.com/errors/POSE_DETECTION_FAILED",
  "title": "AI Pose Detection Error",
  "status": 422,
  "detail": "The AI tracking engine could not identify the user's lower limbs due to insufficient lighting.",
  "instance": "/api/v1/sessions/live/track",
  "code": "ERR_POSE_NOT_DETECTED",
  "timestamp": "2026-07-06T12:06:18Z",
  "correlationId": "f47ac10b-58cc-4372-a567-0e02b2c3d479"
}
```

### Domain Exception Hierarchy
In NestJS, domain logic throws custom domain errors rather than HTTP exceptions:
```typescript
export abstract class BaseDomainError extends Error {
  abstract readonly code: string;
  abstract readonly statusCode: number;
}
export class PoseDetectionError extends BaseDomainError { ... }
export class InsufficientFundsError extends BaseDomainError { ... }
```
A **Global Exception Filter** catches `BaseDomainError` instances and automatically translates them into RFC 7807 JSON HTTP responses.

### Mobile & Frontend Error Handling
- **Flutter Functional Error Handling**: We utilize the `fpdart` or `dartz` package to enforce functional error handling across repositories and use cases:
  ```dart
  Future<Either<Failure, PoseAccuracyResult>> analyzeFrame(VideoFrame frame);
  ```
  This forces presentation controllers (Riverpod AsyncNotifiers) to explicitly handle both failure and success states without relying on fragile `try/catch` blocks.
- **Global Error Boundaries**:
  - In Flutter: `FlutterError.onError` and `PlatformDispatcher.instance.onError` intercept unhandled UI exceptions, rendering a graceful fallback "Oops! Something went wrong" screen while reporting stack traces to Crashlytics.
  - In Next.js: `error.tsx` error boundaries capture React render errors and provide localized retry mechanisms.

---

## 18. Project Roadmap

The engineering roadmap spans **16 Weeks across 5 Agile Phases**, delivering a production-ready, highly scalable AI super app.

```
Week:  1    2    3    4    5    6    7    8    9    10   11   12   13   14   15   16
       |----|----|----|----|----|----|----|----|----|----|----|----|----|----|----|
Ph 1:  [=== Foundation & Core Auth ===]
Ph 2:            [=== Wellness Engine & CMS ===]
Ph 3:                      [=== AI Pose Tracking & WebRTC ===]
Ph 4:                                   [=== Social, Billing & Gamification ===]
Ph 5:                                              [=== QA, Security & Launch ===]
```

### Phase 1: Foundation, Infrastructure & Core Identity (Weeks 1-3)
- **Deliverables**: Monorepo repository scaffolding, Docker local development stack, PostgreSQL schema initialization, CI/CD pipeline automation.
- **Core Features**: NestJS Auth module (JWT + Refresh token rotation in Redis), Google OAuth 2.0 integration, OTP SMS verification, Flutter authentication screens, Next.js Admin login screen.
- **Milestone 1**: Secure end-to-end authentication and token refresh working across Mobile, API, and Admin.

### Phase 2: Core Wellness Engine, Video Streaming & CMS (Weeks 4-7)
- **Deliverables**: S3 pre-signed URL upload pipeline, CloudFront CDN integration, HLS video streaming setup.
- **Core Features**: Course & routine catalog database models, NestJS wellness CRUD APIs, Next.js Admin course builder & video chapter uploader, Flutter course catalog UI, video player widget with adaptive bitrate streaming.
- **Milestone 2**: Users can browse wellness courses and stream HD yoga instructional videos seamlessly on mobile; Admins can manage content via Next.js portal.

### Phase 3: AI Pose Tracking Engine & Real-Time Feedback (Weeks 8-11)
- **Deliverables**: MLKit / TensorFlow Lite model integration in Flutter, WebRTC live video streaming infrastructure.
- **Core Features**: Real-time on-device skeleton joint extraction (33 landmarks), mathematical angle calculation (elbow, knee, hip alignment), audio/visual posture correction feedback loops, NestJS WebSocket telemetry gateway, session accuracy scoring database sync.
- **Milestone 3**: AI Pose Tracker successfully evaluates user yoga postures in real-time with <50ms latency and records accuracy telemetry to backend.

### Phase 4: Social, Gamification, Subscriptions & Notifications (Weeks 12-14)
- **Deliverables**: Razorpay payment gateway integration, Firebase Cloud Messaging push notification engine, Redis leaderboard caching.
- **Core Features**: Subscription tiers (Free, Pro, VIP), Razorpay webhook processing & invoice generation, streak tracking, achievement badges, community discussion forums, scheduled workout reminders.
- **Milestone 4**: Complete monetization loop operational; users can purchase subscriptions via Razorpay, earn badges, and receive automated push notifications.

### Phase 5: QA, Security Audit, Performance Tuning & App Store Launch (Weeks 15-16)
- **Deliverables**: Penetration testing, OWASP Top 10 security remediation, load testing (10,000 concurrent WebSocket connections), iOS App Store & Google Play Store submission.
- **Core Features**: Sentry & Crashlytics production monitoring, database query indexing & optimization, final UI/UX polish, micro-animations, App Store compliance verification.
- **Milestone 5**: Yoga24X Super App live on iOS App Store, Google Play Store, and Production Cloud Infrastructure.

---

## 19. Module Dependency Diagram

The following Mermaid architectural diagram illustrates the system boundaries, data flow, and dependency relationships across the **Yoga24X** ecosystem.

```mermaid
graph TD
    subgraph Client Layer [Client Applications]
        M["apps/mobile (Flutter Riverpod/Clean Arch)"]
        A["apps/admin (Next.js 15 App Router/Tailwind)"]
    end

    subgraph Shared Layer [Monorepo Shared Packages]
        ST["packages/shared-types"]
        SC["packages/shared-constants"]
        SU["packages/shared-utils"]
    end

    subgraph API Gateway & Microservices [apps/backend - NestJS]
        GT["API Gateway / Middleware (Auth, Throttling, Correlation ID)"]
        MOD_AUTH["Module: Identity & Auth"]
        MOD_WELL["Module: Wellness Catalog"]
        MOD_AI["Module: AI Pose Telemetry (WebSocket Gateway)"]
        MOD_BILL["Module: Subscription & Billing"]
        MOD_NOTIF["Module: Push Notifications & SMS"]
    end

    subgraph Infrastructure Layer [Data Persistence & External Services]
        PG[("PostgreSQL (Prisma ORM)")]
        RD[("Redis Cache & Pub/Sub")]
        S3["AWS S3 / CloudFront CDN"]
        FCM["Firebase Cloud Messaging"]
        RZP["Razorpay Payment Gateway"]
        ML["On-Device AI / TFLite Engine"]
    end

    %% Client dependencies on Shared Packages
    M ---> ST & SC & SU
    A ---> ST & SC & SU
    GT ---> ST & SC & SU

    %% Client interactions with Backend
    M -- "HTTPS REST / JWT" --> GT
    M -- "WebRTC / WebSocket (Pose Telemetry)" --> MOD_AI
    M -- "On-Device Inference" --> ML
    A -- "HTTPS REST (Admin BFF)" --> GT

    %% Gateway Routing
    GT --> MOD_AUTH & MOD_WELL & MOD_AI & MOD_BILL & MOD_NOTIF

    %% Backend integrations with Infrastructure
    MOD_AUTH -- "Read/Write Users & Sessions" --> PG
    MOD_AUTH -- "Token Blacklist & Refresh Caching" --> RD
    MOD_WELL -- "Query Courses & Metadata" --> PG
    MOD_WELL -- "Cache Course Catalogs" --> RD
    MOD_WELL -- "Generate Pre-signed Video URLs" --> S3
    MOD_AI -- "Persist Accuracy Scores & Biometrics" --> PG
    MOD_AI -- "Pub/Sub Live Leaderboards" --> RD
    MOD_BILL -- "Verify Webhook Signatures & Record Subscriptions" --> PG
    MOD_BILL -- "API Checkout / Webhooks" <--> RZP
    MOD_NOTIF -- "Trigger Push Notifications" --> FCM
    MOD_NOTIF -- "Schedule Reminder Jobs" --> RD

    %% Styling
    style M fill:#02569B,stroke:#fff,stroke-width:2px,color:#fff
    style A fill:#000000,stroke:#fff,stroke-width:2px,color:#fff
    style GT fill:#E0234E,stroke:#fff,stroke-width:2px,color:#fff
    style PG fill:#336791,stroke:#fff,stroke-width:2px,color:#fff
    style RD fill:#DC382D,stroke:#fff,stroke-width:2px,color:#fff
    style ML fill:#FF6F00,stroke:#fff,stroke-width:2px,color:#fff
```

---

## 20. Development Order

To guarantee seamless integration, zero blocking dependencies, and continuous testability, engineering teams must execute development in the following strict sequential order:

### Step 1: Monorepo & Infrastructure Scaffolding
1. Initialize Git repository, `.gitignore`, `.editorconfig`, and Prettier/ESLint root configs.
2. Configure pnpm workspace (`pnpm-workspace.yaml`) and Turborepo pipeline (`turbo.json`).
3. Create local Docker Compose infrastructure (`infra/docker/docker-compose.yml`) running PostgreSQL 16, Redis 7, and LocalStack (local S3).
4. Establish GitHub Actions CI workflows for linting, typechecking, and automated PR checks.

### Step 2: Shared Contracts & Database Foundation
1. Initialize `packages/shared-types`, `packages/shared-constants`, and `packages/shared-utils`.
2. Initialize Prisma ORM in `apps/backend/prisma/` with modular schema definitions (`base.prisma`, `identity.prisma`, `wellness.prisma`, `billing.prisma`).
3. Execute initial PostgreSQL database migration (`prisma migrate dev`) and build automated seeding scripts (`prisma db seed`).
4. Export generated Prisma types and DTO interfaces to `packages/shared-types` for universal consumption.

### Step 3: Backend Core & Identity Module (NestJS)
1. Bootstrap NestJS application structure with global validation pipes (Zod/class-validator), exception filters (RFC 7807), and Pino structured JSON logging.
2. Build `config/` module with strict environment variable schema validation.
3. Implement `auth/` and `users/` modules: JWT generation, Redis refresh token rotation, Google OAuth 2.0 verification, and OTP SMS delivery.
4. Write comprehensive e2e automated API tests for authentication flows using Jest and Supertest.

### Step 4: Admin Portal Core & Content Pipeline (Next.js 15)
1. Bootstrap Next.js 15 App Router project with TypeScript, Tailwind CSS, and Shadcn UI.
2. Implement NextAuth / Auth.js integrating with NestJS JWT backend.
3. Build authenticated Admin Dashboard layout, navigation sidebar, and RBAC route protection.
4. Develop Course & Video Management CMS: S3 pre-signed URL file uploader, video chapter editor, and instructor management pages.

### Step 5: Mobile App Core & Identity Integration (Flutter)
1. Bootstrap Flutter application with Melos workspace, Riverpod state management, and GoRouter declarative routing.
2. Establish core design system: HSL color tokens, typography, glassmorphism UI components, and responsive layout helpers.
3. Implement `core/network` Dio client with automated JWT access token attachment and 401 Unauthorized refresh token interception.
4. Build `features/identity` clean architecture layers: Login, Google OAuth, OTP verification screens, and secure token storage.

### Step 6: Wellness Catalog & Video Streaming Integration
1. **Backend**: Build `wellness/` module endpoints (courses, routines, filtering, pagination, instructor profiles).
2. **Admin**: Build course publication workflows and video transcoding monitoring.
3. **Mobile**: Build `features/wellness_catalog` pages: Course browsing, routine detail view, and custom video player widget with HLS streaming and offline caching.

### Step 7: AI Pose Tracking Engine & Real-Time Telemetry
1. **Mobile**: Integrate MLKit / TensorFlow Lite vision plugins. Build CustomCanvas skeleton joint overlay painter.
2. **Mobile**: Implement mathematical angle calculation algorithms (evaluating warrior pose, downward dog, tree pose alignment).
3. **Backend**: Implement NestJS WebSocket Gateway (`ai-tracking.gateway.ts`) to receive real-time session telemetry, calculate running accuracy scores, and broadcast live community metrics.
4. **Mobile**: Implement audio/visual posture correction feedback loops (e.g., "Straighten your left knee", visual green/red skeleton indicators).

### Step 8: Monetization, Gamification & Social Features
1. **Backend & Admin**: Integrate Razorpay SDK. Implement checkout order creation, webhook verification signature checking, subscription tier upgrades, and automated invoice PDF generation.
2. **Backend**: Build gamification engine: Streak calculation cron jobs, achievement badge evaluation triggers, and Redis-backed real-time leaderboards.
3. **Mobile**: Build Razorpay checkout modal, subscription management screens, badge showcase profile, and interactive leaderboard UI.

### Step 9: Notifications, Observability & Hardening
1. **Backend**: Integrate Firebase Cloud Messaging (FCM) push notification scheduling (workout reminders, live class alerts).
2. **Full-Stack**: Integrate Sentry crash reporting across Flutter and Next.js; verify Pino structured log ingestion into CloudWatch/Datadog.
3. **DevOps**: Execute load testing (K6 / Locust against NestJS API & WebSocket gateway), database query optimization (EXPLAIN ANALYZE), and OWASP penetration testing.

### Step 10: Production Deployment & App Store Submission
1. Deploy production infrastructure via Terraform & Kubernetes Helm charts to AWS/GCP (ECS/EKS, RDS PostgreSQL, ElastiCache Redis, S3, CloudFront).
2. Configure automated GitHub Actions CI/CD production pipelines with staging sign-off gates.
3. Prepare iOS App Store and Google Play Store metadata, privacy nutrition labels, screenshots, and submit Yoga24X mobile app for review.

---
*Engineering Foundation Architecture & Roadmap v1.0.0 — Yoga24X AI Engineering OS*
