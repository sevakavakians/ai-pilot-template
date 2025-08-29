# API Reference

**Purpose**: Complete API documentation including endpoints, request/response formats, and authentication.  
**Audience**: Frontend developers, API consumers, integration partners  
**Update Frequency**: On API changes, versioned with releases

## API Overview

**Base URL**: `https://api.example.com`  
**Version**: v1  
**Protocol**: HTTPS only  
**Format**: JSON (application/json)

## Authentication

### Method: [OAuth 2.0 | JWT | API Key]

#### Obtaining Credentials
```bash
POST /auth/token
Content-Type: application/json

{
  "client_id": "your_client_id",
  "client_secret": "your_client_secret",
  "grant_type": "client_credentials"
}
```

#### Using Credentials
```bash
Authorization: Bearer {token}
# or
X-API-Key: {api_key}
```

#### Token Refresh
```bash
POST /auth/refresh
{
  "refresh_token": "your_refresh_token"
}
```

## Rate Limiting

| Tier | Requests/Hour | Burst | Headers |
|------|--------------|--------|---------|
| Free | 1,000 | 50/min | X-RateLimit-* |
| Pro | 10,000 | 500/min | X-RateLimit-* |
| Enterprise | Unlimited | Custom | X-RateLimit-* |

**Rate Limit Headers**:
- `X-RateLimit-Limit`: Maximum requests
- `X-RateLimit-Remaining`: Requests remaining
- `X-RateLimit-Reset`: Reset timestamp

## Common Headers

### Request Headers
| Header | Required | Description | Example |
|--------|----------|-------------|---------|
| Authorization | Yes | Bearer token | Bearer abc123 |
| Content-Type | Yes* | Request format | application/json |
| X-Request-ID | No | Idempotency key | uuid-v4 |
| X-API-Version | No | API version override | 2023-01-01 |

### Response Headers
| Header | Description | Example |
|--------|-------------|---------|
| X-Request-ID | Request tracking ID | uuid-v4 |
| X-Response-Time | Processing time | 123ms |
| X-Deprecation | Deprecation warning | 2024-01-01 |

## Error Handling

### Error Response Format
```json
{
  "error": {
    "code": "RESOURCE_NOT_FOUND",
    "message": "The requested resource was not found",
    "details": {
      "resource": "user",
      "id": "123"
    },
    "request_id": "req_abc123",
    "documentation_url": "https://docs.api.com/errors/RESOURCE_NOT_FOUND"
  }
}
```

### Error Codes
| HTTP Status | Error Code | Description | Resolution |
|-------------|------------|-------------|------------|
| 400 | INVALID_REQUEST | Malformed request | Check request format |
| 401 | UNAUTHORIZED | Missing/invalid auth | Check credentials |
| 403 | FORBIDDEN | Insufficient permissions | Check scopes |
| 404 | NOT_FOUND | Resource not found | Verify resource ID |
| 409 | CONFLICT | Resource conflict | Check for duplicates |
| 429 | RATE_LIMITED | Too many requests | Retry after delay |
| 500 | INTERNAL_ERROR | Server error | Contact support |
| 503 | SERVICE_UNAVAILABLE | Temporary outage | Retry later |

## API Endpoints

### Users

#### List Users
```http
GET /v1/users
```

**Query Parameters**:
| Parameter | Type | Required | Description | Default |
|-----------|------|----------|-------------|---------|
| page | integer | No | Page number | 1 |
| limit | integer | No | Items per page (max 100) | 20 |
| sort | string | No | Sort field | created_at |
| order | string | No | Sort order (asc/desc) | desc |
| filter[status] | string | No | Filter by status | all |

**Response** `200 OK`:
```json
{
  "data": [
    {
      "id": "usr_123",
      "email": "user@example.com",
      "name": "John Doe",
      "status": "active",
      "created_at": "2024-01-01T00:00:00Z",
      "updated_at": "2024-01-01T00:00:00Z"
    }
  ],
  "meta": {
    "page": 1,
    "limit": 20,
    "total": 100,
    "pages": 5
  },
  "links": {
    "self": "/v1/users?page=1",
    "next": "/v1/users?page=2",
    "prev": null,
    "first": "/v1/users?page=1",
    "last": "/v1/users?page=5"
  }
}
```

#### Get User
```http
GET /v1/users/{user_id}
```

**Path Parameters**:
| Parameter | Type | Description |
|-----------|------|-------------|
| user_id | string | User identifier |

**Response** `200 OK`:
```json
{
  "data": {
    "id": "usr_123",
    "email": "user@example.com",
    "name": "John Doe",
    "status": "active",
    "metadata": {
      "key": "value"
    },
    "created_at": "2024-01-01T00:00:00Z",
    "updated_at": "2024-01-01T00:00:00Z"
  }
}
```

#### Create User
```http
POST /v1/users
```

**Request Body**:
```json
{
  "email": "user@example.com",
  "name": "John Doe",
  "password": "SecurePassword123!",
  "metadata": {
    "source": "signup_form"
  }
}
```

**Validation Rules**:
- `email`: Required, valid email format
- `name`: Required, 2-100 characters
- `password`: Required, min 8 chars, 1 uppercase, 1 number, 1 special

**Response** `201 Created`:
```json
{
  "data": {
    "id": "usr_123",
    "email": "user@example.com",
    "name": "John Doe",
    "status": "pending_verification",
    "created_at": "2024-01-01T00:00:00Z"
  }
}
```

#### Update User
```http
PATCH /v1/users/{user_id}
```

**Request Body** (partial update):
```json
{
  "name": "Jane Doe",
  "metadata": {
    "updated_by": "admin"
  }
}
```

