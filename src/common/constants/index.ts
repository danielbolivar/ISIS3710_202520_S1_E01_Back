export const OCCASIONS = [
  'party',
  'work',
  'casual',
  'travel',
  'sport',
  'night',
  'formal',
] as const;

export const STYLES = [
  'Street',
  'Minimalist',
  'Formal',
  'Boho',
  'Vintage',
  'Casual',
] as const;

export const NOTIFICATION_TYPES = [
  'new_post',
  'follow',
  'like',
  'comment',
  'rating',
] as const;

export const POST_STATUS = ['published', 'draft'] as const;

export const LANGUAGES = ['en', 'es'] as const;

export const CLOTH_CATEGORIES = [
  'Tops',
  'Bottoms',
  'Outerwear',
  'Dresses',
  'Shoes',
  'Accessories',
  'Bags',
] as const;

export type Occasion = (typeof OCCASIONS)[number];
export type Style = (typeof STYLES)[number];
export type NotificationType = (typeof NOTIFICATION_TYPES)[number];
export type PostStatus = (typeof POST_STATUS)[number];
export type Language = (typeof LANGUAGES)[number];
export type ClothCategory = (typeof CLOTH_CATEGORIES)[number];
