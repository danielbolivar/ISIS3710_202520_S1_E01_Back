#!/bin/bash

# Script de prueba para StyleBox Backend API
# Colores para output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

API_URL="http://localhost:3000/api"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}StyleBox Backend API - Test Suite${NC}"
echo -e "${BLUE}========================================${NC}\n"

# 1. Register
echo -e "${GREEN}[1/7] Testing Registration...${NC}"
REGISTER_RESPONSE=$(curl -s -X POST $API_URL/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "fashionista",
    "email": "fashionista@stylebox.com",
    "password": "Fashion123!",
    "firstName": "Anna",
    "lastName": "Style"
  }')

if echo "$REGISTER_RESPONSE" | grep -q "token"; then
    echo "✅ Registration successful"
    TOKEN=$(echo $REGISTER_RESPONSE | grep -o '"token":"[^"]*"' | cut -d'"' -f4)
    USER_ID=$(echo $REGISTER_RESPONSE | grep -o '"id":"[^"]*"' | cut -d'"' -f4)
    echo "   User ID: $USER_ID"
else
    echo "❌ Registration failed"
    echo "$REGISTER_RESPONSE"
fi

echo ""

# 2. Login
echo -e "${GREEN}[2/7] Testing Login...${NC}"
LOGIN_RESPONSE=$(curl -s -X POST $API_URL/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "fashionista@stylebox.com",
    "password": "Fashion123!"
  }')

if echo "$LOGIN_RESPONSE" | grep -q "token"; then
    echo "✅ Login successful"
    TOKEN=$(echo $LOGIN_RESPONSE | grep -o '"token":"[^"]*"' | cut -d'"' -f4)
else
    echo "❌ Login failed"
fi

echo ""

# 3. Get Profile
echo -e "${GREEN}[3/7] Testing Get Profile...${NC}"
PROFILE_RESPONSE=$(curl -s -X GET $API_URL/auth/me \
  -H "Authorization: Bearer $TOKEN")

if echo "$PROFILE_RESPONSE" | grep -q "fashionista"; then
    echo "✅ Get profile successful"
    echo "   Username: $(echo $PROFILE_RESPONSE | grep -o '"username":"[^"]*"' | cut -d'"' -f4)"
else
    echo "❌ Get profile failed"
fi

echo ""

# 4. Create Post
echo -e "${GREEN}[4/7] Testing Create Post...${NC}"
POST_RESPONSE=$(curl -s -X POST $API_URL/posts \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "description": "My first stylish outfit! 🔥",
    "imageUrl": "https://example.com/outfit1.jpg",
    "occasion": "casual",
    "style": "Street",
    "clothItems": [
      {
        "id": "item1",
        "name": "Black Leather Jacket",
        "shop": "Zara",
        "category": "Jackets",
        "price": 89.99
      },
      {
        "id": "item2",
        "name": "White Sneakers",
        "shop": "Nike",
        "category": "Shoes",
        "price": 120.00
      }
    ]
  }')

if echo "$POST_RESPONSE" | grep -q "description"; then
    echo "✅ Create post successful"
    POST_ID=$(echo $POST_RESPONSE | grep -o '"_id":"[^"]*"' | head -1 | cut -d'"' -f4)
    echo "   Post ID: $POST_ID"
else
    echo "❌ Create post failed"
    echo "$POST_RESPONSE"
fi

echo ""

# 5. Get Feed
echo -e "${GREEN}[5/7] Testing Get Feed...${NC}"
FEED_RESPONSE=$(curl -s -X GET "$API_URL/posts?page=1&limit=10" \
  -H "Authorization: Bearer $TOKEN")

if echo "$FEED_RESPONSE" | grep -q "items"; then
    echo "✅ Get feed successful"
    POST_COUNT=$(echo $FEED_RESPONSE | grep -o '"total":[0-9]*' | cut -d':' -f2)
    echo "   Total posts: $POST_COUNT"
else
    echo "❌ Get feed failed"
fi

echo ""

# 6. Like Post
echo -e "${GREEN}[6/7] Testing Like Post...${NC}"
if [ ! -z "$POST_ID" ]; then
    LIKE_RESPONSE=$(curl -s -X POST "$API_URL/posts/$POST_ID/like" \
      -H "Authorization: Bearer $TOKEN")

    if echo "$LIKE_RESPONSE" | grep -q "liked"; then
        echo "✅ Like post successful"
    else
        echo "❌ Like post failed"
    fi
else
    echo "⚠️  Skipped (no post ID)"
fi

echo ""

# 7. Add Comment
echo -e "${GREEN}[7/7] Testing Add Comment...${NC}"
if [ ! -z "$POST_ID" ]; then
    COMMENT_RESPONSE=$(curl -s -X POST "$API_URL/posts/$POST_ID/comments" \
      -H "Authorization: Bearer $TOKEN" \
      -H "Content-Type: application/json" \
      -d '{
        "content": "Love this outfit! Where did you get those sneakers? 👟"
      }')

    if echo "$COMMENT_RESPONSE" | grep -q "content"; then
        echo "✅ Add comment successful"
        COMMENT_ID=$(echo $COMMENT_RESPONSE | grep -o '"_id":"[^"]*"' | head -1 | cut -d'"' -f4)
        echo "   Comment ID: $COMMENT_ID"
    else
        echo "❌ Add comment failed"
    fi
else
    echo "⚠️  Skipped (no post ID)"
fi

echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Test Suite Completed!${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo "📚 View full API documentation at:"
echo "   http://localhost:3000/api/docs"
echo ""
