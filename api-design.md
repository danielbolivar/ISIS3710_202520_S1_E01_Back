# API REST - StyleBox Backend

## 📋 Endpoints Necesarios para el Frontend

---

## 🔐 1. **Auth Service**

### Base URL: `/api/auth`

| Método | Endpoint | Descripción | Request | Response |
|--------|----------|-------------|---------|----------|
| POST | `/register` | Registrar usuario | `{username, email, password, firstName, lastName}` | `{user, token, refreshToken}` |
| POST | `/login` | Iniciar sesión | `{email, password}` | `{user, token, refreshToken}` |
| POST | `/refresh` | Renovar token | `{refreshToken}` | `{token, refreshToken}` |
| GET | `/me` | Usuario actual | - | `{user}` |
| PATCH | `/me` | Actualizar perfil | `{username?, bio?, style?, avatar?, language?, location?}` | `{user}` |

**Detectado en:** `SettingsScreen.tsx`, `LanguageContext.tsx`

**Nota:** Si no usas refresh tokens, elimina `/refresh` y usa tokens de larga duración

---

## 👤 2. **Users Service**

### Base URL: `/api/users`

| Método | Endpoint | Descripción | Request | Response |
|--------|----------|-------------|---------|----------|
| GET | `/` | Buscar usuarios | `?search=username&style=` | `{users[]}` |
| GET | `/:userId` | Perfil de usuario | - | `{user, postsCount, followersCount, followingCount}` |
| GET | `/:userId/posts` | Posts del usuario | `?page=1&limit=20&status=published` | `{posts[], total}` |
| GET | `/:userId/followers` | Seguidores | `?page=1&limit=50` | `{users[], total}` |
| GET | `/:userId/following` | Siguiendo | `?page=1&limit=50` | `{users[], total}` |
| POST | `/:userId/follow` | Seguir usuario | - | `{isFollowing: true, followersCount}` |
| DELETE | `/:userId/follow` | Dejar de seguir | - | `{isFollowing: false, followersCount}` |
| POST | `/:userId/block` | Bloquear usuario | - | `{blocked: true}` |
| DELETE | `/:userId/block` | Desbloquear | - | `{blocked: false}` |

**Detectado en:** `user/[id]/page.tsx`, `profile/page.tsx`, `followers/page.tsx`, `FollowersScreen.tsx`, `UserProfileScreen.tsx` (bloquear), `Header.tsx` (búsqueda)

---

## 📸 3. **Posts Service**

### Base URL: `/api/posts`

| Método | Endpoint | Descripción | Request | Response |
|--------|----------|-------------|---------|----------|
| GET | `/` | Feed/Discover | `?page=1&limit=20&filter=following&userId=&sort=recent\|popular&section=&occasion=&style=&tags=&status=published` | `{posts[], page, total}` |
| GET | `/:postId` | Detalle de post | - | `{post, isSaved, isLiked, userRating}` |
| POST | `/` | Crear post | `{imageUrl, description, tags[], occasion, style, clothItems[], status}` | `{post}` |
| PATCH | `/:postId` | Editar post | `{description?, tags[]?, occasion?, style?, status?}` | `{post}` |
| DELETE | `/:postId` | Eliminar post | - | `{deleted: true}` |
| POST | `/:postId/like` | Dar like | - | `{liked: true, likesCount}` |
| DELETE | `/:postId/like` | Quitar like | - | `{liked: false, likesCount}` |
| GET | `/search` | Buscar posts | `?q=&occasion=&style=&tags=` | `{posts[], total}` |

**Detectado en:** `page.tsx` (feed), `discover/[section]/page.tsx`, `post/[id]/page.tsx`, `UploadScreen.tsx`, `SocialActions.tsx`, `Header.tsx`

**Nota:** `/discover` unificado en `GET /posts` usando query params `section`, `occasion`, `style`, `tags` para simplificar rutas

---

## 💬 4. **Comments Service**

### Base URL: `/api/posts/:postId/comments`

| Método | Endpoint | Descripción | Request | Response |
|--------|----------|-------------|---------|----------|
| GET | `/` | Comentarios del post | `?page=1&limit=50` | `{comments[], total}` |
| POST | `/` | Crear comentario | `{text, parentCommentId?}` | `{comment}` |
| DELETE | `/:commentId` | Eliminar comentario | - | `{deleted: true}` |

**Detectado en:** `PostDetailScreen.tsx`, `CommentItem.tsx`

**Validación:** Solo 1 nivel de anidación (parentCommentId válido solo si es comentario raíz)

---

## ⭐ 5. **Ratings Service**

### Base URL: `/api/posts/:postId/ratings`

