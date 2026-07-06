// ==============================================================================
// Yoga24X AI Engineering OS — Waitlist Service (Prompt 7)
// ==============================================================================

import { Injectable } from "@nestjs/common";
import { WaitlistRepository } from "../repositories/waitlist.repository";
import { JoinWaitlistDto } from "../dto/booking.dto";
import { EventEmitter2 } from "@nestjs/event-emitter";

@Injectable()
export class WaitlistService {
  constructor(
    private readonly waitlistRepo: WaitlistRepository,
    private readonly events: EventEmitter2,
  ) {}

  async join(studentUserId: string, dto: JoinWaitlistDto) {
    const entry = await this.waitlistRepo.joinWaitlist(studentUserId, dto);
    this.events.emit("waitlist.joined", { entryId: entry.id, studentUserId });
    return entry;
  }

  async leave(studentUserId: string, entryId: string) {
    return this.waitlistRepo.leaveWaitlist(studentUserId, entryId);
  }

  async getMyWaitlist(studentUserId: string) {
    return this.waitlistRepo.getWaitlistForStudent(studentUserId);
  }

  async promoteNext(sessionId?: string, eventId?: string) {
    const promoted = await this.waitlistRepo.promoteNext(sessionId, eventId);
    if (promoted) {
      this.events.emit("waitlist.promoted", {
        studentId: promoted.studentUserId,
        sessionId,
        eventId,
      });
    }
    return promoted;
  }

  async expireStale() {
    return this.waitlistRepo.expireStale();
  }
}
