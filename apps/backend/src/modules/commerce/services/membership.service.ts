import { Injectable } from '@nestjs/common';
import { MembershipRepository } from '../repositories/membership.repository';
import { CreateMembershipPlanDto, PurchaseMembershipDto, FreezeMembershipDto } from '../dto/commerce.dto';

@Injectable()
export class MembershipService {
  constructor(private readonly membershipRepo: MembershipRepository) {}

  createPlan(dto: CreateMembershipPlanDto) { return this.membershipRepo.createPlan(dto); }
  listPlans() { return this.membershipRepo.listPlans(); }
  purchaseMembership(userId: string, dto: PurchaseMembershipDto) { return this.membershipRepo.purchaseMembership(userId, dto); }
  getActiveMembership(userId: string) { return this.membershipRepo.getActiveMembership(userId); }
  freezeMembership(userId: string, membershipId: string, dto: FreezeMembershipDto) { return this.membershipRepo.freezeMembership(userId, membershipId, dto); }
  cancelMembership(userId: string, membershipId: string) { return this.membershipRepo.cancelMembership(userId, membershipId); }
}
