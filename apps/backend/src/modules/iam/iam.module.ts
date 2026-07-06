// ==============================================================================
// Yoga24X AI Engineering OS — IAM & User Management Module
// ==============================================================================

import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma/prisma.module';
import { RedisModule } from '../redis/redis.module';
import { ConfigModule } from '@nestjs/config';

// Repositories
import { UserProfileRepository } from './repositories/user-profile.repository';
import { OrganizationRepository } from './repositories/organization.repository';
import { VerificationRepository } from './repositories/verification.repository';
import { PrivacyRepository } from './repositories/privacy.repository';
import { DeviceRepository } from './repositories/device.repository';

// Services
import { ProfileService } from './services/profile.service';
import { OrganizationService } from './services/organization.service';
import { VerificationService } from './services/verification.service';
import { PrivacyService } from './services/privacy.service';
import { DeviceManagementService } from './services/device-management.service';
import { AccountLifecycleService } from './services/account-lifecycle.service';

// Guards & Interceptors
import { OrgRoleGuard } from './guards/org-role.guard';
import { PiiMaskingInterceptor } from './interceptors/pii-masking.interceptor';

// Controllers
import { ProfileController } from './controllers/profile.controller';
import { OrganizationController } from './controllers/organization.controller';
import { VerificationController } from './controllers/verification.controller';
import { PrivacyController } from './controllers/privacy.controller';
import { DeviceController } from './controllers/device.controller';
import { AdminUserController } from './controllers/admin-user.controller';

@Module({
  imports: [
    PrismaModule,
    RedisModule,
    ConfigModule,
  ],
  providers: [
    UserProfileRepository,
    OrganizationRepository,
    VerificationRepository,
    PrivacyRepository,
    DeviceRepository,
    ProfileService,
    OrganizationService,
    VerificationService,
    PrivacyService,
    DeviceManagementService,
    AccountLifecycleService,
    OrgRoleGuard,
    PiiMaskingInterceptor,
  ],
  controllers: [
    ProfileController,
    OrganizationController,
    VerificationController,
    PrivacyController,
    DeviceController,
    AdminUserController,
  ],
  exports: [
    ProfileService,
    OrganizationService,
    VerificationService,
    PrivacyService,
    DeviceManagementService,
    AccountLifecycleService,
    UserProfileRepository,
    OrganizationRepository,
    VerificationRepository,
    PrivacyRepository,
    DeviceRepository,
  ],
})
export class IamModule {}
