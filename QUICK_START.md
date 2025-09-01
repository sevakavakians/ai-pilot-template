# 🚀 Quick Start Guide

Get your AI-powered development environment running in 5 minutes!

## Prerequisites

- [Claude Code](https://claude.ai/code) installed
- Git
- Your preferred programming language environment (Node.js, Python, etc.)

## 5-Minute Setup

### 1. Clone and Run Setup (2 minutes)

```bash
# Clone the template
git clone https://github.com/your-username/ai-pilot-template.git my-project
cd my-project

# Run the interactive setup
./setup.sh
```

The setup wizard will ask you for:
- Project name
- Project description  
- Project type (web-app, api-service, cli-tool, library, or generic)
- Primary language
- Build/test commands (with sensible defaults)

### 2. Quick Customization (2 minutes)

After setup, quickly customize these key files:

#### CLAUDE.md
Replace remaining placeholders:
- `[COMPONENT_1]`, `[COMPONENT_2]` - Your main components
- `[DATABASE]`, `[CACHE]` - Your tech stack choices
- `[ENV_VAR_1]`, `[ENV_VAR_2]` - Your environment variables

#### planning-docs/PROJECT_OVERVIEW.md
Fill in:
- Project goals
- Success metrics
- Team members
- Timeline

### 3. Start Coding! (1 minute)

```bash
# Open with Claude Code
claude code .

# Claude will automatically:
# 1. Read the planning system
# 2. Understand your project structure
# 3. Use the project-manager and test-analyst agents
```

## What Happens Automatically

When you start working with Claude Code:

✅ **On Session Start**
- Claude reads your project context
- Loads current tasks and progress
- Understands your tech stack

✅ **During Development**
- Task completions trigger documentation updates
- Architectural decisions are logged
- Blockers are tracked and resolved
- Tests run automatically after changes

✅ **Project Management**
- The `project-manager` agent maintains all documentation
- Progress is tracked in SESSION_STATE.md
- Completed work is archived automatically

✅ **Testing**
- The `test-analyst` agent runs all tests
- Test results are documented
- Infrastructure issues are auto-fixed

## Common Customizations

### For Web Applications
```bash
# Use the web-app template
cp templates/web-app.md CLAUDE.md

# Common tech stacks:
# React + TypeScript + Vite
# Vue + JavaScript + Webpack
# Angular + TypeScript + CLI
```

### For API Services
```bash
# Use the api-service template
cp templates/api-service.md CLAUDE.md

# Common stacks:
# Node.js + Express + PostgreSQL
# Python + FastAPI + MongoDB
# Go + Gin + Redis
```

### For Libraries
```bash
# Use the library template
cp templates/library.md CLAUDE.md

# Publishing setup:
# npm - package.json
# PyPI - setup.py or pyproject.toml
# crates.io - Cargo.toml
```

## Quick Command Reference

### Working with Claude Code
```bash
# Start a session
claude code .

# Resume previous session
claude code . --resume

# Get help
/help
```

### Triggering Agents

**Never edit planning-docs/ directly!** Instead:

```
# After completing a feature:
"I've finished the login feature"
# Claude triggers project-manager automatically

# To run tests:
"Run all tests"
# Claude triggers test-analyst automatically
```

## Troubleshooting

### Issue: Agents not working
```bash
# Reinstall agents
cp agents/*.md ~/.claude/agents/
```

### Issue: Tests not found
```bash
# Update test commands in CLAUDE.md
# Look for [TEST_COMMAND] placeholders
```

### Issue: Wrong project type
```bash
# Switch templates
cp templates/[type].md CLAUDE.md
# Re-run placeholder replacement
```

## Tips for Maximum Productivity

1. **Let agents work**: Don't manually edit planning-docs/
2. **Trust the system**: Documentation updates happen automatically
3. **Be specific**: Clear task descriptions help agents work better
4. **Review patterns**: Check `planning-docs/project-manager/patterns.md` weekly
5. **Use shortcuts**: Learn Claude Code keyboard shortcuts with `/help`

## Next Steps

- 📖 Read the full [README.md](README.md) for complete documentation
- 🤝 Check [SHARING.md](SHARING.md) to share with your team
- 📚 Explore `docs/` for comprehensive project documentation templates
- 🎯 Start with a small task to see the system in action

## Getting Help

- **Claude Code Help**: Type `/help` in Claude Code
- **Template Issues**: Check the [GitHub Issues](https://github.com/your-username/ai-pilot-template/issues)
- **Agent Problems**: Review agent configurations in `agents/`

---

**Ready to code?** Open Claude Code and let the AI-powered development begin! 🎉