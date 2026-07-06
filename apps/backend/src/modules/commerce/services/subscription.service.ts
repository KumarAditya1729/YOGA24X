import { Injectable } from '@nestjs/common';
import { SubscriptionRepository } from '../repositories/subscription.repository';
import { CreateSubscriptionDto, CancelSubscriptionDto } from '../dto/commerce.dto';

@Injectable()
export class SubscriptionService {
  constructor(private readonly subscriptionRepo: SubscriptionRepository) {}

  getPlans() { return this.subscriptionRepo.getPlans(); }
  createSubscription(userId: string, dto: CreateSubscriptionDto) { return this.subscriptionRepo.createSubscription(userId, dto); }
  getUserSubscription(userId: string) { return this.subscriptionRepo.getUserSubscription(userId); }
  cancelSubscription(userId: string, subscriptionId: string, dto: CancelSubscriptionDto) { return this.subscriptionRepo.cancelSubscription(userId, subscriptionId, dto); }
  renewSubscription(subscriptionId: string) { return this.subscriptionRepo.renewSubscription(subscriptionId); }
}
