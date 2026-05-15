---
name: fde-discovery
description: Use when running FDE engagement discovery on a client codebase. Triggers on phrases like "run FDE discovery", "audit their rig", "engagement briefing", "assess this team's Claude Code setup", "what would I propose for this team", or when prepping for an FDE engagement on someone else's repo. Produces a structured engagement briefing at .claude/discovery.md filled with evidence, recommendations, and trade-offs to take back to the client team.
---

# FDE Discovery

Produce an engagement briefing for an FDE rig audit. The output is a decision-support document — readable by someone making the build/no-build call, not someone reviewing code line by line.

The briefing fills in each of the 6 rig components (the FDE discovery checklist) with:
- **What I found in the repo** — evidence
- **Initial recommendation** — what to build/fix and why
- **Trade-offs to discuss with the team** — alternatives and the questions to ask
- **🚩 Red flag to ask about** — specific signals from the checklist that apply

## When This Skill Fires

Use it when:
- User explicitly asks for FDE discovery, an engagement briefing, or a rig audit
- User is prepping for or running an engagement on someone else's repo
- User uses phrases like "audit their rig", "what would I propose for this team", "engagement briefing"

Do NOT use it for:
- General codebase orientation — use `investigate-codebase` instead
- The user's own personal projects — same, use `investigate-codebase`
- Trivial repos (< 100 lines) — produce a 1-page summary instead

## The Process

### Step 1: Surface Scan

Read these files to ground every finding:
- Top-level `README.md`
- Manifest file (`pyproject.toml`, `package.json`, `Cargo.toml`)
- Top-level directory listing (2 levels deep, skip `node_modules`, `.venv`, build artifacts)
- Root `CLAUDE.md` if present — note tone, what it covers, what's missing
- Build/dev config: `.pre-commit-config.yaml`, `justfile`, `Makefile`, `package.json` scripts, `pyproject.toml` tool sections
- `CONTRIBUTING.md`, `STYLE.md`, or similar contributor docs

### Step 2: Conventions and Patterns

Look for:
- Testing framework + naming pattern
- Linting/formatting tools and configs
- Idiomatic patterns (error handling, logging, validation library, ORM, dataclass usage)
- **Scoped CLAUDE.mds inside `src/` or module folders** — note any that appear stale (referencing code that no longer exists). This is a critical credibility-risk finding.
- Recent activity in last 5-10 commits — what's being worked on right now

### Step 3: Rig Audit

Check for each rig component:
- Root `CLAUDE.md` — present? quality?
- Scoped `CLAUDE.md`s — present? accurate or stale?
- `.claude/skills/` — present? how many? what do they cover?
- `.claude/commands/` — present? how many?
- `.claude/settings.json` with hooks — present? what's configured?
- `.mcp.json` — present? what's wired?
- Pre-commit hooks — present? what's enforced?
- Contributor methodology docs — present? where?

### Step 4: Produce the Briefing

