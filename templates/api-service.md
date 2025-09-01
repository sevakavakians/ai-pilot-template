# CLAUDE.md - API Service Template

This file provides guidance to Claude Code when working with this API service.

## Project Overview

[PROJECT_NAME] - A RESTful/GraphQL API service providing [PURPOSE].

## Common Development Commands

### Building and Running
```bash
# Install dependencies
npm install  # or: pip install -r requirements.txt

# Start development server
npm run dev  # or: python app.py

# Build for production
npm run build  # or: docker build -t api .

# Run production server
npm start  # or: gunicorn app:app

# Run with Docker
docker-compose up
```

### Testing
```bash
# Run all tests
npm test  # or: pytest

# Run unit tests
npm run test:unit  # or: pytest tests/unit

# Run integration tests
npm run test:integration  # or: pytest tests/integration

# Run API tests
npm run test:api  # or: pytest tests/api

# Generate coverage report
npm run coverage  # or: pytest --cov
```

### Code Quality
```bash
# Run linter
npm run lint  # or: flake8 .

# Format code
npm run format  # or: black .

# Type checking
npm run typecheck  # or: mypy .

# Security audit
npm audit  # or: safety check
```

## Architecture Overview

### API Architecture
```
Client → Load Balancer → API Gateway → Service
                              ↓            ↓
                        Rate Limiter   Business Logic
                              ↓            ↓
                        Auth Service   Database
```

### Core Components

1. **API Routes** (`routes/` or `controllers/`)
   - Endpoint definitions
   - Request validation
   - Response formatting
   - Error handling

2. **Business Logic** (`services/` or `domain/`)
   - Core business rules
   - Data processing
   - External service integration

3. **Data Layer** (`models/` or `repositories/`)
   - Database models
   - Query builders
   - Data access objects

4. **Middleware** (`middleware/`)
   - Authentication
   - Rate limiting
   - Logging
   - CORS handling

### API Endpoints

```
GET    /api/v1/resources      - List resources
POST   /api/v1/resources      - Create resource
GET    /api/v1/resources/:id  - Get resource
PUT    /api/v1/resources/:id  - Update resource
DELETE /api/v1/resources/:id  - Delete resource
```

### Technology Stack
- **Language**: Node.js/Python/Go/Java
- **Framework**: Express/FastAPI/Gin/Spring Boot
- **Database**: PostgreSQL/MongoDB/MySQL
- **Cache**: Redis/Memcached
- **Queue**: RabbitMQ/Kafka/SQS
- **Documentation**: Swagger/OpenAPI

## Development Workflow

1. Create feature branch from `develop`
2. Define API spec in OpenAPI format
3. Implement endpoint with tests
4. Document API changes
5. Run test suite
6. Update API documentation
7. Create pull request with API changes highlighted

## Configuration

### Environment Variables
```bash
# Required
NODE_ENV=development|production
PORT=3000
DATABASE_URL=postgresql://...
JWT_SECRET=your-secret-key

# Optional
REDIS_URL=redis://localhost:6379
LOG_LEVEL=debug|info|warn|error
RATE_LIMIT=100
API_VERSION=v1
```

### Configuration Files
- `openapi.yaml`: API specification
- `docker-compose.yml`: Container orchestration
- `.env.example`: Environment template
- `postman_collection.json`: API test collection

## Important Files and Locations

- Entry point: `app.js` or `main.py`
- Routes: `routes/` or `api/`
- Controllers: `controllers/`
- Models: `models/`
- Middleware: `middleware/`
- Tests: `tests/` or `__tests__/`
- Docs: `docs/` or `swagger/`

## API Documentation

- Swagger UI: http://localhost:3000/api-docs
- Postman Collection: `docs/postman_collection.json`
- API Blueprint: `docs/api.apib`

[Include standard agent protocols from main CLAUDE.md template]