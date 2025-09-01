# AI Pilot Template

A comprehensive planning documentation framework for AI-assisted software development with Claude Code. This template provides automated project continuity and documentation maintenance for high-intensity development workflows.

## 🎯 Purpose

This template creates a standardized, event-driven documentation system that maintains perfect project continuity across long development sessions (12+ hours daily). It's designed to be the starting point for new projects, providing a zero-friction planning system that works seamlessly with Claude Code.

## 🚀 Quick Start

### Automatic Setup (Recommended) - 5 Minutes!

```bash
# Clone and run the interactive setup
git clone https://github.com/your-username/ai-pilot-template.git my-project
cd my-project
./setup.sh
```

The setup wizard will:
- Ask for your project details
- Apply the right template (web-app, api-service, cli-tool, library)
- Configure your development commands
- Install Claude Code agents
- Initialize git repository

### Manual Setup

1. **Clone this template** for your new project
2. **Choose a template** from `templates/` if needed
3. **Fill in placeholders** marked with `[BRACKETS]` in CLAUDE.md
4. **Install agents** by copying `agents/*.md` to `~/.claude/agents/`
5. **Start coding** - Claude Code will automatically maintain your documentation

**Need help?** Check out [QUICK_START.md](QUICK_START.md) for a detailed 5-minute guide!

## 📁 Project Structure

```
ai-pilot-template/
├── CLAUDE.md                    # Universal template with placeholders
├── QUICK_START.md              # 5-minute setup guide
├── SHARING.md                  # Team collaboration guide
├── setup.sh                    # Interactive setup script
├── templates/                  # Project-type specific templates
│   ├── web-app.md             # Web application template
│   ├── api-service.md         # API/microservice template
│   ├── cli-tool.md            # CLI tool template
│   └── library.md             # Library/package template
├── agents/                     # Claude Code agent configurations
│   ├── project-manager.md     # Automated documentation agent
│   └── test-analyst.md        # Comprehensive testing agent
├── tests/                      # Test suite structure
│   ├── unit/                  # Unit test templates
│   ├── integration/           # Integration test templates
│   ├── e2e/                   # End-to-end test templates
│   ├── performance/           # Performance test templates
│   ├── security/              # Security test templates
│   ├── fixtures/              # Test data and mocks
│   ├── README.md              # Testing documentation
│   └── TEST-RESULTS.md        # Test execution results
├── planning-docs/               # Planning & project management
│   ├── README.md               # Context loading guide (start here)
│   ├── SESSION_STATE.md        # Current work status
│   ├── DAILY_BACKLOG.md        # Today's prioritized tasks
│   ├── SPRINT_BACKLOG.md       # Weekly planning
│   ├── PROJECT_OVERVIEW.md     # Project information
│   ├── ARCHITECTURE.md         # Technical documentation
│   ├── DECISIONS.md            # Architectural decision log
│   ├── sessions/               # Historical session logs
│   ├── completed/              # Archived completed work
│   │   ├── features/
│   │   ├── bugs/
│   │   ├── refactors/
│   │   └── optimizations/
│   └── planning-maintainer/    # Agent workspace
│       ├── agent-prompt.md
│       ├── maintenance-log.md
│       └── pending-updates.md
└── docs/                        # Comprehensive documentation
    ├── product/                 # Product & business docs
    │   ├── SPECIFICATIONS.md   # Requirements & user stories
    │   ├── ROADMAP.md          # Product timeline
    │   ├── USER_PERSONAS.md    # Target users
    │   └── METRICS.md          # KPIs & analytics
    ├── technical/              # Technical documentation
    │   ├── SYSTEM_DESIGN.md    # Architecture overview
    │   ├── API_REFERENCE.md    # API documentation
    │   ├── DATA_MODEL.md       # Database schemas
    │   ├── INTEGRATIONS.md     # Third-party services
    │   └── INFRASTRUCTURE.md   # Cloud & DevOps
    ├── development/            # Development guides
    │   ├── SETUP.md           # Environment setup
    │   ├── CONVENTIONS.md      # Code standards
    │   ├── TESTING.md         # Testing strategy
    │   ├── SECURITY.md        # Security practices
    │   └── PERFORMANCE.md     # Optimization guides
    ├── operations/             # Operational procedures
    │   ├── DEPLOYMENT.md      # Deploy procedures
    │   ├── MONITORING.md      # Observability
    │   ├── RUNBOOK.md         # Incident response
    │   ├── DISASTER_RECOVERY.md # DR plan
    │   └── SCALING.md         # Scaling strategies
    └── design/                 # Design documentation
        ├── DESIGN_SYSTEM.md    # UI components
        ├── BRAND_GUIDELINES.md # Brand standards
        ├── ACCESSIBILITY.md    # A11y guidelines
        └── USER_FLOWS.md      # UX journeys
```

