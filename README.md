# AI Pilot Template

A comprehensive planning documentation framework for AI-assisted software development with Claude Code. This template provides automated project continuity and documentation maintenance for high-intensity development workflows.

## 🎯 Purpose

This template creates a standardized, event-driven documentation system that maintains perfect project continuity across long development sessions (12+ hours daily). It's designed to be the starting point for new projects, providing a zero-friction planning system that works seamlessly with Claude Code.

## 🚀 Quick Start

1. **Clone this template** for your new project
2. **Fill in project-specific details** in the planning documents (marked with placeholders like `[Project Name]`)
3. **Configure development commands** in `CLAUDE.md` (build, test, lint commands)
4. **Start coding** - Claude Code will automatically maintain your documentation

## 📁 Project Structure

```
ai-pilot-template/
├── CLAUDE.md                    # Claude Code integration protocol
├── Planning-Maintainer.md       # Agent configuration
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

### Step 3: Create the Planning-Maintainer Agent
To enable automated documentation updates, create a custom Claude Code agent:

1. **Open Claude Code settings** to create a new agent
2. **Name the agent**: `planning-maintainer`
3. **Copy the agent configuration** from `Planning-Maintainer.md` 
4. **Use this exact description** for the agent:
   ```
   Use this agent when you need to automatically maintain and update project planning 
   documentation in response to development events. This includes task completions, 
   new task creation, status changes, blocker events, architectural decisions, 
   new specifications, context switches, milestone completions, or knowledge refinement 
   (when assumptions are replaced with verified facts). The agent works silently to 
   keep documentation current and only surfaces critical issues that need human attention.
   ```
5. **Save the agent** - it will now automatically trigger on relevant events

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

## 🤖 Planning-Maintainer Agent

The automated agent responds to development events and maintains documentation without interrupting your flow. The full agent prompt and configuration can be found in `Planning-Maintainer.md`.

### Agent Creation Instructions
To set up the planning-maintainer agent in Claude Code:
1. Create a new agent named `planning-maintainer`
2. Use the description provided in Step 3 above
3. Copy the full prompt from `Planning-Maintainer.md` lines 10-199

### What the Agent Handles
The agent only surfaces critical issues that need human attention:
- **Consistently wrong estimates** (>50% variance)
- **Recurring blockers** (same issue 3+ times)
- **Scope creep** affecting timeline
- **Technical debt crisis** (>30% productivity impact)
- **Architecture conflicts** with established patterns

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
- Modify document templates to match your project structure
- Adjust the planning-maintainer triggers for your development style
- Add project-specific sections to planning documents
- Configure your preferred development commands in CLAUDE.md

## 📄 License

This template is open source and available for use in any project. Feel free to modify and adapt it to your needs.

## 🤝 Contributing

Improvements to the template are welcome! If you develop useful additions or refinements, consider sharing them back to help other developers.

---

*Built for developers who value productivity, continuity, and intelligent automation in their AI-assisted development workflow.*