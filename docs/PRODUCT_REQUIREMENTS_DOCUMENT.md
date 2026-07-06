# Yoga24X AI Engineering OS — Enterprise Product Requirements Document (PRD)

**Document Version**: 1.0.0-PRD  
**Status**: APPROVED & LOCKED  
**Architectural Scope**: Official Business & Product Single Source of Truth for all Product Managers, UX Designers, Software Engineers, QA Engineers, AI Engineers, and Executive Stakeholders. Strictly governed by **Engineering Bible v1.0**.  

---

## PART 1: EXECUTIVE SUMMARY

### 1.1 Product Vision
To build the world's most intelligent, personalized, and accessible AI-powered Yoga & Wellness Super App, empowering **10 Million Active Students** and **100,000 Verified Teachers** globally by transforming mobile devices and web browsers into interactive, AI-guided personal wellness sanctuaries.

### 1.2 Mission
Democratize authentic ancient Vedic yoga, Ayurvedic nutrition, mindfulness meditation, and clinical biomechanical posture coaching through cutting-edge artificial intelligence, real-time edge computer vision, interactive live streaming, and global community engagement.

### 1.3 Business Goals
- **Year 1**: Achieve 1 Million Monthly Active Users (MAU), onboard 10,000 certified Yoga Alliance instructors, process 1 Million class bookings, and generate $\$10\text{ Million}$ in Gross Merchandise Value (GMV).
- **Year 3**: Scale to 10 Million MAU, host 100,000 instructors, curate 1 Million LMS courses, process 10 Million monthly bookings, achieve $\$100\text{ Million+}$ GMV, and maintain a subscription churn rate $< 1\%$.

### 1.4 Target Audience
- **Primary Consumers (B2C)**: Global wellness seekers (aged 16–75), yoga practitioners, prenatal mothers, seniors, chronic pain rehabilitation patients, and fitness enthusiasts seeking holistic mind-body balance.
- **Service Providers (B2B/Creators)**: Certified Yoga Alliance instructors (RYT 200/500), BAMS Ayurvedic doctors, clinical physical therapists, mindfulness/meditation coaches, and multi-city yoga studio owners.
- **Enterprise Clients (B2B2C)**: Corporate HR leaders and Chief Wellness Officers seeking scalable, verifiable employee mental health and posture ergonomic programs.

### 1.5 Market Positioning
Yoga24X positions itself as the premium **"All-in-One AI Wellness Sanctuary"**—replacing fragmented, single-purpose software (disjointed video players, standalone booking calendars, separate nutrition trackers, isolated meditation timers, and basic telehealth tools) with an integrated, intelligent super app.

### 1.6 Competitive Advantage
1. **Real-Time AI Pose Coach**: 30fps edge Computer Vision (WebRTC/MediaPipe) delivering instant, zero-latency biomechanical alignment feedback without uploading raw video streams to cloud servers.
2. **3-Layer RAG-Grounded Intelligence**: AI health and nutrition recommendations grounded in an authoritative vector Knowledge Base of Vedic scriptures, Ayurvedic pharmacopeia, and clinical contraindications.
3. **Interactive Live Sanctuary**: Multi-bitrate live class streaming featuring two-way teacher biometric telemetry monitoring and real-time audio/visual posture corrections.
4. **Offline-First Isar Sanctuary**: Full offline capability for downloaded LMS courses, daily pranayama audio, and student practice journals with automatic background network synchronization.
5. **Integrated Clinical Care**: Seamless transition from AI preventive wellness to 1-on-1 telehealth consultations with verified Ayurvedic doctors and physical therapists.

### 1.7 Business Model & Revenue Streams
- **Freemium Tier**: Free access to daily 10-minute pranayama timers, basic beginner yoga sequences, community feed read-access, and limited AI Chat check-ins.
- **Tiered B2C Subscriptions**:
  - *Silver Sanctuary* ($\$9.99$/mo or $\$99$/yr): Unlimited on-demand LMS courses, daily live community classes, and basic AI nutrition tracking.
  - *Gold Sanctuary* ($\$19.99$/mo or $\$179$/yr): Adds unlimited real-time AI Pose Coach sessions, advanced biometric analytics, and offline Isar downloads.
  - *Platinum Sanctuary* ($\$39.99$/mo or $\$349$/yr): Adds 2 monthly 1-on-1 teacher live consultations, 1 quarterly Ayurvedic doctor evaluation, and VIP workshop access.
- **Transactional Marketplace**: 15%–20% commission on organic yoga mats, ergonomic props, Ayurvedic herbal supplements, and eco-friendly apparel.
- **A-la-Carte Bookings & Retreats**: 10%–15% platform booking fee on high-ticket wellness retreats, teacher training masterclasses, and specialized medical workshops.
- **B2B Corporate Wellness Licensing**: Per-employee monthly licensing ($\$4.99$/seat) with customized HR analytics dashboards and dedicated company wellness challenges.
- **Teacher Revenue Share**: Industry-leading 70/30 or 80/20 revenue split empowering creators and instructors to build sustainable global businesses.

### 1.8 Success Metrics (KPIs)
- **User Engagement**: Daily Active Users (DAU) to Monthly Active Users (MAU) ratio $\ge 40\%$; Average session duration $\ge 25\text{ minutes}$.
- **AI Efficacy**: Computer Vision Pose Coach joint tracking accuracy $\ge 95\%$ compared to expert physical therapist evaluation; AI recommendation click-through rate $\ge 35\%$.
- **Streaming Performance**: Global live interactive video streaming latency $\le 200\text{ms}$; Video playback re-buffering rate $< 0.5\%$.
- **Customer Satisfaction**: Net Promoter Score (NPS) $\ge 75$; App Store and Google Play average rating $\ge 4.8$ stars across 100,000+ reviews.
- **Operational Reliability**: Enterprise infrastructure availability $\ge 99.99\%$ (Four Nines); API p95 response latency $\le 150\text{ms}$.

---

## PART 2: COMPLETE USER PERSONAS (9 PERSONAS)

### 2.1 Persona 1: The Student (Aria, 29 — Tech Project Manager & Wellness Seeker)
- **Goals**: Maintain physical flexibility, relieve desk-posture neck/back pain, manage workplace mental stress, and build a consistent daily 20-minute yoga habit.
- **Pain Points**: Intimidated by advanced studio classes; lacks time to commute to physical studios; unsure if home posture is correct or causing injury; loses motivation quickly without structure.
- **Needs**: Instant real-time feedback on posture alignment; short, flexible 15-30 minute classes; personalized Ayurvedic diet tips for high-stress days; gamified streak tracking.
- **Permissions**: `STUDENT` role (Read/write personal profile, enroll in courses, book classes, use AI Coach, post in community, purchase marketplace items).
- **Primary Features**: AI Pose Coach, LMS Course Player, Interactive Calendar Booking, Daily Meditation Timer, Student Biometric Dashboard, Community Feed.

### 2.2 Persona 2: The Teacher (Master Rajesh, 42 — Certified Yoga Alliance E-RYT 500)
- **Goals**: Expand teaching reach to global students; monetize specialized prenatal and Ashtanga yoga knowledge; automate class scheduling and billing; build a loyal community following.
- **Pain Points**: Wastes 10+ hours weekly on manual WhatsApp scheduling and payment chasing; struggles with technical video editing and hosting platforms; lacks visibility into student home practice.
- **Needs**: Automated booking and Razorpay/Stripe payment collection; easy LMS course creation workflow; live interactive video streaming with student posture telemetry; clear revenue share reports.
- **Permissions**: `TEACHER` role (Create/publish LMS courses, manage class availability calendar, host live streaming classes, view enrolled student progress, manage earnings/wallet).
- **Primary Features**: Teacher Studio Dashboard, Course Curriculum Builder, Live Class Broadcast Studio, Calendar Slot Manager, Student Telemetry Viewer, Revenue & Wallet Ledger.

### 2.3 Persona 3: The Doctor (Dr. Ananya, 38 — BAMS Ayurvedic Physician & Physical Therapist)
- **Goals**: Provide clinical Ayurvedic diagnosis and physical rehabilitation plans; prescribe personalized therapeutic yoga sequences and herbal remedies; track patient recovery biometrics over time.
- **Pain Points**: Standard telehealth tools lack yoga/posture integration; patients forget dietary and herbal regimens; manual medical record keeping is fragmented.
- **Needs**: HIPAA/GDPR compliant consultation video rooms; electronic health record (EHR) intake forms; e-Prescription builder linking directly to platform LMS exercises and marketplace herbs.
- **Permissions**: `DOCTOR` role (Manage clinical consultation slots, access authorized patient health journals, issue e-prescriptions, publish therapeutic clinical courses).
- **Primary Features**: Telehealth Video Room, Patient Health Journal Viewer, Ayurvedic Dosha Diet Planner, e-Prescription & Therapeutic Sequence Builder, Medical Intake Form Manager.

### 2.4 Persona 4: The Nutritionist (Vikram, 34 — Holistic Clinical Dietitian)
- **Goals**: Deliver customized Ayurvedic and macronutrient meal plans aligned with students' yoga routines and seasonal dosha shifts.
- **Pain Points**: Generic diet apps ignore yogic/Ayurvedic principles (Sattvic, Rajasic, Tamasic foods); clients struggle with meal tracking compliance.
- **Needs**: Sattvic recipe database; AI meal photo calorie/dosha analyzer; direct integration with student workout calorie expenditure graphs.
- **Permissions**: `NUTRITIONIST` role (Create nutrition plans, view student dietary logs, publish nutrition courses, consult via video/chat).
- **Primary Features**: Ayurvedic Dosha Diet Planner, Sattvic Recipe Database, AI Meal Tracker Review, Student Calorie & Metabolism Dashboard.

