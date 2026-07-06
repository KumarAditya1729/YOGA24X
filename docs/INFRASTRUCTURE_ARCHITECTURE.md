# Yoga24X AI Engineering OS — Enterprise AI, Event-Driven & Infrastructure Architecture

**Document Version**: 2.5.0-ENTERPRISE  
**Status**: APPROVED & LOCKED  
**Architectural Scope**: Permanent Infrastructure Layer, AI Systems, Event-Driven Backbone, Background Workers, Media Pipelines, Observability, Security, and Microservice Evolution Blueprint.  

---

## EXECUTIVE SUMMARY & ARCHITECTURAL TENETS

This specification defines the foundational infrastructure, artificial intelligence architecture, asynchronous event backbone, and operational primitives for **Yoga24X**—an ultra-scalable, AI-powered Yoga & Wellness Super App engineered to support **10 Million Active Users**, **100,000 Teachers**, **1 Million LMS Courses**, and **100 Million High-Velocity Telemetry Events**.

### Core Engineering Tenets:
1. **Zero Synchronous Coupling for Secondary Flows**: All operations not strictly required to return an immediate HTTP response to the user (e.g., certificate generation, video transcoding, AI pose analysis, reward calculation, email notifications) MUST execute asynchronously via distributed event buses and background queues.
2. **Strict Bounded Context Isolation**: While deployed initially as a high-performance **Modular Monolith** within a NestJS runtime, every domain module is architected with strict logical isolation. Zero cross-module database table joins or direct repository imports are permitted; inter-module communication occurs exclusively via formal Domain Service Contracts or versioned CloudEvents.
3. **Multi-Layered Defense & Tenant Privacy**: Multi-tenancy is enforced at the infrastructure level via API Gateway routing, PostgreSQL Row Level Security (RLS), and Redis namespace tagging. PII and sensitive medical/health data are stripped or tokenized before entering AI inference pipelines or observability logs.
4. **Idempotency & Causal Ordering by Default**: Every asynchronous consumer, webhook handler, and scheduled job is guaranteed idempotent via UUID v4 deduplication keys, atomic database constraints, and distributed Redis locks.
5. **AI Safety & RAG Grounding**: All generative AI outputs (dietary advice, workout plans, pose corrections) must pass through a 3-layer safety rail: Retrieval-Augmented Generation (RAG) grounding against verified medical/yogic contraindication databases, JSON schema output validation, and confidence threshold gating.

---

## SECTION 1: ENTERPRISE AI ARCHITECTURE

The Yoga24X AI layer is architected as a distributed, multi-engine intelligence ecosystem decoupled from the core transactional backend via an **AI Gateway** and **Prompt Orchestrator**.

```mermaid
graph TD
    Client[Client Apps / Web / Edge] -->|HTTPS / WebRTC| APIGW[Enterprise API Gateway]
    APIGW -->|Auth & Rate Limit| AIGW[AI Gateway Service]
    
    subgraph AI_Orchestration_Layer [AI Orchestration & Governance]
        AIGW -->|PII Masking & Token Quotas| PO[Prompt Orchestrator]
        PO -->|Retrieve Context| CM[Conversation Manager]
        PO -->|Fetch Template| PT[Prompt Templates Repository]
        PO -->|Route Query| LLMR[LLM Router Engine]
        PT <-->|Versioned Prompts| DB_Prompts[(PostgreSQL: Prompt Store)]
    end
    
    subgraph Knowledge_and_Memory [RAG & Memory Layer]
        PO <-->|Short-Term Session| ME_Short[Memory Engine: Redis Session Cache]
        PO <-->|Long-Term Vector Search| ME_Long[Memory Engine: pgvector HNSW]
        PO <-->|Semantic Retrieval| KB[Knowledge Base: Ancient Texts & Meds]
        KB <-->|Embeddings Query| ES[Embeddings Service: 1536-dim]
    end
    
    subgraph Specialized_AI_Engines [Domain-Specific AI Engines]
        LLMR -->|Live Workout & Form| ACE[AI Coach Engine]
        LLMR -->|Video / Camera Streams| PAE[Pose Analysis Engine]
        LLMR -->|Prakriti & Macros| NE[Nutrition Engine]
        LLMR -->|HRV & Stress Adaptive| ME[Meditation Engine]
        LLMR -->|Curriculum & Progression| WP[Workout Planner Engine]
        LLMR -->|Longitudinal Trends| HIE[Health Insight Engine]
        LLMR -->|Catalog & Teacher Match| RE[Recommendation Engine]
    end
    
    subgraph External_and_Edge [Inference Providers & Telemetry]
        LLMR -->|Heavy Reasoning| Gemini[Google Gemini 1.5 Pro]
        LLMR -->|Fast Dialogue| Claude[Anthropic Claude 3.5 Sonnet]
        LLMR -->|Fallback / Vision| OpenAI[OpenAI GPT-4o]
        PAE -->|Edge Pre-processing| EdgeAI[MediaPipe / MoveNet Edge TFLite]
        ACE -->|RLHF & Metrics| AAE[AI Analytics Engine]
        AAE -->|Closed-Loop Tuning| AFE[AI Feedback Engine]
    end
```

### 1.1 Service Responsibilities & Contracts

1. **AI Gateway**:
   - **Responsibility**: Single entry point for all internal and external AI requests. Responsible for JWT authentication, per-tenant and per-user token quota enforcement, request rate limiting, PII/HIPAA data scrubbing (masking names, emails, phone numbers, and precise birthdates before LLM transmission), and automatic failover across model providers.
   - **Interface Contract**: Accepts standardized inference requests containing `tenant_id`, `user_id`, `session_id`, `intent_type`, and payload; returns sanitized, validated AI responses with token usage accounting headers.

2. **LLM Router**:
   - **Responsibility**: Dynamic model selection engine. Evaluates incoming prompts based on complexity, latency constraints, context window size, and cost budget. Routes real-time chat to lightweight, high-speed models (e.g., Claude 3 Haiku / Gemini Flash), complex health/curriculum reasoning to heavy models (e.g., Gemini 1.5 Pro / GPT-4o), and vision tasks to multimodal vision models.

3. **Prompt Orchestrator**:
   - **Responsibility**: The central execution coordinator. Assembles final prompts by injecting retrieved RAG context from the Knowledge Base, short-term memory from Redis, user health telemetry from PostgreSQL, and system instructions from Prompt Templates. Enforces strict JSON schema validation on LLM outputs using structured output parsers.

4. **Prompt Templates**:
   - **Responsibility**: A versioned, database-backed repository of system prompts, few-shot examples, persona definitions, and safety guardrails. Supports dynamic Jinja2/Handlebars variable substitution (e.g., `{{student_name}}`, `{{dosha_type}}`, `{{injury_history}}`, `{{current_pose}}`). Allows zero-code prompt engineering updates without backend redeployments.

5. **Conversation Manager**:
   - **Responsibility**: Manages multi-turn dialogue state across web and mobile sessions. Handles session persistence, automatic summarization of chat histories exceeding 4,000 tokens, context pruning, and bidirectional WebSocket/Server-Sent Events (SSE) streaming to clients.

6. **Memory Engine**:
   - **Responsibility**: Dual-layer memory architecture:
     - *Short-Term Memory*: In-memory Redis store maintaining active workout state, ongoing chat turns, and real-time biometric readings (TTL: 24 hours).
     - *Long-Term Memory*: PostgreSQL database utilizing `pgvector` HNSW indexes to store structured summaries, past injury logs, milestone achievements, and student preference embeddings for lifelong personalization.

7. **Knowledge Base**:
   - **Responsibility**: Curated, authoritative vector repository of ancient yogic scriptures (Patanjali Yoga Sutras, Hatha Yoga Pradipika), Ayurvedic pharmacopeia, modern biomechanical research, and clinical physical therapy contraindications. Serves as the ground truth for all RAG retrieval operations to eliminate medical hallucinations.

8. **Embeddings Service**:
   - **Responsibility**: High-throughput vectorization engine generating 1536-dimensional dense vector embeddings for user queries, course transcripts, teacher biographies, and community discussions. Processes requests synchronously for real-time search and asynchronously via batch queues for catalog indexing.

9. **Recommendation Engine**:
   - **Responsibility**: Hybrid recommendation pipeline combining collaborative filtering (matrix factorization on student enrollment histories), content-based vector cosine similarity, and real-time contextual signals (time of day, current mood, soreness logs) to deliver hyper-personalized course, teacher, and live class feeds.

10. **AI Coach Engine**:
    - **Responsibility**: Real-time interactive digital yoga master. Operates during live classes or solo practice to deliver adaptive verbal and visual cues, pacing adjustments, motivation, and immediate form corrections based on biometric feedback and pose telemetry.

11. **Pose Analysis Engine**:
    - **Responsibility**: Hybrid Edge-Cloud Computer Vision pipeline. Edge devices (iOS/Android/Web) run lightweight TensorFlow Lite / MediaPipe models at 30fps to extract 33 3D skeletal keypoints. Keypoint coordinates are streamed via WebRTC/WebSocket to the cloud engine, which calculates joint angles, center of gravity, and alignment vectors against golden reference poses, returning real-time corrective geometry (e.g., "Elevate left arm by 12 degrees to align with shoulder axis").

12. **Nutrition Engine**:
    - **Responsibility**: Ayurvedic and clinical macro/micro-nutrient intelligence service. Analyzes student Prakriti (inherent constitution) and Vikriti (current imbalance) across Vata, Pitta, and Kapha doshas, combined with metabolic goals and allergies, to generate customized weekly meal plans, recipes, and grocery lists.

13. **Meditation Engine**:
    - **Responsibility**: Generative mindfulness and breathwork (Pranayama) coordinator. Synthesizes personalized guided meditation scripts, breath pacing cadences (e.g., 4-7-8 Anulom Vilom, Box Breathing), and dynamic binaural/ambient audio soundscapes adapted to real-time Heart Rate Variability (HRV) and stress logs.

14. **Workout Planner**:
    - **Responsibility**: Intelligent curriculum architect. Builds multi-week, progressive overload yoga and wellness roadmaps tailored to user goals (e.g., prenatal strength, sciatica relief, advanced inversion mastery). Automatically adapts daily intensity based on sleep scores and recovery metrics.

15. **Health Insight Engine**:
    - **Responsibility**: Multi-modal health data synthesizer. Ingests wearable telemetry (Apple HealthKit, Google Health Connect, Oura, Whoop), workout completion rates, sleep stages, and subjective mood journals to detect longitudinal health trends, predicting burnout or overtraining risks 14 days in advance.

16. **AI Analytics Engine**:
    - **Responsibility**: Observability and governance telemetry collector for the AI tier. Records inference latency histograms, token burn rates per tenant/user, LLM error rates, RAG retrieval relevance scores, and pose analysis accuracy distributions.

17. **AI Feedback Engine**:
    - **Responsibility**: Closed-loop Reinforcement Learning from Human Feedback (RLHF) and expert review system. Captures explicit user feedback (thumbs up/down, regenerated answers), teacher overrides during live classes, and physical therapist audits to continuously refine prompt templates and curate high-quality fine-tuning datasets.

---

## SECTION 2: EVENT-DRIVEN ARCHITECTURE

Yoga24X implements an asynchronous, highly decoupled Event-Driven Architecture (EDA) utilizing an **Enterprise Event Bus** backed by **Redis Pub/Sub** (for real-time low-latency fanout) and **BullMQ / Apache Kafka** (for durable, replayable, ordered domain stream processing).

```mermaid
sequenceDiagram
    autonumber
    participant Prod as Domain Producer (e.g., Booking)
    participant Bus as Enterprise Event Bus
    participant DLQ as Dead Letter Queue (DLQ)
    participant Cons1 as Consumer 1 (Wallet Service)
    participant Cons2 as Consumer 2 (Notification Service)
    participant Cons3 as Consumer 3 (AI Analytics)

    Prod->>Bus: Publish CloudEvent (booking.slot.reserved.v1)
    
    par Parallel Asynchronous Fanout
        Bus->>Cons1: Deliver Event
        Bus->>Cons2: Deliver Event
        Bus->>Cons3: Deliver Event
    end
    
    Note over Cons1: Check Idempotency Key (Redis)<br/>Execute Atomic DB Transaction<br/>Mark Event Processed
    Cons1-->>Bus: ACK (Success)
    
    Note over Cons2: Network Timeout / SMTP Failure
    Cons2-->>Bus: NACK (Retry Required)
    
    loop Exponential Backoff Retry (Up to 5 attempts)
        Bus->>Cons2: Redeliver Event (attempt = n)
    end
    
    Note over Cons2: Attempt 5 Failed (Max Retries Exceeded)
    Bus->>DLQ: Route to DLQ (booking.slot.reserved.v1.dlq)
    DLQ->>DLQ: Trigger Alerting (PagerDuty / Slack)<br/>Store for Manual/Automated Replay
```

### 2.1 Event Classification & Taxonomy

1. **Domain Events**:
   - **Definition**: Events emitted and consumed exclusively within the boundaries of a single Bounded Context. Used to trigger aggregate consistency rules without leaving the module boundary.
   - *Example*: Inside the `Learning` (LMS) module: `lesson.progress.updated` triggers recalculation of `course.completion_percentage`.
