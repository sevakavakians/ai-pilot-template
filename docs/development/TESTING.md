# Testing Strategy & Guidelines

**Purpose**: Define testing approach, standards, and best practices for ensuring code quality.  
**Audience**: Developers, QA engineers, DevOps  
**Update Frequency**: Quarterly or when testing tools/strategies change

## Testing Philosophy

### Testing Principles
1. **Test behavior, not implementation**: Focus on what, not how
2. **Test pyramid**: More unit tests, fewer E2E tests
3. **Fast feedback**: Tests should run quickly
4. **Deterministic**: Same input = same output
5. **Independent**: Tests shouldn't depend on each other
6. **Readable**: Tests are documentation

### Testing Pyramid
```
         /\
        /E2E\        (5%) - Critical user journeys
       /------\
      /  API   \     (15%) - Service integration
     /----------\
    / Integration\   (30%) - Component interaction
   /--------------\
  /   Unit Tests   \ (50%) - Individual functions/methods
 /------------------\
```

## Test Types

### Unit Tests
**Purpose**: Test individual functions/methods in isolation  
**Tools**: Jest, Mocha, Jasmine  
**Coverage Target**: 80%+

```javascript
// Example: user-validator.test.js
describe('UserValidator', () => {
  describe('validateEmail', () => {
    it('should return true for valid email', () => {
      expect(validateEmail('user@example.com')).toBe(true);
    });

    it('should return false for invalid email', () => {
      expect(validateEmail('invalid-email')).toBe(false);
    });

    it('should return false for empty string', () => {
      expect(validateEmail('')).toBe(false);
    });

    it('should handle null input', () => {
      expect(validateEmail(null)).toBe(false);
    });
  });
});
```

### Integration Tests
**Purpose**: Test component interactions and data flow  
**Tools**: Jest, Supertest, Testing Library  
**Coverage Target**: 60%+

```javascript
// Example: user-api.integration.test.js
describe('User API Integration', () => {
  let app;
  let database;

  beforeAll(async () => {
    database = await setupTestDatabase();
    app = await createApp(database);
  });

  afterAll(async () => {
    await database.close();
  });

  describe('POST /api/users', () => {
    it('should create user and send welcome email', async () => {
      const userData = {
        email: 'new@example.com',
        name: 'New User'
      };

      const response = await request(app)
        .post('/api/users')
        .send(userData)
        .expect(201);

      // Verify response
      expect(response.body).toMatchObject({
        success: true,
        data: expect.objectContaining({
          id: expect.any(String),
          email: userData.email
        })
      });

      // Verify database
      const user = await database.users.findByEmail(userData.email);
      expect(user).toBeTruthy();

      // Verify email was queued
      const emailJobs = await getQueuedEmails();
      expect(emailJobs).toContainEqual(
        expect.objectContaining({
          template: 'welcome',
          to: userData.email
        })
      );
    });
  });
});
```

### End-to-End Tests
**Purpose**: Test complete user workflows  
**Tools**: Cypress, Playwright, Selenium  
**Coverage Target**: Critical paths only

```javascript
// Example: checkout.e2e.test.js
describe('Checkout Flow', () => {
  it('should complete purchase from cart to confirmation', () => {
    // Login
    cy.visit('/login');
    cy.get('[data-testid="email"]').type('test@example.com');
    cy.get('[data-testid="password"]').type('password123');
    cy.get('[data-testid="login-button"]').click();

    // Add item to cart
    cy.visit('/products');
    cy.get('[data-testid="product-1"]').click();
    cy.get('[data-testid="add-to-cart"]').click();

    // Checkout
    cy.visit('/cart');
    cy.get('[data-testid="checkout-button"]').click();

    // Payment
    cy.get('[data-testid="card-number"]').type('4242424242424242');
    cy.get('[data-testid="expiry"]').type('12/25');
    cy.get('[data-testid="cvc"]').type('123');
    cy.get('[data-testid="pay-button"]').click();

    // Confirmation
    cy.url().should('include', '/order-confirmation');
    cy.contains('Order successful').should('be.visible');
  });
});
```