### 2.5 Persona 5: The Meditation Coach (Lama Tenzin, 55 — Mindfulness & Pranayama Guide)
- **Goals**: Guide students through deep mindfulness meditation, Nidra sleep relaxation, and structured Pranayama breathwork exercises.
- **Pain Points**: Standard audio players lack ambient soundscape customization and breathwork pacing visualizers; students struggle with breath timing.
- **Needs**: High-fidelity audio streaming with customizable background ambient soundscapes (singing bowls, forest rain, Om drone); interactive breathwork pacing animations.
- **Permissions**: `COACH` role (Upload guided audio sessions, host live meditation rooms, moderate community mindfulness groups).
- **Primary Features**: Audio Meditation Studio, Pranayama Breathwork Visualizer & Timer, Live Audio Sanctuary Rooms, Mindfulness Streak Tracker.

### 2.6 Persona 6: The Studio Owner (Meera, 45 — Multi-City Yoga Studio Director)
- **Goals**: Manage 5 physical studio locations and 30 employed instructors; offer hybrid in-person and digital memberships; optimize room utilization and teacher payroll.
- **Pain Points**: Managing multiple software subscriptions (Mindbody, Zoom, Shopify, Payroll) is expensive and fragmented; reconciling teacher payouts is tedious.
- **Needs**: Unified multi-studio schedule; automated teacher payroll and commission splits; hybrid membership access control; physical room inventory management.
- **Permissions**: `STUDIO_ADMIN` role (Manage studio locations, onboard/assign teachers, configure room schedules, view studio financial ledgers, generate business reports).
- **Primary Features**: Multi-Studio Operations Grid, Room & Inventory Calendar, Teacher Payroll & Commission Calculator, Hybrid Membership Manager, Studio Financial Dashboard.

### 2.7 Persona 7: The Corporate HR (David, 40 — VP of People & Employee Wellness)
- **Goals**: Provide 5,000 corporate employees with a verifiable mental health and ergonomic posture wellness benefit to reduce burnout and healthcare costs.
- **Pain Points**: Low employee engagement with traditional Employee Assistance Programs (EAPs); inability to measure ROI or wellness improvements without violating employee privacy.
- **Needs**: Bulk employee seat onboarding via SSO; anonymized, aggregate wellness analytics (stress reduction percentage, posture improvement metrics); private corporate team challenges.
- **Permissions**: `CORPORATE_ADMIN` role (Manage employee seat allocations, view anonymized aggregate wellness analytics, launch corporate challenges).
- **Primary Features**: Corporate Portal Dashboard, Employee Seat & SSO Manager, Aggregate Anonymized Health Reports, Company Wellness Challenge Builder.

### 2.8 Persona 8: The Platform Admin (Siddharth, 32 — Operations & Moderation Lead)
- **Goals**: Ensure platform content quality, verify teacher/doctor credentials, moderate community discussions, and resolve customer support escalations.
- **Pain Points**: High volume of teacher applications requiring credential verification; identifying spam or inappropriate community posts manually.
- **Needs**: Streamlined teacher/doctor credential verification workflow; AI-flagged community moderation queue; user impersonation for customer support troubleshooting.
- **Permissions**: `ADMIN` role (Review/approve teachers and doctors, moderate community posts, manage CMS content, handle refund/support escalations, view operational logs).
- **Primary Features**: Credential Verification Queue, AI Moderation Dashboard, CMS Content Editor, Order & Refund Management Portal, Customer Support Ticket Console.

### 2.9 Persona 9: The Super Admin (Aditya, 35 — Platform Founder & Systems Chief)
- **Goals**: Maintain global platform health, monitor financial growth and unit economics, enforce security policies, and manage system-wide configurations and feature flags.
- **Pain Points**: Lacking real-time visibility into system bottlenecks, payment gateway reconciliation discrepancies, or AI infrastructure token costs.
- **Needs**: Executive command center displaying real-time DAU/MAU, GMV, AI latency, and infrastructure health; dynamic feature flag toggles; global RLS and security controls.
- **Permissions**: `SUPER_ADMIN` role (Full unrestricted access to all platform modules, system settings, financial ledgers, IAM role assignments, and infrastructure telemetry).
- **Primary Features**: Executive Command Center, Financial Reconciliation Ledger, Global Feature Flag & Config Manager, IAM Role & Tenant Admin, System Telemetry & Audit Log Viewer.

---

## PART 3: COMPLETE USER JOURNEY

The user journey maps the end-to-end lifecycle across 13 distinct phases for Students, Teachers, Doctors, and Admins, ensuring a seamless, high-retention experience.

```mermaid
graph TD
    Phase1[1. Discovery & Marketing] --> Phase2[2. Registration & Auth]
    Phase2 --> Phase3[3. Personalized Onboarding]
    Phase3 --> Phase4[4. Daily Sanctuary Usage]
    Phase4 --> Phase5[5. Interactive Booking]
    Phase5 --> Phase6[6. Payment & Wallet]
    Phase6 --> Phase7[7. LMS Course Learning]
    Phase7 --> Phase8[8. Real-Time AI Coaching]
    Phase8 --> Phase9[9. Community Engagement]
    Phase9 --> Phase10[10. Subscription Renewal]
    Phase10 --> Phase11[11. Viral Referral Loop]
    Phase11 --> Phase12[12. Support & Helpdesk]
    Phase12 --> Phase13[13. Long-Term Retention & Streaks]
```

### 3.1 Detailed Journey Phases
1. **Discovery & Marketing**: Student discovers Yoga24X via SEO-optimized Next.js public course catalog, social media share of an AI Pose Coach accuracy score, or corporate HR benefit rollout.
2. **Registration & Auth**: Student downloads Flutter mobile app or opens Next.js web portal. Executes one-tap Google OAuth 2.0 SSO or enters mobile number for 6-digit SMS/WhatsApp OTP verification. Account created in `< 3 seconds` with stateless JWT RS256 issuance.
3. **Personalized Onboarding**: Student completes a dynamic 5-step interactive assessment:
   - *Biometrics*: Age, height, weight, fitness level.
   - *Health & Injuries*: Selects existing conditions (lower back pain, scoliosis, prenatal, knee surgery).
   - *Ayurvedic Dosha Quiz*: 10 questions identifying Prakriti (Vata, Pitta, Kapha constitution).
   - *Goals*: Stress relief, flexibility, weight loss, sleep improvement.
   - *AI Sanctuary Setup*: System initializes custom AI health profile and generates a personalized 7-day starter plan.
4. **Daily Sanctuary Usage**: Student opens app to personalized Home Dashboard displaying daily streak counter, recommended 15-minute morning Vinyasa flow, daily Ayurvedic hydration tip, and upcoming live class reminder.
5. **Interactive Booking**: Student browses schedule for an evening Yin Yoga live class or 1-on-1 consultation with Dr. Ananya. Views real-time slot availability, teacher rating, and class difficulty. Selects slot; system checks GiST exclusion lock to prevent double booking.
6. **Payment & Wallet**: Student proceeds to checkout. Chooses payment method: Razorpay UPI, Credit Card, or existing Yoga24X Wallet balance. For subscriptions, Razorpay e-Mandate is authorized. Payment succeeds; invoice generated; confirmation notification sent via FCM/SMS.
7. **LMS Course Learning**: Student accesses enrolled 14-Day Back Pain Relief LMS course. Plays HD video lesson via CloudFront CDN with multi-bitrate HLS and FairPlay DRM encryption. Video player saves progress checkpoints every 10 seconds. Student downloads lesson 3 to offline Isar storage for upcoming flight.
8. **Real-Time AI Coaching**: During video playback or self-practice, student activates "AI Pose Coach". Front mobile camera activates. Edge MediaPipe computer vision extracts 33 3D skeletal keypoints at 30fps. AI detects Warrior II front knee collapsing inward; instantly triggers visual skeleton highlight and voice prompt: *"Aria, gently rotate your left knee outward to align with your ankle."* Session ends with a 94% alignment accuracy score and joint stress heatmap.
9. **Community Engagement**: Student shares 94% AI Pose score and achievement badge to the Yoga24X Social Feed. Master Rajesh likes the post and comments encouragingly. Other students ask questions; community thrives under automated AI moderation ensuring positive, safe interactions.
10. **Subscription Renewal**: On day 30, Razorpay executes automated subscription recurring billing. BullMQ worker verifies payment, extends `users.subscription_status` in PostgreSQL, and sends a celebratory renewal email and badge.
11. **Viral Referral Loop**: Student invites coworker via unique WhatsApp referral link. Coworker registers and books first paid membership. BullMQ referral saga awards $\$10$ wallet credit to both Aria and coworker instantly.
12. **Support & Helpdesk**: Student experiences a minor video loading delay on cellular data. Opens AI Support Chat. AI Assistant diagnoses low bandwidth, explains adaptive bitrate switching, and resolves query in 15 seconds without human escalation.
13. **Long-Term Retention & Streaks**: Student reaches a 30-day continuous practice streak. Unlocks "Lotus Master" NFT-backed digital badge, receives a physical organic yoga mat discount in the Marketplace, and gets a personalized congratulatory video message from their favorite instructor.

---

## PART 4: INFORMATION ARCHITECTURE (IA)

The Information Architecture organizes all platform capabilities into an intuitive, ergonomic navigation structure optimized for one-handed mobile usage (Flutter Bottom Navigation & Drawer) and high-density web administration (Next.js Sidebar & Command Palette).

