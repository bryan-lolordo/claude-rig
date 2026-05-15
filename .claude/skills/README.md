# Skills

Auto-discovered methodology. Claude Code loads a skill when its `description`
in the YAML frontmatter matches the task context.

## Structure

Each skill is a folder containing a `SKILL.md` file:

```
skills/
├── investigate-codebase/
│   └── SKILL.md
├── write-prd/
│   └── SKILL.md
└── debug-systematically/
    └── SKILL.md
```

## SKILL.md format

```markdown
---
name: skill-name
description: One sentence that tells Claude when to load this skill.
---

# Skill body

Step-by-step methodology Claude follows when this skill is active.
```

## Universal vs project-specific

Skills here are universal — they travel with me to every project.
Project-specific skills (e.g., "how this client writes migrations")
live in that project's `.claude/skills/`, not here.