## Test Structure

### AAA Pattern
```javascript
describe('Calculator', () => {
  it('should add two numbers correctly', () => {
    // Arrange - Set up test data and conditions
    const calculator = new Calculator();
    const a = 5;
    const b = 3;

    // Act - Execute the function being tested
    const result = calculator.add(a, b);

    // Assert - Verify the outcome
    expect(result).toBe(8);
  });
});
```

### Given-When-Then (BDD)
```javascript
describe('Shopping Cart', () => {
  it('should apply discount when coupon is valid', () => {
    // Given - Initial context
    const cart = new ShoppingCart();
    cart.addItem({ id: 1, price: 100 });
    const coupon = 'SAVE20';

    // When - Action occurs
    cart.applyCoupon(coupon);

    // Then - Expected outcome
    expect(cart.getTotal()).toBe(80);
    expect(cart.getDiscount()).toBe(20);
  });
});
```

## Testing Best Practices

### Test Data Management
```javascript
// Use factories for test data
const userFactory = {
  build: (overrides = {}) => ({
    id: faker.datatype.uuid(),
    email: faker.internet.email(),
    name: faker.name.fullName(),
    createdAt: new Date(),
    ...overrides
  }),

  create: async (overrides = {}) => {
    const user = userFactory.build(overrides);
    return await db.users.create(user);
  }
};

// Usage in tests
it('should update user profile', async () => {
  const user = await userFactory.create({ name: 'John Doe' });
  // Test logic
});
```

### Mocking & Stubbing
```javascript
// Mock external dependencies
jest.mock('../services/email-service');
jest.mock('../clients/payment-client');

describe('OrderService', () => {
  let emailService;
  let paymentClient;

  beforeEach(() => {
    emailService = require('../services/email-service');
    paymentClient = require('../clients/payment-client');
    
    // Setup default mock behaviors
    emailService.send.mockResolvedValue({ success: true });
    paymentClient.charge.mockResolvedValue({ transactionId: 'txn_123' });
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should process order successfully', async () => {
    // Arrange
    const order = { id: 1, total: 100, email: 'user@example.com' };

    // Act
    const result = await orderService.process(order);

    // Assert
    expect(paymentClient.charge).toHaveBeenCalledWith(100);
    expect(emailService.send).toHaveBeenCalledWith(
      expect.objectContaining({
        template: 'order-confirmation',
        to: order.email
      })
    );
    expect(result.status).toBe('completed');
  });
});
```

### Database Testing
```javascript
// Test database setup
class TestDatabase {
  async setup() {
    this.connection = await createConnection({
      type: 'sqlite',
      database: ':memory:',
      synchronize: true,
      entities: [User, Order, Product]
    });
  }

  async seed() {
    // Add test data
    await this.connection.getRepository(User).save([
      { email: 'admin@test.com', role: 'admin' },
      { email: 'user@test.com', role: 'user' }
    ]);
  }

  async cleanup() {
    await this.connection.synchronize(true);
  }

  async teardown() {
    await this.connection.close();
  }
}

// Usage
describe('Database Tests', () => {
  const testDb = new TestDatabase();

  beforeAll(() => testDb.setup());
  beforeEach(() => testDb.seed());
  afterEach(() => testDb.cleanup());
  afterAll(() => testDb.teardown());

  // Tests here
});
```

## Test Coverage

### Coverage Requirements
| Type | Minimum | Target | Notes |
|------|---------|---------|-------|
| Statements | 70% | 80% | Lines of code executed |
| Branches | 60% | 75% | If/else paths covered |
| Functions | 70% | 85% | Functions called |
| Lines | 70% | 80% | Executable lines |

