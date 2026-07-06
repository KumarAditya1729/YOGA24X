import { Injectable } from "@nestjs/common";
import { InvoiceRepository } from "../repositories/invoice.repository";

@Injectable()
export class InvoiceService {
  constructor(private readonly invoiceRepo: InvoiceRepository) {}

  createInvoice(paymentTransactionId: string) {
    return this.invoiceRepo.createInvoice(paymentTransactionId);
  }
  getInvoicesForUser(userId: string) {
    return this.invoiceRepo.getInvoicesForUser(userId);
  }
  getInvoiceById(id: string) {
    return this.invoiceRepo.getInvoiceById(id);
  }
  generatePdf(invoiceId: string) {
    return this.invoiceRepo.generateInvoicePdf(invoiceId);
  }
}
