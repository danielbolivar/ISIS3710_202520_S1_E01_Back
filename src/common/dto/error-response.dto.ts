import { ApiProperty } from '@nestjs/swagger';

export class ErrorResponseDto {
  @ApiProperty()
  error: string;

  @ApiProperty()
  message: string;

  @ApiProperty()
  statusCode: number;

  @ApiProperty({ required: false })
  details?: any;
}
