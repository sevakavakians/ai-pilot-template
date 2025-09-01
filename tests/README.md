# Test Suite Documentation

Comprehensive testing framework following the testing pyramid principle.

## 📁 Directory Structure

```
tests/
├── unit/           # Unit tests for individual functions/methods
├── integration/    # Integration tests for component interactions
├── e2e/           # End-to-end tests for complete workflows
├── performance/   # Performance and load tests
├── security/      # Security and vulnerability tests
├── fixtures/      # Test data, mocks, and stubs
└── TEST-RESULTS.md # Latest test execution results
```

## 🎯 Testing Strategy

### Testing Pyramid
```
         /\
        /E2E\        (5%) - Critical user journeys
       /------\
      /  API   \     (15%) - Service integration
     /----------\
    / Integration\   (30%) - Component interaction
   /--------------\
  /   Unit Tests   \ (50%) - Individual functions
 /------------------\
```

## 📝 Test Templates

### Unit Test Template
```javascript
// JavaScript/TypeScript Example
describe('ComponentName', () => {
  describe('methodName', () => {
    it('should handle normal case', () => {
      // Arrange
      const input = 'test';
      
      // Act
      const result = methodName(input);
      
      // Assert
      expect(result).toBe('expected');
    });

    it('should handle edge case', () => {
      expect(() => methodName(null)).toThrow();
    });
  });
});
```

```python
# Python Example
import pytest
from module import function_name

class TestFunctionName:
    def test_normal_case(self):
        # Arrange
        input_data = 'test'
        
        # Act
        result = function_name(input_data)
        
        # Assert
        assert result == 'expected'
    
    def test_edge_case(self):
        with pytest.raises(ValueError):
            function_name(None)
```

### Integration Test Template
```javascript
// Test component interactions
describe('Integration: UserService + Database', () => {
  let userService;
  let database;

  beforeEach(async () => {
    database = await setupTestDatabase();
    userService = new UserService(database);
  });

  afterEach(async () => {
    await database.cleanup();
  });

  it('should create and retrieve user', async () => {
    // Create user
    const user = await userService.create({
      name: 'Test User',
      email: 'test@example.com'
    });

    // Retrieve user
    const retrieved = await userService.findById(user.id);
    
    expect(retrieved.email).toBe('test@example.com');
  });
});
```

### E2E Test Template
```javascript
// Cypress/Playwright Example
describe('User Registration Flow', () => {
  it('should complete registration successfully', () => {
    cy.visit('/register');
    
    cy.get('[data-testid="email-input"]')
      .type('newuser@example.com');
    
    cy.get('[data-testid="password-input"]')
      .type('SecurePassword123!');
    
    cy.get('[data-testid="submit-button"]')
      .click();
    
    cy.url().should('include', '/dashboard');
    cy.contains('Welcome, newuser@example.com');
  });
});
```

### Performance Test Template
```javascript
// K6/Artillery Example
import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  stages: [
    { duration: '2m', target: 100 }, // Ramp up
    { duration: '5m', target: 100 }, // Stay at 100 users
    { duration: '2m', target: 0 },   // Ramp down
  ],
  thresholds: {
    http_req_duration: ['p(95)<500'], // 95% of requests under 500ms
  },
};

export default function () {
  const response = http.get('https://api.example.com/endpoint');
  
  check(response, {
    'status is 200': (r) => r.status === 200,
    'response time < 500ms': (r) => r.timings.duration < 500,
  });
  
  sleep(1);
}
```

### Security Test Template
```python
# Security test example
import requests
from security_scanner import Scanner

class TestSecurity:
    def test_sql_injection_protection(self):
        """Test that SQL injection attempts are blocked"""
        malicious_input = "'; DROP TABLE users; --"
        
        response = requests.post('/api/search', {
            'query': malicious_input
        })
        
        assert response.status_code == 400
        assert 'Invalid input' in response.text
    
    def test_xss_protection(self):
        """Test that XSS attempts are sanitized"""
        xss_payload = '<script>alert("XSS")</script>'
        
        response = requests.post('/api/comment', {
            'text': xss_payload
        })
        
        assert '<script>' not in response.text
    
    def test_authentication_required(self):
        """Test that protected endpoints require auth"""
        response = requests.get('/api/protected')
        assert response.status_code == 401
```

## 🧪 Test Fixtures

### Mock Data Structure
```javascript
// fixtures/users.js
export const mockUsers = [
  {
    id: '1',
    name: 'John Doe',
    email: 'john@example.com',
    role: 'admin'
  },
  {
    id: '2',
    name: 'Jane Smith',
    email: 'jane@example.com',
    role: 'user'
  }
];

// fixtures/api-responses.js
export const successResponse = {
  status: 200,
  data: { message: 'Success' }
};

export const errorResponse = {
  status: 400,
  error: 'Bad Request'
};
```

## 🏃 Running Tests

### All Tests
```bash
[TEST_ALL_COMMAND]
```

### Specific Test Suites
```bash
# Unit tests only
[TEST_UNIT_COMMAND]

# Integration tests
[TEST_INTEGRATION_COMMAND]

# E2E tests
[TEST_E2E_COMMAND]

# Performance tests
[TEST_PERFORMANCE_COMMAND]

# Security tests
[TEST_SECURITY_COMMAND]
```

### With Coverage
```bash
[COVERAGE_COMMAND]
```

## 📊 Test Metrics

### Coverage Goals
- **Overall**: 80%+
- **Unit Tests**: 90%+
- **Integration**: 70%+
- **E2E**: Critical paths only

### Performance Benchmarks
- API Response: < 200ms (p95)
- Page Load: < 3s
- Database Query: < 100ms

## 🔧 Test Configuration

### Common Test Configs

**Jest (JavaScript)**
```json
{
  "testEnvironment": "node",
  "coverageThreshold": {
    "global": {
      "branches": 80,
      "functions": 80,
      "lines": 80,
      "statements": 80
    }
  }
}
```

**Pytest (Python)**
```ini
# pytest.ini
[tool:pytest]
testpaths = tests
python_files = test_*.py
python_classes = Test*
python_functions = test_*
addopts = --verbose --cov=src --cov-report=html
```

## 🤖 Test Automation with test-analyst

The test-analyst agent automatically:
1. Checks for code changes
2. Rebuilds if necessary
3. Runs appropriate test suites
4. Fixes infrastructure issues
5. Generates TEST-RESULTS.md
6. Provides actionable recommendations

**Never run tests manually!** Always use:
```
assistant: "Run all tests"
<triggers test-analyst agent>
```

## 📚 Best Practices

### DO's ✅
- Write tests before or with code (TDD/BDD)
- Keep tests simple and focused
- Use descriptive test names
- Mock external dependencies
- Clean up after tests
- Test edge cases and errors

### DON'Ts ❌
- Don't test implementation details
- Don't write brittle tests
- Don't ignore flaky tests
- Don't skip writing tests
- Don't test third-party code
- Don't use production data

## 🔍 Debugging Failed Tests

1. **Read the error message** - Often contains the solution
2. **Check test isolation** - Ensure no test interdependencies
3. **Verify test data** - Confirm fixtures are correct
4. **Review recent changes** - Check git diff
5. **Run single test** - Isolate the problem
6. **Add debug output** - Console.log/print statements
7. **Check environment** - Verify configuration

## 📈 Continuous Improvement

- Review test failures weekly
- Update slow tests quarterly
- Refactor duplicate test code
- Add tests for bug fixes
- Monitor coverage trends
- Document testing decisions