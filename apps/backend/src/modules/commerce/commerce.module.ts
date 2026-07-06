import { Module } from "@nestjs/common";
import { EventEmitterModule } from "@nestjs/event-emitter";
import { PrismaModule } from "../prisma/prisma.module";

// Repositories
import { PaymentRepository } from "./repositories/payment.repository";
import { WalletRepository } from "./repositories/wallet.repository";
import { MembershipRepository } from "./repositories/membership.repository";
import { SubscriptionRepository } from "./repositories/subscription.repository";
import { PricingRepository } from "./repositories/pricing.repository";
import { RefundRepository } from "./repositories/refund.repository";
import { RevenueRepository } from "./repositories/revenue.repository";
import { InvoiceRepository } from "./repositories/invoice.repository";
import { AnalyticsRepository } from "./repositories/analytics.repository";

// Services
import { PaymentService } from "./services/payment.service";
import { WalletService } from "./services/wallet.service";
import { MembershipService } from "./services/membership.service";
import { SubscriptionService } from "./services/subscription.service";
import { PricingService } from "./services/pricing.service";
import { RefundService } from "./services/refund.service";
import { RevenueService } from "./services/revenue.service";
import { InvoiceService } from "./services/invoice.service";
import { CommerceAnalyticsService } from "./services/commerce-analytics.service";

// Controllers
import { PaymentController } from "./controllers/payment.controller";
import { WalletController } from "./controllers/wallet.controller";
import { MembershipController } from "./controllers/membership.controller";
import { SubscriptionController } from "./controllers/subscription.controller";
import { PricingController } from "./controllers/pricing.controller";
import { RefundController } from "./controllers/refund.controller";
import { InvoiceController } from "./controllers/invoice.controller";
import { RevenueController } from "./controllers/revenue.controller";
import { CommerceAnalyticsController } from "./controllers/commerce-analytics.controller";

// Jobs
import { CommerceEventHandlers } from "./jobs/commerce-event.handlers";

@Module({
  imports: [PrismaModule],
  controllers: [
    PaymentController,
    WalletController,
    MembershipController,
    SubscriptionController,
    PricingController,
    RefundController,
    InvoiceController,
    RevenueController,
    CommerceAnalyticsController,
  ],
  providers: [
    // Repositories
    PaymentRepository,
    WalletRepository,
    MembershipRepository,
    SubscriptionRepository,
    PricingRepository,
    RefundRepository,
    RevenueRepository,
    InvoiceRepository,
    AnalyticsRepository,
    // Services
    PaymentService,
    WalletService,
    MembershipService,
    SubscriptionService,
    PricingService,
    RefundService,
    RevenueService,
    InvoiceService,
    CommerceAnalyticsService,
    // Jobs
    CommerceEventHandlers,
  ],
  exports: [
    PaymentService,
    WalletService,
    MembershipService,
    SubscriptionService,
    PricingService,
    RefundService,
    RevenueService,
    InvoiceService,
    CommerceAnalyticsService,
  ],
})
export class CommerceModule {}
