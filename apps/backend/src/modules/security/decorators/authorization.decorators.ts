// ==============================================================================
// Yoga24X — @RequirePermissions and @RequireRoles Decorators
// ==============================================================================
import { SetMetadata } from '@nestjs/common';
import { PermissionKey } from '../constants/permissions.registry';

export const PERMISSIONS_KEY = 'required_permissions';
export const ROLES_KEY = 'required_roles';
export const PUBLIC_ROUTE_KEY = 'is_public_route';

/** Declare required permissions for a route handler */
export const RequirePermissions = (...permissions: PermissionKey[]) =>
  SetMetadata(PERMISSIONS_KEY, permissions);

/** Declare required roles for a route handler (alternative coarse check) */
export const RequireRoles = (...roles: string[]) =>
  SetMetadata(ROLES_KEY, roles);

/** Mark a route as public (bypasses AuthorizationGuard) */
export const Public = () => SetMetadata(PUBLIC_ROUTE_KEY, true);

/** Extract current authorization context from request */
export const AUTHZ_CONTEXT_KEY = 'authz_context';