Write to `.claude/discovery.md` (create `.claude/` directory if it doesn't exist).

Use the template below. For each section:
- Fill **"What I found in the repo"** with evidence (real files, real findings)
- Fill **"Initial recommendation"** with what to build/fix and why (2-3 sentences)
- Fill **"Trade-offs to discuss with the team"** with alternatives and questions
- Fill **"🚩 Red flag to ask about"** with the specific red flag from the checklist that applies (if any)

If a section has no findings or no recommendations, say so explicitly. Do not fabricate.

## Output Template

```markdown
# <Project Name> — Engagement Briefing

*Generated: <date> · Repo: <path or URL>*

---

## 1. CLAUDE.md — Project Context, Conventions, Approval Rules

### What I found in the repo
- **What this codebase does:** <one sentence>
- **Primary users:** <who uses this>
- **Project stage:** 🟢/🟡/🔴 <Greenfield | Active scaling | Mature | Legacy>
- **Build/test/lint commands:** <canonical commands>
- **Code style:** <key conventions found>
- **AI approval policy:** <explicit if stated, "inferred" if not>
- **"Done" means:** <what the team requires before merge>

### Initial recommendation
<What to build/fix and why, 2-3 sentences>

### Trade-offs to discuss with the team
- 🟡 <trade-off + the question to ask>
- 🟡 <trade-off + the question to ask>

### 🚩 Red flag to ask about
<Only if one from the checklist applies, with the specific evidence>

---

## 2. Skills — Project-Specific Methodology

### What I found in the repo
- **Existing skills:** <number, names>
- **The "shape" of a feature:** <how features happen here>
- **Testing pattern:** <framework, structure>
- **High-leverage modules:** <list>

### Initial recommendation
<3-5 skills max, in a table>

| Skill | Why | Confidence |
|---|---|---|
| <name> | <reason> | 🟢/🟡/🔴 |

### Trade-offs to discuss with the team
- 🟡 <granular vs broad, etc.>
- 🟡 <other trade-offs>

### 🚩 Red flag to ask about
<If applicable>

---

## 3. Slash Commands — Frequently-Repeated Workflows

### What I found in the repo
- **Existing commands:** <number, names>
- **Repeated workflows visible in the code:** <patterns observed>

### Initial recommendation
<1-2 commands max>

### Trade-offs to discuss with the team
- 🟡 <trade-off>

### 🚩 Red flag to ask about
<If applicable>

---

## 4. Hooks — Non-Negotiable Guardrails

### What I found in the repo
- **Pre-commit hooks:** <what's there>
- **Claude Code hooks:** <what's there or "none">
- **Silent failure modes spotted:** <patterns the team would benefit from automating>

### Initial recommendation
<1-2 hooks max>

### Trade-offs to discuss with the team
- 🟡 <Stop vs PostToolUse, performance, failure modes>

### 🚩 Red flag to ask about
<If applicable>

---

## 5. MCP Servers — External System Connections

### What I found in the repo
- **Existing MCP config:** <`.mcp.json` present or not>
- **MCP references in CLAUDE.md:** <any "use the X MCP" instructions>
- **MCP servers the team ships:** <any `examples/<mcp>/` or similar>
- **MCP-relevant deps:** <fastmcp, mcp client libs>

### Initial recommendation
<Wire up to 3 MCPs, with table>

| MCP | Source | Why |
|---|---|---|
| <name> | <where it comes from> | <reason> |

### Trade-offs to discuss with the team
- 🟡 <stdio vs HTTP, context cost, read-only vs read-write>

### 🚩 Red flag to ask about
<If applicable>

---

## 6. Documentation & Handoff

### What I found in the repo
- **Existing docs:** <wiki, README, docs folder>
- **Contributor methodology:** <how new contributors learn>
- **Rig owner:** <known or unknown>

### Initial recommendation
<Handoff approach for this engagement>

### Trade-offs to discuss with the team
- 🟡 <workshop vs video vs doc, single vs shared owner>

### 🚩 Red flag to ask about
<If applicable>

---

## Top 3 Highest-Leverage Additions (Final)

1. **🔴/🟡 <highest leverage item>** — <one sentence why>
2. **🔴/🟡 <next>** — <why>
3. **🔴/🟡 <next>** — <why>

### Things NOT to build

- ❌ <thing> (<why>)
- ❌ <thing> (<why>)

---

## Open Questions for the Team

1. 🔴 <highest-impact question>
2. 🟡 <medium-impact question>
3. 🟡 <medium-impact question>
4. 🟢 <lower-impact but worth asking>
```

## Highlighting Convention

Use these severity markers consistently:
- 🟢 Strong / low concern / well-handled
- 🟡 Watch / trade-off / worth asking the team
- 🔴 Critical / credibility risk / must address
- 🚩 Red flag from the discovery checklist
- ❌ Should NOT be built
- ✅ Already done well

## Reference: The 6 Rig Components

The briefing covers exactly these 6 areas, in this order:
1. CLAUDE.md (project context, conventions, approval rules, quality bar)
2. Skills (project-specific methodology — `add-feature`, `write-test`, etc.)
3. Slash Commands (frequently-repeated workflows)
4. Hooks (non-negotiable guardrails)
5. MCP Servers (external system connections)
6. Documentation & Handoff (rig ownership and adoption)

## Rules

- **Evidence-driven.** Every finding must trace back to a specific file or pattern. No speculation.
- **Plain language.** The briefing is for someone making decisions, not someone reviewing code. Drop function names and decorator syntax unless they're load-bearing.
- **Discipline.** The "Things NOT to build" section is critical — over-building is the #1 FDE failure mode. Always include it.
- **No fabrication.** If a section has no findings, say "none found." Do not invent.
- **Match the team's voice.** If their CLAUDE.md is terse, lean terse. If it's verbose, lean verbose. The briefing should feel native to the team.
- **One file, one location.** Write to `.claude/discovery.md` only. Do not scatter findings across multiple files.

## When to Deviate

- If the user provides an explicit goal that isn't FDE discovery → use `investigate-codebase` instead.
- If the codebase is trivial → produce a 1-page summary explaining why the full briefing isn't warranted.
- If the user says "skip section X" → omit that section but note in the briefing which sections were skipped and why.

## What Not to Do

- Do not run code, install dependencies, or execute tests during investigation
- Do not modify any file other than `.claude/discovery.md`
- Do not skip the "Things NOT to build" section — it is the discipline test
- Do not fabricate findings to fill in empty sections
- Do not produce findings as a sales pitch — this is diagnosis, not proposal
