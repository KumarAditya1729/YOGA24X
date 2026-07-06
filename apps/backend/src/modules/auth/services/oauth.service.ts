// ==============================================================================
// Yoga24X AI Engineering OS — OAuth Service (Google OIDC + Apple Sign-In JWKS)
// ==============================================================================

import { Injectable, UnauthorizedException } from "@nestjs/common";
import { OAuth2Client } from "google-auth-library";
import * as jwt from "jsonwebtoken";
import jwksClient from "jwks-rsa";
import { AuthRepository } from "../repositories/auth.repository";
import { UserRoleName } from "@yoga24x/shared-types";

@Injectable()
export class OAuthService {
  private googleClient: OAuth2Client;
  private appleJwksClient: jwksClient.JwksClient;

  constructor(private readonly authRepository: AuthRepository) {
    this.googleClient = new OAuth2Client(
      process.env.GOOGLE_CLIENT_ID ||
        "sample-google-client-id.apps.googleusercontent.com",
    );

    this.appleJwksClient = jwksClient({
      jwksUri: "https://appleid.apple.com/auth/keys",
      cache: true,
      rateLimit: true,
      jwksRequestsPerMinute: 10,
    });
  }

  // ============================================================================
  // Google OAuth OIDC Token Verification
  // ============================================================================

  async verifyGoogleIdToken(
    idToken: string,
    defaultRole: UserRoleName = "STUDENT",
  ): Promise<{
    user: any;
    isNewUser: boolean;
  }> {
    try {
      const ticket = await this.googleClient.verifyIdToken({
        idToken,
        audience:
          process.env.GOOGLE_CLIENT_ID ||
          "sample-google-client-id.apps.googleusercontent.com",
      });

      const payload = ticket.getPayload();
      if (!payload || !payload.sub || !payload.email) {
        throw new UnauthorizedException("Invalid Google ID Token payload");
      }

      const {
        sub: googleId,
        email,
        given_name,
        family_name,
        picture,
        email_verified,
      } = payload;

      // 1. Check if user already exists by Google Identity
      let user = await this.authRepository.findUserByIdentity(
        "GOOGLE",
        googleId,
      );
      let isNewUser = false;

      if (!user) {
        // 2. Check if user exists by Email (Account Linking)
        user = await this.authRepository.findUserByEmail(email);

        if (user) {
          // Link Google Identity to existing account
          await this.authRepository.createUser({
            email,
            firstName: given_name || user.firstName,
            lastName: family_name || user.lastName,
            roleName: defaultRole,
            provider: "GOOGLE",
            providerId: googleId,
            profileDataJson: { picture, email_verified },
          });
        } else {
          // 3. Create Brand New User Account
          isNewUser = true;
          user = await this.authRepository.createUser({
            email,
            firstName: given_name || "Yoga",
            lastName: family_name || "Student",
            roleName: defaultRole,
            isEmailVerified: !!email_verified,
            provider: "GOOGLE",
            providerId: googleId,
            profileDataJson: { picture, email_verified },
          });
        }
      }

      return { user, isNewUser };
    } catch (error: any) {
      console.error("❌ Google OAuth Verification Error:", error.message);
      throw new UnauthorizedException(`Google login failed: ${error.message}`);
    }
  }

  // ============================================================================
  // Apple Sign-In JWT Validation & JWKS Cryptographic Key Verification
  // ============================================================================

  async verifyAppleIdentityToken(
    identityToken: string,
    authorizationCode: string,
    firstName?: string,
    lastName?: string,
    defaultRole: UserRoleName = "STUDENT",
  ): Promise<{ user: any; isNewUser: boolean }> {
    try {
      // 1. Decode header to extract Key ID (kid) and Algorithm (alg)
      const decodedHeader: any = jwt.decode(identityToken, { complete: true });
      if (
        !decodedHeader ||
        !decodedHeader.header ||
        !decodedHeader.header.kid
      ) {
        throw new UnauthorizedException("Invalid Apple Identity Token header");
      }

      const kid = decodedHeader.header.kid;

      // 2. Fetch Apple Public Key from JWKS
      const key = await this.getAppleSigningKey(kid);
      const publicKey = key.getPublicKey();

      // 3. Verify JWT signature against Apple's public key
      const payload: any = jwt.verify(identityToken, publicKey, {
        algorithms: ["RS256"],
        issuer: "https://appleid.apple.com",
        audience: process.env.APPLE_CLIENT_ID || "com.yoga24x.app",
      });

      if (!payload || !payload.sub || !payload.email) {
        throw new UnauthorizedException("Invalid Apple token claims");
      }

      const { sub: appleId, email, email_verified } = payload;

      // 4. Check if user already exists by Apple Identity
      let user = await this.authRepository.findUserByIdentity("APPLE", appleId);
      let isNewUser = false;

      if (!user) {
        // Check if user exists by Email
        user = await this.authRepository.findUserByEmail(email);

        if (user) {
          // Link Apple Identity
          await this.authRepository.createUser({
            email,
            firstName: firstName || user.firstName,
            lastName: lastName || user.lastName,
            roleName: defaultRole,
            provider: "APPLE",
            providerId: appleId,
            profileDataJson: { email_verified },
          });
        } else {
          // Create Brand New User
          isNewUser = true;
          user = await this.authRepository.createUser({
            email,
            firstName: firstName || "Apple",
            lastName: lastName || "User",
            roleName: defaultRole,
            isEmailVerified:
              email_verified === "true" || email_verified === true,
            provider: "APPLE",
            providerId: appleId,
            profileDataJson: { email_verified },
          });
        }
      }

      return { user, isNewUser };
    } catch (error: any) {
      console.error("❌ Apple Sign-In Verification Error:", error.message);
      throw new UnauthorizedException(`Apple login failed: ${error.message}`);
    }
  }

  private async getAppleSigningKey(
    kid: string,
  ): Promise<jwksClient.SigningKey> {
    return new Promise((resolve, reject) => {
      this.appleJwksClient.getSigningKey(kid, (err, key) => {
        if (err || !key) {
          return reject(err || new Error("Apple JWKS key not found"));
        }
        resolve(key);
      });
    });
  }
}
