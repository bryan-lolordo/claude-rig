# Claude Rig

A reference Claude Code rig — the working setup I use across projects and the template I copy from when starting new engagements.

## What's in here

```
claude-rig/
├── CLAUDE.md              # Project constitution — read every session
├── .claude/
│   ├── skills/            # Auto-discovered methodology (how I want things done)
│   ├── commands/          # Slash commands (/prd, /review, /adr)
│   └── hooks/             # Deterministic guardrails (linters, security checks)
├── .gitignore
└── README.md
```

## How it works

- **CLAUDE.md** is the foundation. It loads on every Claude Code session and encodes my development model, conventions, and approval rules.
- **Skills** are auto-discovered by Claude Code based on their description. They encode repeatable methodology — how to write a PRD, how to investigate an unfamiliar codebase, how to debug systematically.
- **Slash commands** are user-invoked shortcuts. `/prd` runs a feature through my standards before generating a spec.
- **Hooks** are deterministic. They fire on lifecycle events (PreToolUse, PostToolUse) and enforce things that must always happen — security checks before bash, linter runs after edits.

## How I extend this

When I start a new project, I copy this rig and:
1. Update `CLAUDE.md` Project Context for the new project
2. Update Build & Test Commands to match the project's tooling
3. Keep Development Model, Approval Rules, and Quality Bar as-is
4. Add project-specific skills to `.claude/skills/`
5. Wire up project-specific MCP servers via `.mcp.json` if needed

The personal layer travels with me. The project layer gets built fresh per engagement.
