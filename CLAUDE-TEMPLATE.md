This project is ONLY for creating a template that is reusable by Claude Code. 
DO NOT PROCESS THIS FILE!
DO NOT FOLLOW THE INSTRUCTIONS HERE!

## Automated Planning System Protocol

### Every Session Start:
1. READ `planning-docs/README.md` to understand the current system state
2. The README will guide you to the most relevant documents for immediate context
3. Only read additional documents when specifically needed for the current work

### Trigger Planning-Maintainer When:
Use the Task tool with subagent_type="planning-maintainer" when these events occur:
- **Task Completion** → Agent will update SESSION_STATE, archive work, refresh backlogs
- **New Tasks Created** → Agent will add to backlogs with time estimates
- **Priority Changes** → Agent will reorder backlogs and update dependencies
- **Blocker Encountered** → Agent will log blocker, suggest alternative tasks
- **Blocker Resolved** → Agent will update estimates, clear blocker status
- **Architectural Decision** → Agent will update DECISIONS.md and ARCHITECTURE.md
- **New Specifications** → Agent will parse into tasks, update scope
- **Context Switch** → Agent will create session log, update current state
- **Milestone Reached** → Agent will archive phase, update project overview
- **Knowledge Refinement** → Agent will replace assumptions with verified facts across all docs

### Context Loading Strategy (Read-Only):

Start with minimal context and expand as needed:
1. **Always read first**: `planning-docs/README.md` → `SESSION_STATE.md` → `DAILY_BACKLOG.md` → Latest session log
2. **Load on demand**: Other documents only when relevant to current task
3. **Historical data**: Access `sessions/` and `completed/` folders only when investigating specific issues

### Event-Driven Documentation

Trigger the planning-maintainer agent automatically when:

#### Task Management Events
- ✅ Completing any task or subtask
- ➕ Adding new tasks or changing priorities
- 🔄 Moving tasks between backlogs
- ⏱️ Starting work on a new task (mark as in_progress)

#### Development Events
- 🚫 Encountering or resolving blockers
- 🏗️ Making architectural decisions
- 📦 Adding or updating dependencies
- 🔧 Making significant refactors
- 🔍 Discovering verified facts that replace assumptions

#### Context Events
- 📝 Receiving new specifications or requests
- 🎯 Switching focus areas or context
- 🏆 Reaching project milestones
- 📊 Completing significant features

### Planning-Maintainer Integration 

When triggering the planning-maintainer:
```
Trigger: [Event type]
Action: Update [specific documents]
Context: [What changed and why]
```

The agent will handle:  
- Updating SESSION_STATE.md with current progress
- Moving completed items to archived folders
- Updating backlogs with new priorities
- Logging decisions with timestamps
- Calculating actual vs estimated times

### Working with the System

#### Starting Work
1. Read `planning-docs/README.md` for context strategy
2. Load `SESSION_STATE.md` to see current task
3. Check `DAILY_BACKLOG.md` for today's priorities
4. Review latest session for recent context

#### During Work
- Mark tasks as `in_progress` when starting
- Mark tasks as `completed` immediately when done
- Log blockers as soon as identified
- Document decisions when made

#### Ending Work
- Ensure SESSION_STATE.md reflects current status
- Completed tasks should be marked as such
- Note any discoveries in context stack

### Document Update Responsibilities

**Claude Code's Responsibility**: 
- READ planning documentation for context
- TRIGGER planning-maintainer agent for all documentation updates
- EXECUTE development tasks

**Planning-Maintainer's Responsibility**:
- ALL updates to planning-docs files
- Archive completed work
- Update progress percentages
- Documentation archival and organization
- Pattern tracking and velocity calculations
- Calculate and refine time estimate
- Mark task status changes (pending → in_progress → completed)
- Organize session logs
- Sync documentation
- Add new tasks to backlogs
- Document architectural decisions
- Update blockers when found/resolved

**Important**: Claude Code should NEVER directly edit files in planning-docs/. All documentation updates must go through the planning-maintainer agent.

### How to Trigger the Planning-Maintainer:
```
Example: After completing a task
assistant: "I've finished implementing the OAuth2 authentication feature. Let me trigger the planning-maintainer to update our documentation."
<uses Task tool with subagent_type="planning-maintainer">

The planning-maintainer will automatically:
- Update SESSION_STATE.md progress
- Archive the completed task
- Refresh the backlogs
- Calculate actual vs estimated time
- Log any patterns observed

