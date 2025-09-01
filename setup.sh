#!/bin/bash

# AI Pilot Template Setup Script
# This script helps set up a new project using the AI Pilot Template

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_color() {
    color=$1
    message=$2
    echo -e "${color}${message}${NC}"
}

# Function to prompt for input with default value
prompt_with_default() {
    prompt=$1
    default=$2
    read -p "$prompt [$default]: " value
    echo "${value:-$default}"
}

# Welcome message
clear
print_color "$BLUE" "======================================"
print_color "$BLUE" "   AI Pilot Template Setup Wizard    "
print_color "$BLUE" "======================================"
echo

# Check if we're in the template directory
if [ ! -f "CLAUDE.md" ]; then
    print_color "$RED" "Error: CLAUDE.md not found. Please run this script from the template directory."
    exit 1
fi

# Gather project information
print_color "$GREEN" "Let's set up your project!"
echo

PROJECT_NAME=$(prompt_with_default "Project name" "my-project")
PROJECT_DESCRIPTION=$(prompt_with_default "Project description" "A new software project")
PROJECT_TYPE=$(prompt_with_default "Project type (web-app/api-service/cli-tool/library/generic)" "generic")
PRIMARY_LANGUAGE=$(prompt_with_default "Primary language (javascript/typescript/python/go/other)" "javascript")

# Language-specific defaults
case "$PRIMARY_LANGUAGE" in
    javascript|typescript)
        BUILD_COMMAND="npm run build"
        TEST_COMMAND="npm test"
        LINT_COMMAND="npm run lint"
        RUN_COMMAND="npm start"
        DEV_COMMAND="npm run dev"
        ;;
    python)
        BUILD_COMMAND="python setup.py build"
        TEST_COMMAND="pytest"
        LINT_COMMAND="flake8 ."
        RUN_COMMAND="python main.py"
        DEV_COMMAND="python -m flask run --debug"
        ;;
    go)
        BUILD_COMMAND="go build"
        TEST_COMMAND="go test ./..."
        LINT_COMMAND="golangci-lint run"
        RUN_COMMAND="./main"
        DEV_COMMAND="go run main.go"
        ;;
    *)
        BUILD_COMMAND="make build"
        TEST_COMMAND="make test"
        LINT_COMMAND="make lint"
        RUN_COMMAND="./run.sh"
        DEV_COMMAND="make dev"
        ;;
esac

# Allow customization of commands
print_color "$YELLOW" "\nDefault commands for $PRIMARY_LANGUAGE:"
echo "Build: $BUILD_COMMAND"
echo "Test: $TEST_COMMAND"
echo "Lint: $LINT_COMMAND"
echo

CUSTOMIZE=$(prompt_with_default "Customize commands? (y/n)" "n")
if [ "$CUSTOMIZE" = "y" ]; then
    BUILD_COMMAND=$(prompt_with_default "Build command" "$BUILD_COMMAND")
    TEST_COMMAND=$(prompt_with_default "Test command" "$TEST_COMMAND")
    LINT_COMMAND=$(prompt_with_default "Lint command" "$LINT_COMMAND")
    RUN_COMMAND=$(prompt_with_default "Run command" "$RUN_COMMAND")
    DEV_COMMAND=$(prompt_with_default "Dev command" "$DEV_COMMAND")
fi

# Function to replace placeholders in a file
replace_placeholders() {
    file=$1
    if [ -f "$file" ]; then
        # Use different delimiter for sed to avoid conflicts with forward slashes in commands
        sed -i.bak \
            -e "s|\[PROJECT_NAME\]|$PROJECT_NAME|g" \
            -e "s|\[PROJECT_DESCRIPTION\]|$PROJECT_DESCRIPTION|g" \
            -e "s|\[PRIMARY_LANGUAGE\]|$PRIMARY_LANGUAGE|g" \
            -e "s|\[BUILD_COMMAND\]|$BUILD_COMMAND|g" \
            -e "s|\[TEST_COMMAND\]|$TEST_COMMAND|g" \
            -e "s|\[TEST_ALL_COMMAND\]|$TEST_COMMAND|g" \
            -e "s|\[LINT_COMMAND\]|$LINT_COMMAND|g" \
            -e "s|\[RUN_COMMAND\]|$RUN_COMMAND|g" \
            -e "s|\[DEV_COMMAND\]|$DEV_COMMAND|g" \
            "$file"
        rm "${file}.bak"
    fi
}

# Create project directory if not in template
if [ "$(basename $(pwd))" = "ai-pilot-template" ]; then
    print_color "$YELLOW" "\nCreating new project directory: $PROJECT_NAME"
    cd ..
    cp -r ai-pilot-template "$PROJECT_NAME"
    cd "$PROJECT_NAME"
    rm -rf .git
fi

# Apply the appropriate template
if [ "$PROJECT_TYPE" != "generic" ] && [ -f "templates/${PROJECT_TYPE}.md" ]; then
    print_color "$GREEN" "Applying $PROJECT_TYPE template..."
    cp "templates/${PROJECT_TYPE}.md" CLAUDE.md
fi

# Replace placeholders in key files
print_color "$GREEN" "\nCustomizing files for your project..."

replace_placeholders "CLAUDE.md"
replace_placeholders "planning-docs/PROJECT_OVERVIEW.md"
replace_placeholders "README.md"