### Coverage Configuration
```javascript
// jest.config.js
module.exports = {
  collectCoverage: true,
  coverageDirectory: 'coverage',
  coverageReporters: ['text', 'lcov', 'html'],
  collectCoverageFrom: [
    'src/**/*.{js,jsx,ts,tsx}',
    '!src/**/*.test.{js,jsx,ts,tsx}',
    '!src/**/index.{js,ts}',
    '!src/**/*.d.ts',
    '!src/generated/**'
  ],
  coverageThreshold: {
    global: {
      branches: 60,
      functions: 70,
      lines: 70,
      statements: 70
    },
    './src/services/': {
      branches: 80,
      functions: 85,
      lines: 85,
      statements: 85
    }
  }
};
```

### Improving Coverage
```bash
# Generate coverage report
npm run test:coverage

# View HTML report
open coverage/index.html

# Find uncovered lines
npm run test:coverage -- --collectCoverageFrom='src/services/**'
```

## Performance Testing

### Load Testing
```javascript
// k6 load test script
import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  stages: [
    { duration: '2m', target: 100 }, // Ramp up
    { duration: '5m', target: 100 }, // Stay at 100 users
    { duration: '2m', target: 200 }, // Ramp up
    { duration: '5m', target: 200 }, // Stay at 200 users
    { duration: '2m', target: 0 },   // Ramp down
  ],
  thresholds: {
    http_req_duration: ['p(95)<500'], // 95% of requests under 500ms
    http_req_failed: ['rate<0.05'],   // Error rate under 5%
  },
};

export default function () {
  const response = http.get('https://api.example.com/users');
  
  check(response, {
    'status is 200': (r) => r.status === 200,
    'response time < 500ms': (r) => r.timings.duration < 500,
    'has results': (r) => JSON.parse(r.body).data.length > 0,
  });
  
  sleep(1);
}
```

### Benchmark Tests
```javascript
// benchmark.test.js
describe('Performance Benchmarks', () => {
  it('should process 1000 items in under 1 second', async () => {
    const items = generateTestItems(1000);
    
    const startTime = performance.now();
    await processor.processItems(items);
    const endTime = performance.now();
    
    const duration = endTime - startTime;
    expect(duration).toBeLessThan(1000);
  });

  it('should handle concurrent requests efficiently', async () => {
    const requests = Array.from({ length: 100 }, (_, i) => 
      fetch(`/api/resource/${i}`)
    );

    const startTime = performance.now();
    await Promise.all(requests);
    const endTime = performance.now();

    const avgTime = (endTime - startTime) / 100;
    expect(avgTime).toBeLessThan(50); // Average 50ms per request
  });
});
```

## Security Testing

### Security Test Examples
```javascript
describe('Security Tests', () => {
  describe('SQL Injection Prevention', () => {
    it('should sanitize malicious input', async () => {
      const maliciousInput = "'; DROP TABLE users; --";
      
      const response = await request(app)
        .get('/api/users')
        .query({ name: maliciousInput })
        .expect(200);

      // Should return empty results, not error
      expect(response.body.data).toEqual([]);
      
      // Verify table still exists
      const tableExists = await db.schema.hasTable('users');
      expect(tableExists).toBe(true);
    });
  });

  describe('XSS Prevention', () => {
    it('should escape HTML in user input', async () => {
      const xssPayload = '<script>alert("XSS")</script>';
      
      const response = await request(app)
        .post('/api/comments')
        .send({ content: xssPayload })
        .expect(201);

      expect(response.body.data.content).toBe('&lt;script&gt;alert("XSS")&lt;/script&gt;');
    });
  });

  describe('Authentication', () => {
    it('should reject requests without valid token', async () => {
      await request(app)
        .get('/api/protected')
        .expect(401);
    });

    it('should reject expired tokens', async () => {
      const expiredToken = generateToken({ exp: Date.now() - 1000 });
      
      await request(app)
        .get('/api/protected')
        .set('Authorization', `Bearer ${expiredToken}`)
        .expect(401);
    });
  });
});
```

## Test Automation