2. **Integration Events**:
   - **Definition**: Public, immutable historical facts published across Bounded Contexts to notify external services of significant state transformations. Must adhere to strict JSON schema contracts.
   - *Example*: `learning.course.completed.v1` published by LMS module; consumed by `Finance` module (to issue reward coins) and `Notification` module (to send congratulatory email/push).
3. **Internal System Events**:
   - **Definition**: Technical telemetry and operational infrastructure lifecycle events used for cache eviction, rate limit adjustments, and security logging.
   - *Example*: `infra.cache.invalidated`, `security.ratelimit.breached`, `iam.token.revoked`.

### 2.2 Event Naming Convention & Versioning Strategy

- **Naming Syntax**: `<bounded_context>.<entity>.<past_tense_action>.<schema_version>`
  - Must be lowercase, dot-separated, alphanumeric ASCII strings.
  - *Valid Examples*: `iam.user.registered.v1`, `booking.class.cancelled.v2`, `finance.payment.failed.v1`.
- **Versioning Strategy**:
  - All event schemas must implement the **CloudEvents v1.0** specification.
  - **Non-Breaking Changes** (adding optional fields, adding metadata tags) DO NOT increment the version number; consumers must be engineered to ignore unrecognized fields (Tolerant Reader pattern).
  - **Breaking Changes** (removing fields, changing field data types, renaming semantic keys) MUST increment the version suffix (`v1` $\to$ `v2`). Producers must double-publish both `v1` and `v2` events during a mandatory 30-day deprecation window until all consumers migrate.

### 2.3 Reliability Primitives: Retries, DLQ, Ordering, and Idempotency

- **Event Retry Policy**:
  - Transient failures (network timeouts, DB lock contention, third-party API 5xx errors) trigger automated retries using an exponential backoff algorithm with randomized jitter:
    $$\text{Delay}_{attempt} = \min\left(\text{MaxDelay}, \text{BaseDelay} \times 2^{attempt} + \text{RandomJitter}(0, 1000\text{ms})\right)$$
  - *Configuration*: `BaseDelay` = 2,000ms, `MaxDelay` = 86,400,000ms (24 hours), `MaxAttempts` = 5.
- **Dead Letter Queue (DLQ) Management**:
  - If an event fails processing after 5 retry attempts, it is stripped from the active queue and moved atomically to the corresponding DLQ: `<original_queue_name>:dlq`.
  - DLQ insertion automatically fires a critical Prometheus metric (`dlq_messages_total`) and triggers PagerDuty alerts. DLQ messages retain full stack traces, error headers, and original timestamps to enable surgical automated or manual CLI replay once the root cause is remediated.
- **Event Ordering Strategy**:
  - Absolute global ordering across 100M events is anti-scalable and unnecessary. Yoga24X enforces **Causal / Partitioned Ordering**.
  - All integration events must include a `partition_key` (typically the Aggregate Root ID: `user_id`, `booking_id`, or `course_id`). The message broker guarantees strictly ordered FIFO delivery for all events sharing the exact same `partition_key`.
- **Idempotency Strategy**:
  - Every emitted event carries a globally unique UUID v4 `event_id` and a `correlation_id`.
  - Consumers enforce strict **Exactly-Once Processing** via a two-stage deduplication mechanism:
    1. *Fast In-Memory Check*: Query Redis key `idempotency:consumer:<consumer_name>:event:<event_id>`. If key exists, drop event immediately as duplicate.
    2. *Atomic Database Transaction*: Ingest the event inside an ACID database transaction that inserts `event_id` into an immutable `processed_events` table (`PRIMARY KEY (consumer_name, event_id)`). If a duplicate slips past Redis, the database unique constraint raises a unique violation, causing the consumer to gracefully ACK and discard the message without re-executing business logic.

### 3.4 Typical Event JSON Contracts (CloudEvents v1.0)

#### 1. `iam.user.registered.v1`
```json
{
  "specversion": "1.0",
  "id": "a8f9c2e4-3b1d-4f6a-8c9e-1d2b3c4d5e6f",
  "source": "/iam/auth-service",
  "type": "iam.user.registered.v1",
  "datacontenttype": "application/json",
  "subject": "usr_9988776655",
  "time": "2026-07-06T12:16:46.000Z",
  "partition_key": "usr_9988776655",
  "correlation_id": "req_1122334455",
  "data": {
    "user_id": "usr_9988776655",
    "tenant_id": "tnt_default_global",
    "email": "student.alex@yoga24x.com",
    "first_name": "Alex",
    "last_name": "Sharma",
    "role": "STUDENT",
    "registration_source": "GOOGLE_SSO",
    "preferred_language": "en-US",
    "registered_at": "2026-07-06T12:16:45.890Z"
  }
}
```

#### 2. `booking.slot.created.v1`
```json
{
  "specversion": "1.0",
  "id": "b1a2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d",
  "source": "/booking/scheduling-service",
  "type": "booking.slot.created.v1",
  "datacontenttype": "application/json",
  "subject": "bkg_4455667788",
  "time": "2026-07-06T12:17:00.000Z",
  "partition_key": "bkg_4455667788",
  "correlation_id": "req_5566778899",
  "data": {
    "booking_id": "bkg_4455667788",
    "tenant_id": "tnt_studio_mumbai_01",
    "user_id": "usr_9988776655",
    "class_id": "cls_1122334455",
    "teacher_id": "thr_8877665544",
    "slot_start_time": "2026-07-10T06:00:00.000Z",
    "slot_end_time": "2026-07-10T07:00:00.000Z",
    "booking_status": "CONFIRMED",
    "amount_paid": 500.00,
    "currency": "INR"
  }
}
```

#### 3. `booking.slot.cancelled.v1`
```json
{
  "specversion": "1.0",
  "id": "c2d3e4f5-a6b7-8c9d-0e1f-2a3b4c5d6e7f",
  "source": "/booking/scheduling-service",
  "type": "booking.slot.cancelled.v1",
  "datacontenttype": "application/json",
  "subject": "bkg_4455667788",
  "time": "2026-07-08T09:30:00.000Z",
  "partition_key": "bkg_4455667788",
  "correlation_id": "req_6677889900",
  "data": {
    "booking_id": "bkg_4455667788",
    "tenant_id": "tnt_studio_mumbai_01",
    "user_id": "usr_9988776655",
    "class_id": "cls_1122334455",
    "cancellation_reason": "STUDENT_EMERGENCY",
    "cancelled_by": "USER",
    "refund_eligible": true,
    "refund_amount": 500.00,
    "cancelled_at": "2026-07-08T09:29:58.120Z"
  }
}
```

#### 4. `learning.course.completed.v1`
```json
{
  "specversion": "1.0",
  "id": "d3e4f5a6-b7c8-9d0e-1f2a-3b4c5d6e7f8a",
  "source": "/learning/lms-service",
  "type": "learning.course.completed.v1",
  "datacontenttype": "application/json",
  "subject": "enr_3344556677",
  "time": "2026-07-09T15:45:00.000Z",
  "partition_key": "usr_9988776655",
  "correlation_id": "req_7788990011",
  "data": {
    "enrollment_id": "enr_3344556677",
    "user_id": "usr_9988776655",
    "course_id": "crs_9988776655",
    "course_title": "200-Hour Hatha Yoga Mastery",
    "teacher_id": "thr_8877665544",
    "total_lessons": 48,
    "completion_score_percentage": 98.5,
    "completed_at": "2026-07-09T15:44:55.000Z"
  }
}
```

#### 5. `finance.payment.succeeded.v1`
```json
{
  "specversion": "1.0",
  "id": "e4f5a6b7-c8d9-0e1f-2a3b-4c5d6e7f8a9b",
  "source": "/finance/billing-service",
  "type": "finance.payment.succeeded.v1",
  "datacontenttype": "application/json",
  "subject": "pay_2233445566",
  "time": "2026-07-06T12:16:55.000Z",
  "partition_key": "pay_2233445566",
  "correlation_id": "req_5566778899",
  "data": {
    "payment_id": "pay_2233445566",
    "order_id": "ord_1122334455",
    "user_id": "usr_9988776655",
    "gateway_reference": "rzp_pay_99887766554433",
    "amount": 4999.00,
    "currency": "INR",
    "payment_method": "UPI",
    "paid_at": "2026-07-06T12:16:54.100Z"
  }
}
```

#### 6. `finance.payment.failed.v1`
```json
{
  "specversion": "1.0",
  "id": "f5a6b7c8-d9e0-1f2a-3b4c-5d6e7f8a9b0c",
  "source": "/finance/billing-service",
  "type": "finance.payment.failed.v1",
  "datacontenttype": "application/json",
  "subject": "pay_2233445567",
  "time": "2026-07-06T12:18:00.000Z",
  "partition_key": "pay_2233445567",
  "correlation_id": "req_8899001122",
  "data": {
    "payment_id": "pay_2233445567",
    "order_id": "ord_1122334456",
    "user_id": "usr_9988776655",
    "gateway_reference": "rzp_pay_failed_887766",
    "amount": 1499.00,
    "currency": "INR",
    "failure_code": "INSUFFICIENT_FUNDS",
    "failure_reason": "Account balance low or limit exceeded",
    "failed_at": "2026-07-06T12:17:59.000Z"
  }
}
```

#### 7. `notification.dispatch.created.v1`
```json
{
  "specversion": "1.0",
  "id": "a6b7c8d9-e0f1-2a3b-4c5d-6e7f8a9b0c1d",
  "source": "/notification/dispatch-service",
  "type": "notification.dispatch.created.v1",
  "datacontenttype": "application/json",
  "subject": "ntf_7788990011",
  "time": "2026-07-06T12:17:01.000Z",
  "partition_key": "usr_9988776655",
  "correlation_id": "req_5566778899",
  "data": {
    "notification_id": "ntf_7788990011",
    "user_id": "usr_9988776655",
    "channels": ["PUSH", "EMAIL"],
    "template_code": "BOOKING_CONFIRMATION_V1",
    "priority": "HIGH",
    "payload_variables": {
      "class_name": "Ashtanga Vinyasa Flow",
      "start_time": "6:00 AM IST, 10 Jul"
    },
    "created_at": "2026-07-06T12:17:00.950Z"
  }
}
```

#### 8. `social.post.created.v1`
```json
{
  "specversion": "1.0",
  "id": "b7c8d9e0-f1a2-3b4c-5d6e-7f8a9b0c1d2e",
  "source": "/social/community-service",
  "type": "social.post.created.v1",
  "datacontenttype": "application/json",
  "subject": "pst_6677889900",
  "time": "2026-07-06T14:20:00.000Z",
  "partition_key": "pst_6677889900",
  "correlation_id": "req_9900112233",
  "data": {
    "post_id": "pst_6677889900",
    "author_id": "thr_8877665544",
    "tenant_id": "tnt_default_global",
    "community_id": "cmn_5544332211",
    "content_snippet": "Here are 3 tips to master Sirsasana (Headstand) without neck strain...",
    "media_asset_ids": ["med_1122334455"],
    "tags": ["#Inversion", "#HathaYoga", "#Safety"],
    "created_at": "2026-07-06T14:19:58.000Z"
  }
}
```

#### 9. `finance.referral.rewarded.v1`
```json
{
  "specversion": "1.0",
  "id": "c8d9e0f1-a2b3-4c5d-6e7f-8a9b0c1d2e3f",
  "source": "/finance/wallet-service",
  "type": "finance.referral.rewarded.v1",
  "datacontenttype": "application/json",
  "subject": "rew_5566778899",
  "time": "2026-07-06T12:16:48.000Z",
  "partition_key": "usr_1122334455",
  "correlation_id": "req_1122334455",
  "data": {
    "reward_id": "rew_5566778899",
    "referrer_user_id": "usr_1122334455",
    "referred_user_id": "usr_9988776655",
    "reward_type": "WALLET_CREDIT",
    "amount_credited": 250.00,
    "currency": "INR",
    "wallet_transaction_id": "wtx_9988776655",
    "issued_at": "2026-07-06T12:16:47.500Z"
  }
}
```

#### 10. `intelligence.analysis.completed.v1`
```json
{
  "specversion": "1.0",
  "id": "d9e0f1a2-b3c4-5d6e-7f8a-9b0c1d2e3f4a",
  "source": "/intelligence/ai-service",
  "type": "intelligence.analysis.completed.v1",
  "datacontenttype": "application/json",
  "subject": "anl_8899001122",
  "time": "2026-07-06T16:00:00.000Z",
  "partition_key": "usr_9988776655",
  "correlation_id": "req_0011223344",
  "data": {
    "analysis_id": "anl_8899001122",
    "user_id": "usr_9988776655",
    "session_id": "ses_4433221100",
    "analysis_type": "BIOMECHANICAL_POSE_EVALUATION",
    "pose_name": "Virabhadrasana II (Warrior II)",
    "overall_accuracy_score": 92.4,
    "keypoint_faults_detected": 1,
    "primary_correction_instruction": "Align anterior knee directly over ankle joint; prevent inward valgus collapse.",
    "tokens_consumed": 845,
    "processing_time_ms": 312,
    "completed_at": "2026-07-06T15:59:59.680Z"
  }
}
```

---

