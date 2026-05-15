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
│   │   ├── fde-discovery/             # FDE engagement briefing — fills the discovery checklist
│   │   ├── write-prd/                 # Hybrid product+engineering specs
│   │   └── debug-systematically/      # Reproduce → isolate → hypothesize → test
│   ├── commands/
│   │   └── prd.md                     # /prd — shortcut to the write-prd skill
│   └── hooks/
│       └── post-edit-lint.ps1         # Runs ruff after every Python edit
├── docs/
│   ├── discovery-checklist.md         # The 6-component FDE discovery framework
│   └── engagement-playbook.md         # Step-by-step for running a real engagement
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
- Universal methodology skills — investigate, discover, write specs, debug

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

- **investigate-codebase** — When I drop into a new repo, this produces a structured 4-phase report (surface scan → entry points → conventions → leverage map) saved as `INVESTIGATION.md`. Built for orienting fast in unfamiliar code.
- **fde-discovery** — For FDE engagement work. Fills the 6-component discovery checklist with evidence from the repo, initial recommendations, trade-offs to discuss with the team, and red flags. Output: `.claude/discovery.md`.
- **write-prd** — Specification-first engineering. Produces a hybrid PRD with both a product lens (problem, users, success metrics, scope) and an engineering lens (architecture, data model, API surface, conventions check, test plan). Saves to `PRD/PRD-<feature>.md`.
- **debug-systematically** — Forces a reproduce → isolate → hypothesize → test loop instead of fix-and-pray. Explicitly forbids proposing a fix before confirming the bug.

### Slash command — /prd
A thin wrapper that invokes the `write-prd` skill deterministically (vs. relying on description-based discovery). Type `/prd <feature description>` to start the spec-first flow.

### Hook — post-edit-lint
Fires after every `Edit` or `Write`. Runs `ruff check` on edited `.py` files. Exit code 2 + stderr surfaces lint findings directly to the model — Claude sees the violations and reacts. This is the "deterministic guardrail" pattern: hooks for what *must* happen, skills for best practices.

### Discovery checklist + engagement playbook
- `docs/discovery-checklist.md` — the 6-component framework (CLAUDE.md, skills, commands, hooks, MCP, handoff) for assessing a team's Claude Code setup.
- `docs/engagement-playbook.md` — step-by-step for running an FDE engagement from clone → publish.

---

## Case Study: PrefectHQ/Marvin Engagement

A live mock engagement on the [Marvin AI framework](https://github.com/PrefectHQ/marvin) demonstrating the full FDE workflow.

**The fork:** [`bryan-lolordo/marvin` branch `engagement/claude-rig`](https://github.com/bryan-lolordo/marvin/tree/engagement/claude-rig)

**What was found** (via `fde-discovery` skill):
- Two scoped `CLAUDE.md`s were stale — actively misleading Claude Code sessions with references to a `@task` decorator that doesn't exist and a `modules.py` file that was renamed
- Root `CLAUDE.md` instructed contributors to "use the GitHub MCP server" but `.mcp.json` didn't exist
- The team built and ships their own Slack-search MCP server but never wired it into the rig
- Pre-commit gate (load-bearing for Mintlify API docs) only runs at commit time — silent drift possible mid-session

**What was delivered** (5 commits on `engagement/claude-rig`):
1. **Refreshed drifted scoped CLAUDE.mds** — `tasks/` and `slackbot/` rewritten with the real current API
2. **Wired `.mcp.json`** — GitHub MCP + team's own slack-search MCP, with full env-var documentation
3. **Added a Stop hook** — runs `uv run pre-commit run --all-files` so Claude can't claim "done" while pre-commit is dirty
4. **Added `/repro` slash command** — scaffolds the reproduction script pattern root CLAUDE.md prescribes but doesn't seed
5. **Handoff doc** — `.claude/README.md` summarizing what was built, how to extend, and the open questions for the team

**What was explicitly NOT built** — `CONTRIBUTING.md`, generic linting skills, new-module wizards, Prefect MCP (deferred pending team conversation). Discipline matters more than volume in FDE work.

---

## How I Use This

Day-to-day, on my own projects:
1. `/prd <new feature>` → spec generated, open questions surfaced
2. Answer the open questions
3. Implement — Claude follows CLAUDE.md, lint hook keeps Python clean
4. When something breaks, the debug skill keeps me from guessing

On a new engagement, the same pattern but layered:
1. Clone the repo, open Claude Code
2. Run `fde-discovery` → `.claude/discovery.md` produced
3. Review the briefing, confirm findings with the team
4. Build the project-specific rig (skills, commands, hooks, MCP wiring)
5. Hand off with `.claude/README.md`

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
- A second case study on a different stack (TypeScript or Go codebase)

---

## Notes

This rig is opinionated. The development model section in CLAUDE.md reflects how *I* want to work — architectural, propose-before-implement, decisions surfaced. Copy the structure; rewrite the rules to match yours.
