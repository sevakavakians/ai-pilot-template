# Planning Documentation System - Quick Start Guide

**READ THIS FIRST** - This README provides immediate context without overwhelming you with unnecessary details.

## Current Status Overview

### 🎯 What to read immediately:
1. **SESSION_STATE.md** - Current task, next actions, active blockers
2. **DAILY_BACKLOG.md** - Today's prioritized work items
3. **Latest session log** in `sessions/` folder (most recent timestamp)

### 📋 What to read if needed during work:
- **PROJECT_OVERVIEW.md** - When you need project context or tech stack info
- **ARCHITECTURE.md** - When making structural decisions or understanding system design
- **DECISIONS.md** - When you need to understand why past architectural choices were made
- **SPRINT_BACKLOG.md** - When planning beyond today or checking upcoming features

### 📁 What to read only when specifically investigating:
- **Historical sessions** in `sessions/` - When debugging issues or understanding previous implementation approaches
- **Completed work** in `completed/` subfolders - When building on previous features or investigating past solutions
- **planning-maintainer** folder - Only if you need to understand what the automation agent has been doing

---

## Folder Structure & Usage Guide

### 📄 Core Planning Documents (Check these regularly)
```
SESSION_STATE.md          ← Current work status - ALWAYS READ FIRST
DAILY_BACKLOG.md          ← Today's tasks - READ SECOND  
PROJECT_OVERVIEW.md       ← Project info - read when needed
ARCHITECTURE.md           ← Technical docs - read when making design decisions
DECISIONS.md              ← Decision history - read when questioning past choices
SPRINT_BACKLOG.md         ← Week's work - read for broader context
```

### 📁 Archive Folders (Read selectively)
```
sessions/YYYY-MM-DD-HHMMSS.md    ← Session logs (READ: latest only, unless investigating)
completed/features/              ← Done features (READ: only when building related functionality)
completed/bugs/                  ← Fixed bugs (READ: only when similar issues arise)  
completed/refactors/             ← Past refactors (READ: only when doing related refactoring)
completed/optimizations/         ← Performance work (READ: only when optimizing similar areas)
```

### 🤖 Agent Workspace (Usually ignore)
```
planning-maintainer/             ← Agent's workspace (READ: only if agent behavior seems wrong)
```

---

## Smart Context Loading Strategy

### ✅ Always Start With:
1. Read SESSION_STATE.md to understand current work
2. Check DAILY_BACKLOG.md for today's priorities
3. Scan latest session log for recent context

### ✅ Load Additional Context When:
- **New architectural decision needed** → Read ARCHITECTURE.md + DECISIONS.md
- **Building on previous work** → Check relevant completed/ subfolder
- **Debugging recurring issue** → Search through sessions/ folder for similar problems
- **Understanding project scope** → Read PROJECT_OVERVIEW.md
- **Planning beyond today** → Check SPRINT_BACKLOG.md
- **Investigating why something was done** → Search DECISIONS.md for rationale

### ❌ Don't Load Unless Needed:
- All historical session logs (just the latest)
- All completed work documentation (just what's relevant)
- planning-maintainer logs (unless debugging the agent)

---

## Key Principles

### 🔄 How Updates Happen:
- **planning-maintainer agent** automatically updates documents when:
  - Tasks are completed or changed
  - New requests are made
  - Blockers are identified/resolved
  - Architectural decisions are made
  - Focus areas shift

### 🎯 Your Role:
1. **Start each session**: Read this README → SESSION_STATE.md → DAILY_BACKLOG.md → latest session log
2. **During work**: Trigger planning-maintainer when completing tasks, adding new work, or making decisions
3. **Need context**: Load additional documents based on the guidance above

### ⚡ Efficiency Rules:
- **Minimum viable context**: Only read what you need for current work
- **Just-in-time loading**: Pull in historical context when you hit a specific need
- **Trust the system**: SESSION_STATE.md always reflects the current reality

---

## Quick Reference Commands

When you need to find something specific:
- **Current work**: SESSION_STATE.md
- **Today's plan**: DAILY_BACKLOG.md  
- **Why we chose X**: Search DECISIONS.md
- **How system works**: ARCHITECTURE.md
- **What we did before**: Search sessions/ or completed/
- **What's coming up**: SPRINT_BACKLOG.md

**Remember**: This system is designed to give you perfect context without information overload. Start minimal, expand as needed.
