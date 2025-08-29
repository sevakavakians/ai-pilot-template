# Code Conventions & Standards

**Purpose**: Define coding standards, naming conventions, and best practices for consistent codebase.  
**Audience**: All developers, code reviewers  
**Update Frequency**: Quarterly or when adopting new patterns

## General Principles

### Code Philosophy
1. **Readability > Cleverness**: Write code for humans to read
2. **DRY (Don't Repeat Yourself)**: Extract common functionality
3. **SOLID Principles**: Follow object-oriented design principles
4. **YAGNI**: Don't add functionality until needed
5. **Boy Scout Rule**: Leave code better than you found it

## Naming Conventions

### Variables & Functions
```javascript
// Variables - camelCase
const userName = 'John Doe';
let itemCount = 0;

// Constants - UPPER_SNAKE_CASE
const MAX_RETRY_COUNT = 3;
const API_BASE_URL = 'https://api.example.com';

// Functions - camelCase, verb prefixes
function getUserById(id) { }
function calculateTotalPrice(items) { }
function isValidEmail(email) { }
function hasPermission(user, action) { }

// Boolean variables - use is/has/can prefixes
const isActive = true;
const hasAccess = false;
const canEdit = true;

// Private functions/variables - prefix with underscore
function _internalHelper() { }
const _privateConfig = {};
```

### Classes & Interfaces
```typescript
// Classes - PascalCase
class UserAccount { }
class ProductService { }
class DatabaseConnection { }

// Interfaces - PascalCase with 'I' prefix (optional)
interface User { }
interface IRepository { }  // Alternative style

// Enums - PascalCase for name, UPPER_SNAKE_CASE for values
enum UserRole {
  ADMIN = 'ADMIN',
  USER = 'USER',
  GUEST = 'GUEST'
}

// Type aliases - PascalCase
type UserId = string;
type ProductMap = Map<string, Product>;
```

### Files & Directories
```
// Files - kebab-case
user-controller.js
auth-middleware.ts
database-config.json

// React/Vue components - PascalCase
UserProfile.jsx
NavigationBar.vue
LoginForm.tsx

// Test files - match source with .test or .spec
user-service.js → user-service.test.js
api-client.ts → api-client.spec.ts

// Directories - kebab-case
src/
├── components/
├── services/
├── utils/
├── models/
└── config/
```

### Database Conventions
```sql
-- Tables - snake_case, plural
CREATE TABLE users (...);
CREATE TABLE order_items (...);

-- Columns - snake_case
user_id, created_at, is_active

-- Indexes - idx_table_column
CREATE INDEX idx_users_email ON users(email);

-- Foreign keys - fk_source_target
ALTER TABLE orders ADD CONSTRAINT fk_orders_users 
  FOREIGN KEY (user_id) REFERENCES users(id);

-- Stored procedures - sp_action_entity
CREATE PROCEDURE sp_get_user_orders(...);
```

## Code Structure

### Module Organization
```javascript
// 1. Imports - grouped and ordered
// Node.js built-ins
import fs from 'fs';
import path from 'path';

// External packages
import express from 'express';
import lodash from 'lodash';

// Internal modules
import { UserService } from '../services/user-service';
import { logger } from '../utils/logger';
import { config } from '../config';

// 2. Constants
const MAX_RETRIES = 3;
const TIMEOUT_MS = 5000;

// 3. Main code
class MyClass {
  // ...
}

// 4. Exports
export { MyClass };
export default MyClass;
```

### Function Structure
```javascript
/**
 * Calculate the total price including tax and shipping
 * @param {Array<Item>} items - List of items in cart
 * @param {number} taxRate - Tax rate as decimal (e.g., 0.08 for 8%)
 * @param {number} shippingCost - Flat shipping cost
 * @returns {Object} Total price breakdown
 * @throws {Error} If items array is empty
 */
function calculateTotalPrice(items, taxRate = 0.08, shippingCost = 10) {
  // Input validation
  if (!items || items.length === 0) {
    throw new Error('Items array cannot be empty');
  }

  // Main logic
  const subtotal = items.reduce((sum, item) => sum + item.price * item.quantity, 0);
  const tax = subtotal * taxRate;
  const total = subtotal + tax + shippingCost;

  // Return result
  return {
    subtotal,
    tax,
    shipping: shippingCost,
    total
  };
}
```

## JavaScript/TypeScript

### Variable Declarations
```javascript
// Use const by default, let when reassignment needed
const API_KEY = process.env.API_KEY;
let retryCount = 0;

// Never use var
// var oldStyle = 'avoid'; // ❌

// Destructuring
const { name, email } = user;
const [first, second, ...rest] = array;

// Default parameters
function greet(name = 'Guest') {
  return `Hello, ${name}!`;
}
```

### Async/Await Pattern
```javascript
// Prefer async/await over promises
// Good ✅
async function fetchUser(id) {
  try {
    const user = await db.users.findById(id);
    if (!user) {
      throw new Error('User not found');
    }
    return user;
  } catch (error) {
    logger.error('Failed to fetch user:', error);
    throw error;
  }
}

// Avoid callback hell ❌
function fetchUser(id, callback) {
  db.users.findById(id, (err, user) => {
    if (err) callback(err);
    else callback(null, user);
  });
}
```

### Error Handling
```javascript
// Custom error classes
class ValidationError extends Error {
  constructor(message, field) {
    super(message);
    this.name = 'ValidationError';
    this.field = field;
  }
}

// Consistent error handling
async function processPayment(paymentData) {
  try {
    validatePaymentData(paymentData);
    const result = await paymentGateway.process(paymentData);
    return { success: true, transactionId: result.id };
  } catch (error) {
    // Log error with context
    logger.error('Payment processing failed', {
      error: error.message,
      paymentData: { ...paymentData, cardNumber: '***' }
    });

    // Handle specific error types
    if (error instanceof ValidationError) {
      return { success: false, error: 'Invalid payment data', field: error.field };
    }
    
    if (error.code === 'INSUFFICIENT_FUNDS') {
      return { success: false, error: 'Insufficient funds' };
    }

    // Generic error response
    return { success: false, error: 'Payment processing failed' };
  }
}
```

## React/Component Guidelines

### Component Structure
```jsx
// Functional component with hooks
import React, { useState, useEffect, useCallback } from 'react';
import PropTypes from 'prop-types';
import { useAuth } from '../hooks/useAuth';
import Button from './Button';
import './UserProfile.css';

function UserProfile({ userId, onUpdate }) {
  // State declarations
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  // Custom hooks
  const { currentUser, permissions } = useAuth();

  // Effects
  useEffect(() => {
    fetchUser();
  }, [userId]);

  // Callbacks
  const fetchUser = useCallback(async () => {
    try {
      setLoading(true);
      const data = await api.getUser(userId);
      setUser(data);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  }, [userId]);

  // Event handlers
  const handleSave = async (formData) => {
    const updated = await api.updateUser(userId, formData);
    onUpdate(updated);
  };

  // Render
  if (loading) return <Spinner />;
  if (error) return <ErrorMessage message={error} />;
  if (!user) return <NotFound />;

  return (
    <div className="user-profile">
      <h1>{user.name}</h1>
      {/* Component JSX */}
    </div>
  );
}

// PropTypes
UserProfile.propTypes = {
  userId: PropTypes.string.isRequired,
  onUpdate: PropTypes.func
};

// Default props
UserProfile.defaultProps = {
  onUpdate: () => {}
};

export default UserProfile;
```

## API Design

### RESTful Endpoints
```javascript
// Standard REST patterns
GET    /api/users           // List all users
GET    /api/users/:id       // Get specific user
POST   /api/users           // Create new user
PUT    /api/users/:id       // Update entire user
PATCH  /api/users/:id       // Partial update
DELETE /api/users/:id       // Delete user

// Nested resources
GET    /api/users/:id/orders       // User's orders
POST   /api/users/:id/orders       // Create order for user

// Actions
POST   /api/users/:id/verify-email // Specific action
POST   /api/users/:id/reset-password

// Query parameters for filtering/pagination
GET    /api/users?status=active&page=2&limit=20&sort=-created_at
```

### Response Format
```javascript
// Success response
{
  "success": true,
  "data": {
    "id": "123",
    "name": "John Doe"
  },
  "meta": {
    "timestamp": "2024-01-01T12:00:00Z",
    "version": "1.0"
  }
}

// Error response
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input data",
    "details": [
      {
        "field": "email",
        "message": "Invalid email format"
      }
    ]
  },
  "meta": {
    "timestamp": "2024-01-01T12:00:00Z",
    "request_id": "req_abc123"
  }
}

// Paginated response
{
  "success": true,
  "data": [...],
  "pagination": {
    "page": 2,
    "limit": 20,
    "total": 100,
    "pages": 5,
    "next": "/api/users?page=3&limit=20",
    "prev": "/api/users?page=1&limit=20"
  }
}
```

## Testing Standards

### Test File Structure
```javascript
// user-service.test.js
describe('UserService', () => {
  // Setup and teardown
  beforeAll(async () => {
    await setupTestDatabase();
  });

  afterAll(async () => {
    await cleanupTestDatabase();
  });

  beforeEach(() => {
    jest.clearAllMocks();
  });

  // Group related tests
  describe('createUser', () => {
    it('should create a new user with valid data', async () => {
      // Arrange
      const userData = { name: 'John', email: 'john@example.com' };
      
      // Act
      const user = await userService.createUser(userData);
      
      // Assert
      expect(user).toHaveProperty('id');
      expect(user.name).toBe(userData.name);
      expect(user.email).toBe(userData.email);
    });

    it('should throw error for duplicate email', async () => {
      // Arrange
      const userData = { email: 'existing@example.com' };
      await userService.createUser(userData);
      
      // Act & Assert
      await expect(userService.createUser(userData))
        .rejects.toThrow('Email already exists');
    });
  });

  // Edge cases
  describe('edge cases', () => {
    it('should handle null input gracefully', async () => {
      await expect(userService.createUser(null))
        .rejects.toThrow('Invalid user data');
    });
  });
});
```

### Test Naming
```javascript
// Use descriptive test names
// Pattern: should [expected behavior] when [condition]

// Good ✅
it('should return user data when valid ID is provided', ...);
it('should throw NotFoundError when user does not exist', ...);
it('should retry 3 times when network error occurs', ...);

// Avoid ❌
it('test user creation', ...);
it('error test', ...);
it('works', ...);
```

## Documentation

### JSDoc Comments
```javascript
/**
 * Service for managing user accounts
 * @class UserService
 * @extends BaseService
 */
class UserService extends BaseService {
  /**
   * Create a new user account
   * @param {Object} userData - User information
   * @param {string} userData.email - User's email address
   * @param {string} userData.name - User's full name
   * @param {string} [userData.phone] - Optional phone number
   * @returns {Promise<User>} Created user object
   * @throws {ValidationError} If email is invalid
   * @throws {DuplicateError} If email already exists
   * @example
   * const user = await userService.createUser({
   *   email: 'john@example.com',
   *   name: 'John Doe'
   * });
   */
  async createUser(userData) {
    // Implementation
  }
}
```

### Inline Comments
```javascript
// Good: Explain WHY, not WHAT
// Calculate tax based on user's region (different rates apply)
const tax = calculateRegionalTax(user.region, subtotal);

// Avoid: Obvious comments ❌
// Increment counter by 1
counter++;

// Good: Complex logic explanation
// Use binary search for performance on large sorted arrays
// Time complexity: O(log n), Space complexity: O(1)
function binarySearch(array, target) {
  // Implementation
}

// TODO comments with owner and date
// TODO(john): Implement caching here - 2024-01-15
// FIXME(jane): Handle edge case for negative values
// HACK: Temporary workaround until API v2 is released
```

## Git Commit Messages

### Commit Format
```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types
- **feat**: New feature
- **fix**: Bug fix
- **docs**: Documentation changes
- **style**: Code style changes (formatting, semicolons, etc.)
- **refactor**: Code refactoring
- **perf**: Performance improvements
- **test**: Add or update tests
- **build**: Build system changes
- **ci**: CI/CD configuration changes
- **chore**: Other changes (update dependencies, etc.)

### Examples
```bash
# Good commit messages ✅
feat(auth): add OAuth2 Google authentication
fix(api): handle null response from payment gateway
docs(readme): update installation instructions
refactor(user-service): extract validation logic
perf(db): add index on users.email column

# Bad commit messages ❌
fix bug
update code
WIP
asdf
changes
```

## Security Best Practices

### Input Validation
```javascript
// Always validate and sanitize input
const { body, validationResult } = require('express-validator');

router.post('/users',
  [
    body('email').isEmail().normalizeEmail(),
    body('name').trim().isLength({ min: 2, max: 100 }),
    body('age').isInt({ min: 0, max: 120 }),
    body('password').isStrongPassword()
  ],
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }
    // Process valid input
  }
);
```

### Sensitive Data
```javascript
// Never log sensitive data
logger.info('User login', {
  email: user.email,
  // password: user.password, // ❌ Never log passwords
  timestamp: new Date()
});

