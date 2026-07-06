// ==============================================================================
// Yoga24X AI Engineering OS — Auth Decorators (@Public, @Roles, @CurrentUser)
// ==============================================================================

import {
  SetMetadata,
  createParamDecorator,
  ExecutionContext,
} from "@nestjs/common";
import { UserRoleName } from "@yoga24x/shared-types";

export const IS_PUBLIC_KEY = "isPublic";
export const Public = () => SetMetadata(IS_PUBLIC_KEY, true);

export const ROLES_KEY = "roles";
export const Roles = (...roles: UserRoleName[]) =>
  SetMetadata(ROLES_KEY, roles);

export const CurrentUser = createParamDecorator(
  (data: string | undefined, ctx: ExecutionContext) => {
    const request = ctx.switchToHttp().getRequest();
    const user = request.user;
    return data ? user?.[data] : user;
  },
);