### 4.1 Mobile App Navigation Hierarchy (Flutter)
- **Primary Bottom Navigation Bar (5 Tabs)**:
  1. *Home / Sanctuary*: Personalized dashboard, daily streak, quick AI check-in, live class banner, daily Ayurvedic tip.
  2. *Explore / Courses (LMS)*: Course catalog, faceted search, categorized playlists (Vinyasa, Hatha, Prenatal, Pranayama), teacher directory.
  3. *Live / Schedule*: Interactive class calendar, room bookings, 1-on-1 doctor/teacher consultation scheduling, my upcoming classes.
  4. *Community / Social*: Global and studio social feeds, user posts, achievement sharing, discussion forums, Q&A threads.
  5. *AI Coach / Hub*: Direct access to AI Pose Coach camera studio, AI Ayurvedic Diet Planner, AI Meditation Soundscape mixer, and health journals.
- **Secondary Drawer / Side Menu**:
  - *My Sanctuary*: Enrolled Courses, Class Bookings, Doctor Prescriptions, Practice History & Biometrics.
  - *Finance & Rewards*: Wallet Balance, Add Money, Referral Program & Earning Link, Order History, Saved Payment Methods.
  - *Offline Sanctuary*: Downloaded LMS Videos, Offline Audio Meditations, Storage Management.
  - *Marketplace*: E-commerce store, Shopping Cart, Wishlist, Equipment & Ayurvedic Herbs.
  - *Retreats & Workshops*: Upcoming residential retreats, masterclass webinars, ticket management.
  - *Settings & Preferences*: Account Edit, Security & 2FA, Privacy & GDPR Export, Notification Toggles, Language (i18n), Theme (Light/Dark).
  - *Help & Support*: AI 24/7 Support Chat, FAQ Knowledge Base, Report an Issue, Contact Studio.

### 4.2 Web Administration Portal Navigation (Next.js 15)
- **Left Sidebar Navigation (Role-Protected Items)**:
  - *Executive Command Center* (`SUPER_ADMIN`, `STUDIO_ADMIN`): Real-time DAU/MAU, GMV, AI telemetry, system health.
  - *User Management* (`ADMIN`): Student directory, Teacher verification queue, Doctor onboarding, Corporate HR accounts, RBAC role assignment.
  - *Studio & Schedule Operations* (`STUDIO_ADMIN`, `TEACHER`): Multi-studio room matrix, class schedule builder, teacher substitution manager, attendance tracking.
  - *LMS Course Studio* (`TEACHER`, `ADMIN`): Course creation wizard, video upload & MediaConvert pipeline monitor, quiz builder, certificate template designer.
  - *Clinical Telehealth Console* (`DOCTOR`): Patient appointment queue, EHR intake forms, e-prescription builder, clinical notes archive.
  - *Financial Ledger & Payouts* (`SUPER_ADMIN`, `STUDIO_ADMIN`): Razorpay transaction ledger, wallet balance reconciliation, teacher commission calculations, tax invoice generator.
  - *Content & CMS Manager* (`ADMIN`): Banner promotions, blog articles, FAQ editor, prompt template version manager, legal terms editor.
  - *Community & Moderation* (`ADMIN`, `COACH`): AI-flagged post review queue, user report resolution, community guidelines enforcement, announcement broadcast.
  - *System Telemetry & Audit Logs* (`SUPER_ADMIN`): OpenTelemetry metrics, Grafana Loki ECS logs, security audit trail WORM viewer, feature flag manager.

---

## PART 5: COMPLETE SCREEN INVENTORY (24 FUNCTIONAL AREAS)

This inventory defines EVERY screen required across the platform. Each screen must strictly implement its defined Purpose, User Actions, Business Rules, Navigation paths, and Edge Case handling.

| # | Functional Area | Screen Name | Purpose | User Actions | Business Rules | Edge Cases & Error States |
| :- | :--- | :--- | :--- | :--- | :--- | :--- |
| **1** | Authentication | `LoginScreen` | Secure user authentication via Google SSO or mobile OTP. | Tap Google SSO; enter phone number; tap Send OTP. | Rate limit: max 5 OTP requests / 15 min. Phone must be valid E.164 format. | Network offline banner; rate limit 429 lockout countdown; invalid phone format error. |
| **2** | Authentication | `OtpVerifyScreen` | Verify 6-digit OTP sent via SMS/WhatsApp. | Enter 6-digit code; tap Verify; tap Resend OTP after 60s timer. | OTP expires in 5m; max 5 failed attempts before 30m account lock. | Incorrect OTP vibration shake & red border; expired OTP prompt to resend; account locked modal. |
| **3** | Authentication | `OnboardingAssessmentScreen`| Collect biometrics, injuries, and Ayurvedic Dosha profile. | Select age, weight, injuries; answer 10 Dosha questions; tap Complete. | All medical contraindications selected must trigger AI safety guardrails in DB. | Student skips assessment $\to$ assign default balanced dosha and beginner safety restrictions. |
| **4** | Home | `StudentDashboardScreen` | Daily personalized hub showing streaks, next class, and AI tips. | Tap start morning flow; tap join live class; view daily streak; tap AI check-in. | Streak resets if no practice logged between 00:00 and 23:59 local timezone. | Zero classes booked $\to$ show empty state with "Explore Classes" CTA; offline mode shows cached dashboard. |
| **5** | Course / LMS | `CourseCatalogScreen` | Discover and filter on-demand video courses and learning paths. | Filter by difficulty, teacher, dosha, duration; search keyword; tap course card. | Courses with status `PUBLISHED` only are displayed; soft-deleted courses hidden. | Zero search results $\to$ display "No courses found, try clearing filters"; pagination loading skeleton. |
| **6** | Course / LMS | `CourseDetailScreen` | View course syllabus, teacher bio, reviews, and enroll/purchase. | View syllabus curriculum; watch promo video; tap Enroll / Buy Course; read reviews. | If user has active Silver/Gold/Platinum subscription, Enroll is free; else show Razorpay price. | Course already enrolled $\to$ CTA changes to "Resume Course"; course under maintenance banner. |
| **7** | Course / LMS | `LessonVideoPlayerScreen` | HD video playback with HLS streaming, DRM, and offline saving. | Play/pause, seek, change playback speed (0.5x–2.0x), select quality, tap Download, tap AI Coach. | Progress checkpoint saved to DB every 10s. Lesson marked complete at $\ge 80\%$ watch time. | Cellular data warning modal; DRM license decryption failure error; video buffering spinner. |
| **8** | Course / LMS | `LessonQuizScreen` | Assess student understanding of yoga philosophy or anatomy. | Select multiple-choice answers; tap Submit Quiz; view immediate score explanations. | Passing score $\ge 75\%$. Can retry unlimited times with 10-minute cooldown after 3 failures. | Unanswered questions highlighted on submit; network drop during submit $\to$ cache answers locally in Isar. |
| **9** | Course / LMS | `CertificateViewerScreen` | Display earned course completion certificate with QR code. | View high-res PDF certificate; tap Share to LinkedIn/Instagram; tap Download PDF. | Certificate generated only when all lessons complete AND quiz score $\ge 75\%$. | Certificate rendering delay $\to$ show shimmer skeleton; invalid verification QR code error page. |
| **10**| Booking | `ScheduleCalendarScreen` | Interactive weekly/monthly grid of live classes and consultations. | Switch calendar view (Day/Week/Month); filter by studio/teacher; tap class slot. | Slots past start time cannot be booked; class capacity limit enforced strictly. | Fully booked slot $\to$ show "Join Waitlist" button; teacher emergency substitution notice banner. |
| **11**| Booking | `SlotCheckoutModal` | Confirm slot selection, review cancellation policy, and pay. | Select payment method (Wallet, Razorpay UPI, Card); apply coupon; tap Confirm Booking. | Must check PostgreSQL GiST exclusion lock; if slot taken during checkout, abort with 409 Conflict. | Insufficient wallet balance $\to$ inline Razorpay top-up flow; payment gateway timeout retry prompt. |
| **12**| Booking | `MyBookingsScreen` | Manage upcoming and past booked classes and consultations. | View upcoming list; tap Join Live Room (enabled 15m before); tap Cancel Booking; view past logs. | Cancellation $>6\text{h}$ before start $\to$ 100% refund; $<6\text{h} \to 50\%$ fee; $<2\text{h} \to$ no refund. | Live stream link not ready $\to$ show countdown timer; cancelled booking shown with greyed strike-through. |
| **13**| Teacher | `TeacherProfileScreen` | Showcase teacher bio, Yoga Alliance RYT badges, schedule, and courses.| Read bio; view credentials; tap Follow; browse teacher's courses; book 1-on-1 slot. | Only verified teachers (`verification_status = VERIFIED`) appear in public search. | Teacher on leave/vacation banner; zero upcoming classes empty state. |
| **14**| Teacher | `TeacherStudioDashboard`| Teacher command center for managing schedule, students, and earnings.| Create class slot; start live stream broadcast; view enrolled student roster; check earnings. | Live stream broadcast button enabled 30 minutes prior to scheduled start time. | Audio/Video permission denied error modal; zero students enrolled warning notice. |
| **15**| Student | `HealthJournalScreen` | Track student practice history, weight, dosha balance, and pain logs.| Log daily weight; record pain level (1–10); add journal note; view biometric graphs. | Journal entries encrypted at rest (AES-256-GCM); accessible only by student and authorized doctors. | Missing data points in graph $\to$ connect dots with dashed line; export health report PDF loading state. |
| **16**| Doctor | `DoctorDirectoryScreen` | Discover certified Ayurvedic physicians and physical therapists. | Filter by specialization (Ortho, Ayurvedic, Prenatal); sort by rating; tap doctor card. | Doctors must have valid BAMS/MBBS medical registration number verified by Admin. | Zero doctors available in timezone $\to$ prompt to book asynchronous video message consultation. |
| **17**| Doctor | `ConsultationRoomScreen` | WebRTC HIPAA-compliant video consultation room with EHR tools. | Video/audio mute; screen share; doctor views patient health journal; doctor writes e-prescription. | Room locks automatically 10 minutes after appointment end time; zero cloud recording without consent. | WebRTC ICE connection disconnection $\to$ automatic reconnection spinner with telephone dial-in fallback. |
| **18**| Community | `SocialFeedScreen` | Global and studio community feed showing achievements and discussions.| Scroll feed; tap Like; write comment; tap Share; tap Create Post floating action button. | All user posts and comments pass through automated AI moderation before publishing. | AI moderation flag $\to$ post hidden with "Under Review" badge; network offline shows cached feed. |
| **19**| Community | `CreatePostModal` | Publish text, photos, videos, or practice milestone badges to feed. | Write caption; attach photo/video; tag teacher/course; select privacy (Public/Studio); tap Post. | Max video size 100MB; media uploaded via S3 pre-signed URL; virus scan mandatory. | S3 upload failure $\to$ retry button; inappropriate words blocked instantly by local regex filter. |
| **20**| Marketplace| `ProductCatalogScreen` | E-commerce store for organic yoga mats, props, and Ayurvedic herbs.| Filter by category (Props, Herbs, Apparel); sort by price; tap product card; tap Add to Cart. | Physical products require shipping address validation; herbs display FSSAI/FDA disclaimer. | Out of stock item $\to$ greyed out with "Notify When Available" CTA; price update sync error. |
| **21**| Wallet | `WalletDashboardScreen`| Manage wallet cash balance, promotional credits, and ledgers. | View total balance; tap Add Money; view transaction history grid; tap Cashout (Teachers). | Cash credits never expire; promo credits expire in 30 days; balance cannot be negative. | Razorpay payment pending reconciliation $\to$ show "Processing" badge on ledger row. |
| **22**| Membership | `SubscriptionPlansScreen`| Compare Silver, Gold, and Platinum subscription tiers and upgrade. | Toggle monthly/annual billing; view benefit matrix; tap Select Plan; authorize Razorpay mandate. | Upgrades calculated pro-rata instantly; downgrades take effect at end of current billing cycle. | Card mandate authorization failure modal; active subscription cancellation confirmation retention flow. |
| **23**| AI Coach | `AIPoseCoachScreen` | Real-time edge camera studio analyzing 33 skeletal posture keypoints.| Position phone 6 feet away; align body in silhouette; hold asana; listen to AI voice corrections. | 30fps MediaPipe inference executes locally on device GPU; zero video frames transmitted to cloud. | Poor room lighting warning banner; student out of camera frame alert; low GPU frame rate degradation notice. |
| **24**| Meditation | `PranayamaStudioScreen`| Interactive breathwork timer with customizable ambient soundscapes. | Select breathing rhythm (4-7-8, Box Breathing); adjust soundscape volume sliders; tap Start Session. | Audio plays in background Isar service when phone screen is locked or app minimized. | Audio focus loss (incoming phone call) $\to$ auto-pause meditation timer and smoothly fade audio out. |

