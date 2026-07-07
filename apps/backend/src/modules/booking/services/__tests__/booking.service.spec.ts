import { Test, TestingModule } from '@nestjs/testing';
import { BookingService } from '../booking.service';
import { BookingRepository } from '../../repositories/booking.repository';
import { WaitlistRepository } from '../../repositories/waitlist.repository';
import { EventEmitter2 } from '@nestjs/event-emitter';

describe('BookingService', () => {
  let service: BookingService;
  let bookingRepo: jest.Mocked<BookingRepository>;
  let waitlistRepo: jest.Mocked<WaitlistRepository>;
  let eventEmitter: jest.Mocked<EventEmitter2>;

  beforeEach(async () => {
    const mockBookingRepo = {
      createBooking: jest.fn(),
      findForStudent: jest.fn(),
      findForTeacher: jest.fn(),
      findById: jest.fn(),
      rescheduleBooking: jest.fn(),
      cancelBooking: jest.fn(),
    };

    const mockWaitlistRepo = {
      promoteNext: jest.fn(),
    };

    const mockEventEmitter = {
      emit: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        BookingService,
        { provide: BookingRepository, useValue: mockBookingRepo },
        { provide: WaitlistRepository, useValue: mockWaitlistRepo },
        { provide: EventEmitter2, useValue: mockEventEmitter },
      ],
    }).compile();

    service = module.get<BookingService>(BookingService);
    bookingRepo = module.get(BookingRepository);
    waitlistRepo = module.get(WaitlistRepository);
    eventEmitter = module.get(EventEmitter2);
  });

  describe('createBooking', () => {
    it('should create a booking and emit booking.created event', async () => {
      const mockBooking = { id: 'booking-1', sessionId: 'session-1', status: 'CONFIRMED' };
      bookingRepo.createBooking.mockResolvedValue(mockBooking as any);

      const dto = { sessionId: 'session-1' } as any;
      const result = await service.createBooking('user-1', dto, 'tenant-1');

      expect(result).toEqual(mockBooking);
      expect(bookingRepo.createBooking).toHaveBeenCalledWith('user-1', dto, 'tenant-1');
      expect(eventEmitter.emit).toHaveBeenCalledWith('booking.created', {
        bookingId: 'booking-1',
        userId: 'user-1',
        tenantId: 'tenant-1',
      });
    });
  });

  describe('reschedule', () => {
    it('should reschedule booking, emit event, and promote next on waitlist for old session', async () => {
      const mockRescheduled = { id: 'booking-1', sessionId: 'session-2', status: 'CONFIRMED' };
      const mockOldBooking = { id: 'booking-1', sessionId: 'session-1', status: 'CONFIRMED' };

      bookingRepo.rescheduleBooking.mockResolvedValue(mockRescheduled as any);
      bookingRepo.findById.mockResolvedValue(mockOldBooking as any);
      waitlistRepo.promoteNext.mockResolvedValue({} as any);

      const dto = { bookingId: 'booking-1', newSessionId: 'session-2' } as any;
      const result = await service.reschedule('user-1', dto);

      expect(result).toEqual(mockRescheduled);
      expect(eventEmitter.emit).toHaveBeenCalledWith('booking.rescheduled', {
        bookingId: 'booking-1',
        userId: 'user-1',
      });
      expect(waitlistRepo.promoteNext).toHaveBeenCalledWith('session-1');
    });
  });

  describe('cancel', () => {
    it('should cancel booking, emit event, and promote next on waitlist for freed slot', async () => {
      const mockCancelled = { id: 'booking-1', sessionId: 'session-1', status: 'CANCELLED' };
      bookingRepo.cancelBooking.mockResolvedValue(mockCancelled as any);
      waitlistRepo.promoteNext.mockResolvedValue({} as any);

      const dto = { bookingId: 'booking-1', reason: 'Personal reasons' } as any;
      const result = await service.cancel('user-1', dto, 'STUDENT');

      expect(result).toEqual(mockCancelled);
      expect(eventEmitter.emit).toHaveBeenCalledWith('booking.cancelled', {
        bookingId: 'booking-1',
        userId: 'user-1',
        reason: 'Personal reasons',
      });
      expect(waitlistRepo.promoteNext).toHaveBeenCalledWith('session-1');
    });
  });
});