| Método | Endpoint | Descripción | Request | Response |
|--------|----------|-------------|---------|----------|
| PUT | `/` | Set/actualizar valoración | `{score}` | `{rating, ratingAvg, ratingCount}` |
| GET | `/me` | Mi valoración actual | - | `{rating, score}` |
| DELETE | `/` | Eliminar mi valoración | - | `{deleted: true, ratingAvg, ratingCount}` |

**Detectado en:** `PostDetailScreen.tsx` (renderStars), `FeedItem.rating`, `types.ts`

---

## 💾 6. **Collections Service**

### Base URL: `/api/collections`

| Método | Endpoint | Descripción | Request | Response |
|--------|----------|-------------|---------|----------|
| GET | `/` | Mis colecciones | - | `{collections[]}` (con `itemsCount`, `isPublic`) |
| GET | `/:collectionId` | Detalle colección | - | `{collection, items[], itemsCount}` |
| POST | `/` | Crear colección | `{title, description, coverImageUrl?, isPublic?}` | `{collection}` |
| PATCH | `/:collectionId` | Editar colección | `{title?, description?, coverImageUrl?, isPublic?}` | `{collection}` |
| DELETE | `/:collectionId` | Eliminar colección | - | `{deleted: true}` |
| POST | `/:collectionId/items` | Guardar post | `{postId}` | `{saved: true, itemsCount}` |
| DELETE | `/:collectionId/items/:postId` | Quitar post | - | `{removed: true, itemsCount}` |

**Detectado en:** `saved/page.tsx`, `SavedScreen.tsx`, `CreateListModal.tsx`, `CollectionSection.tsx`, `SelectCollectionModal.tsx`, `SocialActions.tsx`

---

## 🔔 7. **Notifications Service**

### Base URL: `/api/notifications`

| Método | Endpoint | Descripción | Request | Response |
|--------|----------|-------------|---------|----------|
| GET | `/` | Mis notificaciones | `?unread=true&page=1&limit=50` | `{notifications[], unreadCount}` |
| PATCH | `/:notificationId/read` | Marcar leída | - | `{read: true}` |
| PATCH | `/read-all` | Marcar todas leídas | - | `{updated: count}` |
| DELETE | `/:notificationId` | Eliminar | - | `{deleted: true}` |

**Detectado en:** `notifications/page.tsx`, `NotificationsScreen.tsx`, `AppStateContext.tsx`, `Header.tsx` (badge contador)

---

## 🔍 8. **Search Service**

### Base URL: `/api/search`

| Método | Endpoint | Descripción | Request | Response |
|--------|----------|-------------|---------|----------|
| GET | `/posts` | Buscar posts | `?q=&occasion=&style=&tags=` | `{posts[], total}` |
| GET | `/users` | Buscar usuarios | `?q=&style=` | `{users[]}` |
| GET | `/suggestions` | Autocompletado | `?q=partial` | `{suggestions[]}` |

**Detectado en:** `Header.tsx` (búsqueda), `SavedScreen.tsx` (filteredCollections), `FollowersScreen.tsx` (búsqueda usuarios)

**Nota:** Historial de búsqueda (`SEARCH_HISTORY` en BD) no implementado en frontend actual

---

## 📤 9. **Upload Service**

### Base URL: `/api/upload`

| Método | Endpoint | Descripción | Request | Response |
|--------|----------|-------------|---------|----------|
| POST | `/image` | Subir imagen | `FormData {file}` + `?type=post\|avatar\|cloth` | `{url, filename, size}` |
| DELETE | `/image/:filename` | Eliminar imagen | - | `{deleted: true}` |

**Límites:** Max 5MB, MIME: `image/jpeg`, `image/png`, `image/webp`

**Detectado en:** `UploadScreen.tsx` (outfit), `SettingsScreen.tsx` (avatar), `EditClothScreen.tsx` (cloth items)

**Alternativa con URLs firmadas:**
```
POST /api/upload/sign-url?type=post&filename=outfit.jpg
Response: {uploadUrl, publicUrl, expiresIn}
```

---

## 📊 **Resumen**

| Servicio | Endpoints | Prioridad | Usado en Frontend |
|----------|-----------|-----------|-------------------|
| **Auth** | 5 | 🔴 Crítico | ✅ Register, Login, Refresh, Profile |
| **Users** | 9 | 🔴 Crítico | ✅ Profile, Followers, Follow/Block |
| **Posts** | 8 | 🔴 Crítico | ✅ Feed, Discover, Create, Like |
| **Comments** | 3 | 🟡 Importante | ✅ PostDetail, CommentItem |
| **Ratings** | 3 | 🟡 Importante | ✅ PostDetail (stars), FeedItem |
| **Collections** | 7 | 🟡 Importante | ✅ Saved, Create/Manage lists |
| **Notifications** | 4 | 🟡 Importante | ✅ Notifications, Badge counter |
| **Search** | 3 | 🟢 Nice-to-have | ✅ Header, Autocompletado |
| **Upload** | 2 | 🔴 Crítico | ✅ Upload images, Avatars |

