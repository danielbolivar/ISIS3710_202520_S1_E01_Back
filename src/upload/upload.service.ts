import {
  Injectable,
  BadRequestException,
  NotFoundException,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import * as fs from 'fs';
import * as path from 'path';

@Injectable()
export class UploadService {
  private readonly uploadPath: string;
  private readonly maxFileSize: number;
  private readonly allowedTypes: string[];

  constructor(private configService: ConfigService) {
    this.uploadPath = this.configService.get<string>('UPLOAD_PATH') || './uploads';
    this.maxFileSize = this.configService.get<number>('MAX_FILE_SIZE') || 5242880;
    this.allowedTypes = (this.configService.get<string>('ALLOWED_IMAGE_TYPES') || 'image/jpeg,image/png,image/webp').split(',');

    if (!fs.existsSync(this.uploadPath)) {
      fs.mkdirSync(this.uploadPath, { recursive: true });
    }

    const subdirs = ['posts', 'avatars', 'cloths'];
    subdirs.forEach((dir) => {
      const dirPath = path.join(this.uploadPath, dir);
      if (!fs.existsSync(dirPath)) {
        fs.mkdirSync(dirPath, { recursive: true });
      }
    });
  }

  async uploadImage(file: Express.Multer.File, type: string): Promise<any> {
    if (!file) {
      throw new BadRequestException('No file provided');
    }

    if (!this.allowedTypes.includes(file.mimetype)) {
      throw new BadRequestException(`Invalid file type. Allowed types: ${this.allowedTypes.join(', ')}`);
    }

    if (file.size > this.maxFileSize) {
      throw new BadRequestException(`File too large. Maximum size: ${this.maxFileSize / 1024 / 1024}MB`);
    }

    const typeDir = type === 'avatar' ? 'avatars' : type === 'cloth' ? 'cloths' : 'posts';
    const fileName = `${Date.now()}-${file.originalname}`;
    const filePath = path.join(this.uploadPath, typeDir, fileName);

    fs.writeFileSync(filePath, file.buffer);

    const url = `/uploads/${typeDir}/${fileName}`;

    return {
      url,
      filename: fileName,
      size: file.size,
    };
  }

  async deleteImage(filename: string): Promise<{ deleted: boolean }> {
    const subdirs = ['posts', 'avatars', 'cloths'];

    for (const dir of subdirs) {
      const filePath = path.join(this.uploadPath, dir, filename);

      if (fs.existsSync(filePath)) {
        fs.unlinkSync(filePath);
        return { deleted: true };
      }
    }

    throw new NotFoundException('File not found');
  }
}
