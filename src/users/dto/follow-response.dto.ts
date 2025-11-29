import { ApiProperty } from '@nestjs/swagger';

export class FollowResponseDto {
  @ApiProperty()
  isFollowing: boolean;

  @ApiProperty()
  followersCount: number;
}

export class BlockResponseDto {
  @ApiProperty()
  blocked: boolean;
}