# Update planning docs with project name
for file in planning-docs/*.md; do
    replace_placeholders "$file"
done

# Create tests directory structure
print_color "$GREEN" "Creating test directory structure..."
mkdir -p tests/{unit,integration,e2e,performance,security,fixtures}

# Create basic test README
cat > tests/README.md << 'EOF'
# Test Suite

This directory contains all tests for the project.

## Structure

- `unit/` - Unit tests for individual functions/methods
- `integration/` - Integration tests for component interactions
- `e2e/` - End-to-end tests for complete workflows
- `performance/` - Performance and load tests
- `security/` - Security and vulnerability tests
- `fixtures/` - Test data and mock objects

## Running Tests

See CLAUDE.md for test commands specific to this project.
EOF

# Install Claude Code agents
print_color "$GREEN" "\nInstalling Claude Code agents..."
CLAUDE_AGENTS_DIR="$HOME/.claude/agents"
mkdir -p "$CLAUDE_AGENTS_DIR"

if [ -d "agents" ]; then
    cp agents/*.md "$CLAUDE_AGENTS_DIR/" 2>/dev/null || true
    print_color "$GREEN" "✓ Agents installed to $CLAUDE_AGENTS_DIR"
fi

# Initialize git repository
print_color "$GREEN" "\nInitializing git repository..."
git init
git add .
git commit -m "Initial commit from AI Pilot Template"

# Rename planning-maintainer folder to project-manager
if [ -d "planning-docs/planning-maintainer" ]; then
    print_color "$GREEN" "Updating folder structure..."
    mv planning-docs/planning-maintainer planning-docs/project-manager
    print_color "$GREEN" "✓ Renamed planning-maintainer to project-manager"
fi

# Comprehensive cleanup of template files
print_color "$YELLOW" "\nCleanup options:"
REMOVE_TEMPLATES=$(prompt_with_default "Remove ALL template-specific files? (recommended)" "y")
if [ "$REMOVE_TEMPLATES" = "y" ]; then
    print_color "$GREEN" "Removing template files..."
    
    # Remove template variations
    [ -d "templates" ] && rm -rf templates/ && print_color "$GREEN" "  ✓ Removed templates/"
    
    # Remove template documentation
    [ -f "CLAUDE-TEMPLATE.md" ] && rm -f CLAUDE-TEMPLATE.md && print_color "$GREEN" "  ✓ Removed CLAUDE-TEMPLATE.md"
    [ -f "QUICK_START.md" ] && rm -f QUICK_START.md && print_color "$GREEN" "  ✓ Removed QUICK_START.md"
    [ -f "SHARING.md" ] && rm -f SHARING.md && print_color "$GREEN" "  ✓ Removed SHARING.md"
    
    # Remove setup scripts
    [ -f "cleanup.sh" ] && rm -f cleanup.sh && print_color "$GREEN" "  ✓ Removed cleanup.sh"
    [ -f ".templateignore" ] && rm -f .templateignore && print_color "$GREEN" "  ✓ Removed .templateignore"
    
    # Remove agent source files (already copied to ~/.claude/agents)
    [ -d "agents" ] && rm -rf agents/ && print_color "$GREEN" "  ✓ Removed agents/ (already installed)"
    
    # Create project-specific README if template README exists
    if grep -q "AI Pilot Template" README.md 2>/dev/null; then
        print_color "$YELLOW" "Creating project-specific README..."
        cat > README.md << EOF
# $PROJECT_NAME

$PROJECT_DESCRIPTION

## Getting Started

\`\`\`bash
# Build the project
$BUILD_COMMAND

# Run the project
$RUN_COMMAND

# Run tests
$TEST_COMMAND
\`\`\`

## Development with Claude Code

This project uses automated agents:
- **project-manager**: Handles documentation updates
- **test-analyst**: Manages testing

## Project Structure

- \`planning-docs/\` - Project planning and tracking
- \`docs/\` - Comprehensive documentation  
- \`tests/\` - Test suites
- \`CLAUDE.md\` - Claude Code configuration

## License

[Your license here]
EOF
        print_color "$GREEN" "  ✓ Created project-specific README.md"
    fi
    
    # Remove setup.sh itself (must be last)
    print_color "$YELLOW" "  Note: Run 'rm setup.sh' to remove the setup script"
    
    print_color "$GREEN" "\n✓ Template cleanup complete!"
else
    print_color "$YELLOW" "Template files retained. Run './cleanup.sh' later to remove them."
fi

# Summary
print_color "$BLUE" "\n======================================"
print_color "$BLUE" "        Setup Complete!               "
print_color "$BLUE" "======================================"
echo
print_color "$GREEN" "✓ Project: $PROJECT_NAME"
print_color "$GREEN" "✓ Type: $PROJECT_TYPE"
print_color "$GREEN" "✓ Language: $PRIMARY_LANGUAGE"
print_color "$GREEN" "✓ Git repository initialized"
print_color "$GREEN" "✓ Claude Code agents installed"
echo
print_color "$YELLOW" "Next steps:"
echo "1. Review and customize CLAUDE.md with your specific components"
echo "2. Fill in the planning-docs/ with your project details"
echo "3. Start coding with Claude Code!"
echo
print_color "$BLUE" "To get started with Claude Code:"
echo "  claude code ."
echo
print_color "$GREEN" "Happy coding! 🚀"