## 📚 Comprehensive Documentation System

The template now includes a complete documentation framework using the MECE (Mutually Exclusive, Collectively Exhaustive) principle:

### Documentation Categories

1. **Product Documentation** (`docs/product/`)
   - Requirements and specifications
   - Product roadmap and timeline
   - User personas and research
   - Metrics and KPIs

2. **Technical Documentation** (`docs/technical/`)
   - System design and architecture
   - API reference and contracts
   - Data models and schemas
   - Third-party integrations
   - Infrastructure and cloud resources

3. **Development Documentation** (`docs/development/`)
   - Environment setup guides
   - Code conventions and standards
   - Testing strategies
   - Security best practices
   - Performance optimization

4. **Operations Documentation** (`docs/operations/`)
   - Deployment procedures
   - Monitoring and observability
   - Incident response runbooks
   - Disaster recovery plans
   - Scaling strategies

5. **Design Documentation** (`docs/design/`)
   - Design system and components
   - Brand guidelines
   - Accessibility standards
   - User flows and journey maps

Each template includes:
- Clear purpose and audience
- Comprehensive sections with examples
- Industry best practices
- Placeholder content for customization
- Update frequency guidelines

## 🔑 Key Features

### Event-Driven Documentation
Automatically updates planning docs when key development events occur:
- ✅ Task completions
- ➕ New tasks or priority changes
- 🚫 Blockers identified or resolved
- 🏗️ Architectural decisions
- 📝 New specifications received
- 🔄 Context switches
- 🏆 Milestone completions

### Smart Context Loading
Minimal context strategy that prevents information overload:
1. **Always read first**: README → SESSION_STATE → DAILY_BACKLOG → Latest session
2. **Load on demand**: Other documents only when relevant
3. **Historical data**: Access archives only when investigating specific issues

### Automated Maintenance
The planning-maintainer agent silently handles:
- Document synchronization
- Task archival and organization
- Time estimate refinements
- Pattern recognition
- Context preservation
- Dependency mapping

### Perfect Project Continuity
- **Zero "where were we?" moments** when resuming work
- **Time estimates within 20% accuracy** based on historical data
- **All decisions documented** with context and rationale
- **Clean, searchable documentation** always current
- **Seamless context switches** between features or focus areas

## 💡 Problems This Solves

| Problem | Solution |
|---------|----------|
| **Context Loss** | Automatic session logging preserves exact state between development sessions |
| **Documentation Drift** | Event-driven updates keep docs synchronized with actual work |
| **Planning Overhead** | Automated documentation reduces manual burden on developers |
| **Progress Tracking** | Accurate time estimates and velocity metrics updated automatically |
| **Decision History** | Architectural choices preserved with rationale and alternatives |
| **Task Management** | Intelligent backlog organization with dependency tracking |

## 🛠️ How to Use This Template

### Step 1: Initial Setup
```bash
# Clone or fork this template
git clone https://github.com/sevakavakians/ai-pilot-template.git my-project
cd my-project

# Remove template git history
rm -rf .git
git init
```

### Step 2: Configure Project Details
Fill in placeholders in these files:
- `planning-docs/PROJECT_OVERVIEW.md` - Project name, tech stack, goals
- `planning-docs/ARCHITECTURE.md` - System design, components
- `CLAUDE.md` - Development commands (build, test, lint)
- `docs/` folder templates - Fill in project-specific documentation as needed

### Step 3: Choose Your Project Type
The template includes specialized configurations for different project types:

- **web-app**: React/Vue/Angular applications
- **api-service**: REST/GraphQL APIs
- **cli-tool**: Command-line tools
- **library**: NPM/PyPI packages
- **generic**: General purpose (default)

### Step 4: Run the Setup Script
```bash
./setup.sh
```

This interactive script will:
- Prompt for project details
- Apply the appropriate template
- Replace all placeholders
- Install agents automatically
- Initialize git repository

### Agents Included

#### project-manager
**Purpose**: Automatically maintains and updates project planning documentation in response to development events.

**Triggers on**:
- Task completions (features, bugs, refactors)
- New task creation or priority changes
- Blocker identification or resolution
- Architectural decisions
- New specifications or scope changes
- Context switches between features
- Milestone completions
- Knowledge refinement (replacing assumptions with facts)

**What it does**:
- Updates SESSION_STATE.md with current progress
- Archives completed work with timestamps
- Manages backlogs and task priorities
- Documents architectural decisions
- Tracks patterns and productivity insights
- Preserves context between sessions

