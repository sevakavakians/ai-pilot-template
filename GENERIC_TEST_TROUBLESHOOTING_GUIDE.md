# Generic Test Troubleshooting Guide

## Overview
This guide provides a systematic approach to debugging test failures across software projects. It emphasizes understanding actual system behavior before fixing test code, ensuring fixes address root causes rather than symptoms.

## Core Troubleshooting Process

### Step 1: Manual Verification First
Before examining test code, understand what the system ACTUALLY does:

**For APIs/Web Services:**
```bash
# Test endpoints directly
curl -X POST http://localhost:8080/api/endpoint \
  -H "Content-Type: application/json" \
  -d '{"key": "value"}' | jq '.' > actual_response.json

# Test authentication flows
curl -H "Authorization: Bearer $TOKEN" http://localhost:8080/api/protected
```

**For CLI Applications:**
```bash
# Test command directly
./app command --flag value > actual_output.txt 2>&1

# Compare with expected behavior
diff expected_output.txt actual_output.txt
```

**For Libraries/Functions:**
```python
# Create minimal reproduction script
from your_module import function_under_test

result = function_under_test(test_input)
print(f"Input: {test_input}")
print(f"Output: {result}")
print(f"Type: {type(result)}")
```

**Key Information to Document:**
- Exact input format required
- Actual output structure and types
- Error messages and status codes
- Side effects (database changes, file creation, etc.)
- Performance characteristics (timing, memory usage)

### Step 2: Compare Manual vs Test Behavior
Execute the same operations that failing tests perform:

1. **Extract test operations**: Read the failing test to understand its exact sequence
2. **Reproduce manually**: Execute identical operations outside the test framework
3. **Compare results**:
   ```bash
   # What the test expects
   grep -E "(assert|expect|should)" test_file.* 
   
   # What actually happens
   cat actual_response.json
   ```
4. **Document discrepancies**: Note every difference between expectations and reality

### Step 3: Root Cause Analysis
Systematically determine WHY there's a mismatch:

#### Critical Questions:
- **Documentation vs Reality**: What does official documentation say should happen?
- **Test Assumptions**: Are test expectations based on outdated assumptions?
- **Environment Differences**: Are there configuration differences between test and manual environments?
- **Timing Issues**: Are there race conditions, async operations, or initialization delays?
- **Data Dependencies**: Does the test require specific database state or external data?
- **Version Mismatches**: Has the implementation changed but tests weren't updated?

#### Investigation Techniques:

**Application Logs:**
```bash
# Real-time monitoring
tail -f application.log | grep -E "(ERROR|WARN|test_identifier)"

# Search for specific patterns
grep -C 5 "failing_operation" application.log

# Check log levels are appropriate for debugging
```

**Database/Storage Verification:**
```bash
# Check actual data state
sqlite3 test.db "SELECT * FROM table_name WHERE condition;"

# MongoDB
db.collection.find({condition}).pretty()

# Redis
redis-cli KEYS "*pattern*"
```

**Network/Service Dependencies:**
```bash
# Check service availability
curl -I http://dependency-service:8080/health

# Verify connectivity
telnet hostname port

# Check DNS resolution
nslookup service-name
```

**Environment State:**
```bash
# Check environment variables
env | grep -i test

# Verify file permissions
ls -la /path/to/files

# Check disk space and resources
df -h && free -m
```

### Step 4: Fix Infrastructure First, Then Logic

#### Priority Order:

**1. Build and Environment Issues**
```bash
# Verify builds are current
make clean && make build

# Check dependency versions
npm list / pip freeze / go mod list

# Ensure test environment is properly initialized
make setup-test-env
```

**2. Test Framework and Configuration**
- Fix syntax errors in test files
- Resolve import/dependency issues
- Ensure proper test isolation and cleanup
- Verify test data fixtures are correct

**3. Application Configuration**
- Check config files for test environment
- Verify database connections and schemas
- Ensure external service mocks are working
- Validate authentication/authorization setup

**4. Test Logic and Expectations**
- Update assertions to match actual behavior
- Add appropriate tolerances for non-deterministic results
- Fix incorrect test assumptions
- Update test data to match current requirements

### Step 5: Incremental Testing Strategy
Build confidence through progressive testing:

```bash
# 1. Test individual units
pytest tests/test_module.py::test_specific_function -v

# 2. Test single file
npm test -- tests/module.test.js

# 3. Test related functionality
pytest tests/integration/test_feature_*.py

# 4. Run full suite only after smaller tests pass
make test-all
```

## Common Failure Patterns and Solutions

### Pattern 1: Missing Required Data/Parameters
**Symptom**: NullPointerException, KeyError, 400 Bad Request
**Cause**: Test not providing all required inputs
**Solution**:
```python
# Bad: Missing required fields
response = client.post('/api/users', json={'name': 'John'})

# Good: All required fields
response = client.post('/api/users', json={
    'name': 'John',
    'email': 'john@example.com',
    'age': 30
})
```

### Pattern 2: Timing and Asynchronous Operations
**Symptom**: Intermittent failures, "element not found", empty results
**Cause**: Test executing before async operations complete
**Solution**:
```python
# Bad: No wait for async operation
submit_form()
assert success_message_displayed()

# Good: Wait for operation to complete
submit_form()
wait_for_element(success_message, timeout=10)
assert success_message_displayed()
```

