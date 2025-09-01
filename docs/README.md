# Documentation Templates Guide

This directory contains comprehensive documentation templates organized using the MECE (Mutually Exclusive, Collectively Exhaustive) framework. Each template is designed to be immediately useful while remaining customizable for your specific needs.

## 📚 Documentation Categories

### 1. Product Documentation (`product/`)
Strategic and business-oriented documentation for stakeholders and product teams.

| Template | Purpose | Primary Audience | Update Frequency |
|----------|---------|------------------|------------------|
| **SPECIFICATIONS.md** | Requirements, user stories, acceptance criteria | Product, Dev, QA | Per sprint/feature |
| **ROADMAP.md** | Timeline, milestones, release planning | All stakeholders | Monthly/Quarterly |
| **USER_PERSONAS.md** | Target users, needs, pain points | Product, Design, Dev | Quarterly |
| **METRICS.md** | KPIs, analytics, success metrics | Product, Management | Weekly/Monthly |

### 2. Technical Documentation (`technical/`)
System architecture and technical specifications for developers and architects.

| Template | Purpose | Primary Audience | Update Frequency |
|----------|---------|------------------|------------------|
| **SYSTEM_DESIGN.md** | Architecture, components, data flow | Dev, Architects | Major changes |
| **API_REFERENCE.md** | Endpoints, contracts, examples | Dev, External teams | Per API change |
| **DATA_MODEL.md** | Schemas, relationships, migrations | Dev, Data team | Schema changes |
| **INTEGRATIONS.md** | Third-party services, APIs | Dev, DevOps | New integrations |
| **INFRASTRUCTURE.md** | Cloud resources, networking | DevOps, SRE | Infrastructure changes |

### 3. Development Documentation (`development/`)
Guidelines and standards for the development team.

| Template | Purpose | Primary Audience | Update Frequency |
|----------|---------|------------------|------------------|
| **SETUP.md** | Environment setup, prerequisites | New developers | Tool changes |
| **CONVENTIONS.md** | Code standards, style guides | All developers | Quarterly review |
| **TESTING.md** | Test strategy, coverage goals | Dev, QA | Test tool changes |
| **SECURITY.md** | Security practices, vulnerabilities | Dev, Security team | Security updates |
| **PERFORMANCE.md** | Optimization, benchmarks | Dev, SRE | Performance reviews |

### 4. Operations Documentation (`operations/`)
Deployment, monitoring, and incident response procedures.

| Template | Purpose | Primary Audience | Update Frequency |
|----------|---------|------------------|------------------|
| **DEPLOYMENT.md** | Deploy procedures, rollback | DevOps, SRE | Process changes |
| **MONITORING.md** | Metrics, alerts, dashboards | DevOps, SRE | Alert changes |
| **RUNBOOK.md** | Incident response, troubleshooting | On-call engineers | After incidents |
| **DISASTER_RECOVERY.md** | Backup, recovery procedures | DevOps, Management | Annual review |
| **SCALING.md** | Scaling strategies, limits | DevOps, Architects | Capacity planning |

### 5. Design Documentation (`design/`)
UI/UX guidelines and design standards.

| Template | Purpose | Primary Audience | Update Frequency |
|----------|---------|------------------|------------------|
| **DESIGN_SYSTEM.md** | Components, patterns, guidelines | Design, Frontend | Component changes |
| **BRAND_GUIDELINES.md** | Colors, typography, logos | Design, Marketing | Brand updates |
| **ACCESSIBILITY.md** | A11y standards, WCAG compliance | Design, Dev | Standard updates |
| **USER_FLOWS.md** | User journeys, interaction maps | Design, Product | Feature changes |

## 🎯 How to Use These Templates

### Step 1: Identify What You Need

Use this decision tree:
```
Is it about...
├── Business/Product? → product/
├── System Architecture? → technical/
├── How to build? → development/
├── How to run? → operations/
└── How it looks? → design/
```

### Step 2: Fill In the Templates

Each template contains:
- **Placeholder sections** marked with `[BRACKETS]`
- **Example content** to guide you
- **Best practices** for that type of documentation
- **Update frequency** recommendations

### Step 3: Customize for Your Project

