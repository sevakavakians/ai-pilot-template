# 🤝 Sharing Guide

How to share your AI Pilot Template configuration with your team and contribute improvements back to the community.

## Sharing with Your Team

### Option 1: Shared Repository (Recommended)

The best way to ensure team consistency is to commit the configuration to your project repository:

```bash
# In your project root
git add CLAUDE.md agents/ planning-docs/
git commit -m "Add AI Pilot Template configuration"
git push
```

Team members can then:
```bash
# Clone the project
git clone your-repo-url
cd your-project

# Install the agents locally
cp agents/*.md ~/.claude/agents/

# Start working with Claude Code
claude code .
```

### Option 2: Configuration Package

Create a shareable configuration package:

```bash
# Create a config package
tar -czf ai-pilot-config.tar.gz \
  CLAUDE.md \
  agents/ \
  planning-docs/ \
  templates/

# Share via your preferred method
# Team members extract with:
tar -xzf ai-pilot-config.tar.gz
```

### Option 3: Team Standards Repository

Create a dedicated repository for team standards:

```bash
# Create team-standards repo
mkdir team-ai-standards
cd team-ai-standards

# Copy configurations
cp -r /path/to/ai-pilot-template/* .

# Customize for your team
vim TEAM_CONVENTIONS.md

# Push to shared location
git init
git add .
git commit -m "Team AI development standards"
git remote add origin your-team-repo
git push -u origin main
```

## Setting Up Team-Wide Standards

### 1. Customize Agent Behaviors

Edit agent configurations for your team's workflow:

```markdown
# In agents/project-manager.md
Add team-specific triggers:
- Code review completion
- Sprint planning events
- Daily standup summaries
```

### 2. Define Team Conventions

Create `TEAM_CONVENTIONS.md`:

```markdown
# Team AI Development Conventions

## Commit Messages
- Use conventional commits: feat/fix/docs/chore
- Reference ticket numbers: "feat: add login [PROJ-123]"

## Documentation Updates
- Trigger project-manager after each PR merge
- Update ARCHITECTURE.md for any structural changes

## Testing Requirements
- Minimum 80% code coverage
- All PRs must pass test-analyst review
```

### 3. Standardize Commands

Ensure consistent commands across projects:

```bash
# In CLAUDE.md, standardize:
[BUILD_COMMAND] = "npm run build"
[TEST_COMMAND] = "npm test"
[LINT_COMMAND] = "npm run lint"
```

## Agent Installation for Team Members

### Automated Installation Script

Create `install-agents.sh` for your team:

```bash
#!/bin/bash
# Team agent installation script

CLAUDE_AGENTS_DIR="$HOME/.claude/agents"
mkdir -p "$CLAUDE_AGENTS_DIR"

# Download team agents
curl -L https://your-team.com/agents/project-manager.md \
  -o "$CLAUDE_AGENTS_DIR/project-manager.md"

curl -L https://your-team.com/agents/test-analyst.md \
  -o "$CLAUDE_AGENTS_DIR/test-analyst.md"

echo "✅ Team agents installed successfully!"
```

### Manual Installation

Share these instructions with your team:

1. **Download agent files** from team repository
2. **Copy to Claude Code directory**:
   ```bash
   cp agents/*.md ~/.claude/agents/
   ```
3. **Verify installation**:
   ```bash
   ls ~/.claude/agents/
   ```

## Contributing Improvements

### Back to This Template

If you've made improvements that could benefit others:

1. **Fork the template repository**
2. **Make your improvements**
3. **Submit a pull request** with:
   - Description of changes
   - Use cases that benefit
   - Any breaking changes

Example improvements to contribute:
- New project type templates
- Additional agent configurations
- Workflow optimizations
- Documentation enhancements

### To Your Organization

Create an internal improvement process:

```markdown
# In CONTRIBUTING.md

## Suggesting Template Improvements

1. Create issue in team-standards repo
2. Describe the improvement
3. Provide example usage
4. Get team consensus
5. Update shared configuration
```

## Version Control for Configurations

### Tracking Configuration Changes

```bash
# Tag configuration versions
git tag -a v1.0.0 -m "Initial team configuration"
git push --tags

# Team members can use specific versions
git checkout tags/v1.0.0
```

### Configuration Changelog

Maintain a `CHANGELOG.md`:

```markdown
# Configuration Changelog

## [1.1.0] - 2024-01-15
### Added
- New test-analyst triggers for performance testing
- Data pipeline project template

### Changed
- Updated project-manager to handle microservices
- Improved setup.sh with more language options

### Fixed
- Agent path issues on Windows
```

## Best Practices for Team Sharing

### DO's ✅

1. **Version your configurations** - Tag releases for stability
2. **Document customizations** - Explain team-specific changes
3. **Provide examples** - Show how to use custom features
4. **Regular updates** - Keep configurations current
5. **Gather feedback** - Improve based on team experience

### DON'Ts ❌

1. **Don't hardcode paths** - Use relative or configurable paths
2. **Don't include secrets** - Keep sensitive data separate
3. **Don't force overwrites** - Respect local customizations
4. **Don't break compatibility** - Version breaking changes
5. **Don't ignore feedback** - Address team pain points

## Collaboration Workflows

### For Open Source Projects

```yaml
# .github/ai-pilot.yml
name: AI Pilot Template
version: 1.0.0
agents:
  - project-manager
  - test-analyst
conventions:
  - file: CLAUDE.md
  - file: CONTRIBUTING.md
```

### For Enterprise Teams

```json
// ai-pilot-config.json
{
  "version": "1.0.0",
  "team": "platform-team",
  "agents": {
    "project-manager": {
      "source": "https://internal.company.com/agents/project-manager.md",
      "version": "2.1.0"
    },
    "test-analyst": {
      "source": "https://internal.company.com/agents/test-analyst.md",
      "version": "1.5.0"
    }
  },
  "standards": {
    "testing": {
      "coverage": 80,
      "framework": "jest"
    }
  }
}
```

## Troubleshooting Shared Configurations

### Common Issues and Solutions

| Issue | Solution |
|-------|----------|
| Agents not found | Ensure agents are in `~/.claude/agents/` |
| Different OS paths | Use environment variables |
| Version conflicts | Use tagged versions |
| Custom modifications lost | Maintain local overrides file |
| Team member confusion | Provide clear onboarding docs |

## Support and Community

### Getting Help
- **Template Issues**: [GitHub Issues](https://github.com/your-username/ai-pilot-template/issues)
- **Team Setup**: Contact your team lead
- **Claude Code**: [Official Documentation](https://docs.anthropic.com/claude-code)

### Sharing Your Success
- Share your setup on social media with #AIPilotTemplate
- Write blog posts about your team's workflow
- Contribute case studies to the repository

---

**Remember**: The best configuration is one that your entire team uses consistently. Start simple and evolve based on your needs! 🚀