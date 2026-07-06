import { Injectable } from "@nestjs/common";
import { PublishingRepository } from "../repositories/publishing.repository";

@Injectable()
export class PublishingService {
  constructor(private readonly repository: PublishingRepository) {}
}