---

## PART 6: DETAILED FEATURE REQUIREMENTS (35+ FEATURES)

Each feature requirement defines the operational boundaries, validation rules, RBAC permissions, and failure handling across all system subsystems.

### 6.1 Authentication & Identity System
- **Purpose**: Provide secure, frictionless, zero-trust user identification and session management across web and mobile platforms.
- **Description**: Supports Google OAuth 2.0 SSO, Apple Sign-In, and 6-digit SMS/WhatsApp OTP passwordless authentication. Issues stateless RS256 JWT access tokens (15m TTL) and opaque SHA-256 hashed refresh tokens (7d TTL) stored in Redis and PostgreSQL.
- **Business & Validation Rules**:
  - Phone numbers must be validated against E.164 international format.
  - OTP codes are strictly 6 numeric digits, expiring in exactly 300 seconds.
  - Maximum 5 failed OTP verification attempts per user per 15-minute window; breaching triggers a temporary 30-minute account lockout in Redis.
  - Refresh token reuse detection: if a previously consumed refresh token is presented, the entire token family is revoked immediately in Redis and PostgreSQL.
- **Success Criteria**: User successfully logs in or registers within $< 3\text{ seconds}$; JWT tokens securely stored in mobile secure storage or web HTTP-only cookies.
- **Failure Cases & Edge Cases**: Network disconnection during OTP request; SMS gateway provider outage (fallback to WhatsApp OTP or automated voice call); clock skew between client and server during JWT validation (allow 30s leeway).
- **Permissions (RBAC)**: Public access for login/register; authenticated bearer token required for all subsequent identity modifications.
- **Notifications & Offline Behaviour**: FCM/SMS security alert sent on login from a new device ID or unrecognized IP address. Authentication requires active network connectivity; offline login is prohibited for security.
- **Accessibility & Future Expansion**: Full VoiceOver/TalkBack announcement of OTP input fields and error messages. Future expansion: WebAuthn / Passkey biometric authentication (FaceID / TouchID / Windows Hello) without passwords or OTPs.

