// ==============================================================================
// Yoga24X — Teacher Portfolio Controller
// REST API: gallery, videos, awards, publications, achievements
// ==============================================================================
import {
  Controller,
  Get,
  Post,
  Put,
  Delete,
  Body,
  Param,
  Query,
  Req,
  HttpCode,
  HttpStatus,
} from "@nestjs/common";
import {
  ApiBearerAuth,
  ApiOperation,
  ApiTags,
  ApiQuery,
} from "@nestjs/swagger";
import { TeacherPortfolioService } from "../services/teacher-portfolio.service";
import { AddPortfolioItemDto } from "../dto/teacher.dto";

@ApiTags("Teachers — Portfolio")
@ApiBearerAuth()
@Controller("api/v1/teachers")
export class TeacherPortfolioController {
  constructor(private readonly portfolioService: TeacherPortfolioService) {}

  @Get("me/portfolio")
  @ApiOperation({ summary: "List own portfolio items" })
  @ApiQuery({
    name: "type",
    required: false,
    description: "Filter by PortfolioItemType",
  })
  listItems(@Req() req: any, @Query("type") type?: string) {
    return this.portfolioService.listItems(req.user.userId, type);
  }

  @Post("me/portfolio")
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({
    summary: "Add a portfolio item (gallery image, video, award, etc.)",
  })
  addItem(@Req() req: any, @Body() dto: AddPortfolioItemDto) {
    return this.portfolioService.addItem(req.user.userId, dto);
  }

  @Put("me/portfolio/:id")
  @ApiOperation({ summary: "Update a portfolio item" })
  updateItem(
    @Req() req: any,
    @Param("id") id: string,
    @Body() dto: Partial<AddPortfolioItemDto>,
  ) {
    return this.portfolioService.updateItem(id, req.user.userId, dto);
  }

  @Delete("me/portfolio/:id")
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: "Remove a portfolio item" })
  removeItem(@Req() req: any, @Param("id") id: string) {
    return this.portfolioService.removeItem(id, req.user.userId);
  }

  @Put("me/portfolio/reorder")
  @ApiOperation({ summary: "Reorder portfolio items" })
  reorder(@Req() req: any, @Body() body: { orderedIds: string[] }) {
    return this.portfolioService.reorder(req.user.userId, body.orderedIds);
  }

  @Put("me/portfolio/:id/toggle-featured")
  @ApiOperation({ summary: "Toggle featured status of a portfolio item" })
  toggleFeatured(@Req() req: any, @Param("id") id: string) {
    return this.portfolioService.toggleFeatured(id, req.user.userId);
  }

  // ── Public view ────────────────────────────────────────────────────────────

  @Get(":userId/portfolio")
  @ApiOperation({ summary: "View a teacher's public portfolio" })
  publicPortfolio(
    @Param("userId") userId: string,
    @Query("type") type?: string,
  ) {
    return this.portfolioService.listItems(userId, type);
  }
}
