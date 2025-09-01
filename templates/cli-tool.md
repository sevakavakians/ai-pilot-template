# CLAUDE.md - CLI Tool Template

This file provides guidance to Claude Code when working with this command-line tool.

## Project Overview

[PROJECT_NAME] - A command-line interface tool for [PURPOSE].

## Common Development Commands

### Building and Running
```bash
# Install dependencies
npm install  # or: pip install -e .

# Run in development
npm run dev  # or: python -m cli_tool

# Build executable
npm run build  # or: pyinstaller cli.py

# Install globally
npm link  # or: pip install .

# Run CLI
cli-tool --help
```

### Testing
```bash
# Run all tests
npm test  # or: pytest

# Run unit tests
npm run test:unit  # or: pytest tests/unit

# Run integration tests
npm run test:integration  # or: pytest tests/integration

# Test CLI commands
npm run test:cli  # or: pytest tests/cli

# Generate coverage
npm run coverage  # or: pytest --cov
```

### Code Quality
```bash
# Run linter
npm run lint  # or: flake8

# Format code
npm run format  # or: black .

# Type checking
npm run typecheck  # or: mypy .
```

## Architecture Overview

### CLI Architecture
```
User Input → Parser → Command Router → Command Handler
                ↓           ↓              ↓
            Validation   Subcommands   Business Logic
                            ↓              ↓
                        Options/Flags   File I/O
```

### Core Components

1. **CLI Parser** (`cli/` or `src/cli/`)
   - Argument parsing
   - Command routing
   - Help generation
   - Error handling

2. **Commands** (`commands/`)
   - Individual command implementations
   - Command-specific logic
   - Output formatting

3. **Core Logic** (`lib/` or `core/`)
   - Business logic
   - File operations
   - API interactions
   - Data processing

4. **Utilities** (`utils/`)
   - Helper functions
   - Formatters
   - Validators
   - Config loaders

### Command Structure

```bash
cli-tool <command> [options] [arguments]

Commands:
  init        Initialize new project
  build       Build the project
  test        Run tests
  deploy      Deploy to production
  config      Manage configuration

Options:
  -v, --verbose     Verbose output
  -q, --quiet       Quiet mode
  --config <file>   Config file path
  --no-color        Disable colored output
```

### Technology Stack
- **Language**: Node.js/Python/Go/Rust
- **CLI Framework**: Commander.js/Click/Cobra/Clap
- **Testing**: Jest/Pytest/Go test
- **Distribution**: npm/PyPI/Homebrew

## Development Workflow

1. Create feature branch
2. Implement new command/feature
3. Add command tests
4. Update help documentation
5. Test manually with various inputs
6. Update README with examples
7. Create pull request

## Configuration

### Configuration Files
```bash
# User config
~/.cli-tool/config.json

# Project config
.cli-toolrc.json

# Environment variables
CLI_TOOL_HOME=/path/to/home
CLI_TOOL_CONFIG=/path/to/config
```

### Config Schema
```json
{
  "version": "1.0.0",
  "defaultCommand": "help",
  "output": {
    "format": "json|text|table",
    "color": true,
    "verbose": false
  },
  "plugins": []
}
```

## Important Files and Locations

- Entry point: `bin/cli` or `src/index.js`
- Commands: `src/commands/`
- Core logic: `src/lib/`
- Tests: `tests/` or `__tests__/`
- Config: `src/config/`
- Templates: `templates/`

## Usage Examples

```bash
# Initialize new project
cli-tool init my-project --template react

# Run with verbose output
cli-tool build --verbose

# Use custom config
cli-tool deploy --config ./custom-config.json

# Pipe output
cli-tool list | grep "active"

# Interactive mode
cli-tool interactive
```

## Testing Strategy

### Unit Tests
- Test individual functions
- Mock file system and network calls
- Test error handling

### Integration Tests
- Test complete commands
- Use temporary directories
- Test with real files

### CLI Tests
- Test argument parsing
- Test help output
- Test error messages
- Test exit codes

[Include standard agent protocols from main CLAUDE.md template]