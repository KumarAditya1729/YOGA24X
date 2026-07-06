// ==============================================================================
// Yoga24X AI Engineering OS — Enterprise Database Seed Script (seed.ts)
// Seeds Roles, Permissions, Admin/Test Users, Identities, Devices, Organizations,
// Profiles, Verifications, Privacy Consents, Media, and Audit Logs
// ==============================================================================

import { PrismaClient, UserStatus, Gender, DoshaType, CourseLevel } from '@prisma/client';
import * as crypto from 'crypto';

const prisma = new PrismaClient();

// Helper to simulate bcrypt/PBKDF2 SHA-256 password hashing for seed consistency
function hashPassword(password: string): string {
  const salt = crypto.randomBytes(16).toString('hex');
  const hash = crypto.pbkdf2Sync(password, salt, 100000, 64, 'sha512').toString('hex');
  return `${salt}:${hash}`;
}

async function main() {
  console.log('🌱 Starting Yoga24X Enterprise Database Seed (v2.0 Identity & User Management)...');

  // 1. Seed Roles
  const rolesData = [
    { name: 'SUPER_ADMIN', description: 'System owner with unrestricted access across all tenants and modules' },
    { name: 'ADMIN', description: 'System administrator with user management, moderation, and support access' },
    { name: 'STUDENT', description: 'Standard learner accessing AI coaching, live classes, courses, and bookings' },
    { name: 'TEACHER', description: 'Verified instructor teaching live classes, publishing courses, and mentoring' },
    { name: 'DOCTOR', description: 'Ayurvedic & medical practitioner providing consultations and clinical reviews' },
    { name: 'NUTRITIONIST', description: 'Dietary specialist creating personalized Sattvic and Ayurvedic meal plans' },
    { name: 'MEDITATION_COACH', description: 'Mindfulness guide leading guided pranayama and meditation retreats' },
    { name: 'STUDIO_OWNER', description: 'Partner managing physical yoga studios, teacher rosters, and hybrid classes' },
    { name: 'CORPORATE_HR', description: 'Enterprise wellness coordinator monitoring corporate employee engagement KPIs' },
  ];

  const roleMap: Record<string, string> = {};
  for (const r of rolesData) {
    const role = await prisma.role.upsert({
      where: { name: r.name },
      update: { description: r.description },
      create: { name: r.name, description: r.description, isSystemRole: true },
    });
    roleMap[r.name] = role.id;
    console.log(`  ✅ Role seeded: ${r.name}`);
  }

  // 2. Seed Permissions
  const permissionsData = [
    { module: 'auth', action: 'login', description: 'Perform standard authentication' },
    { module: 'auth', action: 'refresh', description: 'Refresh JWT access tokens' },
    { module: 'auth', action: 'logout', description: 'Terminate active user session' },
    { module: 'iam', action: 'manage_users', description: 'Create, edit, suspend, or delete user accounts' },
    { module: 'iam', action: 'view_sessions', description: 'View active sessions across all users' },
    { module: 'iam', action: 'revoke_sessions', description: 'Force logout users and terminate sessions' },
    { module: 'iam', action: 'unlock_accounts', description: 'Unlock rate-limited or brute-force locked accounts' },
    { module: 'iam', action: 'manage_devices', description: 'View and revoke trusted biometric devices' },
    { module: 'iam', action: 'manage_organizations', description: 'Create and manage studios and corporate accounts' },
    { module: 'iam', action: 'verify_identities', description: 'Review and approve verification documents' },
    { module: 'lms', action: 'create_course', description: 'Publish and manage video learning courses' },
    { module: 'booking', action: 'book_slot', description: 'Book live yoga classes and doctor consultations' },
    { module: 'ai_coach', action: 'start_session', description: 'Initiate 30fps edge AI pose evaluation session' },
  ];

  for (const p of permissionsData) {
    const perm = await prisma.permission.upsert({
      where: { uq_permissions_module_action: { module: p.module, action: p.action } },
      update: { description: p.description },
      create: { module: p.module, action: p.action, description: p.description },
    });

    // Assign all permissions to SUPER_ADMIN and ADMIN
    await prisma.rolePermission.upsert({
      where: { roleId_permissionId: { roleId: roleMap['SUPER_ADMIN'], permissionId: perm.id } },
      update: {},
      create: { roleId: roleMap['SUPER_ADMIN'], permissionId: perm.id },
    });
    await prisma.rolePermission.upsert({
      where: { roleId_permissionId: { roleId: roleMap['ADMIN'], permissionId: perm.id } },
      update: {},
      create: { roleId: roleMap['ADMIN'], permissionId: perm.id },
    });
  }
  console.log('  ✅ Permissions and Role-Permission mappings seeded.');

  // 3. Seed Core Users across all 9 Profile Types
  const usersToSeed = [
    {
      email: 'aditya@yoga24x.com',
      phone: '+919876543210',
      firstName: 'Aditya',
      lastName: 'SuperAdmin',
      role: 'SUPER_ADMIN',
      password: 'SuperSecretAditya2026!',
      status: UserStatus.ACTIVE,
      isEmailVerified: true,
      isPhoneVerified: true,
      twoFactorEnabled: true,
      profileCompletion: 100,
    },
    {
      email: 'siddharth@yoga24x.com',
      phone: '+919876543211',
      firstName: 'Siddharth',
      lastName: 'Admin',
      role: 'ADMIN',
      password: 'AdminSecret2026!',
      status: UserStatus.ACTIVE,
      isEmailVerified: true,
      isPhoneVerified: true,
      twoFactorEnabled: true,
      profileCompletion: 100,
    },
    {
      email: 'master.rajesh@yoga24x.com',
      phone: '+919876543212',
      firstName: 'Rajesh',
      lastName: 'Yogi',
      role: 'TEACHER',
      password: 'TeacherRajesh2026!',
      status: UserStatus.ACTIVE,
      isEmailVerified: true,
      isPhoneVerified: true,
      twoFactorEnabled: false,
      profileCompletion: 95,
    },
    {
      email: 'aria.sharma@yoga24x.com',
      phone: '+919876543213',
      firstName: 'Aria',
      lastName: 'Sharma',
      role: 'STUDENT',
      password: 'StudentAria2026!',
      status: UserStatus.ACTIVE,
      isEmailVerified: true,
      isPhoneVerified: true,
      twoFactorEnabled: false,
      profileCompletion: 90,
    },
    {
      email: 'dr.ananya@yoga24x.com',
      phone: '+919876543214',
      firstName: 'Ananya',
      lastName: 'Vaidya',
      role: 'DOCTOR',
      password: 'DoctorAnanya2026!',
      status: UserStatus.ACTIVE,
      isEmailVerified: true,
      isPhoneVerified: true,
      twoFactorEnabled: true,
      profileCompletion: 100,
    },
    {
      email: 'meera.nutri@yoga24x.com',
      phone: '+919876543215',
      firstName: 'Meera',
      lastName: 'Kapoor',
      role: 'NUTRITIONIST',
      password: 'NutriMeera2026!',
      status: UserStatus.ACTIVE,
      isEmailVerified: true,
      isPhoneVerified: true,
      twoFactorEnabled: false,
      profileCompletion: 90,
    },
    {
      email: 'vikram.studio@yoga24x.com',
      phone: '+919876543216',
      firstName: 'Vikram',
      lastName: 'Singhania',
      role: 'STUDIO_OWNER',
      password: 'StudioVikram2026!',
      status: UserStatus.ACTIVE,
      isEmailVerified: true,
      isPhoneVerified: true,
      twoFactorEnabled: true,
      profileCompletion: 95,
    },
    {
      email: 'neha.hr@techcorp.com',
      phone: '+919876543217',
      firstName: 'Neha',
      lastName: 'Verma',
      role: 'CORPORATE_HR',
      password: 'CorporateNeha2026!',
      status: UserStatus.ACTIVE,
      isEmailVerified: true,
      isPhoneVerified: true,
      twoFactorEnabled: true,
      profileCompletion: 90,
    },
  ];

  const createdUsers: Record<string, string> = {};

  for (const u of usersToSeed) {
    const user = await prisma.user.upsert({
      where: { email: u.email },
      update: {
        status: u.status,
        isEmailVerified: u.isEmailVerified,
        isPhoneVerified: u.isPhoneVerified,
        profileCompletionPercentage: u.profileCompletion,
      },
      create: {
        email: u.email,
        phoneNumber: u.phone,
        firstName: u.firstName,
        lastName: u.lastName,
        passwordHash: hashPassword(u.password),
        status: u.status,
        isEmailVerified: u.isEmailVerified,
        isPhoneVerified: u.isPhoneVerified,
        twoFactorEnabled: u.twoFactorEnabled || false,
        profileCompletionPercentage: u.profileCompletion,
      },
    });

    createdUsers[u.role] = user.id;

    // Assign Role
    await prisma.userRole.upsert({
      where: { userId_roleId: { userId: user.id, roleId: roleMap[u.role] } },
      update: {},
      create: { userId: user.id, roleId: roleMap[u.role] },
    });

    // Create Email & Phone Identities
    await prisma.userIdentity.upsert({
      where: { uq_identities_provider_id: { provider: 'EMAIL', providerId: u.email } },
      update: {},
      create: { userId: user.id, provider: 'EMAIL', providerId: u.email },
    });
    await prisma.userIdentity.upsert({
      where: { uq_identities_provider_id: { provider: 'PHONE', providerId: u.phone } },
      update: {},
      create: { userId: user.id, provider: 'PHONE', providerId: u.phone },
    });

    // Create User Settings & Notification Preferences
    await prisma.userSettings.upsert({
      where: { userId: user.id },
      update: {},
      create: {
        userId: user.id,
        theme: 'DARK',
        language: 'en',
        timezone: 'Asia/Kolkata',
        currency: 'INR',
        measurementUnit: 'METRIC',
      },
    });

    await prisma.userNotificationPreference.upsert({
      where: { userId: user.id },
      update: {},
      create: {
        userId: user.id,
        pushEnabled: true,
        emailEnabled: true,
        smsEnabled: true,
        marketingPref: false,
      },
    });

    // Create Privacy Consents
    const consentTypes = ['TERMS_OF_SERVICE', 'PRIVACY_POLICY', 'COOKIE_PREFERENCES', 'AI_COACHING', 'HEALTH_DATA_PROCESSING'];
    for (const cType of consentTypes) {
      await prisma.userConsent.create({
        data: {
          userId: user.id,
          consentType: cType,
          isAccepted: true,
          ipAddress: '103.21.244.0',
          userAgent: 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_0)',
        },
      });
    }

    // Role-specific profile creation
    if (u.role === 'SUPER_ADMIN') {
      await prisma.superAdminProfile.upsert({
        where: { userId: user.id },
        update: {},
        create: { userId: user.id, securityClearanceLevel: 'LEVEL_5', canManageTenant: true },
      });
    } else if (u.role === 'ADMIN') {
      await prisma.adminProfile.upsert({
        where: { userId: user.id },
        update: {},
        create: { userId: user.id, adminLevel: 'SENIOR_ADMIN', department: 'IAM_OPERATIONS', assignedRegions: ['APAC', 'EMEA'] },
      });
    } else if (u.role === 'STUDENT') {
      await prisma.studentProfile.upsert({
        where: { userId: user.id },
        update: {},
        create: {
          userId: user.id,
          gender: Gender.FEMALE,
          heightCm: 165.0,
          weightKg: 58.5,
          experienceLevel: CourseLevel.INTERMEDIATE,
          ayurvedicDosha: DoshaType.VATA_PITTA,
          medicalConditions: ['Mild Lower Back Stiffness'],
        },
      });
      await prisma.wallet.upsert({
        where: { userId: user.id },
        update: {},
        create: { userId: user.id, balanceCents: 500000, currency: 'INR' },
      });
    } else if (u.role === 'TEACHER') {
      await prisma.instructorProfile.upsert({
        where: { userId: user.id },
        update: {},
        create: {
          userId: user.id,
          bio: 'Master of Ashtanga and Hatha Yoga with over 15 years of traditional training in Rishikesh.',
          yearsExperience: 15,
          specializations: ['Ashtanga', 'Hatha', 'Pranayama', 'Kriyas'],
          hourlyRateCents: 250000,
          isVerified: true,
          averageRating: 4.95,
          totalReviews: 320,
        },
      });
    } else if (u.role === 'DOCTOR') {
      await prisma.doctorProfile.upsert({
        where: { userId: user.id },
        update: {},
        create: {
          userId: user.id,
          medicalRegistrationNumber: 'AYUR_REG_IN_98765',
          qualification: 'BAMS, MD (Ayurveda), Banaras Hindu University',
          consultationFeeCents: 150000, // 1,500 INR
          averageRating: 4.98,
          isVerified: true,
        },
      });
    } else if (u.role === 'NUTRITIONIST') {
      await prisma.nutritionistProfile.upsert({
        where: { userId: user.id },
        update: {},
        create: {
          userId: user.id,
          bio: 'Clinical Dietitian and Ayurvedic Nutrition Specialist focusing on gut health and Sattvic living.',
          yearsExperience: 8,
          specializations: ['Sattvic Diet', 'Weight Management', 'Dosha Balancing'],
          certificationNumber: 'NUTRI_CERT_2026_001',
          consultationFeeCents: 120000, // 1,200 INR
          isVerified: true,
        },
      });
    } else if (u.role === 'STUDIO_OWNER') {
      await prisma.studioProfile.upsert({
        where: { userId: user.id },
        update: {},
        create: {
          userId: user.id,
          studioName: 'Sattvic Soul Sanctuary',
          businessRegistrationNumber: 'REG_STUDIO_MUM_8877',
          address: '14B, Linking Road, Bandra West',
          city: 'Mumbai',
          country: 'India',
          amenities: ['Heated Floor', 'Sound Healing Studio', 'Organic Tea Bar', 'Valet Parking'],
          contactPhone: '+919876543216',
          websiteUrl: 'https://sattvicsoul.yoga',
          isVerified: true,
        },
      });
    } else if (u.role === 'CORPORATE_HR') {
      await prisma.corporateProfile.upsert({
        where: { userId: user.id },
        update: {},
        create: {
          userId: user.id,
          companyName: 'TechCorp Global Systems Pvt Ltd',
          taxIdentificationNumber: 'GSTIN_27AAACT1234A1Z5',
          industry: 'Information Technology',
          employeeCount: 1500,
          hrContactName: 'Neha Verma',
          hrContactEmail: 'neha.hr@techcorp.com',
          isVerified: true,
        },
      });
    }

    console.log(`  ✅ User & Profile seeded: ${u.firstName} ${u.lastName} (${u.role})`);
  }

  // 4. Seed Organizations & Structures (Part 4)
  const studioOwnerId = createdUsers['STUDIO_OWNER'];
  const teacherId = createdUsers['TEACHER'];
  if (studioOwnerId) {
    const studioOrg = await prisma.organization.create({
      data: {
        name: 'Sattvic Soul Sanctuary Studio Network',
        type: 'STUDIO',
        ownerId: studioOwnerId,
        city: 'Mumbai',
        country: 'India',
        status: 'ACTIVE',
      },
    });

    const team = await prisma.organizationTeam.create({
      data: {
        organizationId: studioOrg.id,
        name: 'Senior Ashtanga Faculty',
        description: 'Lead instructors for morning Mysore classes',
        leadUserId: teacherId,
      },
    });

    if (teacherId) {
      await prisma.organizationMember.create({
        data: {
          organizationId: studioOrg.id,
          userId: teacherId,
          role: 'ADMIN',
          teamId: team.id,
          status: 'ACTIVE',
        },
      });
    }
    console.log('  ✅ Studio Organization and Team seeded.');
  }

  // 5. Seed Verification Workflow Sample (Part 10)
  if (teacherId) {
    const verifReq = await prisma.verificationRequest.create({
      data: {
        userId: teacherId,
        verificationType: 'TEACHER_CERT',
        status: 'APPROVED',
        submittedDataJson: { institute: 'Yoga Alliance RYT-500', year: 2018 },
        reviewedBy: createdUsers['ADMIN'],
        reviewedAt: new Date(),
      },
    });

    await prisma.verificationDocument.create({
      data: {
        requestId: verifReq.id,
        documentType: 'CERTIFICATE',
        fileUrl: 'https://cdn.yoga24x.com/verifications/rajesh_ryt500.pdf',
        fileSizeBytes: 1048576,
        mimeType: 'application/pdf',
      },
    });
    console.log('  ✅ Teacher Verification Workflow seeded.');
  }

  // 6. Seed Feature Flags
  await prisma.featureFlag.upsert({
    where: { key: 'ai_pose_coach_v2_edge' },
    update: { isEnabled: true },
    create: { key: 'ai_pose_coach_v2_edge', description: '30fps Edge AI Pose Evaluation', isEnabled: true, rolloutPercentage: 100 },
  });
  await prisma.featureFlag.upsert({
    where: { key: 'biometric_passkey_login' },
    update: { isEnabled: true },
    create: { key: 'biometric_passkey_login', description: 'WebAuthn / Passkey Biometric Login', isEnabled: true, rolloutPercentage: 100 },
  });
  // 7. Seed Enterprise Wellness Identity & Health Profiles (Prompt 4.5)
  const studentId = createdUsers['STUDENT'];
  const doctorId = createdUsers['DOCTOR'];
  if (studentId) {
    await prisma.healthProfile.upsert({
      where: { userId: studentId },
      update: {},
      create: {
        userId: studentId,
        bloodGroup: 'O+',
        emergencyContactName: 'Rohan Sharma',
        emergencyContactPhone: '+919876543299',
        emergencyContactRelation: 'Brother',
        pregnancyStatus: 'NONE',
        medicalHistoryJson: [{ condition: 'Mild Lower Back Stiffness', diagnosedYear: 2024, status: 'MANAGED' }],
        currentConditionsJson: [],
        pastConditionsJson: [],
        surgeriesJson: [],
        medicationsJson: [],
        allergiesJson: [{ allergen: 'Peanuts', type: 'FOOD', severity: 'MILD' }],
        physicalLimitationsJson: [{ bodyPart: 'Lower Back', issue: 'Stiffness', severity: 'MEDIUM', restrictedMovements: ['Deep Backward Bends'] }],
        lifestyleJson: { isSmoker: false, alcoholConsumption: 'NONE', workNature: 'SEDENTARY', averageScreenTimeHours: 8 },
        isVerifiedByDoctor: true,
        verifiedByDoctorId: doctorId,
        verificationNotes: 'Reviewed lumbar stiffness. Recommended gentle forward folds and avoiding forced backbends.',
      },
    });

    await prisma.wellnessAssessment.create({
      data: {
        userId: studentId,
        stressLevel: 4,
        sleepQuality: 8,
        energyLevel: 8,
        hydrationScore: 9,
        flexibilityScore: 7,
        strengthScore: 6,
        mobilityScore: 8,
        bodyFatPercentage: 22.5,
        bmi: 21.5,
        restingHeartRate: 64,
        breathingPattern: 'DIAPHRAGMATIC',
        dailyActivityLevel: 'MODERATELY_ACTIVE',
      },
    });

    await prisma.yogaAssessment.upsert({
      where: { userId: studentId },
      update: {},
      create: {
        userId: studentId,
        experienceLevel: 'INTERMEDIATE',
        yogaGoalsJson: ['FLEXIBILITY', 'CORE_STRENGTH', 'STRESS_RELIEF'],
        preferredYogaStyle: 'HATHA',
        preferredSessionLengthMin: 45,
        preferredInstructorGender: 'ANY',
        practiceFrequencyPerWeek: 4,
        favoriteTeachersJson: ['Rajesh Yogi'],
        favoriteCoursesJson: ['Ashtanga Fundamentals', 'Chakra Balancing'],
        favoriteMusicJson: ['FLUTE', 'AMBIENT_NATURE'],
        preferredPracticeTime: 'MORNING',
      },
    });

    await prisma.nutritionProfile.upsert({
      where: { userId: studentId },
      update: {},
      create: {
        userId: studentId,
        dietType: 'VEGETARIAN',
        dailyCaloriesGoal: 2100,
        dailyProteinGoalGrams: 65,
        dailyWaterGoalMl: 3000,
        foodAllergiesJson: ['Peanuts'],
        foodPreferencesJson: ['Sattvic', 'Organic', 'Ayurvedic Warm Meals'],
        mealTimingJson: { breakfast: '08:30', lunch: '13:00', dinner: '19:30' },
        supplementsJson: ['Ashwagandha', 'Vitamin D3', 'B12'],
      },
    });

    await prisma.meditationProfile.upsert({
      where: { userId: studentId },
      update: {},
      create: {
        userId: studentId,
        meditationExperience: 'INTERMEDIATE',
        preferredDurationMin: 20,
        preferredVoice: 'WARM_FEMALE_EN_IN',
        preferredMusic: 'AMBIENT',
        focusArea: 'MINDFULNESS',
        mindfulnessGoalsJson: ['ANXIETY_RELIEF', 'DEEP_SLEEP', 'SPIRITUAL_GROWTH'],
      },
    });

    await prisma.aiPersonalizationProfile.upsert({
      where: { userId: studentId },
      update: {},
      create: {
        userId: studentId,
        coachingStyle: 'ENCOURAGING',
        motivationStyle: 'POSITIVE_REINFORCEMENT',
        reminderStyle: 'REGULAR',
        communicationTone: 'WARM_AND_EMPATHETIC',
        preferredLanguage: 'en',
        difficultyProgression: 'ADAPTIVE',
        learningStyle: 'VISUAL',
        voicePreference: 'WARM_FEMALE_EN_IN',
        notificationBehaviour: 'SMART_ADAPTIVE',
        recommendationPreferencesJson: { poseCorrectionSensitivity: 'HIGH', pacingPreference: 'MODERATE' },
      },
    });

    await prisma.userGoal.create({
      data: {
        userId: studentId,
        goalType: 'FLEXIBILITY',
        title: '30-Day Hamstring & Lumbar Flexibility Mastery',
        description: 'Achieve comfortable full forward fold (Uttanasana) without lumbar strain.',
        targetValue: 100,
        currentValue: 65,
        unit: 'PERCENTAGE',
        status: 'ACTIVE',
        targetDate: new Date(Date.now() + 30 * 24 * 3600 * 1000),
        milestonesJson: [
          { title: 'Hold Ardha Uttanasana for 60 seconds with straight spine', isCompleted: true },
          { title: 'Touch fingertips to floor without bending knees', isCompleted: false },
          { title: 'Full Uttanasana palms on floor', isCompleted: false },
        ],
        achievementsJson: ['FIRST_STEP_FLEXIBILITY'],
      },
    });

    await prisma.medicalSafetyFlag.create({
      data: {
        userId: studentId,
        flagType: 'RESTRICTED_POSE',
        severity: 'MEDIUM',
        title: 'Lumbar Stiffness Restriction',
        description: 'Avoid forced backbends or sudden spinal hyperextension due to lumbar stiffness.',
        restrictedPosesJson: ['CHAKRASANA', 'POORNA BHUJANGASANA', 'HALASANA'],
        recommendedBy: 'Dr. Ananya Vaidya (Ayurvedic Doctor)',
        isActive: true,
      },
    });

    console.log('  ✅ Enterprise Wellness Profiles, Assessments, Goals & Safety Flags seeded.');
  }

  console.log('🎉 Yoga24X Enterprise Database Seed Completed Successfully!');
}

main()
  .catch((e) => {
    console.error('❌ Error during seeding:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