### CI/CD Pipeline Tests
```yaml
# .github/workflows/test.yml
name: Test Suite

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    
    services:
      postgres:
        image: postgres:14
        env:
          POSTGRES_PASSWORD: postgres
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
          
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'
          cache: 'npm'
          
      - name: Install dependencies
        run: npm ci
        
      - name: Run linter
        run: npm run lint
        
      - name: Run unit tests
        run: npm run test:unit
        
      - name: Run integration tests
        run: npm run test:integration
        env:
          DATABASE_URL: postgresql://postgres:postgres@localhost/test
          
      - name: Run E2E tests
        run: npm run test:e2e
        
      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          file: ./coverage/lcov.info
```

### Pre-commit Hooks
```json
// package.json
{
  "husky": {
    "hooks": {
      "pre-commit": "lint-staged",
      "pre-push": "npm test"
    }
  },
  "lint-staged": {
    "*.{js,jsx,ts,tsx}": [
      "eslint --fix",
      "jest --bail --findRelatedTests"
    ],
    "*.{json,md}": [
      "prettier --write"
    ]
  }
}
```

## Test Debugging

### Debugging Techniques
```javascript
// 1. Focus on specific test
it.only('should focus on this test', () => {
  // Only this test runs
});

// 2. Skip test temporarily
it.skip('should skip this test', () => {
  // This test is skipped
});

// 3. Debug with console.log
it('should debug values', () => {
  const result = complexFunction();
  console.log('Result:', result); // See output
  expect(result).toBeDefined();
});

// 4. Use debugger
it('should pause execution', () => {
  const value = getValue();
  debugger; // Breakpoint here
  expect(value).toBe(expected);
});

// 5. Increase timeout for slow tests
it('should handle slow operation', async () => {
  const result = await slowOperation();
  expect(result).toBeDefined();
}, 10000); // 10 second timeout
```

### Common Test Issues
| Issue | Cause | Solution |
|-------|-------|----------|
| Flaky tests | Timing/async issues | Use proper waits, mock time |
| Slow tests | Database/network calls | Use mocks, parallel execution |
| False positives | Weak assertions | Add specific expectations |
| Test pollution | Shared state | Proper setup/teardown |
| Hard to maintain | Implementation details | Test behavior, not implementation |

## Test Documentation

### Test Naming Convention
```javascript
// Pattern: [MethodName]_[Scenario]_[ExpectedBehavior]
it('createUser_WithValidData_ReturnsNewUser', ...);
it('createUser_WithDuplicateEmail_ThrowsError', ...);
it('calculatePrice_WithDiscount_AppliesCorrectAmount', ...);

// Or descriptive sentences
it('should return user when valid ID is provided', ...);
it('should throw error when email already exists', ...);
it('should apply discount correctly to total price', ...);
```

### Test Comments
```javascript
describe('PaymentProcessor', () => {
  // Test suite for payment processing functionality
  // Covers: credit card, PayPal, and bank transfer methods
  // Dependencies: Payment gateway mock, test database
  
  beforeAll(async () => {
    // Setup test payment gateway with sandbox credentials
    // Initialize test database with sample data
  });

  it('should process credit card payment', async () => {
    // This test verifies the complete payment flow
    // including validation, charging, and receipt generation
    
    // Note: Uses Stripe test card numbers
    // See: https://stripe.com/docs/testing
  });
});
```

## Testing Tools

### Recommended Tools
| Category | Tool | Purpose |
|----------|------|---------|
| Test Runner | Jest | JavaScript testing |
| Assertion | Chai | BDD/TDD assertions |
| Mocking | Sinon | Spies, stubs, mocks |
| HTTP Testing | Supertest | API endpoint testing |
| Browser Testing | Cypress | E2E testing |
| Component Testing | Testing Library | React/Vue testing |
| Load Testing | k6 | Performance testing |
| Security Testing | OWASP ZAP | Vulnerability scanning |
| Code Coverage | Istanbul | Coverage reporting |

---
*Last Updated: [Date]*  
*Test Lead: [Name]*