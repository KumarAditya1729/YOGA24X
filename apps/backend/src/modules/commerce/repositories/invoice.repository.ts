import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.module';

@Injectable()
export class InvoiceRepository {
  constructor(private prisma: PrismaService) {}

  async createInvoice(paymentTransactionId: string, taxPercent = 18) {
    const invoiceNumber = `INV-${Date.now()}-${Math.floor(Math.random() * 10000)}`;

    return this.prisma.invoice.create({
      data: {
        paymentTransactionId,
        invoiceNumber,
      },
    });
  }

  async getInvoicesForUser(userId: string) {
    return this.prisma.invoice.findMany({
      where: {
        transaction: { userId },
      },
      include: {
        transaction: true,
      },
      orderBy: { issuedAt: 'desc' },
    });
  }

  async getInvoiceById(invoiceId: string) {
    return this.prisma.invoice.findUnique({
      where: { id: invoiceId },
      include: { transaction: true },
    });
  }

  async generateInvoicePdf(invoiceId: string): Promise<string> {
    // In production this would use a PDF library (e.g., pdfkit or puppeteer)
    // Here we return a placeholder URL that would be set after PDF generation + S3 upload
    const pdfUrl = `https://cdn.yoga24x.com/invoices/${invoiceId}.pdf`;

    await this.prisma.invoice.update({
      where: { id: invoiceId },
      data: { pdfUrl },
    });

    return pdfUrl;
  }
}