## SECTION 3: BACKGROUND JOB SYSTEM

To guarantee high API responsiveness and resilience against traffic surges, Yoga24X offloads all CPU-intensive, I/O-heavy, and scheduled operations to a distributed **Background Job System** powered by **BullMQ** running over an enterprise **Redis Cluster** (AWS ElastiCache / Redis Enterprise).

```mermaid
graph LR
    API[API Controllers / Event Consumers] -->|Dispatch Job| RedisCluster[(Redis Cluster: BullMQ Store)]
    
    subgraph Worker_Pools [Dedicated Worker Pools]
        RedisCluster -->|Pull| W_Email[Email Worker Pool]
        RedisCluster -->|Pull| W_Push[Push Worker Pool]
        RedisCluster -->|Pull| W_SMS[SMS Worker Pool]
        RedisCluster -->|Pull| W_Video[Video Processing Pool]
        RedisCluster -->|Pull| W_Thumb[Thumbnail Pool]
        RedisCluster -->|Pull| W_Cert[Certificate Pool]
        RedisCluster -->|Pull| W_AI[AI Batch Inference Pool]
        RedisCluster -->|Pull| W_Rec[Recommendation Pool]
        RedisCluster -->|Pull| W_Anl[Analytics Pool]
        RedisCluster -->|Pull| W_Rep[Report Generator Pool]
        RedisCluster -->|Pull| W_Bak[Backup Worker Pool]
        RedisCluster -->|Pull| W_Cln[Cleanup Worker Pool]
        RedisCluster -->|Pull| W_Ret[Webhook Retry Pool]
    end
    
    W_Video -->|Transcode| AWS_MC[AWS MediaConvert / FFmpeg]
    W_Cert -->|Render PDF| S3_Bucket[(AWS S3 Storage)]
    W_AI -->|Batch Inference| LLM_API[Vertex AI / OpenAI API]
```

### 3.1 Queue Specifications & Worker Responsibilities

| Queue Name | Concurrency | Retry / Backoff | Worker Responsibility & Operational Logic |
| :--- | :---: | :--- | :--- |
| **`email-queue`** | 50 | 5 attempts / Exponential (1m base) | Renders dynamic MJML/Handlebars HTML email templates; attaches ICS calendar files for bookings; interfaces with AWS SES / SendGrid API; handles bounce/complaint webhook processing and updates user suppression lists. |
| **`push-queue`** | 200 | 3 attempts / Immediate (5s base) | Batches device registration tokens (up to 500 per batch); communicates with Firebase Cloud Messaging (FCM) and APNs HTTP/2 APIs; handles silent background data synchronization and payload encryption. |
| **`sms-queue`** | 30 | 3 attempts / Exponential (10s base) | Dispatches high-priority transactional SMS (OTPs, urgent class cancellations) via Twilio / AWS SNS; manages DLT (Distributed Ledger Technology) template scrubbing required for Indian telecom compliance. |
| **`video-processing-queue`** | 10 | 2 attempts / Fixed (5m base) | Orchestrates asynchronous video pipelines: submits transcoding jobs to AWS Elemental MediaConvert; generates multi-bitrate HLS streams (1080p to 360p); embeds invisible forensic watermarks to prevent piracy. |
| **`thumbnail-queue`** | 40 | 3 attempts / Exponential (10s base) | Executes sharp/libvips image processing: generates WebP and AVIF responsive breakpoints (320w, 720w, 1080w); calculates BlurHash placeholders; extracts 3-second animated GIF preview loops from video files. |
| **`certificate-queue`** | 20 | 3 attempts / Exponential (30s base) | Spawns headless Chromium/Puppeteer instances to render high-resolution vector PDF graduation certificates; embeds cryptographic SHA-256 verification QR codes; uploads final assets to S3 and emails student. |
| **`ai-queue`** | 25 | 3 attempts / Exponential (1m base) | Executes heavy asynchronous AI tasks: processes multi-hour video recordings for batch biomechanical pose analysis; generates comprehensive health progress reports; executes offline RAG document chunking and vector indexing. |
| **`recommendation-queue`** | 15 | 2 attempts / Fixed (10m base) | Runs nightly collaborative filtering matrix factorization; updates user affinity vectors in PostgreSQL `user_embeddings`; pre-computes and caches personalized homepage course and teacher feeds in Redis. |
| **`analytics-queue`** | 100 | 5 attempts / Exponential (5s base) | High-throughput ingestion worker: drains raw clickstream events, video watch time heartbeats, and live class attendance logs; performs time-series rollup aggregations; updates real-time studio dashboards. |
| **`report-queue`** | 10 | 2 attempts / Exponential (2m base) | Generates heavy administrative exports (CSV, Excel, PDF): processes multi-year studio financial ledgers, teacher payroll calculations, and GST/tax compliance statements; emails secure S3 download link to admin. |
| **`backup-queue`** | 5 | 2 attempts / Fixed (15m base) | Orchestrates automated database backup verification; executes point-in-time recovery (PITR) simulation drills; audits cross-region S3 bucket replication status; archives audit logs to immutable AWS Glacier vaults. |
| **`cleanup-queue`** | 20 | 3 attempts / Fixed (1m base) | Enforces data retention and hygiene policies: soft-deletes expired JWT refresh tokens; purges stale Redis rate-limit buckets; sweeps unreferenced staging media uploads from S3 older than 24 hours. |
| **`retry-queue`** | 50 | 10 attempts / Exponential (1m base) | Dedicated delayed execution queue for temporarily failed third-party webhook deliveries (Razorpay payment callbacks, WhatsApp delivery receipts, calendar integrations); guarantees eventual consistency. |

---

## SECTION 4: WORKFLOW ENGINE

Complex multi-step business processes spanning multiple Bounded Contexts are managed by an enterprise **Distributed Workflow Engine** implementing the **Saga Pattern** (utilizing orchestrated state machines stored in PostgreSQL `workflow_instances` and `workflow_steps` tables).

```mermaid
stateDiagram-v2
    [*] --> INITIATED: User Submits Booking
    INITIATED --> VALIDATING: Check User Eligibility & Balance
    VALIDATING --> RESERVED: Lock Calendar Slot (EXCLUDE USING gist)
    VALIDATING --> FAILED: Ineligible / Slot Taken
    
    RESERVED --> PAYMENT_PENDING: Initiate Razorpay Gateway Order
    PAYMENT_PENDING --> CONFIRMED: PaymentSucceeded Webhook
    PAYMENT_PENDING --> COMPENSATING: PaymentFailed / Timeout (15m)
    
    COMPENSATING --> CANCELLED: Release Calendar Slot Lock
    CONFIRMED --> [*]: Emit BookingConfirmed Event
    CANCELLED --> [*]: Notify User (Booking Failed)
    FAILED --> [*]: Alert Student
```

### 4.1 Exhaustive Specification of 13 Core Business Workflows

#### 1. Authentication & Onboarding Workflow
- **States**: `INITIATED` $\to$ `OTP_SENT` $\to$ `VERIFIED` $\to$ `PROFILE_CREATION` $\to$ `COMPLETED` | `FAILED`.
- **Transitions**: Triggered by phone/email submission, OTP verification match, and onboarding questionnaire completion.
- **Failure Handling**: Invalid OTP attempts increment Redis counter; 5 failed attempts trigger 30-minute account lockout and alert IAM security monitor.
- **Rollback Strategy**: If onboarding fails during profile creation or DB transaction crash, delete orphaned authentication identities and purge Redis session tokens.
- **Retry Strategy**: Immediate retry for transient database connection drops; no retry on validation failures (fail fast).

#### 2. Class Booking Workflow
- **States**: `INITIATED` $\to$ `SLOT_RESERVED` $\to$ `PAYMENT_PENDING` $\to$ `CONFIRMED` | `COMPENSATING` $\to$ `CANCELLED`.
- **Transitions**: Student selects class $\to$ system acquires PostgreSQL exclusion lock on calendar slot $\to$ gateway payment succeeds.
- **Failure Handling**: If Razorpay payment webhook does not arrive within 15 minutes, transition workflow to `COMPENSATING`.
- **Rollback Strategy**: Execute compensating transaction: release PostgreSQL `EXCLUDE USING gist` calendar slot lock, decrement class enrollment counter, and void pending payment authorization.
- **Retry Strategy**: 3 exponential retries for payment gateway status verification API calls before initiating rollback.

#### 3. Payment Processing Workflow
- **States**: `ORDER_CREATED` $\to$ `GATEWAY_AUTHORIZED` $\to$ `CAPTURED` $\to$ `LEDGER_RECORDED` $\to$ `SETTLED` | `FAILED`.
- **Transitions**: Order creation $\to$ Razorpay signature verification $\to$ bank capture $\to$ immutable accounting ledger insertion.
- **Failure Handling**: Signature mismatch immediately aborts workflow, flags potential fraud in audit logs, and blocks user IP.
- **Rollback Strategy**: If ledger insertion fails post-capture, initiate automated Razorpay refund API call and alert financial engineering team.
- **Retry Strategy**: 5 exponential backoff retries with jitter for banking network capture timeouts.

#### 4. Refund & Dispute Workflow
- **States**: `REQUESTED` $\to$ `ELIGIBILITY_CHECK` $\to$ `ADMIN_REVIEW` $\to$ `GATEWAY_REFUND_INITIATED` $\to$ `REFUNDED` | `REJECTED`.
- **Transitions**: Student requests cancellation $\to$ automated rule check (e.g., >24h before class start) $\to$ gateway refund processing.
- **Failure Handling**: If gateway refund fails due to expired card or frozen account, transition to `MANUAL_PAYOUT_REQUIRED`.
- **Rollback Strategy**: Re-credit equivalent value to student's internal Yoga24X Wallet if bank payout cannot be routed.
- **Retry Strategy**: Daily automated retry for failed bank routing for up to 7 business days before escalating to support.

#### 5. Subscription & Recurring Billing Workflow
- **States**: `ACTIVE` $\to$ `RENEWAL_DUE` $\to$ `AUTO_DEBIT_INITIATED` $\to$ `RENEWED` | `GRACE_PERIOD` $\to$ `SUSPENDED` $\to$ `CANCELLED`.
- **Transitions**: Cron scheduler triggers at renewal date $\to$ UPI/Card auto-debit succeeds $\to$ subscription period extended by 30 days.
- **Failure Handling**: Auto-debit failure transitions subscription to 7-day `GRACE_PERIOD`; sends urgent payment update push/email.
- **Rollback Strategy**: If renewal fails post-grace period, revoke access to premium LMS courses and live class booking privileges without deleting user history.
- **Retry Strategy**: Automated retry on Day 1, Day 3, Day 5, and Day 7 of the grace period using alternate saved payment methods.

#### 6. Teacher Onboarding & Approval Workflow
- **States**: `SUBMITTED` $\to$ `DOC_VERIFICATION` $\to$ `BACKGROUND_CHECK` $\to$ `INTERVIEW_SCHEDULED` $\to$ `APPROVED` | `REJECTED`.
- **Transitions**: Teacher uploads Yoga Alliance RYT-200/500 certificates $\to$ admin verifies credentials $\to$ live audition passed.
- **Failure Handling**: Blurry or expired certificate documents trigger automatic transition to `DOC_RESUBMISSION_REQUIRED` with automated email instructions.
- **Rollback Strategy**: If rejected, revoke provisional teacher portal access, archive uploaded identity documents to cold storage, and delete public calendar availability.
- **Retry Strategy**: Allow up to 3 document resubmission attempts within 30 days before archiving application.

#### 7. Ayurvedic Doctor Verification Workflow
- **States**: `APPLIED` $\to$ `MEDICAL_COUNCIL_CHECK` $\to$ `DEGREE_AUTHENTICATION` $\to$ `PANEL_INTERVIEW` $\to$ `VERIFIED` | `REVOKED`.
- **Transitions**: Doctor submits BAMS/MD degrees and Medical Registration Number $\to$ automated/manual registry verification $\to$ approval.
- **Failure Handling**: Failure to authenticate registration number with State Ayurvedic Medical Board triggers immediate application freeze and compliance alert.
- **Rollback Strategy**: Revoke telemedicine prescribing privileges and remove profile from student consultation directory immediately upon license lapse or verification failure.
- **Retry Strategy**: Manual administrative override required after formal credential re-verification; no automated retry.

#### 8. Course Publishing & LMS Workflow
- **States**: `DRAFT` $\to$ `MEDIA_PROCESSING` $\to$ `AI_CURRICULUM_AUDIT` $\to$ `ADMIN_REVIEW` $\to$ `PUBLISHED` | `ARCHIVED`.
- **Transitions**: Teacher clicks publish $\to$ all video lessons transcode to HLS $\to$ AI checks for audio quality and safety $\to$ live in catalog.
- **Failure Handling**: If video transcoding fails for any lesson, hold course in `MEDIA_PROCESSING_ERROR` and notify instructor with specific file error codes.
- **Rollback Strategy**: If a published course is flagged for copyright or safety violations, atomically unpublish course, hide from search indexes, but maintain read-only access for already-enrolled students.
- **Retry Strategy**: Automated 3-time retry for failed video transcoding chunks before alerting media pipeline engineers.

