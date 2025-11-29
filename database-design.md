# Diseño de Base de Datos MongoDB - StyleBox

```mermaid
erDiagram
    USERS ||--o{ POSTS : creates
    USERS ||--o{ COMMENTS : writes
    USERS ||--o{ COLLECTIONS : owns
    USERS ||--o{ FOLLOWS : follows
    USERS ||--o{ FOLLOWS : followed_by
    USERS ||--o{ POST_LIKES : likes
    USERS ||--o{ COLLECTION_ITEMS : saves
    USERS ||--o{ NOTIFICATIONS : receives
    USERS ||--o{ RATINGS : rates
    USERS ||--o{ SEARCH_HISTORY : searches
    USERS ||--o{ BLOCKED_USERS : blocks
    USERS ||--o{ BLOCKED_USERS : blocked_by

    POSTS ||--o{ COMMENTS : has
    POSTS ||--o{ POST_LIKES : liked_by
    POSTS ||--o{ COLLECTION_ITEMS : saved_in
    POSTS ||--o{ NOTIFICATIONS : triggers
    POSTS ||--o{ RATINGS : rated_by
    POSTS ||--o{ SEARCH_HISTORY : targeted

    COLLECTIONS ||--o{ COLLECTION_ITEMS : groups

    COMMENTS }o--|| POSTS : belongs_to
    COMMENTS }o--|| USERS : written_by

    NOTIFICATIONS }o--|| USERS : recipient
    NOTIFICATIONS }o--|| USERS : sender
    NOTIFICATIONS }o--o{ POSTS : references
    NOTIFICATIONS }o--o{ COMMENTS : references
    NOTIFICATIONS }o--o{ RATINGS : references

    USERS {
        ObjectId _id PK
        string username UK
        string email UK
        string passwordHash
        string avatar
        string firstName
        string lastName
        string style
        string bio
        string location
        string language
        number followersCount
        number followingCount
        number postsCount
        boolean isPrivate
        boolean isVerified
        date lastLoginAt
        date createdAt
        date updatedAt
    }

    POSTS {
        ObjectId _id PK
        ObjectId userId FK
        string imageUrl
        string description
        array tags "string[]"
        string occasion
        string style
        string location
        array clothItems "embedded {id,name,shop,imageUrl,category,price}"
        number ratingAvg
        number ratingCount
        number likesCount
        number commentsCount
        number savedCount
        number viewsCount
        string status "published|draft"
        boolean isPublic
        date createdAt
        date updatedAt
    }

    COMMENTS {
        ObjectId _id PK
        ObjectId postId FK
        ObjectId userId FK
        string text
        ObjectId parentCommentId FK
        date createdAt
        date updatedAt
    }

    RATINGS {
        ObjectId _id PK
        ObjectId postId FK
        ObjectId userId FK
        number score "1-5"
        date createdAt
    }

    FOLLOWS {
        ObjectId _id PK
        ObjectId followerId FK
        ObjectId followeeId FK
        date createdAt
    }

    POST_LIKES {
        ObjectId _id PK
        ObjectId postId FK
        ObjectId userId FK
        date createdAt
    }

    COLLECTIONS {
        ObjectId _id PK
        ObjectId userId FK
        string title
        string description
        string coverImageUrl
        date createdAt
        date updatedAt
    }

    COLLECTION_ITEMS {
        ObjectId _id PK
        ObjectId collectionId FK
        ObjectId postId FK
        date savedAt
    }

    NOTIFICATIONS {
        ObjectId _id PK
        ObjectId recipientId FK
        ObjectId senderId FK
        string type "new_post|follow|like|comment|rating"
        string message
        ObjectId postId FK
        ObjectId commentId FK
        ObjectId ratingId FK
        boolean isRead
        date createdAt
    }

    SEARCH_HISTORY {
        ObjectId _id PK
        ObjectId userId FK
        string query
        array filters "{occasion,style,tags}"
        date createdAt
    }

    BLOCKED_USERS {
        ObjectId _id PK
        ObjectId blockerId FK
        ObjectId blockedId FK
        date createdAt
    }
```

---

## Resumen de las colecciones

| Collection | Propósito | Índices Principales |
|-----------|-----------|---------------------|
| **users** | Perfil y preferencias | username (unique), email (unique) |
| **follows** | Relaciones follow | followerId+followeeId (unique), followeeId |
| **posts** | Publicaciones de outfits | userId+createdAt, tags, occasion, style, text-search |
| **ratings** | Valoraciones de posts | postId+userId (unique), postId |
| **post_likes** | Likes a posts | postId+userId (unique), postId |
| **comments** | Comentarios en posts | postId+createdAt, userId, parentCommentId |
| **collections** | Listas guardadas del usuario | userId, createdAt |
| **collection_items** | Posts dentro de colecciones | collectionId+postId (unique), collectionId |
| **notifications** | Alertas al usuario | recipientId+isRead+createdAt |
| **search_history** | Historial de búsquedas | userId+createdAt, query |
| **blocked_users** | Usuarios bloqueados | blockerId+blockedId (unique), blockerId, blockedId |

## Cardinalidades

- **User → Posts**: 1:N
- **User → Comments**: 1:N
- **User → Collections**: 1:N
- **User → Ratings**: 1:N
- **User → Search History**: 1:N
- **User ↔ User (follows)**: N:M vía FOLLOWS
- **User ↔ User (blocks)**: N:M vía BLOCKED_USERS
- **Post → Comments**: 1:N
- **Post → Ratings**: 1:N
- **Post ↔ User (likes)**: N:M vía POST_LIKES
- **Post ↔ Collections**: N:M vía COLLECTION_ITEMS
- **User ← Notifications**: 1:N (recibe)

## Optimizaciones

**Desnormalización**: likesCount, commentsCount, savedCount, ratingAvg, ratingCount, followersCount, followingCount, postsCount, viewsCount | **Embebidos**: clothItems dentro de posts | **Índices compuestos**: recipientId+isRead+createdAt, followerId+followeeId, blockerId+blockedId, postId+userId (likes/ratings), collectionId+postId
