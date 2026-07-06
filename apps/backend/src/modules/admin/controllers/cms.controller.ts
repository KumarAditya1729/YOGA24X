import { Controller, Get, Post, Patch, Delete, Body, Param, Query, UseGuards } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth, ApiQuery } from '@nestjs/swagger';
import { AuthorizationGuard } from '../../security/guards/authorization.guard';
import { RequirePermissions } from '../../security/decorators/authorization.decorators';
import { PERMISSIONS } from '../../security/constants/permissions.registry';
import { CmsService } from '../services/cms.service';
import { CmsType } from '@prisma/client';

@ApiTags('Admin - CMS')
@ApiBearerAuth()
@Controller('admin/cms')
@UseGuards(AuthorizationGuard)
export class CmsController {
  constructor(private readonly cmsService: CmsService) {}

  @Get()
  @ApiOperation({ summary: 'List all CMS articles' })
  @ApiQuery({ name: 'type', required: false, enum: CmsType })
  @RequirePermissions(PERMISSIONS.CMS_MANAGE)
  async listArticles(@Query('type') type?: CmsType) {
    return this.cmsService.listArticles(type);
  }

  @Post()
  @ApiOperation({ summary: 'Create a CMS article' })
  @RequirePermissions(PERMISSIONS.CMS_MANAGE)
  async createArticle(@Body() body: {
    authorId: string;
    title: string;
    slug: string;
    content: string;
    type: CmsType;
  }) {
    return this.cmsService.createArticle(
      body.authorId, body.title, body.slug, body.content, body.type
    );
  }

  @Patch(':id/publish')
  @ApiOperation({ summary: 'Publish a CMS article' })
  @RequirePermissions(PERMISSIONS.CMS_MANAGE)
  async publishArticle(@Param('id') id: string) {
    return this.cmsService.publishArticle(id);
  }
}