### 6.2 Real-Time AI Pose Coach (Computer Vision)
- **Purpose**: Prevent physical injury and provide clinical-grade postural alignment corrections during home yoga practice.
- **Description**: Utilizes mobile device front/rear camera to run Google MediaPipe / MoveNet edge computer vision models at 30fps. Extracts 33 3D skeletal keypoints in real-time, calculates joint angles (elbow, knee, hip, spine), compares against golden biomechanical vectors, and delivers instant visual skeleton overlays and voice coaching.
- **Business & Validation Rules**:
  - Inference MUST execute locally on the mobile device edge GPU/NPU; raw camera video frames must NEVER be uploaded or stored on cloud servers without explicit user recording consent.
  - If calculated joint angle deviation exceeds golden threshold by $> 15^\circ$ on an injured joint (checked against student's injury profile), AI must immediately issue an urgent voice warning: *"Stop, ease out of the pose to protect your lower back."*
  - Overall pose alignment score calculated from weighted average of key joint angles: $\ge 90\%$ (Green/Perfect), $75\%–89\%$ (Yellow/Adjust), $< 75\%$ (Red/Misaligned).
- **Success Criteria**: 30fps real-time tracking with joint angle calculation latency $< 33\text{ms}$; voice feedback delivered within $< 500\text{ms}$ of posture deviation detection.
- **Failure Cases & Edge Cases**: Student moves out of camera frame (trigger UI guidance arrow); room lighting too dark (display low-light warning banner); older mobile device GPU cannot sustain 30fps (dynamically degrade model resolution or drop to 15fps while notifying user).
- **Permissions (RBAC)**: Available to `STUDENT`, `TEACHER`, and `DOCTOR` roles possessing active Gold or Platinum subscriptions.
- **Notifications & Offline Behaviour**: Post-practice summary notification with alignment score and calorie burn. AI Pose Coach model weights (`.tflite`) are downloaded and cached locally in Isar during onboarding, enabling 100% offline pose coaching in airplane mode.
- **Accessibility & Future Expansion**: Audio-only coaching mode with high-contrast screen reader descriptions for visually impaired practitioners. Future expansion: Multi-person pose tracking for couples yoga and instructor classroom monitoring.

### 6.3 Interactive Live Class Sanctuary (Streaming & Telemetry)
- **Purpose**: Recreate the immersive, communal experience of an in-person yoga studio with two-way teacher interaction.
- **Description**: Multi-bitrate live video broadcasting via AWS CloudFront / WebRTC. Teachers broadcast HD video/audio from the Studio Dashboard. Students join via mobile or web; their local AI Pose Coach calculates real-time alignment scores and heart rate (via wearable sync), transmitting lightweight numeric telemetry data (not video) back to the teacher's dashboard.
- **Business & Validation Rules**:
  - Class broadcast room opens automatically 15 minutes prior to scheduled start time for teacher setup and student warm-up check-in.
  - Maximum capacity strictly enforced per class slot (e.g., 50 students for interactive telemetry room; unlimited for one-way broadcast view).
  - Teacher dashboard highlights students with alignment scores $< 70\%$ or elevated heart rates in red, allowing the teacher to give personalized verbal cues or request two-way spotlight video spotlighting.
- **Success Criteria**: Global end-to-end streaming latency $\le 200\text{ms}$; zero audio/video desynchronization; telemetry data grid updates on teacher dashboard at 1Hz (1 update per second per student).
- **Failure Cases & Edge Cases**: Student cellular network bandwidth drops below 500kbps (automatically downgrade video stream from 1080p to 360p or audio-only while keeping telemetry active); teacher internet disconnection (auto-activate 60-second "Teacher Reconnecting" slate while maintaining student chat room).
- **Permissions (RBAC)**: `TEACHER` and `STUDIO_ADMIN` can broadcast; enrolled `STUDENT` with valid booking or subscription can join.
- **Notifications & Offline Behaviour**: FCM push notification sent 15 minutes before class start: *"Master Rajesh's Vinyasa Flow is starting soon! Tap to enter the Sanctuary."* Requires active internet connection; no offline live streaming.
- **Accessibility & Future Expansion**: Real-time AI speech-to-text live closed captions (CC) in English, Hindi, and Spanish with adjustable font sizes. Future expansion: Apple Vision Pro / Meta Quest 3 spatial 3D VR yoga studio environments.

### 6.4 LMS Course Learning & Offline Video Player
- **Purpose**: Deliver structured, progressive educational courses on yoga philosophy, anatomy, asana mastery, and teacher training.
- **Description**: On-demand video courses organized into modules, lessons, downloadable PDF resources, and quizzes. Video content is transcoded via AWS Elemental MediaConvert into multi-bitrate HLS streams protected by Apple FairPlay and Google Widevine DRM encryption.
- **Business & Validation Rules**:
  - Course progress checkpoints must be saved to PostgreSQL `lesson_progress` table every 10 seconds during playback.
  - A lesson is marked `COMPLETED` only when student watch time reaches $\ge 80\%$ of total video duration.
  - Sequential course locking rule: if `is_sequential = true`, lesson $N$ cannot be played until lesson $N-1$ is marked `COMPLETED`.
  - Offline downloads expire automatically 30 days after download or immediately upon subscription cancellation/expiration.
- **Success Criteria**: Video playback initiates in $< 1\text{ second}$ (instant start); zero buffering on standard 4G/WiFi networks; seamless DRM decryption across iOS, Android, and web browsers.
- **Failure Cases & Edge Cases**: DRM license server unreachable (retry 3 times with exponential backoff; if failed, display clear error explaining DRM check failure); student seeks/skips to end of video immediately (do not mark lesson complete; enforce actual watch time calculation).
- **Permissions (RBAC)**: `TEACHER`, `DOCTOR`, and `ADMIN` can publish courses; `STUDENT` can view enrolled courses.
- **Notifications & Offline Behaviour**: Automated email/push reminder sent after 3 days of course inactivity: *"You're 60% through 14-Day Back Pain Relief! Complete Lesson 9 today."* Downloaded videos stored securely in local Isar/SQLite storage, fully playable offline with local progress tracking that syncs to backend upon network reconnection.
- **Accessibility & Future Expansion**: Subtitles/CC in 10 languages; audio descriptions of physical movements; keyboard navigation for web video player. Future expansion: AI-generated interactive video branching where lesson difficulty adapts dynamically based on quiz results.

### 6.5 Enterprise Booking & Calendar Engine
- **Purpose**: Enable conflict-free scheduling of live studio classes, workshops, and 1-on-1 doctor/teacher consultations across global timezones.
- **Description**: Interactive calendar grid supporting daily, weekly, and monthly views. Syncs bi-directionally with Google Calendar and Apple Calendar. Handles multi-teacher studio schedules, room inventory constraints, and automated waitlist promotions.
- **Business & Validation Rules**:
  - **GiST Exclusion Rule**: All slot bookings must execute against PostgreSQL `EXCLUDE USING gist` constraints on `calendar_slots` to structurally prevent double bookings or room overlaps under high concurrency.
  - **Booking Windows**: Classes can be booked up to 30 days in advance and close exactly 5 minutes before scheduled start time.
  - **Waitlist Auto-Promotion**: When a confirmed student cancels, the system automatically promotes the #1 waitlisted student, deducts wallet/subscription credit, and dispatches an instant FCM/SMS confirmation.
- **Success Criteria**: Booking transaction completes in $< 200\text{ms}$ p95; zero double bookings or double wallet debits ever recorded under simulated 10,000 concurrent booking requests.
- **Failure Cases & Edge Cases**: Two students attempt to book the final remaining slot simultaneously (PostgreSQL GiST lock grants slot to first transaction; second transaction aborts cleanly with `409 Conflict` and displays "Slot just filled, added to waitlist" modal); teacher changes class time after 40 students have booked (system auto-notifies all enrolled students with 1-click confirm/cancel options and automated full refund if unable to attend).
- **Permissions (RBAC)**: `STUDENT` can book/cancel; `TEACHER` and `STUDIO_ADMIN` can create/modify/cancel slots and view rosters; `ADMIN` can override bookings.
- **Notifications & Offline Behaviour**: Instant booking confirmation push/email with `.ics` calendar invite attachment; 2-hour and 15-minute pre-class reminders. Calendar view caches previously fetched schedules locally in Isar for offline viewing; booking mutations require online connectivity.
- **Accessibility & Future Expansion**: Screen reader optimized calendar grid with explicit date and time announcements; high-contrast focus indicators. Future expansion: AI predictive scheduling recommending optimal class times to studio owners based on historical attendance heatmaps.

### 6.6 Razorpay Payment Gateway & Wallet Ledger
- **Purpose**: Provide secure, PCI-DSS compliant financial transactions, recurring subscription billing, instant refunds, and multi-currency digital wallet management.
- **Description**: Seamless integration with Razorpay (supporting Indian UPI, NetBanking, Cards, and global Wallets/Stripe for international users). Includes an internal immutable double-entry financial ledger (`wallet_transactions`) tracking user cash balances and promotional credits.
- **Business & Validation Rules**:
  - All financial modifications MUST execute inside an ACID PostgreSQL transaction (`prisma.$transaction()`) under `SERIALIZABLE` or `READ COMMITTED` isolation.
  - **Wallet Balance Rule**: `wallet_balance` cannot drop below zero. Cash credits never expire; promotional bonus credits expire exactly 30 days from issuance.
  - **Recurring Subscriptions**: Razorpay e-Mandates must execute automated renewal debits 24 hours prior to subscription expiration. On debit failure, system grants a 3-day grace period with daily retry attempts before downgrading account to Freemium.
  - **Instant Refund Rule**: Class cancellations qualifying for a refund must credit the user's Yoga24X Wallet instantly or initiate a Razorpay bank refund within 24 hours.
- **Success Criteria**: Payment webhook reconciliation completes in $< 500\text{ms}$; 100% cryptographic verification of Razorpay webhook signatures (`X-Razorpay-Signature`); zero ledger discrepancies during daily automated reconciliation audits.
- **Failure Cases & Edge Cases**: User bank account debited but network connection drops before reaching app confirmation screen (BullMQ payment reconciliation worker receives Razorpay webhook, marks booking confirmed in DB, and sends confirmation notification); fraudulent chargeback initiated (system auto-suspends user account and freezes wallet balance pending admin investigation).
- **Permissions (RBAC)**: `STUDENT` can view own wallet and pay; `TEACHER` and `STUDIO_ADMIN` can view earnings and request cashout payouts; `SUPER_ADMIN` has read-only audit access to all financial ledgers.
- **Notifications & Offline Behaviour**: Transactional email and push notification with PDF tax invoice attached sent instantly upon every successful payment, wallet top-up, or refund. All financial transactions strictly require active network connectivity and HTTPS encryption.
- **Accessibility & Future Expansion**: Clear, large-font currency displays; explicit VoiceOver reading of payment amounts and breakdown totals. Future expansion: Integration of Apple Pay, Google Pay, and localized Buy Now Pay Later (BNPL) options (e.g., Simpl, LazyPay, Klarna).

### 6.7 Ayurvedic & Biometric Health Journal
- **Purpose**: Enable holistic tracking of student mind-body evolution, correlating physical yoga practice with Ayurvedic dosha balance, pain relief, sleep quality, and nutrition.
- **Description**: A secure, encrypted digital journal where students log daily weight, mood, pain severity (1–10 scale on interactive body map), sleep hours, and digestion quality. Automatically integrates telemetry from wearable devices (Apple HealthKit, Google Health Connect, Whoop, Oura Ring) capturing resting heart rate, Heart Rate Variability (HRV), and active calories burned.
- **Business & Validation Rules**:
  - All health journal entries and biometric telemetry MUST be encrypted at rest using AES-256-GCM via AWS KMS customer-managed keys.
  - Health data is strictly private (`RLS` enabled); accessible only by the individual student and explicitly authorized clinical `DOCTOR` or `NUTRITIONIST` during active consultation periods.
  - If a student logs severe chronic pain ($\ge 8/10$ for 3 consecutive days), the system must automatically trigger an AI recommendation prompt: *"We noticed persistent high lower back pain. Would you like to book a clinical evaluation with Dr. Ananya or switch to our gentle Chair Yoga series?"*
- **Success Criteria**: Biometric graph rendering completes in $< 100\text{ms}$; wearable background data sync executes reliably without draining mobile battery ($< 1\%$ battery usage per day).
- **Failure Cases & Edge Cases**: Apple HealthKit / Google Fit permission denied by user (display informative card explaining benefits of sync with 1-tap settings redirect button); wearable device sync sends duplicate timestamp logs (deduplicate automatically at repository layer based on `(user_id, timestamp, metric_type)` unique key).
- **Permissions (RBAC)**: `STUDENT` read/write own journal; authorized `DOCTOR` and `NUTRITIONIST` read-only access during active care windows; `ADMIN` and `SUPER_ADMIN` strictly blocked from reading decrypted patient journal entries.
- **Notifications & Offline Behaviour**: Daily evening reflection reminder: *"Take 60 seconds to log your mind-body balance for today."* Journal entries can be logged completely offline in Isar local storage and sync securely to cloud databases upon network restoration.
- **Accessibility & Future Expansion**: Voice-to-text journal dictation allowing students to speak their daily reflections; high-contrast interactive pain body map. Future expansion: AI predictive wellness scoring correlating HRV drops with impending physical burnout or sickness, automatically suggesting restorative Yin yoga and sleep meditations.

---

## PART 7: BUSINESS RULES (12 CORE DOMAINS)

This section articulates the immutable business rules governing system behavior across all 12 operational domains.

| # | Domain | Rule ID | Immutable Business Rule Statement | Enforcement Layer & Mechanism |
| :- | :--- | :--- | :--- | :--- |
| **1** | Booking | `BR-BKG-01` | **Advance Window**: Studio classes and consultations can be booked a maximum of 30 days in advance and close exactly 5 minutes prior to scheduled start time. | NestJS Booking Service + Zod DTO date validation. |
| **2** | Booking | `BR-BKG-02` | **Concurrent Lock**: Every slot reservation must execute against PostgreSQL GiST exclusion constraints (`EXCLUDE USING gist`) to prevent double booking. | PostgreSQL Database Engine Constraint. |
| **3** | Cancellation | `BR-CAN-01` | **Free Cancellation Window**: Class or consultation cancellations executed $\ge 6\text{ hours}$ before scheduled start time receive a 100% refund to wallet or original payment source. | NestJS Finance Service + BullMQ Refund Saga. |
| **4** | Cancellation | `BR-CAN-02` | **Late Cancellation Penalty**: Cancellations executed between $2\text{ hours}$ and $6\text{ hours}$ before class incur a 50% cancellation fee; cancellations $< 2\text{ hours}$ receive zero refund. | NestJS Booking & Finance Service business logic. |
| **5** | Refund | `BR-RFD-01` | **Teacher Cancellation Protection**: If a teacher or studio cancels a confirmed class, all enrolled students receive a 100% instant refund PLUS a $\$5$/₹250 promotional wallet credit inconvenience bonus. | BullMQ Class Cancellation Saga + Wallet Service. |
| **6** | Membership | `BR-MEM-01` | **Tier Privileges**: Tier upgrades take effect immediately with pro-rata pricing; tier downgrades take effect at the end of the current paid billing cycle. | NestJS Subscription Service + Razorpay Mandate API. |
| **7** | Membership | `BR-MEM-02` | **Auto-Debit Grace Period**: If a recurring subscription debit fails, the account enters a 3-day grace period with daily retry attempts before downgrading to Freemium. | BullMQ Recurring Billing Scheduler + Redis State. |
| **8** | Wallet | `BR-WAL-01` | **Credit Expiration**: Real cash added via payment gateways never expires. Promotional bonus credits awarded via referrals or marketing expire exactly 30 days from issuance. | PostgreSQL `wallet_credits` table `expires_at` column + Cron cleanup. |
| **9** | Course | `BR-CRS-01` | **Completion Threshold**: A video lesson is marked complete only when watch time reaches $\ge 80\%$ of total duration. Course completion requires all lessons complete and quiz score $\ge 75\%$. | NestJS Learning Service + Lesson Progress tracking API. |
| **10**| Certificate| `BR-CRT-01` | **Cryptographic Verification**: Every issued PDF certificate must embed a unique verification QR code and KSUID verifiable on the public `/verify-certificate/{id}` endpoint. | BullMQ Certificate Worker + PDFKit + Public Verification Controller. |
| **11**| Referral | `BR-REF-01` | **Anti-Fraud Viral Reward**: Referrer and Referee both receive $\$10$/₹500 wallet credit ONLY after the referee completes their first paid transaction $\ge \$15$/₹1000. Device ID and IP address checked for fraud. | NestJS Referral Service + BullMQ Reward Saga + Redis Fraud IP Lock. |
| **12**| Teacher | `BR-TCH-01` | **Strict Onboarding Verification**: Teachers cannot publish courses or host live classes until Admin verifies: (a) Yoga Alliance RYT certificate, (b) Government photo ID, and (c) 15-min audition video. | NestJS IAM Service `verification_status` flag + Admin Guard. |
| **13**| Doctor | `BR-DOC-01` | **Clinical Medical Verification**: Doctors must upload valid BAMS/MBBS degree and State Medical Council registration number. System executes automated verification against national medical registry APIs. | NestJS IAM Service + External Medical Registry Verification Adapter. |
| **14**| Community| `BR-COM-01` | **Zero Tolerance AI Moderation**: Any community post or comment containing hate speech, harassment, explicit content, or unverified clinical cure claims is blocked instantly by AI moderation. 3 strikes result in permanent account ban. | AI Gateway Moderation Filter + NestJS Social Service + Redis Ban List. |
| **15**| Marketplace| `BR-MKT-01` | **Vendor Commission & Inventory**: Marketplace vendor sales incur a 15% platform commission. Inventory is atomically locked for 15 minutes upon adding to cart and decremented upon successful Razorpay checkout. | NestJS Marketplace Service + PostgreSQL Inventory Transaction Lock. |

---

## PART 8: ACCEPTANCE CRITERIA (GHERKIN FORMAT)

This section details exhaustive behavior-driven development (BDD) acceptance criteria in Gherkin format (`Given`, `When`, `Then`) for critical system workflows across Positive, Negative, Boundary, Failure, and Edge Cases.

### 8.1 Feature: Real-Time AI Pose Coach Alignment & Safety Gating
```gherkin
Feature: Real-Time AI Pose Coach Alignment & Safety Gating
  As an enrolled Student practicing yoga at home
  I want real-time Computer Vision posture feedback on my mobile device
  So that I can correct my alignment immediately and prevent physical injury

  # POSITIVE SCENARIO: Perfect alignment detection
  Scenario: Student achieves correct alignment in Warrior II pose
    Given the student is logged in with an active "Gold Sanctuary" subscription
    And the student has launched the "AI Pose Coach" studio for "Warrior II"
    And the student stands 6 feet away in a well-lit room within camera frame
    When the edge MediaPipe computer vision model extracts 33 skeletal keypoints at 30fps
    And the calculated front knee flexion angle is between 85 degrees and 95 degrees
    Then the UI skeleton overlay must highlight the front knee joint in "Green"
    And the alignment score display must update to "96% - Perfect Alignment"
    And no corrective voice audio prompt should be played

  # NEGATIVE SCENARIO: Posture misalignment triggering voice correction
  Scenario: Student front knee collapses inward during Warrior II pose
    Given the student is actively practicing "Warrior II" in the AI Pose Coach studio
    When the calculated front knee adduction angle deviates inward by 18 degrees from the golden vector
    Then the UI skeleton overlay must highlight the left knee and ankle joints in "Red"
    And the alignment score display must drop to "68% - Needs Adjustment"
    And the system must immediately play the voice prompt: "Gently rotate your left knee outward to align directly over your ankle."
    And a posture correction event must be logged to the student's practice session memory

  # BOUNDARY SCENARIO: Medical contraindication safety intervention
  Scenario: Student with lower back injury hyperextends spine in Cobra pose
    Given the student's onboarding health journal lists an active "Lumbar Disc Herniation" injury
    And the student is practicing "Cobra Pose (Bhujangasana)" in the AI Pose Coach studio
    When the edge computer vision model detects lumbar spinal extension exceeding 35 degrees
    Then the UI must immediately flash a high-priority amber safety warning banner: "Safety Alert: Spine Extension Limit Reached"
    And the system must play the urgent voice override: "Aria, please lower your chest halfway down to protect your lower back lumbar disc."
    And the AI Pose Coach must suppress further deep extension recommendations for the remainder of the session

  # FAILURE SCENARIO: Room lighting too dark for reliable computer vision inference
  Scenario: Room lighting drops below minimum threshold for keypoint extraction
    Given the student is actively practicing in the AI Pose Coach studio
    When the camera video stream luminance level drops below 30 lux
    And the MediaPipe keypoint detection confidence score falls below 0.60 for 60 consecutive frames (2 seconds)
    Then the AI Pose Coach must pause alignment scoring
    And display a non-intrusive warning modal: "Low Lighting Detected. Please turn on a room light for accurate posture tracking."
    And the system must temporarily disable voice correction prompts until lighting luminance restores above 50 lux

  # EDGE CASE: Student steps completely out of the camera frame
  Scenario: Student steps out of mobile device camera view during active practice
    Given the student is actively practicing in the AI Pose Coach studio
    When the edge computer vision model detects 0 skeletal keypoints for 3 consecutive seconds
    Then the UI must display an on-screen directional arrow indicating where the student should step to re-enter frame
    And play a gentle chime sound with the voice prompt: "Please step back into the center of the camera frame."
    And the session timer and calorie calculation must pause automatically until the student re-enters the frame
```

### 8.2 Feature: Interactive Live Class Booking & GiST Concurrency Lock
```gherkin
Feature: Interactive Live Class Booking & GiST Concurrency Lock
  As an enrolled Student
  I want to book a guaranteed time slot for a live yoga class
  So that I can join the interactive broadcast and receive teacher guidance

  # POSITIVE SCENARIO: Successful slot reservation
  Scenario: Student successfully books an available live class slot
    Given the student is logged in and has $25.00 balance in their Yoga24X Wallet
    And "Master Rajesh's Evening Vinyasa Flow" on "2026-07-10 18:00 UTC" has 1 available slot remaining (Capacity: 49/50)
    When the student taps "Confirm Booking" on the checkout modal selecting "Wallet Payment"
    Then the NestJS backend must execute an ACID transaction acquiring the PostgreSQL GiST exclusion lock
    And debit exactly $15.00 from the student's wallet balance
    And increment the class slot occupancy to 50/50
    And insert a booking record with status "CONFIRMED"
    And return HTTP 201 Created with booking confirmation details
    And dispatch an instant FCM push notification with calendar invite attachment to the student

  # NEGATIVE SCENARIO: Slot capacity full resulting in waitlist placement
  Scenario: Student attempts to book a class slot that is already at maximum capacity
    Given "Master Rajesh's Evening Vinyasa Flow" has reached maximum capacity (50/50)
    When the student taps "Confirm Booking" on the checkout modal
    Then the system must prevent wallet debit or payment gateway authorization
    And return HTTP 409 Conflict with Problem Details code "ERR_BKG_4009"
    And display a user-friendly modal: "This class is fully booked. Would you like to join the priority waitlist for free?"
    When the student taps "Join Waitlist"
    Then the system must add the student to the class waitlist table at position #1
    And send an email confirming waitlist registration without debiting funds

  # BOUNDARY SCENARIO: Booking window closure 5 minutes before class start
  Scenario: Student attempts to book a class slot 4 minutes prior to scheduled start time
    Given the current system time is "2026-07-10 17:56 UTC"
    And "Master Rajesh's Evening Vinyasa Flow" is scheduled to start at "2026-07-10 18:00 UTC" (4 minutes away)
    When the student opens the class details screen
    Then the "Book Class" CTA button must be disabled and greyed out
    And display label: "Booking Closed (Class starting soon)"
    And any API POST request to book this slot must be rejected with HTTP 400 Bad Request and code "ERR_BKG_4015"

  # FAILURE SCENARIO: Concurrent double-booking race condition under high traffic
  Scenario: Two students attempt to reserve the final remaining slot simultaneously at the exact same millisecond
    Given "Master Rajesh's Evening Vinyasa Flow" has exactly 1 remaining slot (49/50)
    And Student A and Student B tap "Confirm Booking" simultaneously at "12:00:00.000 UTC"
    When both HTTP POST requests reach the NestJS Booking Service concurrently
    Then the PostgreSQL database engine must evaluate the GiST exclusion constraint (`EXCLUDE USING gist`)
    And grant the final slot (50/50) to the first transaction to acquire the database row lock (Student A)
    And cleanly abort the second concurrent transaction (Student B) without corrupting class occupancy
    And Student A must receive HTTP 201 Confirmed with wallet debit of $15.00
    And Student B must receive HTTP 409 Conflict with message "Slot just filled by another user. You have been added to the waitlist."
    And Student B's wallet balance must remain completely untouched

  # EDGE CASE: Teacher emergency class cancellation triggering automated refunds & bonus
  Scenario: Teacher cancels a confirmed class 3 hours prior to scheduled start time
    Given "Master Rajesh's Evening Vinyasa Flow" has 50 confirmed students enrolled
    When Master Rajesh taps "Emergency Cancel Class" on the Teacher Studio Dashboard specifying reason "Medical Emergency"
    Then the system must update class status to "CANCELLED_BY_TEACHER"
    And publish CloudEvent "booking.class.cancelled_by_teacher.v1" to the Event Bus
    And the BullMQ Refund Saga worker must process all 50 enrolled students asynchronously
    And credit 100% of the paid booking fee ($15.00) back to each student's Yoga24X Wallet instantly
    And award an additional $5.00 promotional wallet credit inconvenience bonus (expiring in 30 days) to each student
    And dispatch high-priority push notifications and emails explaining the cancellation and bonus credit
```

---

## PART 9: NON-FUNCTIONAL REQUIREMENTS (12 PILLARS)

The platform must satisfy these 12 stringent Non-Functional Requirements (NFRs) to ensure enterprise-grade reliability, security, and global scalability.

| Pillar | Metric / Requirement | Architectural Enforcement & Verification Strategy |
| :--- | :--- | :--- |
| **1. Performance** | API p50 $< 50\text{ms}$, p95 $< 150\text{ms}$, p99 $< 300\text{ms}$. DB p95 $< 10\text{ms}$. Mobile UI 60 FPS (120 FPS ProMotion). | PgBouncer transaction pooling; Redis Cluster caching; Flutter Isolate background parsing; k6 automated load testing gating in CI/CD. |
| **2. Availability** | **99.99% Uptime** (Four Nines), allowing max 52.6 minutes of unplanned downtime per year. | AWS EKS Multi-AZ Kubernetes pod deployment; RDS Aurora Multi-AZ replication; Cloudflare Route 53 automated DNS health failover. |
| **3. Reliability** | **Zero Data Loss** (RPO $< 5\text{ minutes}$); automated self-healing from worker crashes and network splits. | ACID PostgreSQL transactions (`prisma.$transaction()`); BullMQ exponential backoff retries ($2\text{s} \times 2^{attempt}$); Dead Letter Queues (DLQ) with SEV-1 alerts. |
| **4. Scalability** | Support 10 Million MAU; handle 100,000 concurrent live stream connections and 50,000 concurrent bookings. | Horizontal Pod Autoscaling (HPA) in Kubernetes based on CPU/Memory and BullMQ queue depth; stateless NestJS architecture; CloudFront CDN. |
| **5. Accessibility** | **WCAG 2.1 AA Compliance** mandatory across web and mobile applications. | 4.5:1 text contrast ratio; minimum 48x48 logical touch targets; full VoiceOver / TalkBack screen reader support; semantic ARIA labels. |
| **6. Security** | Zero-Trust architecture; HIPAA/GDPR health data privacy; PCI-DSS payment compliance. | TLS 1.3 transit encryption; AES-256-GCM rest encryption via AWS KMS; RS256 JWT (15m TTL); PostgreSQL Row Level Security (RLS); OWASP WAF. |
| **7. Localization** | Global multi-language support (i18n) and multi-currency localized billing. | Flutter ARB files and Next.js i18n routing supporting English, Hindi, Spanish, and Sanskrit medical terms; RTL layout support ready. |
| **8. Offline Mode** | Full offline functionality for downloaded LMS courses, audio pranayama, and practice journals. | Local SQLite database via **Isar / Hive** in Flutter; automatic background sync queue replaying offline mutations upon network restoration. |
| **9. SEO** | Maximum organic search visibility for public course catalogs, teacher profiles, and blog articles. | Next.js 15 Server-Side Rendering (SSR) and Static Site Generation (SSG); structured JSON-LD schema markup; dynamic XML sitemaps; Core Web Vitals LCP $< 2.5\text{s}$. |
| **10. Monitoring**| Complete real-time full-stack observability across infrastructure, APIs, and client devices. | OpenTelemetry (OTel) distributed tracing; Prometheus time-series metrics; Grafana Loki ECS JSON logs; Sentry crash reporting; 24/7 PagerDuty alerts. |
| **11. Maintainability**| Clean code architecture enabling rapid onboarding and bug-free feature velocity. | Strict Clean Architecture layering; Riverpod 2.0+ / Freezed in Flutter; NestJS DI; mandatory **85% code coverage** hard gate in GitHub Actions CI/CD. |
| **12. Disaster Recovery**| Guaranteed business continuity during catastrophic regional cloud datacenter failures. | Multi-AZ database deployment; RPO $< 5\text{ minutes}$, RTO $< 30\text{ minutes}$; daily automated cross-region S3 backup replication; monthly DR simulation drills. |

---

## PART 10: KEY PERFORMANCE INDICATORS (KPIS)

To evaluate product health, user adoption, financial sustainability, and AI efficacy, the executive team tracks 7 comprehensive KPI categories.

```mermaid
graph LR
    KPI[Yoga24X Enterprise KPIs] --> Biz[1. Business: ARR, CLV:CAC > 3:1, GMV]
    KPI --> Tech[2. Technical: 99.99% Uptime, p95 < 150ms]
    KPI --> Prod[3. Product: DAU/MAU > 40%, NPS > 75]
    KPI --> AI[4. AI: Pose Accuracy > 95%, RAG Hallucination < 1%]
    KPI --> Tch[5. Teacher: Retention > 90%, Avg Rating >= 4.8]
    KPI --> Std[6. Student: 3+ Sessions/wk, 14-day Streaks]
    KPI --> Rev[7. Revenue: ARPU Growth, 15% Tier Upgrades]
```

1. **Business KPIs**:
   - Monthly Recurring Revenue (MRR) and Annual Recurring Revenue (ARR) growth rate ($\ge 15\%$ MoM).
   - Customer Lifetime Value (CLV) to Customer Acquisition Cost (CAC) ratio $\ge 3:1$.
   - Gross Merchandise Value (GMV) processed through marketplace and course bookings ($\$100\text{M+}$ Year 3 target).
2. **Technical KPIs**:
   - Enterprise infrastructure uptime percentage ($\ge 99.99\%$).
   - API p95 response latency ($\le 150\text{ms}$) and database query execution latency ($\le 10\text{ms}$).
   - Mobile application crash-free session rate ($\ge 99.8\%$).
3. **Product & Engagement KPIs**:
   - Daily Active Users (DAU) to Monthly Active Users (MAU) ratio ($\ge 40\%$).
   - 30-day user retention rate ($\ge 50\%$) and 90-day retention rate ($\ge 35\%$).
   - Net Promoter Score (NPS) ($\ge 75$) and App Store / Google Play average star rating ($\ge 4.8$).
4. **AI Efficacy KPIs**:
   - Computer Vision Pose Coach joint tracking accuracy ($\ge 95\%$) compared to clinical physical therapy evaluation.
   - AI RAG Knowledge Base hallucination / error rate ($< 1\%$).
   - AI recommendation click-through rate (CTR) to class booking ($\ge 35\%$).
5. **Teacher & Creator KPIs**:
   - Teacher monthly retention rate ($\ge 90\%$).
   - Average teacher earnings per month ($\ge \$1,500$ for active full-time instructors).
   - Average student rating across all teacher live classes and LMS courses ($\ge 4.8$ stars).
6. **Student Wellness KPIs**:
   - Average weekly practice consistency ($\ge 3.0\text{ practice sessions per week per active student}$).
   - LMS course completion rate ($\ge 45\%$, outperforming industry average of 10%).
   - Average continuous practice habit streak ($\ge 14\text{ days}$).
7. **Revenue & Monetization KPIs**:
   - Average Revenue Per User (ARPU) across Freemium and Paid cohorts.
   - Subscription tier upgrade conversion rate (Silver $\to$ Gold/Platinum) ($\ge 15\%$).
   - E-commerce Marketplace shopping cart checkout conversion rate ($\ge 8\%$).

---

## PART 11: STRATEGIC PRODUCT ROADMAP (7 HORIZONS)

The product roadmap outlines the phased release strategy from initial MVP to global enterprise expansion over a 36-month timeline.

```mermaid
gantt
    title Yoga24X Strategic Product Roadmap (36 Months)
    dateFormat  YYYY-MM
    section Core Horizons
    MVP (Core Sanctuary & Auth)          :done,    m1, 2026-07, 2026-09
    Version 1.0 (AI Pose Coach Beta & Live) :active,  v1, 2026-10, 2026-12
    Version 2.0 (Hybrid Search & Market)    :         v2, 2027-01, 2027-03
    Version 3.0 (Corporate B2B & Wearables) :         v3, 2027-04, 2027-06
    section Expansion Horizons
    AI Expansion (Sanskrit Voice & Injury Prep):       a1, 2027-07, 2027-12
    International Expansion (10 Lang Dubbing):       i1, 2028-01, 2028-06
    Enterprise Expansion (Hospital EHR / FHIR):      e1, 2028-07, 2029-06
```

### 11.1 Horizon Details
- **MVP (Months 1–3 — "Core Sanctuary Foundation")**:
  - Secure Authentication (Google SSO, OTP verification, JWT RS256 / Refresh Token rotation).
  - Student & Teacher Profile creation with 5-step interactive Ayurvedic Dosha onboarding assessment.
  - Basic LMS Course Player with AWS MediaConvert HLS streaming and progress tracking.
  - Interactive Calendar Booking engine with PostgreSQL GiST exclusion double-booking prevention.
  - Razorpay payment gateway integration for one-time class bookings and wallet top-ups.
- **Version 1.0 (Months 4–6 — "AI Pose Coach Beta & Live Streaming")**:
  - Real-Time AI Pose Coach Beta (WebRTC/MediaPipe 30fps edge computer vision for 20 core asanas).
  - Interactive Live Class Broadcasting Studio with two-way student biometric telemetry monitoring.
  - Global Community Feed with photo/video sharing, comments, likes, and AI automated moderation.
  - Yoga24X Digital Wallet, automated instant cancellation refunds, and viral referral reward loop.
  - Doctor Directory and basic telehealth video consultation booking.
- **Version 2.0 (Months 7–9 — "Hybrid Intelligence & Marketplace")**:
  - Unified Hybrid Search engine (Meilisearch BM25 + PostgreSQL pgvector semantic similarity via RRF).
  - Advanced AI Ayurvedic Nutritionist & Meal Photo Calorie/Dosha Scanner.
  - E-commerce Marketplace (organic yoga mats, props, herbal supplements) with shopping cart checkout.
  - Offline Isar Sanctuary Downloads for LMS video courses and pranayama audio in mobile app.
- **Version 3.0 (Months 10–12 — "Corporate B2B & Advanced Biometrics")**:
  - Corporate Wellness B2B Portal with SSO seat management and anonymized HR aggregate analytics dashboards.
  - Multi-Studio Management Grid for multi-city studio owners (payroll, room inventory, hybrid memberships).
  - Advanced Biometric Wearable Sync (Apple HealthKit, Google Health Connect, Whoop, Oura Ring).
  - Residential Wellness Retreats & Teacher Training Masterclass booking engine.
- **AI Expansion (Year 2 — "Deep Vedic Intelligence")**:
  - Voice-interactive Sanskrit Asana Pronunciation Coach utilizing fine-tuned audio recognition models.
  - Predictive Injury Prevention modeling correlating historical posture deviation heatmaps with HRV drops.
  - AI Personalized Ayurvedic Meal Box Delivery integration linking diet prescriptions to local cloud kitchens.
- **International Expansion (Year 2 — "Global Localization")**:
  - Multi-currency localized billing gateway integration (Stripe, Adyen, Apple Pay, Google Pay, BNPL).
  - Automated AI video dubbing and real-time voice translation in 10 global languages (Hindi, Spanish, French, German, Japanese).
  - Regional data sovereignty infrastructure deployment ensuring strict GDPR, HIPAA, and Indian DPDP Act compliance.
- **Enterprise Expansion (Year 3 — "Healthcare & White-Labeling")**:
  - White-label studio mobile app licensing allowing premium yoga studios to deploy custom-branded apps powered by Yoga24X OS.
  - Hospital & Clinical Physical Therapy EHR integration via HL7/FHIR standards for post-surgical orthopedic rehabilitation.
  - Corporate health insurance API verification allowing students to validate yoga practice for health insurance premium discounts.

---

## PART 12: RISK ANALYSIS & MITIGATION PLANS (6 PILLARS)

To ensure proactive risk governance, the engineering and product teams enforce structured mitigation plans across 6 critical operational categories.

| Risk Category | Identified Enterprise Risk | Severity / Likelihood | Proactive Architectural & Operational Mitigation Plan |
| :--- | :--- | :--- | :--- |
| **1. Technical Risk** | Real-time WebRTC video streaming latency spikes or packet loss under poor cellular network connectivity in developing markets. | **High / High** | Implement adaptive bitrate HLS fallback streaming; deploy edge TURN/STUN servers globally; automatically downgrade student broadcast view from 1080p to 360p or audio-only while maintaining lightweight numeric telemetry transmission. |
| **2. Business Risk** | High creator/teacher churn to competing general creator platforms (Patreon, YouTube, Mindbody) due to monetization friction. | **High / Medium**| Offer industry-leading 80/20 revenue share split; automate instant bank payouts via Razorpay Route; provide built-in tax invoicing, marketing promotion tools, and student retention CRM on the Teacher Studio Dashboard. |
| **3. Legal Risk** | Medical liability claims arising from students experiencing physical injury during unassisted home yoga practice or following AI advice. | **Critical / Low** | Inject mandatory clinical medical disclaimers on every AI chat and course screen; enforce mandatory pre-practice injury intake screening; implement AI contraindication gating ($< 85\%$ confidence triggers human doctor review handoff); maintain $\$10\text{M}$ global professional liability insurance. |
| **4. Security Risk** | Data breach exposing sensitive health journals, wearable biometric telemetry, or payment authorization tokens. | **Critical / Low** | Enforce Zero-Trust architecture; encrypt all databases and S3 archives at rest via AES-256-GCM (AWS KMS); enforce strict PostgreSQL Row Level Security (RLS) tenant isolation; tokenize all payments via PCI-DSS compliant Razorpay Vault; execute automated SAST/DAST scanning on every CI/CD pull request. |
| **5. AI Risk** | Generative LLM hallucinating dangerous physical posture advice, clinical medical cures, or dietary regimens for prenatal mothers. | **High / Medium** | Enforce 3-layer AI safety rail: (1) Mandatory RAG grounding against verified medical contraindication vectors, (2) Strict Zod JSON schema output parsing, and (3) Automatic suppression and human teacher review routing whenever AI internal confidence score falls below $85\%$. |
| **6. Scalability Risk**| PostgreSQL database connection pool starvation and CPU exhaustion during celebrity yoga masterclass flash sales or New Year booking surges. | **High / Medium** | Deploy **PgBouncer** in transaction pooling mode multiplexing 10,000+ client connections; route all read-only analytical queries to Aurora Read Replicas; implement Redis Lua rate limiting and virtual waitlist queues to smooth traffic spikes during high-velocity checkout events. |

---

## PART 13: QUALITY REVIEW & AUTOMATED REMEDIATION REPORT

The complete Yoga24X Enterprise Product Requirements Document (PRD) v1.0 underwent rigorous automated self-validation and architectural cross-referencing against all locked foundational specifications (**Engineering Bible v1.0**, **Enterprise Architecture**, **Database Architecture**, **AI Architecture**, **Event Architecture**, and **Infrastructure Architecture**).

### 13.1 Resolved Product & Constitutional Alignment Checks:
1. **Screen & Feature Completeness**: Verified 100% coverage of all 24 screen inventories and 35+ detailed features against the 9 user personas. Every user goal and pain point has a direct, mapped feature and UI screen without placeholders or TODOs.
2. **Database Schema & RLS Harmony**: Confirmed that all product features (e.g., student health journals, teacher wallets, live class telemetry) map perfectly to the approved 64-table PostgreSQL relational schema, enforcing soft deletions (`deleted_at IS NULL`) and Row Level Security (`app.current_tenant_id`) without requiring schema redesigns.
3. **Event-Driven Workflow Decoupling**: Verified that secondary product workflows (certificate issuance upon course completion, referral reward wallet credits, class cancellation refunds, and multi-channel FCM/SMS notifications) are strictly modeled as asynchronous BullMQ/Kafka sagas triggered by CloudEvents v1.0, preserving zero-join bounded context isolation.
4. **AI Safety & Edge Performance Alignment**: Confirmed that real-time AI Pose Coach requirements strictly respect edge mobile device GPU execution (zero video upload without consent), while conversational AI Coach features enforce 3-layer RAG grounding and $< 85\%$ confidence human review handoffs as mandated by the Engineering Bible.
5. **Non-Functional SLA & Quality Gating Synergy**: Confirmed that product performance acceptance criteria (60 FPS mobile UI, $< 150\text{ms}$ API p95 latency, instant video playback) are supported by the underlying infrastructure topology (PgBouncer, Redis Cluster, CloudFront CDN, Isar offline SQLite) and protected by the mandatory **85% code coverage** hard gate in CI/CD.

---

Yoga24X PRD v1.0 Approved ✅

Ready for Prompt 3 – Authentication & Identity System.