#### 9. Certificate Generation & Issuance Workflow
- **States**: `ELIGIBLE` $\to$ `RENDERING_PDF` `$\to$` `CRYPTOGRAPHIC_SIGNING` $\to$ `S3_ARCHIVED` $\to$ `ISSUED` | `FAILED`.
- **Transitions**: Student completes 100% of course lessons and passes final exam $\to$ worker generates PDF $\to$ QR verification hash stored in DB.
- **Failure Handling**: Puppeteer PDF rendering timeout or memory overflow transitions job to `FAILED` and routes to `certificate-queue:dlq`.
- **Rollback Strategy**: If signing fails, delete un-signed PDF from S3 and remove unverified certificate record from student profile.
- **Retry Strategy**: 5 exponential backoff retries in background worker; zero user-facing error messages (student sees "Generating Certificate...").

#### 10. Retreat & Workshop Booking Workflow
- **States**: `INITIATED` $\to$ `ROOM_INVENTORY_LOCKED` $\to$ `DIETARY_LOGGED` $\to$ `PAYMENT_CONFIRMED` $\to$ `BOOKED` | `RELEASED`.
- **Transitions**: Student selects multi-day retreat room package $\to$ inventory decremented $\to$ payment completed.
- **Failure Handling**: If room inventory reaches zero during concurrent checkout, abort workflow instantly with "Sold Out" exception.
- **Rollback Strategy**: Release room inventory lock, restore available bed count, and trigger refund if payment was captured simultaneously.
- **Retry Strategy**: No automated retry on inventory exhaustion; student must select an alternative date or room tier.

#### 11. Community Content Moderation Workflow
- **States**: `SUBMITTED` $\to$ `AI_SAFETY_SCAN` $\to$ `LIVE` $\to$ `FLAGGED_BY_USER` $\to$ `HUMAN_MODERATION` $\to$ `REMOVED` | `RESTORED`.
- **Transitions**: User posts video/text $\to$ AI scans for hate speech, nudity, and medical misinformation $\to$ post published or sent to review queue.
- **Failure Handling**: If AI Moderation API experiences downtime, default to fail-safe mode: place post in temporary `PENDING_REVIEW` state rather than allowing unmoderated publishing.
- **Rollback Strategy**: If post is removed post-publishing, atomically decrement author's community reputation score and hide post from all user feeds and search indexes.
- **Retry Strategy**: Asynchronous retry of AI safety scan every 5 minutes during moderation service outages.

#### 12. AI Coaching Session Workflow
- **States**: `CONNECTING` $\to$ `WEBRTC_ESTABLISHED` $\to$ `STREAMING_POSE_DATA` $\to$ `ANALYZING` $\to$ `SESSION_SUMMARY_GENERATED` | `DISCONNECTED`.
- **Transitions**: Student starts live AI practice $\to$ camera feed opens $\to$ keypoint telemetry streamed to cloud $\to$ practice ends $\to$ report saved.
- **Failure Handling**: WebRTC connection drop or packet loss >15% triggers graceful degradation: switch from real-time 30fps stream to 1fps snapshot evaluation without terminating practice.
- **Rollback Strategy**: If session crashes prematurely, save partial practice duration to student's daily streak log; do not penalize completion percentage.
- **Retry Strategy**: Client SDK implements automated exponential WebSocket reconnection with session token resumption.

#### 13. Order Processing & Physical E-Commerce Workflow
- **States**: `CART_CHECKOUT` $\to$ `INVENTORY_RESERVED` $\to$ `PAID` $\to$ `WAREHOUSE_DISPATCHED` $\to$ `SHIPPED` $\to$ `DELIVERED` | `RETURNED`.
- **Transitions**: Student buys yoga mat/props $\to$ SKU inventory locked $\to$ payment confirmed $\to$ shipping label generated via Delhivery/BlueDart API.
- **Failure Handling**: Warehouse stock discrepancy (item missing) transitions order to `BACKORDERED`; automated SMS sent to user offering instant refund or delayed shipping.
- **Rollback Strategy**: Release SKU inventory reservation, credit refund to original payment source, and cancel generated logistics waybill.
- **Retry Strategy**: 3 retries for logistics courier API integration failures during waybill generation.

---

## SECTION 5: MEDIA PIPELINE

All audio, video, image, and document assets uploaded to Yoga24X pass through an automated, serverless, **11-Step Media Processing Pipeline** engineered for high security, zero piracy, and low-latency global streaming.

```mermaid
graph TD
    Client[Client App / Web] -->|1. Request Upload URL| APIGW[API Gateway]
    APIGW -->|2. Generate Pre-signed URL| S3_Staging[(S3: staging-bucket)]
    Client -->|3. Direct Multipart Upload| S3_Staging
    
    S3_Staging -->|4. S3 ObjectCreated Event| Lambda_Scan[AWS Lambda: ClamAV / GuardDuty Virus Scan]
    Lambda_Scan -->|Infected| Quarantine[(S3: quarantine-bucket)]
    Lambda_Scan -->|Clean| Lambda_Meta[AWS Lambda: ExifTool Metadata & GPS Strip]
    
    Lambda_Meta -->|5. Dispatch Job| BullMQ_Media[BullMQ: video / thumbnail queues]
    
    subgraph Media_Processing_Engine [Transcoding & Optimization Engine]
        BullMQ_Media -->|Images| Vips[libvips / Sharp: WebP / AVIF & Breakpoints]
        BullMQ_Media -->|Videos| MediaConvert[AWS MediaConvert: ABR Transcoding]
        MediaConvert -->|6. Encrypt & Chunk| HLS[HLS .m3u8 + AES-128 / DRM FairPlay]
        Vips -->|7. Generate Previews| Thumb[Thumbnails & BlurHash]
    end
    
    HLS -->|8. Store Production Media| S3_Prod[(S3: production-media-bucket)]
    Thumb -->|Store Assets| S3_Prod
    
    S3_Prod -->|9. Edge Replication| CloudFront[AWS CloudFront CDN / Cloudflare]
    CloudFront -->|10. Signed Cookies / URLs| Student_Player[Student Secure Video Player]
    
    BullMQ_Media -->|11. Atomic DB Update| DB[(PostgreSQL: media_assets table)]
```

### 5.1 End-to-End Media Lifecycle & Processing Rules

1. **Direct-to-Cloud Upload**:
   - The backend API never handles raw binary media streams. The client requests a secure, time-bounded (15-minute expiration) **AWS S3 Pre-signed URL** from the API Gateway.
   - The client performs a direct multipart upload to `s3://yoga24x-staging-upload/`, utilizing S3 Transfer Acceleration for low latency across global network hops.
2. **Automated Virus & Malware Scrubbing**:
   - S3 `ObjectCreated:Put` events immediately trigger an asynchronous AWS Lambda function running ClamAV and AWS GuardDuty Malware Protection.
   - Any file testing positive for malware, ransomware signatures, or zip bombs is immediately moved to `s3://yoga24x-quarantine/`, and an alert is dispatched to SecOps. Clean files proceed to step 3.
3. **Metadata Extraction & Privacy Sanitization**:
   - An extraction worker runs `ExifTool` and `FFprobe` to capture technical metadata (codec, bitrate, color space, frame rate, resolution, duration, audio channels).
   - **Privacy Enforcement**: All EXIF GPS geolocation tags, device serial numbers, and creator author tags are permanently stripped before public storage to protect teacher and student privacy.
4. **Image & Audio Compression**:
   - *Images*: Converted to next-generation formats (**WebP** and **AVIF**) at 85% visual quality compression using `libvips`/`sharp`, reducing payload size by 40% over JPEG without visual degradation.
   - *Audio*: Meditation tracks and podcasts are normalized to -14 LUFS (Loudness Units Full Scale) and compressed into AAC (128 kbps) and MP3 (192 kbps) formats.
5. **Multi-Resolution Thumbnail & Preview Generation**:
   - For every video and image, the pipeline generates three standard responsive image breakpoints: `320w` (mobile thumbnail), `720w` (tablet/grid view), and `1080w` (desktop hero).
   - **BlurHash Generation**: A 20-character base83 BlurHash string is computed and stored in the database to render instant, beautiful placeholder gradients while images load on slow cellular networks.
   - **Video Previews**: An automated worker extracts a 3-second animated WebP/GIF looping preview from the 20% timestamp of video files for catalog hover effects.
6. **Adaptive Bitrate (ABR) Video Transcoding**:
   - Video files are submitted to **AWS Elemental MediaConvert** to transcode source footage into multi-bitrate HTTP Live Streaming (**HLS**) bundles.
   - Transcoding ladder:
     - `1080p` (1920x1080, 4.5 Mbps, H.264 High Profile @ L4.0)
     - `720p` (1280x720, 2.4 Mbps, H.264 Main Profile @ L3.1)
     - `480p` (854x480, 1.2 Mbps, H.264 Main Profile @ L3.0)
     - `360p` (640x360, 600 kbps, H.264 Baseline Profile @ L3.0)
7. **HLS Generation & Digital Rights Management (DRM)**:
   - All premium LMS course videos are segmented into 4-second `.ts` transport stream chunks governed by a master `.m3u8` playlist.
   - **Content Protection**: Streams are encrypted using **AES-128 envelope encryption**. For premium paid tiers, enterprise DRM is applied (Apple FairPlay for iOS/macOS, Google Widevine for Android/Chrome, Microsoft PlayReady for Edge/Windows).
8. **CDN Edge Distribution & Secure Access**:
   - Processed assets are published to `s3://yoga24x-production-media/`, which serves as the origin for an enterprise global CDN (**AWS CloudFront** / **Cloudflare Enterprise**).
   - **Anti-Piracy Enforcement**: Raw CDN URLs are completely blocked. Media can only be accessed via **CloudFront Signed URLs or Signed Cookies** with a short 60-minute TTL, generated dynamically by the backend only after verifying that the requesting user has an active course enrollment or membership in PostgreSQL.
9. **Tiered Storage Lifecycle Strategy**:
   - To optimize cloud storage economics across petabytes of video data, S3 Lifecycle Policies enforce automatic storage class tiering:
     - *Days 0–90*: **S3 Standard** (High-frequency access for active enrolled courses).
     - *Days 91–365*: **S3 Infrequent Access (Standard-IA)** (30% cost reduction for older courses).
     - *Day 365+*: **S3 Glacier Instant Retrieval** (Archive storage for legacy recordings, instant streamability maintained).
10. **Database Registration**:
    - Upon successful transcoding, the worker executes an atomic database transaction updating the `media_assets` and `course_lessons` tables: sets `status = 'READY'`, populates `hls_manifest_url`, `duration_seconds`, `blurhash`, and links thumbnail URLs.
11. **Deletion & Purge Strategy**:
    - When a teacher deletes a course or video, the database record is marked as soft-deleted (`deleted_at = NOW()`).
    - After a mandatory **30-day grace period**, a scheduled cleanup worker fires an S3 Batch Delete API call wiping all HLS chunks, thumbnails, and source files, and dispatches a CDN cache invalidation request (`/*`) to remove edge replicas globally.

---

## SECTION 6: SEARCH ARCHITECTURE

Yoga24X implements a high-performance **Unified Hybrid Search Engine** combining **Lexical Search** (Meilisearch / Elasticsearch / PostgreSQL `pg_trgm`) and **Semantic Vector Search** (`pgvector` HNSW) across **11 core domain indexes**: *Teachers, Courses, Lessons, Products, Doctors, Blogs, Community Posts, Retreats, Workshops, Users, and AI Knowledge Base*.

```mermaid
graph TD
    Client[Client Search Bar] -->|Search Query| APIGW[API Gateway]
    APIGW -->|Check Cache| SearchCache[(Redis: Search Cache L2)]
    SearchCache -->|Cache Miss| SearchEngine[Unified Hybrid Search Router]
    
    subgraph Hybrid_Search_Execution [Parallel Search Execution]
        SearchEngine -->|1. Lexical / Keyword| Lexical[Meilisearch / Elasticsearch: BM25]
        SearchEngine -->|2. Semantic Vector| Embed[Embeddings Service: OpenAI / Vertex]
        Embed -->|1536-dim Vector| Vector[PostgreSQL pgvector: HNSW Cosine]
    end
    
    Lexical -->|Lexical Scores| Ranker[Reciprocal Rank Fusion RRF Engine]
    Vector -->|Semantic Scores| Ranker
    
    Ranker -->|Apply Business Rules| FinalRank[Multi-Factor Ranking Engine]
    FinalRank -->|Cache & Return| SearchCache
    FinalRank -->|Paginated JSON| Client
    
    subgraph RealTime_Indexing_CDC [Real-Time CDC Indexing Pipeline]
        DB[(PostgreSQL Primary DB)] -->|WAL / Debezium CDC| Kafka[Kafka / Event Bus]
        Kafka -->|Index Mutation| Lexical
        Kafka -->|Generate Embedding| Embed
    end
```

### 6.1 Search Capabilities & Math Formulations

1. **Real-Time Indexing Strategy (CDC)**:
   - Database mutations (inserts, updates, deletes) in PostgreSQL must not cause stale search results. We implement **Change Data Capture (CDC)** via Debezium / Prisma Middleware publishing to the Event Bus.
   - Search indexers consume mutation events and update both lexical indexes (Meilisearch) and vector embeddings (`pgvector`) within **500 milliseconds** of database commit.
