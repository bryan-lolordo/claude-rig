---
name: investigate-codebase
description: Use when orienting in an unfamiliar codebase. Triggers on phrases like "what does this codebase do", "how does this project work", "help me understand this repo", "I just cloned X", "give me a tour", or when starting work in a directory that hasn't been discussed yet. Produces a structured investigation report rather than diving into code immediately.
---

# Investigate Codebase

A repeatable methodology for orienting in an unfamiliar codebase. The goal is to produce a clear, structured understanding of what the project is, how it works, and where the leverage points are — before making any changes.

Use this when I drop into a new repo or when I ask any variation of "what does this do."

## The Process

Execute these phases in order. Stop and ask me before deviating from the order.

### Phase 1: Surface Scan (read-only, no code execution)

Goal: Build a 30-second mental model of the project.

1. Read the top-level README (and any `docs/` index if present)
2. Read `package.json`, `pyproject.toml`, `requirements.txt`, `Cargo.toml`, or whatever manifest exists — note the framework and major dependencies
3. List the top-level directory structure (2 levels deep, no node_modules / venv / build artifacts)
4. Note the presence or absence of: tests folder, CI config, contributing guide, changelog, license

Output for Phase 1:
- **What this project is** (1 sentence)
- **Stack** (language, framework, notable deps)
- **Top-level layout** (annotated tree)
- **Maturity signals** (tests? CI? docs? changelog?)

### Phase 2: Entry Points and Flow

Goal: Find where execution starts and how data flows.

1. Identify the entry point(s) — `main.py`, `index.ts`, CLI definition, API route registration
2. Trace one representative path from entry to exit
3. Identify external dependencies — what does this project call out to (APIs, databases, queues)
4. Note any obvious orchestration patterns (event-driven, request-response, scheduled jobs)

Output for Phase 2:
- **Entry points** (file paths)
- **One representative flow** (entry → core logic → exit, in 3-5 bullets)
- **External dependencies** (with confidence level on each)

### Phase 3: Conventions and Patterns

Goal: Understand how the team writes code so I can match their style.

1. Identify the testing framework and naming pattern
2. Identify the linting/formatting setup (config files)
3. Note any custom patterns — error handling style, logging approach, validation library, ORM usage
4. Scan for `CONTRIBUTING.md`, `STYLE.md`, or similar docs
5. Look at the most recent 5-10 commits to gauge what kind of work is active

Output for Phase 3:
- **Test framework + pattern** (e.g., "pytest with parametrize, fixtures in conftest.py")
- **Linting setup** (which tool, custom rules if any)
- **Idiomatic patterns** (3-5 observations)
- **Recent activity** (what's being worked on right now)

### Phase 4: Leverage Map

Goal: Identify the highest-value places to focus.

For the user's stated objective (or, if none stated, ask what they're trying to accomplish), identify:
- Files most relevant to their goal
- Likely friction points (technical debt, missing tests, undocumented modules)
- Quick wins that would build trust with the team before larger changes

Output for Phase 4:
- **Files to read first** (3-5, with one-line reasons)
- **Friction points** (with severity guess)
- **Suggested first change** (something small and high-trust)

## Reporting Format

Produce the four phases as a single markdown report titled `INVESTIGATION.md`. Save it to the current directory.

Keep each phase short — bullets, not paragraphs. The whole report should be readable in 3 minutes.

End the report with **Open Questions** — things I should verify with the team before making changes.

## What Not to Do

- Do not run code, install dependencies, or execute tests during investigation
- Do not make changes to any file other than `INVESTIGATION.md`
- Do not skip phases. If a phase yields little (e.g., no tests exist), say so and move on
- Do not assume — flag uncertainty explicitly with "unclear" or "needs verification"

## When to Deviate

If the user explicitly says "skip investigation, just do X" — comply, but note in your response that you're skipping the structured investigation.

If the codebase is trivial (one file, < 100 lines), produce a compressed 3-bullet summary instead of the full four-phase report.
