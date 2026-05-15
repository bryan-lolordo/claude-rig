# Hooks

Deterministic guardrails. Hooks fire automatically on lifecycle events,
regardless of what Claude decides to do.

## Hook events I care about

- **PreToolUse** — before any tool call (security checks, blocking destructive bash)
- **PostToolUse** — after a tool call (run linter after Edit on .py files)
- **UserPromptSubmit** — when I send a prompt (inject context if missing)
- **Stop** — at end of work (summarize changes, update changelog)

## Hooks vs skills

- **Hooks** are for things that *must* happen. Claude cannot skip them.
- **Skills** are advisory — best practices Claude should follow.

Rule of thumb: if a human reviewer would consider it a process violation
when something is skipped, it belongs in a hook, not a skill.

## Configuration

Hooks are configured in Claude Code's settings file (not in this repo).
This folder holds the *handler scripts* that the settings reference.

```
hooks/
├── pre-bash-security-check.sh   (or .ps1 on Windows)
├── post-edit-lint.sh
└── stop-summarize.sh
```

The settings file then points to these by path.