2. **Multi-Factor Hybrid Ranking Algorithm**:
   - To balance exact keyword matching with deep semantic relevance and business logic, search results are merged using **Reciprocal Rank Fusion (RRF)** and scored via a weighted mathematical formulation:
     $$\text{FinalScore} = w_1 \cdot \text{BM25}_{norm} + w_2 \cdot \text{CosineSim}_{norm} + w_3 \cdot \log(\text{Enrollments} + 1) + w_4 \cdot \left(\frac{\text{Rating}}{5.0}\right) + w_5 \cdot \text{RecencyDecay} - w_6 \cdot \text{DistancePenalty}$$
   - *Default Weights*: $w_1 = 0.30$ (Keywords), $w_2 = 0.35$ (Semantic meaning), $w_3 = 0.15$ (Popularity), $w_4 = 0.10$ (Quality rating), $w_5 = 0.10$ (Freshness), $w_6 = 0.20$ (Geographic distance for physical retreats/studios).
3. **Sub-20ms Autocomplete & Typeahead**:
   - Powered by an Edge N-gram Trie index stored in Redis / Meilisearch. Generates instant suggestions after the user types 2 characters.
   - Evaluates historical search frequency and user personalization to surface top 5 suggestions (e.g., typing "as" suggests: *Ashtanga Yoga*, *Asanas for Beginners*, *Ashram Retreats*).
4. **Fuzzy Search & Spell Correction**:
   - Implements **Damerau-Levenshtein Distance** with a maximum edit distance of $k=2$.
   - Automatically corrects complex yogic and Sanskrit spelling errors without zero-result dead ends (e.g., query `"vinaysa flow"` automatically matches `"Vinyasa Flow"`; `"surya namascar"` matches `"Surya Namaskar"`).
5. **Yogic & Ayurvedic Synonym Dictionary**:
   - A custom domain thesaurus is compiled into the indexing analyzer to ensure bidirectional expansion of English and Sanskrit terms:
     - `"Pranayama"` $\leftrightarrow$ `"Breathwork"` $\leftrightarrow$ `"Breathing Exercises"` $\leftrightarrow$ `"Anulom Vilom"`
     - `"Sirsasana"` $\leftrightarrow$ `"Headstand"` $\leftrightarrow$ `"Inversion"`
     - `"Dosha"` $\leftrightarrow$ `"Ayurvedic Body Type"` $\leftrightarrow$ `"Prakriti"` $\leftrightarrow$ `"Vata/Pitta/Kapha"`
6. **Faceted Navigation & Filtering**:
   - Search responses return dynamic, multi-select faceted aggregations with instant hit counts:
     - *Difficulty*: Beginner (4,200), Intermediate (2,100), Advanced (850)
     - *Duration*: < 15 mins, 15–30 mins, 30–60 mins, 60+ mins
     - *Anatomy Focus*: Lower Back, Hips, Core, Hamstrings, Shoulders, Neck
     - *Instructor Rating*: 4.5+ Stars, 4.0+ Stars
7. **Cursor-Based Pagination**:
   - Traditional offset-based pagination (`OFFSET 10000 LIMIT 20`) is strictly forbidden due to database $O(N)$ scanning degradation.
   - All search endpoints implement **Cursor-Based Pagination** using an opaque base64-encoded cursor containing the item's sort key and unique ID (`cursor = base64(score, course_id)`), guaranteeing constant time $O(1)$ page fetches regardless of depth.
8. **Two-Tier Search Caching Strategy**:
   - **Tier 1 (API Gateway Memory)**: Local LRU cache storing top 100 trending queries (e.g., "morning yoga", "weight loss flow") with a 5-minute TTL. Serves responses in $<2\text{ms}$.
   - **Tier 2 (Redis Distributed Cache)**: Caches complex faceted search queries keyed by a SHA-256 hash of the normalized query string and filter matrix (`search:query:<sha256>`) with a 1-hour TTL. Event listeners immediately evict related cache tags upon course or teacher entity updates.

---

## SECTION 7: NOTIFICATION ARCHITECTURE

Yoga24X provides an enterprise **Multi-Channel Notification Engine** capable of reliably dispatching millions of real-time alerts across **6 distinct communication channels**: *Push Notifications, Email, SMS, WhatsApp, In-App Persistent Inbox, and Web Browser Push*.

```mermaid
graph TD
    Trigger[Event Bus / Cron Scheduler] -->|Dispatch Notification| NService[Notification Dispatch Service]
    NService -->|1. Fetch User Preferences| DB_Pref[(PostgreSQL: notification_preferences)]
    NService -->|2. Check Channel Opt-In| OptCheck{Is Channel Enabled?}
    
    OptCheck -->|No (Opted Out)| Drop[Discard & Log Suppression]
    OptCheck -->|Yes| Template[Template Engine: Handlebars + i18n]
    
    Template -->|3. Render Localized Payload| Router[Multi-Channel Priority Router]
    
    subgraph Priority_Queues [BullMQ Priority Queues]
        Router -->|High: OTP / Live Class| Q_High[High Priority Queue]
        Router -->|Medium: Booking / Social| Q_Med[Medium Priority Queue]
        Router -->|Low: Marketing / Digests| Q_Low[Low Priority Queue]
    end
    
    subgraph Channel_Adapters [External Channel Providers]
        Q_High --> Push[FCM / Apple APNs Push]
        Q_High --> SMS[Twilio / AWS SNS SMS]
        Q_Med --> Email[AWS SES / SendGrid Email]
        Q_Med --> WhatsApp[Twilio / Meta WhatsApp API]
        Q_Med --> InApp[WebSocket / SSE + DB Inbox]
        Q_Low --> WebPush[Browser Web Push API]
    end
    
    Push -->|4. Delivery Webhook| Tracker[Delivery Tracking & Analytics Service]
    Email -->|Open / Click Webhook| Tracker
    WhatsApp -->|Read Receipt Webhook| Tracker
    Tracker -->|5. Update Lifecycle State| DB_Logs[(PostgreSQL: notification_logs)]
```

### 7.1 Channel Capabilities, Preferences, and Governance

1. **Granular Preference Matrix (`notification_preferences`)**:
   - Users maintain absolute control over their communication experience. The database stores a 2D boolean matrix mapping **Channels** (Push, Email, SMS, WhatsApp) against **Notification Categories**:
     - *Transactional & Security*: OTPs, password resets, payment receipts, login alerts (MANDATORY: cannot be disabled by user).
     - *Schedule Reminders*: Class starting in 30 mins, retreat itinerary updates, teacher cancellations (Default: ON).
     - *AI Coaching & Health*: Daily wellness check-in, streak reminders, personalized meal plan alerts (Default: ON).
     - *Community & Social*: Likes, comments, new follower alerts, group chat messages (Default: ON).
     - *Marketing & Promos*: Discount coupons, new course launches, referral rewards (Default: OFF / Opt-in required in EU/GDPR jurisdictions).
2. **Multi-Language Template Engine (i18n)**:
   - Templates are stored in PostgreSQL/S3 and rendered dynamically via **Handlebars.js** / **MJML**.
   - Supports instant localization across 12 global languages (English, Hindi, Spanish, French, German, Japanese, etc.) based on `user.preferred_language`. Automatically formats currency, date/time, and timezones to match the student's local device settings.
3. **Intelligent Scheduling & Timezone Awareness**:
   - Non-urgent notifications (weekly progress reports, AI recommendations) must never wake a user in the middle of the night.
   - The engine checks the student's IANA timezone (`user.timezone`, e.g., `Asia/Kolkata`, `America/New_York`) and delays delivery via BullMQ delayed jobs until the user's preferred waking window (e.g., 08:00 AM local time).
4. **Smart Digest Batching**:
   - To prevent notification fatigue during viral social engagement, social notifications are throttled and aggregated.
   - If a student receives 20 likes on a community post within 60 minutes, the engine suppresses individual alerts and bundles them into a single summary notification: *"Alex Sharma and 19 others liked your post about Headstand posture"* dispatched at the top of the hour.
5. **3-Tier Priority Routing**:
   - All notifications are categorized into strict priority tiers within BullMQ:
     - **HIGH PRIORITY (Instant / Zero Latency)**: Authentication OTPs, payment failure alerts, live class starting in 5 minutes, emergency studio cancellations. Processed instantly by dedicated high-priority worker pools.
     - **MEDIUM PRIORITY (Sub-Minute Latency)**: Booking confirmations, new follower alerts, direct messages, AI pose analysis reports ready.
     - **LOW PRIORITY (Throttled / Batch Processed)**: Weekly fitness summaries, marketing promotions, blog newsletters. Processed during off-peak infrastructure hours.
6. **Full-Funnel Delivery Tracking & Read Acknowledgments**:
   - Every notification dispatched is logged in `notification_logs` with a unique tracking UUID.
   - Webhook endpoints ingest delivery receipts from AWS SES, Twilio, Meta, and FCM, updating the state machine across 6 stages:
     `QUEUED` $\to$ `SENT` $\to$ `DELIVERED` $\to$ `READ` (via pixel tracking or in-app click) $\to$ `CLICKED` $\to$ `FAILED` (with specific SMTP/telecom error codes stored for diagnostic auditing).

---

## SECTION 8: CACHE ARCHITECTURE

Yoga24X utilizes an enterprise **Redis Cluster** (6 nodes: 3 Primary Masters + 3 Auto-Failover Replicas deployed across multi-AZ) as a multi-layered, high-speed distributed caching and synchronization backbone.

```mermaid
graph TD
    Client[HTTP Request / API Call] --> APIGW[API Gateway / NestJS Interceptor]
    
    subgraph Redis_Cluster_Tiered_Caching [Redis Cluster: 10 Caching Layers]
        APIGW -->|1. Rate Limit Check| Layer4[Layer 4: Rate Limit Cache - Lua Sliding Window]
        APIGW -->|2. Validate Session| Layer2[Layer 2: Session & JWT Blocklist Cache]
        
        Layer4 -->|Allowed| Layer3[Layer 3: API & Catalog Cache - Idempotent GETs]
        Layer2 -->|Valid| Layer3
        
        Layer3 -->|Cache Miss| Service[Domain Service / Controller]
        
        Service -->|3. Domain Objects| Layer1[Layer 1: Distributed Object Cache - DB Rows]
        Service -->|4. Search Queries| Layer5[Layer 5: Search & Filter Cache]
        Service -->|5. Gamification| Layer6[Layer 6: Leaderboard Cache - ZSET Sorted Sets]
        Service -->|6. LLM Responses| Layer7[Layer 7: AI Semantic Cache - Vector Hash]
    end
    
    Service -->|Database Query| DB[(PostgreSQL Primary / Replica)]
    
    subgraph Stampede_Protection [Thundering Herd & Stampede Defense]
        Service -->|Check Lock| Mutex[Redlock Distributed Mutex]
        Mutex -->|Acquired: Recompute DB| DB
        Mutex -->|Locked: Wait / Serve Stale| XFetch[XFetch Probabilistic Early Expiration]
    end
```

### 8.1 Specification of 10 Caching Layers & Engineering Protocols

1. **Distributed Object Cache**: Caches frequently read PostgreSQL database entities (user profiles, studio metadata, course curriculums) using serialized JSON strings. Key format: `object:<entity_name>:<uuid>`.
2. **Session & Security Cache**: Stores active user authentication sessions, device fingerprints, and revoked JWT asymmetric token signatures (blocklist). Key format: `session:user:<uuid>` and `jwt:blocklist:<jti>`.
3. **API Response Cache**: Caches full HTTP GET response payloads for high-traffic, idempotent public endpoints (e.g., `/api/v1/courses/trending`, `/api/v1/teachers/featured`) at the NestJS interceptor layer.
4. **Rate Limit Cache**: High-speed token bucket and sliding window rate limiting counters executed via atomic Redis Lua scripts to prevent race conditions under DDoS attempts. Key format: `ratelimit:endpoint:<ip_or_user>:<window_epoch>`.
5. **Search & Filter Cache**: Caches complex faceted search results and autocomplete prefix tries. Key format: `search:query:<sha256_hash_of_params>`.
6. **Leaderboard & Gamification Cache**: High-speed real-time rankings for student challenge streaks, referral contest leaderboards, and studio attendance using Redis Sorted Sets (`ZSET`). O(1) score updates via `ZINCRBY` and instant top-N queries via `ZREVRANGE`. Key format: `leaderboard:challenge:<challenge_id>`.
7. **AI Semantic Cache**: Reduces expensive LLM API costs and latency by caching generative AI responses. Queries are vectorized; if an incoming prompt's embedding has a cosine similarity $> 0.98$ with a cached prompt key, the cached LLM response is returned instantly without invoking Gemini or OpenAI. Key format: `ai:cache:<semantic_vector_hash>`.
8. **Tag-Based & Event-Driven Invalidation Strategy**:
   - Hardcoded time-based expiration alone causes stale data. We implement **Tag-Based Invalidation** using Redis Sets.
   - When a course is cached, its key is added to a tag set: `tag:course:<course_id>`.
   - When a `learning.course.updated.v1` event fires on the Event Bus, an asynchronous listener executes `SMEMBERS tag:course:<course_id>` and atomically deletes all associated cache keys across all layers in a single pipeline.
