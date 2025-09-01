# CLAUDE.md - Library/Package Template

This file provides guidance to Claude Code when working with this library/package.

## Project Overview

[LIBRARY_NAME] - A [LANGUAGE] library for [PURPOSE].

## Common Development Commands

### Building and Testing
```bash
# Install dependencies
npm install  # or: pip install -e .[dev]

# Run tests
npm test  # or: pytest

# Build library
npm run build  # or: python setup.py build

# Watch mode for development
npm run watch  # or: ptw

# Generate documentation
npm run docs  # or: sphinx-build docs

# Publish to registry
npm publish  # or: python -m twine upload dist/*
```

### Code Quality
```bash
# Run linter
npm run lint  # or: flake8

# Format code
npm run format  # or: black .

# Type checking
npm run typecheck  # or: mypy .

# Check bundle size
npm run size  # or: size-limit

# Security audit
npm audit  # or: safety check
```

## Library Architecture

### Structure
```
Public API → Core Modules → Internal Utilities
     ↓            ↓              ↓
  Exports    Implementation   Helpers
     ↓            ↓              ↓
Type Defs    Algorithms     Constants
```

### Core Components

1. **Public API** (`src/index.ts` or `__init__.py`)
   - Exported functions/classes
   - Type definitions
   - Public interfaces

2. **Core Modules** (`src/core/` or `lib/`)
   - Main implementation
   - Business logic
   - Algorithm implementations

3. **Utilities** (`src/utils/`)
   - Helper functions
   - Internal tools
   - Common patterns

4. **Types** (`src/types/` or `types/`)
   - TypeScript interfaces
   - Python type hints
   - Generic types

### API Design

```javascript
// JavaScript/TypeScript
import { LibraryName } from 'library-name';

const instance = new LibraryName(options);
const result = await instance.method(params);
```

```python
# Python
from library_name import LibraryClass

instance = LibraryClass(options)
result = instance.method(params)
```

### Technology Stack
- **Language**: TypeScript/Python/Go/Rust
- **Build Tool**: Rollup/Webpack/setuptools
- **Testing**: Jest/Pytest/Go test
- **Documentation**: TypeDoc/Sphinx/Docusaurus
- **Package Registry**: npm/PyPI/crates.io

## Development Workflow

1. Create feature branch
2. Implement feature with tests
3. Update API documentation
4. Add usage examples
5. Check backward compatibility
6. Run full test suite
7. Update changelog
8. Create pull request

## Configuration

### Package Configuration
```json
// package.json
{
  "name": "library-name",
  "version": "1.0.0",
  "main": "dist/index.js",
  "types": "dist/index.d.ts",
  "exports": {
    ".": "./dist/index.js",
    "./utils": "./dist/utils.js"
  }
}
```

```python
# setup.py or pyproject.toml
[project]
name = "library-name"
version = "1.0.0"
requires-python = ">=3.8"
```

## Important Files and Locations

- Entry point: `src/index.ts` or `src/__init__.py`
- Core logic: `src/core/`
- Utilities: `src/utils/`
- Tests: `tests/` or `__tests__/`
- Examples: `examples/`
- Documentation: `docs/`
- Type definitions: `types/` or `index.d.ts`

## API Documentation

### Core Functions

```typescript
/**
 * Main function description
 * @param input - Input parameter description
 * @returns Output description
 * @example
 * const result = mainFunction('input');
 */
export function mainFunction(input: string): Result;
```

### Classes

```typescript
/**
 * Main class description
 */
export class MainClass {
  /**
   * Constructor description
   */
  constructor(options: Options);
  
  /**
   * Method description
   */
  method(params: Params): Promise<Result>;
}
```

## Testing Strategy

### Unit Tests
- Test each exported function
- Test edge cases
- Test error conditions
- Mock external dependencies

### Integration Tests
- Test complete workflows
- Test with real data
- Test performance characteristics

### Example Tests
```javascript
describe('LibraryName', () => {
  it('should handle basic case', () => {
    const result = library.method('input');
    expect(result).toBe('expected');
  });
  
  it('should handle edge case', () => {
    expect(() => library.method(null)).toThrow();
  });
});
```

## Versioning Strategy

Follow Semantic Versioning (SemVer):
- MAJOR: Breaking API changes
- MINOR: New features (backward compatible)
- PATCH: Bug fixes

## Browser/Environment Support

- Node.js: 14+
- Browsers: Chrome 90+, Firefox 88+, Safari 14+
- TypeScript: 4.0+
- Python: 3.8+

[Include standard agent protocols from main CLAUDE.md template]