1. **Remove irrelevant sections** - Not every project needs every section
2. **Add project-specific sections** - Your project may have unique needs
3. **Adjust terminology** - Use your team's language
4. **Set review schedules** - Plan regular updates

## 📝 Template Structure

Each template follows this structure:

```markdown
# Document Title

**Purpose**: Why this document exists
**Audience**: Who should read this
**Update Frequency**: How often to review/update

## Overview
High-level introduction

## Main Sections
Detailed content organized logically

## Examples
Concrete examples and code samples

## Best Practices
Recommendations and guidelines

## References
Links to related resources
```

## 🔄 Keeping Documentation Current

### Automated Updates via project-manager

The project-manager agent automatically updates:
- Architectural decisions in DECISIONS.md
- Technical details when code changes
- Progress tracking in planning-docs/

### Manual Review Schedule

| Documentation Type | Review Frequency | Trigger Events |
|-------------------|------------------|----------------|
| Product specs | Per sprint | New features, requirement changes |
| Technical docs | Quarterly | Architecture changes, major refactors |
| Development guides | Bi-annually | Tool updates, team growth |
| Operations docs | After incidents | Outages, process improvements |
| Design docs | Per release | UI changes, rebrand |

## 💡 Best Practices

### DO's ✅
1. **Start simple** - Begin with essential sections, expand over time
2. **Use examples** - Concrete examples are worth 1000 words
3. **Include diagrams** - Visual representations aid understanding
4. **Version control** - Track all documentation changes
5. **Link extensively** - Connect related documents
6. **Date updates** - Include "Last Updated" timestamps

### DON'Ts ❌
1. **Don't duplicate** - Link to source of truth instead
2. **Don't overwrite** - Preserve history with versioning
3. **Don't neglect** - Outdated docs are worse than no docs
4. **Don't gatekeep** - Make docs accessible to all who need them
5. **Don't perfectize** - Good enough today beats perfect tomorrow

## 🎨 Customization Examples

### For Startups
- Focus on: SPECIFICATIONS, SETUP, API_REFERENCE
- Minimize: DISASTER_RECOVERY, SCALING
- Combine: Merge similar docs to reduce overhead

### For Enterprise
- Expand: Add compliance sections, audit trails
- Separate: Split docs by team/department
- Automate: Generate from code where possible

### For Open Source
- Prioritize: SETUP, CONVENTIONS, API_REFERENCE
- Add: CONTRIBUTING.md, CODE_OF_CONDUCT.md
- Public: Make all non-sensitive docs public

## 📊 Documentation Metrics

Track documentation health:

```markdown
## Documentation Coverage Scorecard

| Area | Coverage | Last Updated | Owner |
|------|----------|--------------|-------|
| Product | 80% | 2024-01-15 | Product Team |
| Technical | 75% | 2024-01-10 | Dev Team |
| Development | 90% | 2024-01-05 | Tech Lead |
| Operations | 70% | 2024-01-12 | DevOps |
| Design | 60% | 2024-01-08 | Design Team |
```

## 🚀 Quick Start for New Projects

1. **Run setup script** - `./setup.sh` to initialize
2. **Fill critical docs first**:
   - PROJECT_OVERVIEW.md (planning-docs/)
   - SETUP.md (development/)
   - API_REFERENCE.md or SYSTEM_DESIGN.md (technical/)
3. **Add as you grow** - Don't try to fill everything at once
4. **Review quarterly** - Set calendar reminders

## 🤝 Contributing to Templates

Found a way to improve these templates?

1. **Identify the gap** - What's missing or could be better?
2. **Propose the change** - Create an issue or discussion
3. **Submit improvement** - PR with explanation
4. **Share your experience** - Help others learn

## 📚 Additional Resources

- [Write the Docs](https://www.writethedocs.org/)
- [Google Developer Documentation Style Guide](https://developers.google.com/style)
- [Microsoft Writing Style Guide](https://docs.microsoft.com/en-us/style-guide/welcome/)
- [The Documentation System](https://documentation.divio.com/)

---

**Remember**: Documentation is a living system. Start where you are, improve as you go, and let the project-manager agent help maintain it automatically!