**Response** `200 OK`:
```json
{
  "data": {
    "id": "usr_123",
    "email": "user@example.com",
    "name": "Jane Doe",
    "updated_at": "2024-01-01T00:00:00Z"
  }
}
```

#### Delete User
```http
DELETE /v1/users/{user_id}
```

**Response** `204 No Content`

### Resources

#### Search Resources
```http
POST /v1/resources/search
```

**Request Body**:
```json
{
  "query": "search terms",
  "filters": {
    "type": ["document", "image"],
    "created_after": "2024-01-01",
    "tags": ["important"]
  },
  "sort": {
    "field": "relevance",
    "order": "desc"
  },
  "pagination": {
    "page": 1,
    "limit": 20
  }
}
```

**Response** `200 OK`:
```json
{
  "data": [
    {
      "id": "res_123",
      "type": "document",
      "title": "Resource Title",
      "score": 0.95,
      "highlights": {
        "title": ["<em>Resource</em> Title"]
      }
    }
  ],
  "meta": {
    "total": 42,
    "query_time": "23ms"
  }
}
```

### Webhooks

#### Register Webhook
```http
POST /v1/webhooks
```

**Request Body**:
```json
{
  "url": "https://your-app.com/webhook",
  "events": ["user.created", "user.updated"],
  "secret": "webhook_secret_key",
  "active": true
}
```

**Response** `201 Created`:
```json
{
  "data": {
    "id": "whk_123",
    "url": "https://your-app.com/webhook",
    "events": ["user.created", "user.updated"],
    "active": true,
    "created_at": "2024-01-01T00:00:00Z"
  }
}
```

#### Webhook Events
| Event | Trigger | Payload |
|-------|---------|---------|
| user.created | New user registration | User object |
| user.updated | User profile update | User object + changes |
| user.deleted | User account deletion | User ID |
| resource.created | New resource | Resource object |

#### Webhook Payload Format
```json
{
  "id": "evt_123",
  "type": "user.created",
  "created_at": "2024-01-01T00:00:00Z",
  "data": {
    // Event specific data
  },
  "signature": "sha256=abc123..."
}
```

## Batch Operations

### Batch Create
```http
POST /v1/batch
```

**Request Body**:
```json
{
  "operations": [
    {
      "method": "POST",
      "path": "/v1/users",
      "body": { /* user data */ }
    },
    {
      "method": "PATCH",
      "path": "/v1/users/usr_123",
      "body": { /* update data */ }
    }
  ]
}
```

**Response** `207 Multi-Status`:
```json
{
  "results": [
    {
      "status": 201,
      "body": { /* created resource */ }
    },
    {
      "status": 200,
      "body": { /* updated resource */ }
    }
  ]
}
```

## Pagination

### Cursor-based Pagination
```http
GET /v1/items?cursor=eyJpZCI6MTIzfQ&limit=20
```

**Response**:
```json
{
  "data": [ /* items */ ],
  "cursors": {
    "next": "eyJpZCI6MTQzfQ",
    "prev": "eyJpZCI6MTAzfQ"
  },
  "has_more": true
}
```

### Offset Pagination
```http
GET /v1/items?offset=20&limit=20
```

## Filtering & Sorting

### Filter Syntax
```
GET /v1/resources?filter[status]=active&filter[type]=document
GET /v1/resources?filter[created_at][gte]=2024-01-01
GET /v1/resources?filter[tags][in]=important,urgent
```

### Sort Syntax
```
GET /v1/resources?sort=created_at  # Ascending
GET /v1/resources?sort=-created_at # Descending
GET /v1/resources?sort=type,-created_at # Multiple
```

## Versioning

### Version Selection
1. **URL Path**: `/v1/users` (recommended)
2. **Header**: `X-API-Version: 2024-01-01`
3. **Query Parameter**: `/users?version=1`

### Deprecation Policy
- Minimum 6 months notice
- Deprecation header in responses
- Migration guide provided
- Sunset date communicated

## SDKs & Code Examples

### JavaScript/Node.js
```javascript
const client = new APIClient({
  apiKey: 'your_api_key',
  version: 'v1'
});

// Get user
const user = await client.users.get('usr_123');

// Create user
const newUser = await client.users.create({
  email: 'user@example.com',
  name: 'John Doe'
});

// List with filters
const users = await client.users.list({
  filter: { status: 'active' },
  sort: '-created_at',
  limit: 50
});
```

### Python
```python
from api_client import Client

client = Client(api_key='your_api_key')

# Get user
user = client.users.get('usr_123')

# Create user
new_user = client.users.create(
    email='user@example.com',
    name='John Doe'
)

# List with filters
users = client.users.list(
    filter={'status': 'active'},
    sort='-created_at',
    limit=50
)
```

### cURL
```bash
# Get user
curl -X GET https://api.example.com/v1/users/usr_123 \
  -H "Authorization: Bearer your_token"

# Create user
curl -X POST https://api.example.com/v1/users \
  -H "Authorization: Bearer your_token" \
  -H "Content-Type: application/json" \
  -d '{"email":"user@example.com","name":"John Doe"}'
```

## Testing

### Sandbox Environment
**Base URL**: `https://sandbox.api.example.com`  
**Test Credentials**: Available in dashboard  
**Data Reset**: Daily at 00:00 UTC

### Test Credit Cards
| Number | Type | Result |
|--------|------|--------|
| 4242 4242 4242 4242 | Visa | Success |
| 4000 0000 0000 0002 | Visa | Decline |
| 4000 0000 0000 9995 | Visa | Insufficient funds |

## Support

**Documentation**: https://docs.api.example.com  
**Status Page**: https://status.api.example.com  
**Support Email**: api-support@example.com  
**Developer Forum**: https://forum.api.example.com

---
*API Version: v1*  
*Last Updated: [Date]*  
*Next Version: v2 (Q2 2024)*