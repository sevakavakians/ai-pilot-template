# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

[PROJECT_NAME] - [PROJECT_DESCRIPTION]

## Key Terminology

Define project-specific terms and concepts here:
- **[TERM_1]**: [DEFINITION]
- **[TERM_2]**: [DEFINITION]

## Common Development Commands

### Building and Running
```bash
# Build the project
[BUILD_COMMAND]

# Run the project
[RUN_COMMAND]

# Start development server
[DEV_COMMAND]

# Stop services
[STOP_COMMAND]

# Check status
[STATUS_COMMAND]
```

### Testing
```bash
# Run all tests
[TEST_ALL_COMMAND]

# Run unit tests
[TEST_UNIT_COMMAND]

# Run integration tests
[TEST_INTEGRATION_COMMAND]

# Run specific test file
[TEST_FILE_COMMAND]

# Generate coverage report
[COVERAGE_COMMAND]
```

### Code Quality
```bash
# Run linter
[LINT_COMMAND]

# Run type checking
[TYPECHECK_COMMAND]

# Format code
[FORMAT_COMMAND]

# Run security checks
[SECURITY_COMMAND]
```

## Architecture Overview

### System Architecture
```
[ARCHITECTURE_DIAGRAM]
```

### Core Components

1. **[COMPONENT_1]** (`[PATH]`)
   - [DESCRIPTION]
   - [RESPONSIBILITIES]

2. **[COMPONENT_2]** (`[PATH]`)
   - [DESCRIPTION]
   - [RESPONSIBILITIES]

3. **[COMPONENT_3]** (`[PATH]`)
   - [DESCRIPTION]
   - [RESPONSIBILITIES]

### Technology Stack
- **Language**: [PRIMARY_LANGUAGE]
- **Framework**: [FRAMEWORK]
- **Database**: [DATABASE]
- **Cache**: [CACHE]
- **Queue**: [QUEUE]
- **Cloud**: [CLOUD_PROVIDER]

## Development Workflow

1. Make changes to source files
2. Run tests with `[TEST_COMMAND]`
3. Check linting with `[LINT_COMMAND]`
4. Commit changes with descriptive messages
5. Push to feature branch and create PR

## Configuration

### Environment Variables
```bash
# Required
[ENV_VAR_1]=[DESCRIPTION]
[ENV_VAR_2]=[DESCRIPTION]

# Optional
[ENV_VAR_3]=[DESCRIPTION] (default: [DEFAULT_VALUE])
```

### Configuration Files
- `[CONFIG_FILE_1]`: [PURPOSE]
- `[CONFIG_FILE_2]`: [PURPOSE]

## Important Files and Locations

- Main entry point: `[ENTRY_POINT]`
- Configuration: `[CONFIG_PATH]`
- Tests: `[TESTS_PATH]`
- Documentation: `[DOCS_PATH]`
- Scripts: `[SCRIPTS_PATH]`

## Automated Planning System Protocol

### ⚠️ CRITICAL RULE: NEVER EDIT planning-docs/ FILES DIRECTLY ⚠️

### Role Separation
**Claude Code's Responsibility**: 
- **READ-ONLY** access to planning documentation for context
- **TRIGGER** project-manager agent for ALL documentation updates
- **EXECUTE** development tasks (code, tests, configs)

**Project-Manager's Responsibility**:
- **EXCLUSIVE WRITE ACCESS** to all planning-docs/ files
- Documentation archival and organization
- Pattern tracking and velocity calculations
- Time estimate refinements

### Every Session Start:
1. READ `planning-docs/README.md` to understand the current system state
2. The README will guide you to the most relevant documents for immediate context
3. Only read additional documents when specifically needed for the current work

### Trigger Project-Manager When:
Use the Task tool with subagent_type="project-manager" when these events occur:
- **Task Completion** → Agent will update SESSION_STATE, archive work, refresh backlogs
- **New Tasks Created** → Agent will add to backlogs with time estimates
- **Priority Changes** → Agent will reorder backlogs and update dependencies
- **Blocker Encountered** → Agent will log blocker, suggest alternative tasks
- **Blocker Resolved** → Agent will update estimates, clear blocker status
- **Architectural Decision** → Agent will update DECISIONS.md and ARCHITECTURE.md
- **New Specifications** → Agent will parse into tasks, update scope
- **Context Switch** → Agent will create session log, update current state
- **Milestone Reached** → Agent will archive phase, update project overview
- **Knowledge Refinement** → Agent will replace assumptions with verified facts

### Context Loading Strategy (Read-Only):
1. **Immediate Context** (Always Load):
   - `planning-docs/README.md` → Entry point and guide
   - `planning-docs/SESSION_STATE.md` → Current task and progress
   - `planning-docs/DAILY_BACKLOG.md` → Today's priorities
   - Latest session log in `planning-docs/sessions/` (if exists)

2. **On-Demand Context** (Load When Needed):
   - `planning-docs/PROJECT_OVERVIEW.md` → Project scope and tech stack
   - `planning-docs/ARCHITECTURE.md` → Technical decisions and structure
   - `planning-docs/SPRINT_BACKLOG.md` → Weekly planning and future work
   - `planning-docs/DECISIONS.md` → Historical architectural choices
   - `planning-docs/completed/` → Previous work for reference

### How to Trigger the Project-Manager:
```
Example: After completing a task
assistant: "I've finished implementing [FEATURE]. Let me trigger the project-manager to update our documentation."
<uses Task tool with subagent_type="project-manager">

The project-manager will automatically:
- Update SESSION_STATE.md progress
- Archive the completed task
- Refresh the backlogs
- Calculate actual vs estimated time
- Log any patterns observed
```

## Test Execution Protocol

### ⚠️ CRITICAL RULE: USE test-analyst FOR ALL TESTING ⚠️

### When to Trigger test-analyst:
Use the Task tool with subagent_type="test-analyst" when:
- **After Code Changes** → To verify functionality and catch regressions
- **After Bug Fixes** → To confirm fixes work and don't break other tests
- **After Feature Implementation** → To ensure comprehensive testing
- **When Investigating Test Failures** → To get detailed analysis
- **For Performance Testing** → To benchmark and analyze performance
- **When User Requests Testing** → Any test-related request

### ❌ FORBIDDEN ACTIONS for Claude Code:
- Running test commands directly via Bash tool
- Running test scripts manually
- Executing test frameworks directly

### ✅ CORRECT WORKFLOW:
```
❌ WRONG: Bash("[TEST_COMMAND]")
❌ WRONG: Bash("npm test")
❌ WRONG: Bash("python -m pytest")

✅ RIGHT: Task tool with subagent_type="test-analyst"
```

### Example Usage:
```
assistant: "I've completed the bug fix. Let me use the test-analyst to verify all tests pass."
<uses Task tool with subagent_type="test-analyst">

The test-analyst will:
1. Check for code changes
2. Run appropriate test suites
3. Analyze results
4. Fix test infrastructure issues if needed
5. Generate comprehensive report
```

## Agent Usage Summary

### Available Specialized Agents:
1. **project-manager**: ALL planning-docs/ updates and documentation
2. **test-analyst**: ALL test execution and analysis  
3. **general-purpose**: Complex multi-step research tasks

### Quick Decision Tree:
- Updating documentation? → project-manager
- Running tests? → test-analyst
- Complex research? → general-purpose
- Everything else? → Do it directly

### Common Mistakes to Avoid:
1. ❌ Editing planning-docs/ directly → ✅ Use project-manager
2. ❌ Running tests directly → ✅ Use test-analyst
3. ❌ Manual test execution → ✅ Use test-analyst