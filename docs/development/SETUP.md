# Development Environment Setup

**Purpose**: Guide developers through setting up their local development environment.  
**Audience**: New developers, contributors  
**Update Frequency**: When dependencies or setup process changes

## Prerequisites

### Required Software
| Software | Version | Installation | Verification |
|----------|---------|-------------|--------------|
| Node.js | 18.x LTS | [nodejs.org](https://nodejs.org) | `node --version` |
| npm | 9.x | Comes with Node.js | `npm --version` |
| Git | 2.x | [git-scm.com](https://git-scm.com) | `git --version` |
| Docker | 24.x | [docker.com](https://docker.com) | `docker --version` |
| PostgreSQL | 14.x | [postgresql.org](https://postgresql.org) | `psql --version` |
| Redis | 7.x | [redis.io](https://redis.io) | `redis-cli --version` |

### Recommended Tools
| Tool | Purpose | Installation |
|------|---------|-------------|
| VS Code | IDE | [code.visualstudio.com](https://code.visualstudio.com) |
| Postman | API testing | [postman.com](https://postman.com) |
| TablePlus | Database GUI | [tableplus.com](https://tableplus.com) |
| Docker Desktop | Container management | [docker.com](https://docker.com) |

## Quick Start

### 1. Clone Repository
```bash
# Clone the repository
git clone https://github.com/your-org/your-repo.git
cd your-repo

# Or using SSH
git clone git@github.com:your-org/your-repo.git
cd your-repo
```

### 2. Install Dependencies
```bash
# Install Node.js dependencies
npm install

# Install global tools
npm install -g nodemon jest eslint prettier

# Verify installation
npm list
```

### 3. Environment Configuration
```bash
# Copy environment template
cp .env.example .env

# Edit environment variables
nano .env  # or use your preferred editor
```

#### Required Environment Variables
```bash
# Application
NODE_ENV=development
PORT=3000
BASE_URL=http://localhost:3000

# Database
DATABASE_URL=postgresql://user:password@localhost:5432/dbname
DATABASE_POOL_MIN=2
DATABASE_POOL_MAX=10

# Redis
REDIS_URL=redis://localhost:6379
REDIS_PREFIX=dev:

# Authentication
JWT_SECRET=your-secret-key-change-in-production
JWT_EXPIRY=7d
SESSION_SECRET=your-session-secret

# External Services (use test keys for development)
STRIPE_SECRET_KEY=sk_test_...
STRIPE_PUBLISHABLE_KEY=pk_test_...
SENDGRID_API_KEY=SG...
AWS_ACCESS_KEY_ID=...
AWS_SECRET_ACCESS_KEY=...
AWS_REGION=us-east-1

# Feature Flags
ENABLE_FEATURE_X=true
ENABLE_DEBUG_MODE=true
```

### 4. Database Setup
```bash
# Start PostgreSQL (using Docker)
docker run --name postgres-dev \
  -e POSTGRES_USER=devuser \
  -e POSTGRES_PASSWORD=devpass \
  -e POSTGRES_DB=appdb \
  -p 5432:5432 \
  -d postgres:14

# Or using local PostgreSQL
createdb appdb
psql appdb < schema/init.sql

# Run migrations
npm run migrate:up

# Seed development data
npm run seed:dev
```

### 5. Start Development Servers
```bash
# Start all services with Docker Compose
docker-compose up

# Or start services individually
npm run dev:db     # Start database
npm run dev:redis  # Start Redis
npm run dev:app    # Start application

# Start with hot reload
npm run dev

# Start with debugging
npm run dev:debug
```

## Docker Development

### Docker Compose Setup
```yaml
# docker-compose.yml
version: '3.8'

services:
  app:
    build: .
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=development
    volumes:
      - .:/app
      - /app/node_modules
    depends_on:
      - postgres
      - redis

  postgres:
    image: postgres:14
    environment:
      POSTGRES_USER: devuser
      POSTGRES_PASSWORD: devpass
      POSTGRES_DB: appdb
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data

volumes:
  postgres_data:
  redis_data:
```

### Docker Commands
```bash
# Build containers
docker-compose build

# Start all services
docker-compose up

# Start in background
docker-compose up -d

# View logs
docker-compose logs -f app

# Execute commands in container
docker-compose exec app npm test

# Stop services
docker-compose down

# Stop and remove volumes
docker-compose down -v
```

## IDE Configuration

### VS Code Extensions
```json
{
  "recommendations": [
    "dbaeumer.vscode-eslint",
    "esbenp.prettier-vscode",
    "streetside.code-spell-checker",
    "wayou.vscode-todo-highlight",
    "gruntfuggly.todo-tree",
    "eamodio.gitlens",
    "humao.rest-client",
    "prisma.prisma",
    "ms-azuretools.vscode-docker",
    "github.copilot"
  ]
}
```

### VS Code Settings
```json
{
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true
  },
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "[javascript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[typescript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "files.exclude": {
    "node_modules": true,
    ".git": true,
    "dist": true,
    "coverage": true
  },
  "jest.autoRun": {
    "watch": true,
    "onSave": "test-file"
  }
}
```

### Debugging Configuration
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "type": "node",
      "request": "launch",
      "name": "Debug Application",
      "skipFiles": ["<node_internals>/**"],
      "program": "${workspaceFolder}/src/index.js",
      "envFile": "${workspaceFolder}/.env",
      "console": "integratedTerminal"
    },
    {
      "type": "node",
      "request": "launch",
      "name": "Debug Tests",
      "skipFiles": ["<node_internals>/**"],
      "program": "${workspaceFolder}/node_modules/.bin/jest",
      "args": ["--runInBand", "--watchAll=false"],
      "console": "integratedTerminal"
    }
  ]
}
```

## Database Management

### Migration Commands
```bash
# Create new migration
npm run migrate:create -- --name add_users_table

# Run migrations
npm run migrate:up

# Rollback last migration
npm run migrate:down

# Reset database
npm run db:reset

# View migration status
npm run migrate:status
```

### Database Seeds
```bash
# Run all seeds
npm run seed:all

# Run specific seed
npm run seed:run -- --seed users

# Create new seed file
npm run seed:create -- --name demo-users
```

## Testing Setup

### Running Tests
```bash
# Run all tests
npm test

# Run with coverage
npm run test:coverage

# Run specific test file
npm test -- user.test.js

# Run tests in watch mode
npm run test:watch

# Run integration tests
npm run test:integration

# Run end-to-end tests
npm run test:e2e
```

### Test Database
```bash
# Create test database
createdb appdb_test

# Set up test database
NODE_ENV=test npm run migrate:up

# Seed test data
NODE_ENV=test npm run seed:test
```

## Local Services

### Email Testing (Mailhog)
```bash
# Start Mailhog
docker run -d -p 1025:1025 -p 8025:8025 mailhog/mailhog

# Configure SMTP
SMTP_HOST=localhost
SMTP_PORT=1025

# View emails at http://localhost:8025
```

### S3 Alternative (MinIO)
```bash
# Start MinIO
docker run -d \
  -p 9000:9000 \
  -p 9001:9001 \
  --name minio \
  -e MINIO_ROOT_USER=minioadmin \
  -e MINIO_ROOT_PASSWORD=minioadmin \
  minio/minio server /data --console-address ":9001"

# Access console at http://localhost:9001
```

## Troubleshooting

### Common Issues

#### Port Already in Use
```bash
# Find process using port
lsof -i :3000  # macOS/Linux
netstat -ano | findstr :3000  # Windows

# Kill process
kill -9 <PID>  # macOS/Linux
taskkill /PID <PID> /F  # Windows
```

#### Database Connection Failed
```bash
# Check PostgreSQL is running
pg_isready

# Check connection
psql -h localhost -U devuser -d appdb

# Reset database
npm run db:reset
```

#### Node Module Issues
```bash
# Clear cache and reinstall
rm -rf node_modules package-lock.json
npm cache clean --force
npm install
```

#### Docker Issues
```bash
# Reset Docker environment
docker-compose down -v
docker system prune -af
docker-compose build --no-cache
docker-compose up
```

## Git Workflow

### Branch Setup
```bash
# Create feature branch
git checkout -b feature/your-feature

# Create bugfix branch
git checkout -b bugfix/issue-description

# Sync with main
git checkout main
git pull origin main
git checkout feature/your-feature
git rebase main
```

### Pre-commit Hooks
```bash
# Install Husky
npm install --save-dev husky
npx husky install

# Add pre-commit hook
npx husky add .husky/pre-commit "npm run lint && npm test"
```

## Performance Profiling

### Node.js Profiling
```bash
# Start with profiling
node --inspect src/index.js

# Connect Chrome DevTools
# Navigate to chrome://inspect

# Generate heap snapshot
node --heap-prof src/index.js

# Analyze CPU profile
node --cpu-prof src/index.js
```

### Database Query Analysis
```sql
-- Enable query logging
ALTER SYSTEM SET log_statement = 'all';
ALTER SYSTEM SET log_duration = on;

-- Analyze query performance
EXPLAIN ANALYZE SELECT * FROM users WHERE email = 'test@example.com';
```

## Security Setup

### SSL Certificates (Development)
```bash
# Generate self-signed certificate
openssl req -x509 -newkey rsa:4096 -nodes \
  -keyout key.pem -out cert.pem -days 365 \
  -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost"

# Configure application
SSL_KEY=./key.pem
SSL_CERT=./cert.pem
```

### Environment Security
```bash
# Never commit .env file
echo ".env" >> .gitignore

# Use dotenv-vault for team sharing
npx dotenv-vault local login
npx dotenv-vault local pull
```

## Useful Scripts

### Package.json Scripts
```json
{
  "scripts": {
    "dev": "nodemon src/index.js",
    "dev:debug": "nodemon --inspect src/index.js",
    "build": "webpack --mode production",
    "test": "jest",
    "test:watch": "jest --watch",
    "test:coverage": "jest --coverage",
    "lint": "eslint src/",
    "lint:fix": "eslint src/ --fix",
    "format": "prettier --write \"src/**/*.{js,jsx,json,css,md}\"",
    "db:migrate": "knex migrate:latest",
    "db:rollback": "knex migrate:rollback",
    "db:seed": "knex seed:run",
    "db:reset": "npm run db:rollback && npm run db:migrate && npm run db:seed",
    "clean": "rm -rf dist coverage node_modules",
    "precommit": "lint-staged",
    "prepush": "npm test"
  }
}
```

## Resources

### Documentation
- [Project Wiki](https://github.com/your-org/your-repo/wiki)
- [API Documentation](http://localhost:3000/api-docs)
- [Architecture Docs](../technical/ARCHITECTURE.md)

### Learning Resources
- [Node.js Best Practices](https://github.com/goldbergyoni/nodebestpractices)
- [PostgreSQL Tutorial](https://www.postgresqltutorial.com/)
- [Docker Guide](https://docs.docker.com/get-started/)
- [Git Tutorial](https://www.atlassian.com/git/tutorials)

---
*Last Updated: [Date]*  
*Maintained By: [Team/Person]*