9. **Hierarchical TTL Matrix**:
   - Every key written to Redis MUST include an explicit Time-To-Live (TTL). Infinite TTLs are strictly prohibited.
   - *Static Reference Data* (Countries, Languages, Anatomy tags): **24 Hours**.
   - *Course Catalogs & Teacher Profiles*: **1 Hour**.
   - *Search Results & Category Feeds*: **15 Minutes**.
   - *User Profiles & Wallet Balances*: **5 Minutes** (with immediate event-driven invalidation on mutation).
   - *Rate Limit Sliding Windows*: **1 Minute**.
   - *Authentication OTP Codes*: **5 Minutes**.
   - *AI Semantic Cache Responses*: **7 Days**.
10. **Thundering Herd & Cache Stampede Defense**:
    - When a viral course or homepage banner cache key expires, thousands of concurrent requests could miss the cache simultaneously, overwhelming the PostgreSQL database (Thundering Herd / Cache Stampede).
    - **Defense 1: XFetch Probabilistic Early Expiration**: Cache keys are assigned a randomized early expiration window. As the key approaches expiration, read requests have an exponentially increasing mathematical probability of independently refreshing the cache *before* it strictly expires.
    - **Defense 2: Redlock Distributed Mutex**: If a total cache miss occurs on a critical key, the worker must acquire a Redis distributed mutex lock (`lock:recompute:<key>`) with a 5-second lease. Exactly **one thread** is permitted to query PostgreSQL and populate the cache; all other concurrent threads wait in a retry loop or return slightly stale data.

---

## SECTION 9: OBSERVABILITY

Yoga24X integrates an enterprise **Observability & Telemetry Framework** built on the **OpenTelemetry (OTel)** standard, unifying metrics, structured logs, and distributed traces across all mobile clients, edge nodes, backend modules, and database tiers.

```mermaid
graph LR
    subgraph Telemetry_Sources [Telemetry Emitters]
        Flutter[Flutter Mobile App: Sentry / RUM] -->|HTTP / OTel SDK| APIGW[API Gateway]
        APIGW -->|Trace Headers| Nest[NestJS Backend Modules]
        Nest -->|Prisma Traces| DB[(PostgreSQL)]
        Nest -->|BullMQ Traces| Redis[(Redis Cluster)]
        Nest -->|LLM Latency / Tokens| AI[AI Gateway / LLM Providers]
    end
    
    subgraph OpenTelemetry_Collector [OpenTelemetry Collector Pipeline]
        Nest -->|OTLP / gRPC| OTelCol[OpenTelemetry Collector]
        AI -->|OTLP / gRPC| OTelCol
    end
    
    subgraph Storage_and_Visualization [Observability Backends & Alerting]
        OTelCol -->|Logs (Structured JSON)| Loki[Grafana Loki / OpenSearch]
        OTelCol -->|Metrics (Time Series)| Prom[Prometheus / AWS CloudWatch]
        OTelCol -->|Traces (Spans)| Tempo[Grafana Tempo / AWS X-Ray]
        
        Prom -->|Visualize| Grafana[Grafana Enterprise Dashboards]
        Loki -->|Query| Grafana
        Tempo -->|Correlate| Grafana
        
        Prom -->|Evaluate Rules| AlertMgr[Prometheus Alertmanager]
        AlertMgr -->|Critical Alerts| Pager[PagerDuty / Opsgenie / Slack]
    end
```

### 9.1 Observability Pillars & Engineering Specifications

1. **Structured JSON Logging**:
   - All backend services emit structured JSON logs via `Winston` / `Pino` formatted to the Elastic Common Schema (ECS). Plain text console logs are blocked in production.
   - **Mandatory Log Context**: Every log line MUST include `timestamp`, `log_level`, `tenant_id`, `user_id` (if authenticated), `bounded_context`, `action`, and the distributed tracing correlation headers: `x-trace-id` and `x-span-id`.
2. **Prometheus Time-Series Metrics**:
   - NestJS modules expose a `/metrics` endpoint scraped every 15 seconds by Prometheus.
   - Tracks infrastructure health: Node.js event loop lag, garbage collection pauses, HTTP request duration histograms (p50, p95, p99), Prisma database connection pool saturation, Redis memory fragmentation, and BullMQ waiting/active/failed job counts.
3. **Distributed Tracing (OpenTelemetry)**:
   - Complete end-to-end distributed tracing instrumented via OpenTelemetry SDKs.
   - When a student initiates a booking on Flutter, a unique `traceparent` W3C header is generated and propagated across the API Gateway $\to$ NestJS Booking Controller $\to$ Prisma ORM query $\to$ Redis lock acquisition $\to$ Razorpay API call $\to$ BullMQ event dispatch $\to$ Email notification worker. Engineers can trace the exact millisecond latency bottleneck across every cross-network hop in Grafana Tempo.
4. **Health Check Probes (Kubernetes Readiness & Liveness)**:
   - `/health/liveness`: Returns `200 OK` if the Node.js event loop is responsive and memory usage is below fatal thresholds. Used by Kubernetes to restart dead pods.
   - `/health/readiness`: Performs deep diagnostic checks: pings PostgreSQL read/write replicas, verifies Redis Cluster ping, checks AWS S3 reachability, and validates Kafka broker connectivity. If any critical dependency fails, the pod is removed from the load balancer traffic pool.
5. **Immutable Security Audit Logs**:
   - All sensitive administrative, financial, and security actions (e.g., role escalation, wallet credit adjustments, manual password overrides, PII exports, HIPAA medical record access) are written synchronously to an immutable PostgreSQL table (`audit_logs`) partitioned monthly by declaration.
   - Logs are mirrored in real-time to an append-only AWS S3 Object Lock bucket with compliance retention (WORM: Write Once, Read Many) preventing tampering even by database administrators.
6. **Real User Monitoring (RUM) & Mobile Telemetry**:
   - The Flutter mobile application integrates Sentry and Google Analytics for Firebase to capture real-time user UX metrics.
   - **Performance Tracking**: Measures Core Web Vitals (LCP, FID, CLS for web), mobile cold-start duration (must be $<1.5\text{s}$), UI screen render frame rates (alerting if frame drops fall below 60fps during live video classes), and API network latency from client devices across diverse geographical regions.
7. **Real-Time Business Telemetry**:
   - Observability extends beyond IT infrastructure to live business KPIs displayed on executive dashboards:
     - *Concurrent Live Class Streamers* (tracked via WebSocket heartbeats).
     - *AI Coach Session Duration & Accuracy Histograms*.
     - *Booking Conversion Rate* (Class views vs. Completed bookings).
     - *Payment Gateway Success vs. Failure Ratios* (alerting if Razorpay UPI failure rate exceeds 3% in a 5-minute window).
     - *Daily/Monthly Active Users (DAU/MAU) & Revenue Per Active User*.
8. **Crash Reporting & Exception Handling**:
   - Sentry SDK automatically intercepts all unhandled Dart/Flutter client exceptions and Node.js backend unhandled rejections.
   - Captures full stack traces, local variables, device OS, app version, battery state, and a breadcrumb trail of the user's last 20 UI taps/clicks prior to the crash, grouping identical stack traces into deduplicated error tickets.
9. **Automated Alerting & Incident Escalation**:
   - Prometheus Alertmanager evaluates real-time metric thresholds and dispatches tiered alerts:
     - **SEV-1 (CRITICAL - 24/7 PagerDuty Wake-up)**: Database master down, API Gateway error rate $> 2\%$, Payment success rate $< 90\%$, DLQ queue size $> 100$ messages.
     - **SEV-2 (HIGH - Slack `#incident-alerts` + On-Call Notification)**: Redis memory $> 85\%$, Video transcoding latency $> 15\text{ mins}$, AI Gateway fallback rate $> 10\%$.
     - **SEV-3 (LOW - Jira Ticket Creation)**: SSL certificate expiring in 30 days, daily backup verification delayed by $> 1\text{ hour}$.

---

## SECTION 10: SECURITY INFRASTRUCTURE

Yoga24X implements a **Defense-in-Depth** security architecture enforcing **Zero Trust Networking**, strict encryption, automated key rotation, and multi-layered protection against OWASP Top 10 vulnerabilities and volumetric cyber attacks.

```mermaid
graph TD
    Internet[Public Internet / Client Traffic] -->|1. TLS 1.3 / HTTPS| Cloudflare[Cloudflare Enterprise: WAF / DDoS / Bot Mitigation]
    Cloudflare -->|2. Clean Traffic| NLB[AWS Network Load Balancer]
    NLB -->|3. Route| Kong[Kong Enterprise API Gateway]
    
    subgraph Edge_Security_and_Gateway [API Gateway Security Layer]
        Kong -->|4. Rate Limiting| RateLimit[Redis Lua Sliding Window]
        Kong -->|5. Verify JWT Signature| JWKS[JWKS Endpoint: Asymmetric RS256 / ES256]
        Kong -->|6. Check Blocklist| Blocklist[(Redis: JWT Blocklist)]
    end
    
    Kong -->|7. Sanitize & Route| Nest[NestJS Modular Monolith Services]
    
    subgraph Backend_Security_and_Isolation [Application & Database Security]
        Nest -->|8. RBAC / ABAC Evaluation| PermissionEngine[Permission & Role Evaluator]
        Nest -->|9. Inject Tenant Context| Prisma[Prisma ORM Client]
        Prisma -->|10. Set RLS Session Variable| DB[(PostgreSQL: Row Level Security RLS)]
        Nest -->|11. Fetch Runtime Secrets| Vault[HashiCorp Vault / AWS Secrets Manager]
    end
    
    subgraph Encryption_and_Key_Management [Data Protection]
        DB ---|AES-256-GCM Data at Rest| KMS[AWS KMS Key Management Service]
        Vault ---|Automated Rotation| KMS
    end
```

### 10.1 Security Layers & Defense Specifications

1. **Enterprise API Gateway (Kong Gateway / AWS API Gateway)**:
   - Single point of entry for all external traffic. Enforces mandatory SSL/TLS termination, request size limiting (max 10MB for JSON, 500MB for media direct uploads via pre-signed URLs), schema validation against OpenAPI 3.1 contracts, and centralized Cross-Origin Resource Sharing (CORS) whitelisting.
2. **Multi-Tier Rate Limiting & DoS Mitigation**:
   - Enforced at the API Gateway via Redis Lua sliding window algorithms:
     - *Global Edge Rate Limit*: 10,000 requests / minute per IP address (absorbs basic volumetric scans).
     - *Authenticated User Limit*: 1,000 requests / minute per JWT `user_id`.
     - *Sensitive Endpoint Throttling*: Login/OTP endpoints limited to **5 attempts per 15 minutes** per IP/phone number. AI Coach inference endpoints limited to **50 requests per minute** per user to prevent financial token exhaustion attacks.
3. **Web Application Firewall (WAF) & Bot Mitigation**:
   - Deployed at the Cloudflare Enterprise edge. Continuously inspects HTTP traffic against OWASP Top 10 rulesets: blocks SQL Injection (SQLi), Cross-Site Scripting (XSS), Server-Side Request Forgery (SSRF), and Remote Code Execution (RCE) payloads.
   - **Bot Mitigation**: Uses behavioral machine learning and JavaScript browser challenges (Turnstile) to block automated scraping of teacher directories, course videos, and pricing tiers while allowing verified search engine crawlers.
4. **DDoS Protection (Layer 3, 4, and 7)**:
   - Cloudflare Magic Transit and AWS Shield Advanced provide unmetered, always-on DDoS mitigation. Absorbs SYN floods, UDP reflection attacks, and HTTP/2 Rapid Reset floods at the global edge network ($>150\text{ Tbps}$ capacity) before traffic reaches AWS VPC infrastructure.
5. **Secrets Management & Runtime Injection**:
   - Hardcoding secrets, API keys, or database credentials in source code, environment variables, or Dockerfiles is strictly prohibited.
   - All production secrets (PostgreSQL connection strings, Razorpay API keys, OpenAI/Gemini bearer tokens, JWT private signing keys) are encrypted and stored in **HashiCorp Vault / AWS Secrets Manager**. Secrets are injected dynamically into Node.js containers at runtime via Kubernetes Service Account OIDC federation and memory-only tmpfs volumes.
6. **Encryption Standards (Data at Rest & in Transit)**:
   - **Data in Transit**: Enforces **TLS 1.3** globally across all external web traffic and internal microservice-to-microservice gRPC/HTTP communication. HTTP traffic is permanently redirected to HTTPS with HSTS preloading (`max-age=31536000; includeSubDomains; preload`).
   - **Data at Rest**: All PostgreSQL RDS storage volumes, Redis ElastiCache clusters, AWS S3 buckets, and EBS snapshots are encrypted using **AES-256-GCM** backed by customer-managed keys in AWS Key Management Service (KMS).
7. **Automated Cryptographic Key Rotation**:
   - AWS KMS master encryption keys rotate automatically on an annual schedule.
   - Database passwords and third-party API keys rotate automatically every **90 days** via automated AWS Secrets Manager Lambda rotation functions without downtime.
   - **JWT Asymmetric Key Rotation**: The RSA/ECDSA key pairs (RS256/ES256) used to sign access tokens rotate automatically every **30 days**. The API Gateway validates tokens against a public JSON Web Key Set (**JWKS**) endpoint (`/api/v1/.well-known/jwks.json`) which publishes both current and expiring public keys during a 48-hour overlap window, ensuring zero-downtime token verification.
