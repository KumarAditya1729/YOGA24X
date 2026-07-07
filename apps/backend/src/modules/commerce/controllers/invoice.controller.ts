import {
  Controller,
  Get,
  Post,
  Body,
  Param,
  UseGuards,
  Request,
} from "@nestjs/common";
import { ApiTags, ApiOperation, ApiBearerAuth } from "@nestjs/swagger";
import { JwtAuthGuard } from "../../auth/guards/jwt-auth.guard";
import { RequirePermissions } from "../../security/decorators/authorization.decorators";
import { PERMISSIONS } from "../../security/constants/permissions.registry";
import { InvoiceService } from "../services/invoice.service";

@ApiTags("Invoices")
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller("invoices")
export class InvoiceController {
  constructor(private readonly invoiceService: InvoiceService) {}

  @Get()
  @RequirePermissions(PERMISSIONS.INVOICE_READ)
  @ApiOperation({ summary: "Get all invoices for current user" })
  getInvoices(@Request() req: any) {
    return this.invoiceService.getInvoicesForUser(req.user.userId);
  }

  @Get(":id")
  @RequirePermissions(PERMISSIONS.INVOICE_READ)
  @ApiOperation({ summary: "Get a specific invoice" })
  getInvoice(@Param("id") id: string) {
    return this.invoiceService.getInvoiceById(id);
  }

  @Post(":id/generate-pdf")
  @RequirePermissions(PERMISSIONS.INVOICE_READ)
  @ApiOperation({ summary: "Generate and download invoice PDF" })
  generatePdf(@Param("id") id: string) {
    return this.invoiceService.generatePdf(id);
  }
}
