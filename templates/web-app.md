# CLAUDE.md - Web Application Template

This file provides guidance to Claude Code when working with this web application.

## Project Overview

[PROJECT_NAME] - A modern web application built with [FRAMEWORK].

## Common Development Commands

### Building and Running
```bash
# Install dependencies
npm install

# Start development server
npm run dev

# Build for production
npm run build

# Run production build
npm start

# Run with Docker
docker-compose up
```

### Testing
```bash
# Run all tests
npm test

# Run unit tests
npm run test:unit

# Run integration tests
npm run test:integration

# Run E2E tests
npm run test:e2e

# Generate coverage report
npm run test:coverage

# Run tests in watch mode
npm run test:watch
```

### Code Quality
```bash
# Run ESLint
npm run lint

# Fix linting issues
npm run lint:fix

# Run TypeScript type checking
npm run typecheck

# Format with Prettier
npm run format

# Run all checks
npm run check
```

## Architecture Overview

### Frontend Architecture
```
Browser → React/Vue/Angular → State Management → API Client
            ↓                       ↓                ↓
         Components             Redux/Vuex      REST/GraphQL
```

### Core Components

1. **Frontend** (`src/`)
   - Components: UI building blocks
   - Pages/Views: Route-level components
   - Services: API integration layer
   - State: Global state management
   - Utils: Helper functions

2. **API Layer** (`src/api/` or `api/`)
   - REST endpoints or GraphQL resolvers
   - Authentication middleware
   - Request validation
   - Error handling

3. **Database Layer** (`src/models/` or `models/`)
   - ORM models/schemas
   - Migrations
   - Seeders

### Technology Stack
- **Frontend**: React/Vue/Angular/Svelte
- **State Management**: Redux/MobX/Vuex/Pinia
- **Styling**: CSS Modules/Styled Components/Tailwind
- **Build Tool**: Webpack/Vite/Parcel
- **Backend**: Node.js/Express/Nest.js
- **Database**: PostgreSQL/MongoDB/MySQL
- **Cache**: Redis
- **Testing**: Jest/Mocha/Cypress

## Development Workflow

1. Create feature branch from `main`
2. Make changes to components/pages
3. Update tests for new functionality
4. Run `npm run check` to verify all checks pass
5. Test locally with `npm run dev`
6. Commit with conventional commits (feat/fix/chore)
7. Push and create pull request

## Configuration

### Environment Variables
```bash
# Required
NODE_ENV=development|production
API_URL=http://localhost:3000
DATABASE_URL=postgresql://...

# Optional
PORT=3000
LOG_LEVEL=debug|info|warn|error
REDIS_URL=redis://localhost:6379
```

### Configuration Files
- `package.json`: Dependencies and scripts
- `tsconfig.json`: TypeScript configuration
- `.eslintrc.json`: ESLint rules
- `.prettierrc`: Code formatting rules
- `webpack.config.js` or `vite.config.js`: Build configuration

## Important Files and Locations

- Entry point: `src/index.tsx` or `src/main.ts`
- Router: `src/router/` or `src/routes/`
- Components: `src/components/`
- Pages: `src/pages/` or `src/views/`
- API client: `src/services/` or `src/api/`
- Tests: `src/__tests__/` or `tests/`
- Static assets: `public/` or `static/`

[Include standard agent protocols from main CLAUDE.md template]