8. **Stateless JWT Verification & Revocation Blocklist**:
   - Access tokens are short-lived (15-minute lifespan) stateless JSON Web Tokens signed using asymmetric RS256/ES256 cryptography.
   - API Gateway verifies token signature, expiration (`exp`), issuer (`iss`), audience (`aud`), and extracts the unique token ID (`jti`).
   - To support instant user logout or security lockout without database hits, the gateway checks the `jti` against an in-memory Redis cluster blocklist (`jwt:blocklist:<jti>`). When a user logs out or changes their password, all active access token IDs and refresh token families are pushed to Redis with a TTL matching the token's remaining lifespan.
9. **RBAC & ABAC Authorization Engine**:
   - Authentication confirms *who* the user is; the NestJS Permission Engine evaluates *what* they can access using a hybrid **Role-Based Access Control (RBAC)** and **Attribute-Based Access Control (ABAC)** model.
   - Evaluates static roles (`SUPER_ADMIN`, `STUDIO_ADMIN`, `TEACHER`, `STUDENT`) against dynamic resource attributes (e.g., *A teacher can only update a course if `course.instructor_id == current_user.id` AND `course.status == DRAFT`*).
10. **Strict Tenant Isolation via Row Level Security (RLS)**:
    - Multi-tenant data leakage is structurally impossible. In addition to application-level WHERE filtering, PostgreSQL **Row Level Security (RLS)** is enabled on all tables containing tenant or user-scoped data (`bookings`, `wallets`, `health_profiles`, `course_enrollments`).
    - Upon acquiring a database connection from the pool, the Prisma ORM client extension automatically executes `SET LOCAL app.current_tenant_id = '<jwt.tenant_id>'` and `SET LOCAL app.current_user_id = '<jwt.user_id>'`. PostgreSQL database policies automatically reject any SQL read or write query attempting to access rows belonging to another studio or student.
11. **Strict HTTP Security Headers**:
    - All HTTP responses emitted by Yoga24X include industry-standard security headers:
      - `Content-Security-Policy: default-src 'self'; script-src 'self' 'nonce-<random>' https://checkout.razorpay.com; frame-src https://api.razorpay.com; img-src 'self' data: https://*.cloudfront.net; style-src 'self' 'unsafe-inline';`
      - `Strict-Transport-Security: max-age=31536000; includeSubDomains; preload`
      - `X-Content-Type-Options: nosniff`
      - `X-Frame-Options: DENY` (or `SAMEORIGIN` for embedded studio widgets)
      - `Referrer-Policy: strict-origin-when-cross-origin`
      - `Permissions-Policy: camera=(self), microphone=(self), geolocation=(), payment=(self "https://checkout.razorpay.com")`

---

## SECTION 11: SCHEDULER

Scheduled background tasks, periodic maintenance, and time-based business workflows are orchestrated by an enterprise **Distributed Scheduler** utilizing **BullMQ Repeatable Jobs** and **Kubernetes CronJobs** with Redis distributed locks to guarantee strict singleton execution across clustered server nodes.

```mermaid
graph LR
    Cron[Kubernetes CronJob / BullMQ Timer] -->|1. Trigger Schedule| Lock[Redis Redlock Mutex: lock:cron:<job_name>]
    Lock -->|2. Lock Failed: Another Node Running| Abort[Abort Execution - Singleton Guaranteed]
    Lock -->|3. Lock Acquired: Execute| Worker[Dedicated Scheduler Worker Pool]
    
    subgraph Scheduled_Workflows [10 Core Scheduled Workflows]
        Worker -->|00:00 UTC Daily| Job_Rep[Daily Studio Financial & Attendance Reports]
        Worker -->|Hourly| Job_Sub[Razorpay Auto-Debit Subscription Renewals]
        Worker -->|Every 15 Mins| Job_Rem[Class Starting in 30m Reminder Dispatch]
        Worker -->|03:00 UTC Daily| Job_Ina[Inactive User Drip Re-engagement]
        Worker -->|01:00 UTC Daily| Job_Bak[Full DB Backup & S3 Cross-Region Verify]
        Worker -->|04:00 UTC Daily| Job_Cln[Purge Expired JWTs / Stale Staging Media]
        Worker -->|Hourly| Job_Anl[Rollup Clickstream & Telemetry Summaries]
        Worker -->|02:00 UTC Daily| Job_Crt[Audit Teacher RYT/CPR Cert Expirations]
        Worker -->|05:00 UTC Daily| Job_Rnk[Recalculate Teacher & Course Search Ranks]
        Worker -->|00:00 UTC Sunday| Job_AI[Export Anonymized RLHF Logs for Retraining]
    end
    
    Job_Rep -->|Email PDF| Admin[Studio Administrators]
    Job_Sub -->|Charge Gateway| Razorpay[Razorpay Billing API]
    Job_Bak -->|Snapshot| S3[(AWS Glacier Vault)]
```

### 11.1 Specification of 10 Core Scheduled Workflows

| Job Name | Cron Expression (UTC) | Execution Locking | Detailed Workflow & Operational Logic |
| :--- | :---: | :---: | :--- |
| **`daily-studio-reports`** | `0 0 * * *` (Daily at Midnight) | `lock:cron:daily_reports` (30m lease) | Queries PostgreSQL read replica; aggregates daily revenue, new student signups, class attendance ratios, and instructor payout ledgers per tenant; renders PDF report via Puppeteer; emails summary to Studio Admins. |
| **`subscription-renewals`** | `0 * * * *` (Every Hour) | `lock:cron:sub_renewals` (45m lease) | Scans `subscriptions` table for active memberships expiring within the next 24 hours; initiates asynchronous recurring auto-debit charge via Razorpay UPI/Card mandate API; emits `SubscriptionRenewed` or `PaymentFailed` events. |
| **`class-reminders`** | `*/15 * * * *` (Every 15 Mins) | `lock:cron:class_reminders` (10m lease) | Queries `bookings` where `slot_start_time` is between 30 and 45 minutes from `NOW()` and `reminder_sent == false`; pushes high-priority jobs to `push-queue` and `sms-queue`; marks reminder dispatched. |
| **`inactive-user-drip`** | `0 3 * * *` (Daily at 03:00) | `lock:cron:inactive_drip` (2h lease) | Identifies students with zero logins or completed workouts in the last 14, 30, or 60 days; evaluates user dosha and previous class preferences; enqueues personalized re-engagement push/email sequences with incentive discounts. |
| **`database-backup-verify`** | `0 1 * * *` (Daily at 01:00) | `lock:cron:db_backup` (3h lease) | Triggers AWS RDS automated snapshot; spawns an isolated temporary Docker test container; restores snapshot to simulate Disaster Recovery; runs integrity sanity tests; verifies cross-region replication to AWS secondary region. |
| **`system-cleanup-sweep`** | `0 4 * * *` (Daily at 04:00) | `lock:cron:sys_cleanup` (2h lease) | Executes bulk maintenance deletions: purges `refresh_tokens` where `expires_at < NOW()`; sweeps `media_assets` in staging older than 24 hours without database linkage; deletes webhook delivery logs older than 90 days. |
| **`analytics-aggregation`** | `0 * * * *` (Every Hour) | `lock:cron:analytics_agg` (45m lease) | Drains raw time-series telemetry from Redis/ClickHouse; computes hourly DAU, live stream video buffering ratios, AI pose accuracy histograms, and studio revenue rollups; populates high-speed summary tables. |
| **`certificate-expiry-audit`**| `0 2 * * *` (Daily at 02:00) | `lock:cron:cert_expiry` (1h lease) | Audits teacher profiles for Yoga Alliance RYT-200/500, CPR, or Ayurvedic medical license expiration dates; sends 30-day and 7-day warning emails; automatically suspends booking eligibility on the day of expiration. |
| **`teacher-ranking-compute`**| `0 5 * * *` (Daily at 05:00) | `lock:cron:teacher_rank` (2h lease) | Recalculates weighted teacher and course search ranking scores based on trailing 30-day student review averages, booking velocity, class completion rates, and dispute frequency; updates Meilisearch and Redis ranking weights. |
| **`ai-model-retraining-prep`**| `0 0 * * 0` (Sundays at 00:00)| `lock:cron:ai_retrain` (6h lease) | Scans AI Coach interaction logs and pose analysis error histograms; extracts anonymized user thumbs-up/down RLHF corrections; formats curated training JSONL datasets; uploads to S3 bucket for Vertex AI / OpenAI fine-tuning pipelines. |

---

## SECTION 12: MICROSERVICE READINESS

To achieve rapid initial time-to-market while guaranteeing seamless horizontal scalability to 10 Million users, Yoga24X is architected as a **Modular Monolith** within a unified NestJS runtime, designed with strict **Microservice Readiness** principles. Every module is bounded so it can be surgically extracted into an independent Kubernetes microservice without rewriting business logic or breaking client API contracts.

```mermaid
graph TD
    Client[Client Applications] --> APIGW[Kong Enterprise API Gateway]
    
    subgraph Modular_Monolith_Runtime [Current Phase: Modular Monolith NestJS Runtime]
        APIGW -->|/api/v1/auth/*| IAM[IAM & Access Module]
        APIGW -->|/api/v1/lms/*| Learning[Learning & Catalog Module]
        APIGW -->|/api/v1/bookings/*| Booking[Booking & Scheduling Module]
        APIGW -->|/api/v1/finance/*| Finance[Finance & Billing Module]
        APIGW -->|/api/v1/ai/*| Intel[Intelligence & AI Module]
        APIGW -->|/api/v1/social/*| Social[Social & Community Module]
        APIGW -->|/api/v1/notifications/*| Notif[Notification & Dispatch Module]
        
        IAM -.->|In-Process DTO Contract| Learning
        Booking -.->|In-Process DTO Contract| Finance
        Intel -.->|In-Process DTO Contract| Learning
    end
    
    subgraph Decoupled_Data_and_Events [Strictly Isolated Infrastructure]
        IAM & Learning & Booking & Finance & Intel & Social & Notif -->|Publish / Subscribe| EventBus[Enterprise Event Bus Kafka / BullMQ]
        
        IAM -->|Logical Schema: iam_*| DB_IAM[(PostgreSQL Schema: IAM)]
        Learning -->|Logical Schema: lms_*| DB_LMS[(PostgreSQL Schema: LMS)]
        Booking -->|Logical Schema: bkg_*| DB_BKG[(PostgreSQL Schema: Booking)]
        Finance -->|Logical Schema: fin_*| DB_FIN[(PostgreSQL Schema: Finance)]
    end
    
    subgraph Future_Microservice_Extraction [Future Phase: Extracted Independent Microservices]
        Direction[Surgical Extraction via Route Remapping in API Gateway]
        MS_AI[Dedicated AI Service Pods Python / FastAPI + GPU Node Pool]
        MS_Notif[Dedicated Notification Workers Go / Rust Async Pool]
        MS_Fin[Dedicated Finance & Ledger Service High-Security PCI-DSS Pod]
    end
```

### 12.1 Bounded Contexts & Module Isolation Rules

1. **7 Distinct Bounded Contexts**:
   - `IAM` (Identity, Authentication, Authorization, Tenant Management, User Profiles).
   - `Learning` (LMS Course Catalog, Lessons, Video Streaming, Quizzes, Certificates).
   - `Booking` (Class Scheduling, Teacher Calendars, Studio Room Inventory, Attendance).
   - `Finance` (Payments, Razorpay Orders, Student Wallets, Teacher Payouts, Referrals, Ledgers).
   - `Intelligence` (AI Gateway, Prompt Orchestrator, Pose Analysis, Nutrition, Recommendations).
   - `Social` (Community Feeds, Posts, Comments, Likes, Follows, Moderation, Direct Messaging).
   - `Notification` (Multi-channel Dispatch, Template Engine, User Preferences, Delivery Tracking).
2. **Strict Module Isolation Engineering Rules**:
   - **Rule 1: Zero Database Joins Across Modules**: A SQL query inside the `Booking` module is strictly prohibited from joining tables in the `IAM` or `Finance` schema (e.g., `SELECT * FROM bookings JOIN users ...` is illegal). Every module manages its own dedicated PostgreSQL schema namespace (`iam_*`, `lms_*`, `bkg_*`, `fin_*`).
   - **Rule 2: No Direct Repository Imports**: A service in the `Learning` module cannot import or inject the Prisma repository of the `Finance` module.
   - **Rule 3: Communication via Formal Contracts Only**:
     - *Synchronous Reads*: Must occur via explicitly exported TypeScript Interface Contracts and DTOs (e.g., `BookingService` calls `IamReadOnlyService.getUserBasicProfile(userId)`).
     - *Asynchronous Writes/Mutations*: Must occur exclusively via publishing versioned CloudEvents to the Enterprise Event Bus (e.g., `Booking` publishes `booking.slot.confirmed.v1`; `Finance` consumes it to debit wallet).