// Mask sensitive data in responses
function maskCreditCard(number) {
  return number.replace(/\d(?=\d{4})/g, '*');
}

// Use environment variables for secrets
const apiKey = process.env.API_KEY; // ✅
// const apiKey = 'sk_live_abc123'; // ❌ Never hardcode
```

## Performance Guidelines

### Optimization Rules
1. **Measure first**: Profile before optimizing
2. **Optimize algorithms**: Better algorithm > micro-optimizations
3. **Cache expensive operations**: Database queries, API calls
4. **Lazy load**: Load resources only when needed
5. **Batch operations**: Reduce round trips

### Code Examples
```javascript
// Use efficient data structures
const userMap = new Map(); // O(1) lookup
// Instead of array.find() which is O(n)

// Batch database operations
const users = await db.users.bulkCreate(userData); // ✅
// Instead of multiple individual inserts

// Memoization for expensive calculations
const memoizedFibonacci = memoize(fibonacci);

// Debounce frequent operations
const debouncedSearch = debounce(searchUsers, 300);
```

## Code Review Checklist

### Before Submitting PR
- [ ] Code follows naming conventions
- [ ] All tests pass
- [ ] No console.log or debugger statements
- [ ] Error handling is appropriate
- [ ] Documentation is updated
- [ ] No sensitive data exposed
- [ ] Performance impact considered
- [ ] Security implications reviewed

### Review Focus Areas
1. **Logic**: Is the implementation correct?
2. **Design**: Is the approach appropriate?
3. **Style**: Does it follow conventions?
4. **Testing**: Are tests adequate?
5. **Performance**: Are there bottlenecks?
6. **Security**: Are there vulnerabilities?
7. **Documentation**: Is it well-documented?

---
*Last Updated: [Date]*  
*Approved By: [Tech Lead/Team]*