#### test-analyst
**Purpose**: Comprehensive testing and analysis after significant code changes.

**Use after**:
- Completing new features
- Finishing bug fixes
- Major refactoring work
- Architectural changes
- Any significant code modifications

**What it does**:
- Executes all available test suites (unit, integration, e2e)
- Performs static code analysis (linters, type checkers)
- Analyzes container logs when applicable
- Creates detailed TEST-RESULTS.md documentation
- Identifies and documents test failures with root cause analysis
- Provides actionable recommendations for fixes
- Self-corrects testing infrastructure issues

### Step 4: Start Development
When using Claude Code:
1. Claude will automatically read the planning system on session start
2. As you work, the planning-maintainer agent updates documentation
3. Task completions, decisions, and blockers are logged automatically
4. Context is preserved perfectly between sessions

## 📋 Document Purposes

| Document | Purpose | Update Frequency |
|----------|---------|------------------|
| **SESSION_STATE.md** | Current task, progress, blockers | Continuously during work |
| **DAILY_BACKLOG.md** | Today's prioritized work | Daily, on task completion |
| **SPRINT_BACKLOG.md** | Weekly planning, feature pipeline | Weekly or on major changes |
| **PROJECT_OVERVIEW.md** | Project info, tech stack, metrics | On scope/stack changes |
| **ARCHITECTURE.md** | Technical design, patterns | On structural changes |
| **DECISIONS.md** | Architectural choices with rationale | On each decision (append-only) |

## 🤖 Claude Code Agents

This template includes two specialized agents that work together to maintain project continuity and ensure code quality. Agent configurations are stored in the `agents/` directory.

### Project-Manager Agent (project-manager.md)
Handles all documentation updates automatically, only surfacing critical issues:
- **Consistently wrong estimates** (>50% variance)
- **Recurring blockers** (same issue 3+ times)
- **Scope creep** affecting timeline
- **Technical debt crisis** (>30% productivity impact)
- **Architecture conflicts** with established patterns

### Test-Analyst Agent (test-analyst.md)
Ensures comprehensive testing after code changes:
- Runs all test suites in proper order
- Performs static and dynamic analysis
- Documents results with actionable insights
- Self-corrects testing infrastructure issues
- Provides debugging guidance for failures

## 🎯 Success Metrics

When properly configured, this template provides:
- ✅ Perfect context preservation across sessions
- ✅ Automated documentation that stays current
- ✅ Time tracking with <20% estimate variance
- ✅ Complete decision history with rationale
- ✅ Zero-friction task management
- ✅ Proactive workflow optimization insights

## 📚 Best Practices

1. **Let automation work**: Trust the planning-maintainer to handle routine updates
2. **Minimal context loading**: Only read what's needed for current task
3. **Immediate updates**: Mark task status changes as they happen
4. **Document decisions**: Log architectural choices when made
5. **Review patterns**: Check `planning-maintainer/patterns.md` weekly for insights

## 🔧 Customization

This template is designed to be adapted to your specific workflow:

### Quick Customization
- Run `./setup.sh` for interactive configuration
- Choose from pre-built templates in `templates/`
- All placeholders marked with `[BRACKETS]` for easy finding

### Advanced Customization
- Modify document templates to match your project structure
- Adjust the agent triggers for your development style
- Add project-specific sections to planning documents
- Create your own project type templates

### Sharing with Your Team
See [SHARING.md](SHARING.md) for:
- Team setup instructions
- Configuration management
- Collaborative workflows
- Contributing improvements back

## 🎯 What's New in This Version

### Universal Template System
- ✅ Clear `[PLACEHOLDER]` markers throughout
- ✅ Project type templates (web, API, CLI, library)
- ✅ Interactive setup script
- ✅ 5-minute quick start guide

### Enhanced Testing
- ✅ Complete test folder structure
- ✅ Test templates for all types
- ✅ TEST-RESULTS.md automation
- ✅ Comprehensive testing guide

### Better Collaboration
- ✅ Team sharing guide
- ✅ Standardized agent names
- ✅ Configuration management
- ✅ Version control strategies

## 📄 License

This template is open source and available for use in any project. Feel free to modify and adapt it to your needs.

## 🤝 Contributing

Improvements to the template are welcome! If you develop useful additions or refinements, consider sharing them back to help other developers.

### How to Contribute
1. Fork the repository
2. Create your feature branch
3. Add your improvements
4. Submit a pull request

See [SHARING.md](SHARING.md) for more details on sharing improvements.

---

*Built for developers who value productivity, continuity, and intelligent automation in their AI-assisted development workflow.*
