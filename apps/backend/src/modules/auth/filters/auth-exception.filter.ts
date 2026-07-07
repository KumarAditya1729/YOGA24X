// ==============================================================================
// Yoga24X AI Engineering OS — Auth Exception Filter (RFC 7807 Problem Details)
// ==============================================================================

import {
  ExceptionFilter,
  Catch,
  ArgumentsHost,
  HttpException,
  HttpStatus,
} from "@nestjs/common";
import { Request, Response } from "express";

@Catch()
export class AuthExceptionFilter implements ExceptionFilter {
  catch(exception: unknown, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse<Response>();
    const request = ctx.getRequest<Request>();

    const status =
      exception instanceof HttpException
        ? exception.getStatus()
        : HttpStatus.INTERNAL_SERVER_ERROR;

    const exceptionResponse: any =
      exception instanceof HttpException ? exception.getResponse() : null;

    const rawMessage =
      typeof exceptionResponse === "object" && exceptionResponse?.message
        ? Array.isArray(exceptionResponse.message)
          ? exceptionResponse.message.join(", ")
          : exceptionResponse.message
        : exception instanceof Error
          ? exception.message
          : "Internal server error during authentication";

    const message =
      status === HttpStatus.INTERNAL_SERVER_ERROR
        ? "An unexpected internal server error occurred during authentication."
        : rawMessage;

    const errorCode =
      typeof exceptionResponse === "object" && exceptionResponse?.error
        ? exceptionResponse.error
        : HttpStatus[status] || "AUTH_ERROR";

    // RFC 7807 Problem Details for HTTP APIs
    const problemDetails = {
      type: `https://api.yoga24x.com/errors/${errorCode.toString().toLowerCase().replace(/\s+/g, "-")}`,
      title: errorCode,
      status,
      detail: message,
      instance: request.url,
      timestamp: new Date().toISOString(),
      path: request.url,
    };

    if (status === HttpStatus.INTERNAL_SERVER_ERROR) {
      console.error(
        `💥 [UNHANDLED AUTH ERROR] ${request.method} ${request.url}:`,
        exception,
      );
    }

    response.status(status).json(problemDetails);
  }
}
