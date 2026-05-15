# Claude Rig — Reference Project

## Project Context

This is a reference rig for working with Claude Code across projects. It is both a working setup and a template I copy from when starting new engagements.

**Purpose:**
- Encode my development preferences in a portable rig
- Demonstrate the rig pattern (CLAUDE.md + skills + commands + hooks)
- Serve as a reference I can walk through in interviews

**Stage:** Active development. Patterns may evolve.

---

## My Development Model

I work architecturally, not line-by-line. When you take on a task:

1. **Propose before implementing.** For anything beyond a trivial change, outline the approach first. Surface trade-offs. Wait for approval before writing code.
2. **Show me decisions, not just outputs.** If you are picking between two patterns, tell me which and why.
3. **Be direct about uncertainty.** If you do not know something, say so. Do not fabricate.
4. **Small, verifiable steps.** Prefer three small changes I can review over one large change I cannot.

---

## Build & Test Commands

This project is Python-first.

```bash
# Set up the environment
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt

# Run tests
pytest

# Lint
ruff check .

# Format
ruff format .

# Type check
mypy .
```

If `requirements.txt` does not exist yet, that is fine — we will add it when there is actual code to support.

---

## Code Conventions

**Python:**
- Python 3.11+
- Type hints on all function signatures
- Docstrings on public functions (Google style)
- Prefer `pathlib.Path` over `os.path`
- Prefer f-strings over `.format()` or `%`
- No bare `except` — always specify exception types

**File organization:**
- One module per logical concern
- Keep functions under 50 lines when possible
- If you are adding a new top-level module, ask first

**Imports:**
- Standard library first, then third-party, then local
- No wildcard imports (`from x import *`)
- Absolute imports only

---

## Approval Rules

**Always ask before:**
- Creating new top-level directories or modules
- Adding new dependencies to `requirements.txt`
- Running destructive shell commands (`rm`, `del`, `rmdir /s`, anything that deletes)
- Running `git push`, `git reset --hard`, or any rewriting of git history
- Making changes outside the immediate scope of what I asked for

**Never:**
- Commit without my explicit approval
- Push to a remote branch without my explicit approval
- Modify `.env` files or anything containing secrets
- Run shell commands that fetch and execute remote scripts (curl | sh patterns)

---

## Quality Bar

A change is "done" when:
- Tests pass (`pytest` exits clean)
- Linter passes (`ruff check` exits clean)
- Type checker passes (`mypy` exits clean) — unless we have explicitly agreed to skip
- The change is scoped to what I asked for — no incidental refactors
- I have reviewed the diff before any commit

---

## How to Use This Rig

This file is the "constitution" Claude Code reads every session. Skills live in `.claude/skills/`. Slash commands live in `.claude/commands/`. Hooks are configured in Claude Code's settings (not in this repo).

When I copy this rig to a new project, I:
1. Update the **Project Context** section for that project
2. Update the **Build & Test Commands** to match the project's tooling
3. Keep the **Development Model**, **Approval Rules**, and **Quality Bar** as-is — those travel with me