**Total: 44 endpoints** optimizados y consolidados

---

## 🔑 **Autenticación**

### JWT en Header
```
Authorization: Bearer <token>
```

### Endpoints Públicos vs Protegidos

**Públicos** (sin auth):
- `POST /api/auth/register`
- `POST /api/auth/login`
- `GET /api/posts` - Feed público
- `GET /api/posts/discover`
- `GET /api/posts/:postId` - Ver post público
- `GET /api/users/:userId` - Ver perfil público
- `GET /api/users/:userId/posts`

**Protegidos** (requieren auth):
- `GET /api/auth/me`
- `PUT /api/auth/me`
- Todo lo relacionado con: POST, PUT, DELETE
- Follow/Unfollow, Block
- Like posts
- Comentarios
- Ratings
- Collections
- Notifications
- Upload

---

## 📡 **Queries Principales**

### Feed Personalizado (Following)
```
GET /api/posts?filter=following&page=1&limit=20&sort=recent
```

### Discover por Sección (unificado con /posts)
```
GET /api/posts?section=tendencias&sort=trending
GET /api/posts?occasion=fiesta&style=Casual&tags=ootd
```

### Posts Populares (Trending)
```
GET /api/posts?sort=popular&limit=20
```

### Posts de Usuario
```
GET /api/users/:userId/posts?page=1&limit=20&status=published
```

### Buscar Posts
```
GET /api/search/posts?q=summer&occasion=viaje&tags=beach,ootd
```

### Buscar Usuarios
```
GET /api/search/users?q=fashionista&style=Street
```

---

## 📝 **Formato de Respuestas**

### Paginación
```json
{
  "data": [...],
  "page": 1,
  "limit": 20,
  "total": 245,
  "totalPages": 13,
  "hasNext": true,
  "hasPrev": false
}
```

### Errores
```json
{
  "error": "POST_NOT_FOUND",
  "message": "Post not found",
  "statusCode": 404,
  "details": {}
}
```

### Success con Contadores
```json
{
  "success": true,
  "liked": true,
  "likesCount": 127,
  "isLiked": true
}
```

---

## 🔗 **Relaciones entre Endpoints**

### Crear Post → Notificaciones
```
1. POST /api/posts → Crea post
2. Backend automático → Crea notificaciones a seguidores
3. GET /api/notifications → Seguidores ven "new_post"
```

### Like Post → Notificación
```
1. POST /api/posts/:postId/like → Da like
2. Backend automático → Crea notificación al dueño
3. GET /api/notifications → Dueño ve "like"
```

### Follow → Notificación
```
1. POST /api/users/:userId/follow → Sigue usuario
2. Backend automático → Crea notificación
3. GET /api/notifications → Usuario ve "follow"
```

---

## ⚡ **Optimizaciones Importantes**

### Campos Desnormalizados (actualizar en cascada)
- `likesCount` en POSTS → Actualizar en cada like/unlike
- `commentsCount` en POSTS → Actualizar en cada comment
- `savedCount` en POSTS → Actualizar al guardar/quitar
- `followersCount`, `followingCount` en USERS → Actualizar en follow/unfollow
- `postsCount` en USERS → Actualizar en create/delete post
- `ratingAvg`, `ratingCount` en POSTS → Recalcular en cada rating

### Índices Críticos MongoDB
```javascript
// Posts más usados
db.posts.createIndex({ userId: 1, createdAt: -1 })
db.posts.createIndex({ status: 1, createdAt: -1 })
db.posts.createIndex({ likesCount: -1 }) // Sort popular
db.posts.createIndex({ occasion: 1, style: 1 })
db.posts.createIndex({ tags: 1 })
db.posts.createIndex({
  description: "text",
  tags: "text"
}) // Full-text search

// Follows
db.follows.createIndex({ followerId: 1, followeeId: 1 }, { unique: true })

// Likes
db.post_likes.createIndex({ postId: 1, userId: 1 }, { unique: true })

// Notifications
db.notifications.createIndex({ recipientId: 1, isRead: 1, createdAt: -1 })
```

---

## 🎯 **Implementación Recomendada**

### Fase 1 - Core (Semana 1-2)
1. ✅ Setup proyecto (Node.js + Express + MongoDB)
2. ✅ Auth Service completo (JWT)
3. ✅ Users Service (perfil, follow)
4. ✅ Posts Service (CRUD, feed, like)

### Fase 2 - Social (Semana 3)
5. ✅ Comments Service
6. ✅ Ratings Service
7. ✅ Notifications Service (automáticas)

### Fase 3 - Features (Semana 4)
8. ✅ Collections Service
9. ✅ Search Service
10. ✅ Upload Service (imágenes)
