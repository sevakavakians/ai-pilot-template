# CLAUDE.md - Claude Code Integration Protocol

## Automated Planning System Protocol

### Every Session Start
- READ `planning-docs/README.md` to understand the current system state
- The README will guide you to the most relevant documents for immediate context
- Only read additional documents when specifically needed for the current work

### Context Loading Strategy
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

#### Your Manual Updates
- Mark task status changes (pending → in_progress → completed)
- Add new tasks to backlogs
- Document architectural decisions
- Update blockers when found/resolved

#### Automated by planning-maintainer
- Archive completed work
- Update progress percentages
- Calculate time estimates
- Organize session logs
- Sync documentation

### Quick Reference

| Task | Document | Action |
|------|----------|--------|
| Current work status | SESSION_STATE.md | Read first, update frequently |
| Today's tasks | DAILY_BACKLOG.md | Check priorities, mark completions |
| Architectural choice | DECISIONS.md | Log with timestamp and rationale |
| Technical structure | ARCHITECTURE.md | Update when adding components |
| Weekly planning | SPRINT_BACKLOG.md | Review weekly, update as needed |
| Project scope | PROJECT_OVERVIEW.md | Reference for context |

### Performance Optimization

To maintain high productivity:
- **Minimal context loading**: Only read what's needed for current task
- **Immediate updates**: Mark completions as they happen
- **Trust automation**: Let planning-maintainer handle routine updates
- **Batch similar work**: Group related tasks to maintain focus

### Error Handling

If planning-maintainer fails:
1. Check `planning-maintainer/maintenance-log.md` for errors
2. Manually update critical documents
3. Flag issue in `planning-maintainer/pending-updates.md`

---

## Project-Specific Configuration

### Development Commands
```bash
# Add your project-specific commands here
# npm run dev
# npm test
# npm run build
```

### Code Style Guidelines
- Follow existing patterns in the codebase
- Check neighboring files for conventions
- Use existing libraries before adding new ones

### Testing Requirements
- Run tests before marking features complete
- Check for linting errors
- Verify builds succeed

---

*This file integrates Claude Code with the automated planning system for maximum development efficiency.*