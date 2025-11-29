import { ApiProperty } from '@nestjs/swagger';

export class UserProfileResponseDto {
  @ApiProperty()
  user: {
    id: string;
    username: string;
    email: string;
    firstName: string;
    lastName: string;
    avatar: string;
    bio: string;
    location: string;
    style: string;
    isVerified: boolean;
    createdAt: Date;
  };

  @ApiProperty()
  postsCount: number;

  @ApiProperty()
  followersCount: number;

  @ApiProperty()
  followingCount: number;

  @ApiProperty()
  isFollowing?: boolean;

  @ApiProperty()
  isBlocked?: boolean;
}