3. **API Gateway Routing Strategy**:
   - The Kong API Gateway maps public REST and GraphQL endpoints to internal module namespaces via path-based routing:
     - `/api/v1/auth/*` $\to$ routed to `IAM Module`
     - `/api/v1/courses/*`, `/api/v1/lessons/*` $\to$ routed to `Learning Module`
     - `/api/v1/bookings/*`, `/api/v1/calendars/*` $\to$ routed to `Booking Module`
     - `/api/v1/payments/*`, `/api/v1/wallets/*` $\to$ routed to `Finance Module`
     - `/api/v1/ai/*`, `/api/v1/coach/*` $\to$ routed to `Intelligence Module`
   - **Extraction Readiness**: When a module is extracted into a standalone microservice, zero client-facing mobile or web code changes are required. The network engineer simply updates the Kong Gateway routing table to point `/api/v1/ai/*` from the monolithic container IP to the new dedicated Microservice Kubernetes Cluster IP.

### 12.2 4-Phase Microservice Extraction Roadmap

- **Phase 1: High-Performance Modular Monolith (Current Initial Launch)**:
  - All 7 bounded contexts run inside a unified NestJS Node.js runtime process deployed across auto-scaling Kubernetes pods.
  - Utilizes a single RDS PostgreSQL cluster with logical schema separation and a shared Redis Cluster. Eliminates network serialization latency and simplifies initial DevOps deployment while enforcing strict code boundaries.
- **Phase 2: Extraction of High-Compute AI & Telemetry Service**:
  - *Trigger Condition*: When AI inference requests and live video pose analysis streams exceed 30% of total system CPU/RAM, or when GPU-accelerated local embedding models are introduced.
  - *Action*: Extract the `Intelligence` module into an independent **AI Microservice** built on Python / FastAPI or specialized NestJS workers deployed on Kubernetes GPU node pools (NVIDIA A100/T4). Communicates with the core monolith via gRPC and Event Bus.
- **Phase 3: Extraction of High-Throughput Notification & Social Services**:
  - *Trigger Condition*: When community feed broadcasts and push notification fan-outs during live studio events cause event loop contention or lag on core transactional APIs.
  - *Action*: Extract `Notification` and `Social` modules into independent, lightweight asynchronous microservices (written in Go, Rust, or Node.js) dedicated to high-concurrency I/O and WebSocket streaming.
- **Phase 4: Full Microservice Decomposition (10M+ Users Scale)**:
  - *Trigger Condition*: When engineering team size exceeds 50 independent domain developers, or when database storage demands require physical database sharding.
  - *Action*: Extract `Finance`, `Booking`, and `Learning` into completely autonomous microservices, each provisioned with its own physically isolated AWS Aurora PostgreSQL database cluster, communicating entirely via Kafka event streams and gRPC synchronous meshes (Istio/Linkerd).

---

## SECTION 13: QUALITY GATE & ARCHITECTURAL SELF-REMEDIATION

To guarantee that this infrastructure blueprint is impervious to production failures, we executed an exhaustive **9-Pillar Architectural Stress Test & Self-Remediation Review**. We systematically identified every potential failure mode, scalability bottleneck, and security vulnerability across the design, and automatically improved the architecture by engineering explicit self-healing remediations directly into this document.

### 13.1 Exhaustive Review & Automated Architectural Improvements

#### 1. Architecture Review: Synchronous Bottlenecks in Course Completion
- **Identified Weakness**: If the LMS module synchronously generated PDF certificates and sent email notifications during the `POST /lessons/complete` HTTP request, a spike in course completions (e.g., end of a 30-day challenge) would cause thread pool exhaustion, 504 Gateway Timeouts, and degraded UX.
- **Automated Remediation Integrated**: Enforced **Tenet 1 (Zero Synchronous Coupling)**. The lesson completion endpoint now performs only an atomic database transaction updating lesson progress and immediately returns `200 OK` ($<15\text{ms}$). It emits a `learning.course.completed.v1` CloudEvent to BullMQ. Dedicated background worker pools (`certificate-queue`, `email-queue`, `wallet-service`) consume the event asynchronously to render PDFs and credit reward coins in the background.

#### 2. Security Review: Stateless JWT Blocklist Cluster Consistency
- **Identified Weakness**: Relying on local in-memory Node.js RAM for JWT revocation blocklists would fail in a multi-node Kubernetes cluster; a user revoked on Pod A could still make authenticated requests to Pod B until the token naturally expired.
- **Automated Remediation Integrated**: Architected the JWT verification layer to query an enterprise **Redis Cluster Blocklist** (`jwt:blocklist:<jti>`) shared across all API Gateway pods. Added automated JWKS public key rotation and mandatory Row Level Security (RLS) PostgreSQL session variable injection (`SET LOCAL app.current_tenant_id`) on every DB connection pool checkout.

#### 3. Scalability Review: Database Connection Pool Exhaustion Under Flash Traffic
- **Identified Weakness**: At 10 Million users, a viral celebrity yoga live stream or flash sale would trigger 50,000 concurrent user logins and catalog fetches, instantly exhausting PostgreSQL max connection limits (`max_connections = 500`), causing cascading database crash loops.
- **Automated Remediation Integrated**: Integrated **PgBouncer** in transaction pooling mode between NestJS services and PostgreSQL RDS, multiplexing 10,000+ stateless client connections over 200 physical database connections. Paired with **Layer 3 API Cache** and **Layer 1 Distributed Redis Cache**, absorbing 85% of read queries before they ever reach the database tier.

#### 4. Performance Review: Network Latency in AI Pose Analysis Video Streaming
- **Identified Weakness**: Streaming raw 30fps high-definition mobile video camera feeds to cloud backend servers for pose analysis would consume massive cellular bandwidth, introduce 1,500ms+ network round-trip latency, and result in jerky, delayed AI voice coaching.
- **Automated Remediation Integrated**: Architected a **Hybrid Edge-Cloud Vision Pipeline**. Mobile apps (Flutter/iOS/Android) execute lightweight MediaPipe/MoveNet models locally on edge device neural engines (Apple Neural Engine / Snapdragon NPU) at 30fps. The edge extracts 33 lightweight 3D skeletal numerical coordinates (approx. 2 KB/frame) and streams *only the numerical geometry coordinates* over bidirectional **WebRTC / WebSocket** channels to the cloud `Pose Analysis Engine`, achieving sub-50ms corrective feedback latency.

#### 5. Failure Simulation: Payment Gateway Webhook Delivery Outages
- **Identified Weakness**: If Razorpay's webhook dispatch servers experience an outage or network split during a class booking checkout, the student's payment would be captured by the bank, but the Yoga24X booking state would remain permanently stuck in `PAYMENT_PENDING`, leading to severe customer disputes.
- **Automated Remediation Integrated**: Built a proactive, self-healing **Payment Reconciliation Scheduler Worker** (`payment-reconciliation-worker`). Running every 15 minutes via BullMQ, it scans all `bookings` and `orders` stuck in `PAYMENT_PENDING` for $>15\text{ minutes}$ and actively queries the Razorpay Status Verification API. If the gateway reports success, the worker atomically advances the state machine to `CONFIRMED` and emits `booking.slot.confirmed.v1`; if failed, it triggers automated rollback and releases the calendar slot lock.

#### 6. Disaster Recovery Review: Complete AWS Region Outage (RPO & RTO Guarantees)
- **Identified Weakness**: A catastrophic natural disaster or total power failure wiping out the primary AWS cloud region (e.g., `ap-south-1` Mumbai) would cause complete platform shutdown and permanent data loss if backups were strictly local.
- **Automated Remediation Integrated**: Engineered a **Multi-AZ / Multi-Region Disaster Recovery Topology**:
  - *Database*: PostgreSQL RDS deployed in Multi-AZ configuration with continuous, asynchronous storage-level replication to a secondary disaster recovery region (e.g., `ap-southeast-1` Singapore).
  - *Media & Backups*: AWS S3 buckets configured with Cross-Region Replication (CRR) and Object Lock (WORM).
  - *Recovery Guarantees*: Guaranteed **Recovery Point Objective (RPO) $< 5\text{ minutes}$** (max potential data loss) and **Recovery Time Objective (RTO) $< 30\text{ minutes}$** (time to promote secondary replica and failover DNS via Cloudflare Route 53 health checks).

#### 7. Event Review: Message Duplication & Race Conditions in Wallet Credits
- **Identified Weakness**: In distributed message brokers (Kafka/BullMQ), network retries guarantee *at-least-once* delivery. If a `learning.course.completed.v1` event was delivered twice due to a transient network ACK drop, a naive consumer would credit the student's wallet 250 reward coins *twice*.
- **Automated Remediation Integrated**: Enforced strict **Consumer Idempotency (Section 2.3)** across all event listeners. Consumers must execute a two-phase check: Redis deduplication key verification (`idempotency:event:<uuid>`) followed by an atomic SQL transaction inserting the `event_id` into a unique `processed_events` table. Wallet credit operations utilize SQL atomic upserts (`INSERT ... ON CONFLICT DO NOTHING`), making double-crediting mathematically impossible.

#### 8. AI Review: Medical & Biomechanical Hallucination Risks
- **Identified Weakness**: Unconstrained Generative LLMs (GPT-4o / Gemini) could hallucinate and advise a student with severe lumbar disc herniation or high blood pressure to perform an advanced inversion (Headstand / Sirsasana) or intense breathwork (Kapalabhati), risking severe injury and medical liability.
- **Automated Remediation Integrated**: Implemented a mandatory **3-Layer AI Safety Rail**:
  1. *RAG Grounding*: All health, nutrition, and workout prompts must retrieve verified contraindication rules from the `Knowledge Base` (e.g., *"If student has hypertension, exclude all inverted postures"*).
  2. *Structured Output Validation*: LLM responses are forced into strict JSON schemas; any response deviating from the schema is rejected by the `Prompt Orchestrator`.
  3. *Confidence Gating & Disclaimer Injection*: If the AI model's internal confidence score falls below **85%**, the system automatically suppresses the AI suggestion, routes the query to a human yoga teacher's review queue, and appends mandatory medical disclaimers to all wellness outputs.

#### 9. Infrastructure Review: Uncontrolled Cloud Cost Spikes & Runaway Loops
- **Identified Weakness**: An infinite retry loop in the video transcoding worker or a scraping bot spamming the AI Coach chat endpoint could generate millions of OpenAI/Gemini tokens and AWS MediaConvert billing hours overnight, resulting in catastrophic cloud bill shock.
- **Automated Remediation Integrated**: Engineered comprehensive **Cost Governance & Circuit Breakers**:
  - *AI Quotas*: Enforced strict daily token usage budgets per student and per studio tenant in Redis. When a user exhausts their daily AI quota, the API Gateway returns `429 Too Many Requests` with a prompt to upgrade membership.
  - *Infrastructure Circuit Breakers*: Integrated AWS Budgets and CloudWatch billing alarms tied to Lambda kill-switches. If automated video transcoding or AI API costs exceed 150% of the daily moving average, non-essential background processing queues automatically pause, alerting Principal DevOps Engineers immediately.

---

## SUMMARY OF ENGINEERING DELIVERABLES

This document completes the permanent **Enterprise AI, Event-Driven & Infrastructure Architecture** for Yoga24X. We have delivered:
1. **Section 1**: A 17-engine AI ecosystem with RAG grounding, memory hierarchies, and edge-cloud pose analysis.
2. **Section 2**: An asynchronous Event-Driven backbone with 10 production CloudEvent JSON schemas, exponential retries, DLQ management, and causal FIFO ordering.
3. **Section 3**: A 13-queue BullMQ background worker system decoupling all high-latency CPU/IO operations.
4. **Section 4**: A distributed Saga workflow engine governing 13 core business state machines with explicit failure and rollback strategies.
5. **Section 5**: An 11-step automated media processing pipeline with malware quarantine, AVIF/WebP compression, multi-bitrate HLS transcoding, DRM, and tiered S3 lifecycle rules.
6. **Section 6**: A unified hybrid search engine combining lexical BM25 and vector cosine similarity across 11 domain indexes with sub-20ms autocomplete and typo tolerance.
7. **Section 7**: A multi-channel notification engine supporting 6 delivery channels, granular user preference matrices, smart digest batching, and full-funnel read tracking.
8. **Section 8**: A 10-layer Redis Cluster caching strategy with XFetch stampede protection and Redlock distributed mutexes.
9. **Section 9**: An OpenTelemetry observability framework providing ECS JSON logging, Prometheus time-series metrics, distributed tracing, and 60fps mobile RUM.
10. **Section 10**: A defense-in-depth security infrastructure featuring Kong API Gateway, OWASP WAF, DDoS mitigation, HashiCorp Vault secrets, automated 30-day JWKS rotation, and strict RLS multi-tenant isolation.
11. **Section 11**: A distributed scheduler managing 10 core cron workflows with Redis Redlock singleton execution.
12. **Section 12**: A modular monolith architecture divided into 7 bounded contexts with a 4-phase extraction roadmap to independent Kubernetes microservices.
13. **Section 13**: A 9-pillar quality gate review identifying and remediating critical architectural risks across scalability, security, disaster recovery, and AI safety.

---

Infrastructure Architecture Completed ✅  

Ready for Prompt 3 – Authentication & Security Architecture.