### Pattern 3: Floating Point and Approximate Comparisons
**Symptom**: Assertion failures on mathematical calculations
**Cause**: Precision differences in floating point arithmetic
**Solution**:
```python
# Bad: Exact comparison
assert calculated_value == 0.1

# Good: Tolerance-based comparison
assert abs(calculated_value - 0.1) < 0.001
# Or using testing framework helpers
assert calculated_value == pytest.approx(0.1, rel=1e-3)
```

### Pattern 4: Test Isolation and State Contamination
**Symptom**: Tests pass individually but fail when run together
**Cause**: Shared state between tests
**Solution**:
```python
# Ensure proper setup/teardown
def setup_method(self):
    self.database.clear()
    self.cache.flush()
    
def teardown_method(self):
    self.cleanup_test_data()
```

### Pattern 5: External Dependencies and Mocking
**Symptom**: Tests fail due to network issues, external API changes
**Cause**: Tests dependent on external services
**Solution**:
```python
# Mock external dependencies
@patch('requests.get')
def test_api_call(mock_get):
    mock_get.return_value.json.return_value = {'status': 'success'}
    result = my_function()
    assert result['status'] == 'success'
```

## Technology-Specific Quick Reference

### Web Applications
```bash
# Check server status
curl -I http://localhost:3000/health

# Inspect browser network requests
# Use browser dev tools or
curl -v http://localhost:3000/api/endpoint

# Check database connections
psql -h localhost -U user -d testdb -c "SELECT version();"
```

### APIs and Microservices
```bash
# Test authentication
curl -H "Authorization: Bearer $TOKEN" http://api/protected

# Check service discovery
dig service-name.consul

# Verify load balancer health
curl http://loadbalancer/health
```

### CLI Applications
```bash
# Test with various inputs
echo "test input" | ./app --stdin

# Check exit codes
./app command; echo "Exit code: $?"

# Test error handling
./app invalid-command 2>&1 | head -10
```

### Mobile Applications
```bash
# Check device/emulator status
adb devices

# View application logs
adb logcat | grep -i "your_app"

# Test deep links
adb shell am start -W -a android.intent.action.VIEW -d "your-scheme://test"
```

## Debugging Decision Tree

```
Test Failure
├── Does manual testing reproduce the issue?
│   ├── Yes → Application bug, fix code
│   └── No → Continue to test analysis
├── Does the test run in isolation?
│   ├── No → Test isolation problem
│   └── Yes → Environment or timing issue
├── Are test expectations documented/specified?
│   ├── No → Clarify requirements first
│   └── Yes → Compare actual vs expected behavior
└── Is the failure consistent?
    ├── No → Timing/race condition
    └── Yes → Logic or configuration issue
```

## Essential Debugging Commands

### Application State Inspection
```bash
# Process information
ps aux | grep your_app
netstat -tulpn | grep :8080

# Resource usage
top -p $(pgrep your_app)
strace -p $(pgrep your_app)
```

### Log Analysis
```bash
# Recent errors
tail -100 application.log | grep -i error

# Pattern matching
grep -E "(failed|error|exception)" logs/*.log

# Log correlation
grep "request_id_123" logs/*.log
```

### Network and Connectivity
```bash
# Port availability
nc -zv localhost 8080

# DNS resolution
nslookup api.service.com

# HTTP debugging
curl -v -X POST http://api/endpoint
```

## When to Escalate vs Fix

### Fix the Test When:
- Manual testing confirms the application works correctly
- Test expectations don't match documented behavior
- Test is using deprecated APIs or patterns
- Test has incorrect assumptions about data or timing

### Fix the Application When:
- Manual testing reproduces the failure
- Behavior violates documented specifications
- Multiple independent tests fail consistently
- The issue affects user-facing functionality

### Seek Clarification When:
- Requirements are ambiguous or missing
- Expected behavior is not documented
- Test failures reveal conflicting specifications
- Business logic decisions are unclear

## Success Criteria

A properly fixed test should:
- ✅ Pass consistently across multiple runs
- ✅ Test actual application behavior (verified manually)
- ✅ Have clear, maintainable assertions
- ✅ Not break other existing tests
- ✅ Include appropriate error handling
- ✅ Be properly isolated from other tests
- ✅ Match documented specifications

## Best Practices Summary

1. **Understand First, Fix Second**: Always verify actual behavior before changing tests
2. **Test the Right Thing**: Ensure tests validate meaningful business requirements
3. **Isolate Properly**: Each test should be independent and repeatable
4. **Handle Uncertainty**: Use appropriate tolerances for non-deterministic operations
5. **Document Assumptions**: Make test expectations explicit and traceable to requirements
6. **Fail Fast**: Identify and fix infrastructure issues before diving into complex logic
7. **Verify Manually**: Confirm fixes work outside the test framework

## Recovery Strategies

When troubleshooting becomes complex:

1. **Create Minimal Reproduction**: Build the smallest possible test case
2. **Bisect the Problem**: Remove complexity until you find the core issue
3. **Compare Working Examples**: Find similar tests that pass and compare approaches
4. **Check Recent Changes**: Use version control to identify what changed
5. **Pair Debug**: Get fresh eyes on the problem
6. **Document Findings**: Update this guide with new patterns you discover
