#!/bin/bash

# AI Pilot Template Cleanup Script
# Removes template-specific files after setup, leaving only project essentials

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

# Function to prompt for confirmation
confirm() {
    prompt=$1
    read -p "$prompt [y/N]: " response
    case "$response" in
        [yY][eE][sS]|[yY]) 
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

# Welcome message
print_color "$BLUE" "======================================"
print_color "$BLUE" "  AI Pilot Template Cleanup Utility  "
print_color "$BLUE" "======================================"
echo

# Check if we're in a project with template files
if [ ! -f "CLAUDE.md" ]; then
    print_color "$RED" "Error: CLAUDE.md not found. Are you in the right directory?"
    exit 1
fi

# Detect what template files exist
print_color "$YELLOW" "Scanning for template files..."
echo

TEMPLATE_FILES=()
FOUND_FILES=()

# List of template-specific files to remove
TEMPLATE_FILES=(
    "setup.sh"
    "cleanup.sh"
    ".templateignore"
    "QUICK_START.md"
    "SHARING.md"
    "CLAUDE-TEMPLATE.md"
    "templates"
    "agents"
)

# Check which files exist
for file in "${TEMPLATE_FILES[@]}"; do
    if [ -e "$file" ]; then
        FOUND_FILES+=("$file")
        if [ -d "$file" ]; then
            print_color "$YELLOW" "  📁 $file/ (directory)"
        else
            print_color "$YELLOW" "  📄 $file"
        fi
    fi
done

if [ ${#FOUND_FILES[@]} -eq 0 ]; then
    print_color "$GREEN" "✅ No template files found. Your project is already clean!"
    exit 0
fi

echo
print_color "$BLUE" "Found ${#FOUND_FILES[@]} template file(s) to remove."
echo

# Show what will be kept
print_color "$GREEN" "The following will be KEPT:"
echo "  ✓ CLAUDE.md (your project configuration)"
echo "  ✓ planning-docs/ (project planning documents)"
echo "  ✓ docs/ (project documentation)"
echo "  ✓ tests/ (test structure)"
echo "  ✓ .git/ (git repository)"
echo "  ✓ Any project source code"
echo

# Confirm before proceeding
if ! confirm "Remove all template files?"; then
    print_color "$YELLOW" "Cleanup cancelled."
    exit 0
fi

# Create backup option
if confirm "Create backup of template files before removing? (recommended)"; then
    BACKUP_DIR=".template-backup-$(date +%Y%m%d-%H%M%S)"
    print_color "$GREEN" "Creating backup in $BACKUP_DIR..."
    mkdir -p "$BACKUP_DIR"
    
    for file in "${FOUND_FILES[@]}"; do
        if [ -e "$file" ]; then
            cp -r "$file" "$BACKUP_DIR/" 2>/dev/null || true
        fi
    done
    
    print_color "$GREEN" "✓ Backup created in $BACKUP_DIR"
    echo
fi

# Remove template files
print_color "$YELLOW" "Removing template files..."
for file in "${FOUND_FILES[@]}"; do
    if [ -e "$file" ]; then
        rm -rf "$file"
        print_color "$GREEN" "  ✓ Removed $file"
    fi
done

# Check if README needs updating
if [ -f "README.md" ]; then
    if grep -q "AI Pilot Template" README.md 2>/dev/null; then
        print_color "$YELLOW" "\n⚠️  Your README.md still contains template information."
        if confirm "Would you like to create a project-specific README?"; then
            # Get project name from CLAUDE.md or use directory name
            PROJECT_NAME=$(grep "^# " CLAUDE.md | head -1 | sed 's/# //' | sed 's/CLAUDE.md//' | xargs)
            if [ -z "$PROJECT_NAME" ] || [ "$PROJECT_NAME" = "CLAUDE.md" ]; then
                PROJECT_NAME=$(basename $(pwd))
            fi
            
            cat > README.md << EOF
# $PROJECT_NAME

This project uses AI Pilot Template for automated project management with Claude Code.

## Project Overview

[Add your project description here]

## Getting Started

\`\`\`bash
# Install dependencies
[Your install command]

# Run the project
[Your run command]

# Run tests
[Your test command]
\`\`\`

## Development with Claude Code

This project is configured to work with Claude Code's automated agents:
- **project-manager**: Handles all documentation updates
- **test-analyst**: Manages test execution and analysis

### Working with Claude Code

1. Start a session: \`claude code .\`
2. Claude will automatically read the planning documentation
3. As you work, documentation is updated automatically
4. Tests are run through the test-analyst agent

## Project Structure

- \`planning-docs/\` - Project planning and tracking
- \`docs/\` - Comprehensive documentation
- \`tests/\` - Test suites and fixtures
- \`CLAUDE.md\` - Claude Code configuration

## Documentation

See the \`docs/\` directory for detailed documentation on:
- System architecture
- API reference
- Development guidelines
- Deployment procedures

## Contributing

[Add your contribution guidelines]

## License

[Add your license information]
EOF
            print_color "$GREEN" "✓ Created project-specific README.md"
        fi
    fi
fi

# Final summary
echo
print_color "$BLUE" "======================================"
print_color "$BLUE" "        Cleanup Complete!             "
print_color "$BLUE" "======================================"
echo
print_color "$GREEN" "✅ Removed ${#FOUND_FILES[@]} template file(s)"
print_color "$GREEN" "✅ Your project now contains only essential files"

if [ -d "$BACKUP_DIR" ]; then
    echo
    print_color "$YELLOW" "💡 Tip: Template backup saved in $BACKUP_DIR"
    print_color "$YELLOW" "   You can remove it with: rm -rf $BACKUP_DIR"
fi

echo
print_color "$BLUE" "Your project is ready for development with Claude Code!"
echo
print_color "$GREEN" "Next steps:"
echo "1. Review and update CLAUDE.md if needed"
echo "2. Start coding with: claude code ."
echo "3. Let the agents handle documentation and testing!"