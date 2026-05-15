# Claude Code Rig

A working Claude Code configuration — CLAUDE.md, custom skills, slash commands, and a deterministic lint hook. The setup I use to bring repeatable methodology and quality guardrails into every new project.

This rig is both a personal working environment and a reference template I copy from when starting a new engagement.

---

## What's Inside

```
claude-rig/
├── CLAUDE.md                          # Session constitution — read every session
├── .claude/
│   ├── settings.json                  # Hook configuration
│   ├── skills/                        # Auto-discovered methodology
│   │   ├── investigate-codebase/      # 4-phase tour of an unfamiliar repo
│   │   ├── write-prd/                 # Hybrid product+engineering specs
│   │   └── debug-systematically/      # Reproduce → isolate → hypothesize → test
│   ├── commands/
│   │   └── prd.md                     # /prd — shortcut to the write-prd skill
│   └── hooks/
│       └── post-edit-lint.ps1         # Runs ruff after every Python edit
├── experiments/                       # Scratch space for trying patterns
├── .gitignore
└── README.md
```

---

## The Pattern

Two layers, with different lifespans:

**Personal layer (travels with me to every project)**
- Development model — work architecturally, propose before implementing, surface trade-offs
- Approval rules — never commit without review, ask before new modules or dependencies
- Quality bar — tests/lint/types pass before "done"
- Universal methodology skills — investigate, write specs, debug

**Project layer (built fresh per engagement)**
- Project-specific build/test commands
- Codebase conventions (frameworks, file structure, deployment)
- Project-specific skills (how *this* team writes migrations, *this* team's review checklist)
- MCP servers for the client's internal systems
- Hooks wired to *their* linter, *their* test runner, *their* CI

---

## What Each Component Does

### CLAUDE.md — the constitution
Loads on every Claude Code session. Encodes my development model, code conventions, approval rules, and quality bar. The defaults travel with me; the project context section gets updated per project.

### Skills — auto-discovered methodology

- **investigate-codebase** — When I drop into a new repo, this produces a structured 4-phase report (surface scan → entry points → conventions → leverage map) saved as `INVESTIGATION.md`. Built for the FDE motion of walking into a client codebase and orienting fast.
- **write-prd** — Specification-first engineering. Produces a hybrid PRD with both a product lens (problem, users, success metrics, scope) and an engineering lens (architecture, data model, API surface, conventions check, test plan). Saves to `PRD/PRD-<feature>.md`.
- **debug-systematically** — Forces a reproduce → isolate → hypothesize → test loop instead of fix-and-pray. Explicitly forbids proposing a fix before confirming the bug.

### Slash command — /prd
A thin wrapper that invokes the `write-prd` skill deterministically (vs. relying on description-based discovery). Type `/prd <feature description>` to start the spec-first flow.

### Hook — post-edit-lint
Fires after every `Edit` or `Write`. Runs `ruff check` on edited `.py` files. Exit code 2 + stderr surfaces lint findings directly to the model — Claude sees the violations and reacts. This is the "deterministic guardrail" pattern: hooks for what *must* happen, skills for best practices.

---

## How I Use This

Day-to-day, on my own projects:
1. `/prd <new feature>` → spec generated, open questions surfaced
2. Answer the open questions
3. Implement — Claude follows CLAUDE.md, lint hook keeps Python clean
4. When something breaks, the debug skill keeps me from guessing

On a new engagement, the same pattern but layered:
1. Copy this rig into the project
2. Update the **Project Context** in CLAUDE.md
3. Add 3-5 project-specific skills encoding *their* conventions
4. Wire hooks to *their* tooling
5. Configure MCP servers for *their* systems

The personal layer is the working preferences I bring. The project layer is the deliverable.

---

## Built On

- [Claude Code](https://docs.claude.com/en/docs/claude-code/overview)
- [ruff](https://docs.astral.sh/ruff/) for Python linting
- PowerShell 5.1+ for hook scripting (Windows native)

---

## What's Next

- Additional universal skills (`refactor-safely`, `commit-message`)
- MCP server examples (GitHub, internal API patterns)
- WSL2 migration for cross-platform hook portability
- More slash commands as patterns earn the shortcut

---

## Notes

This rig is opinionated. The development model section in CLAUDE.md reflects how *I* want to work — architectural, propose-before-implement, decisions surfaced. Copy the structure; rewrite the rules to match yours.
