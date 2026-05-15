---
name: write-prd
description: Use when starting work on a new feature, capability, or system. Triggers on phrases like "write a PRD", "spec this out", "let's design X", "I want to add feature Y", "write a spec for", "draft requirements for", or whenever the user describes a new idea before any code is written. Produces a hybrid PRD that covers both the product lens (problem, users, metrics) and the engineering lens (architecture, data, tests, conventions).
---

# Write PRD

A specification-first engineering pattern. Before any code is written for a new feature, produce a structured PRD that forces the hard questions out of code review and into the spec.

The skill produces a hybrid spec serving two audiences:

- **Product lens** — what executive stakeholders, product, and strategy leads need to align on
- **Engineering lens** — what the team building the feature needs to know to implement it well

## When This Skill Fires

Use it whenever the user is describing a new idea before implementation. Specifically:

- "Write a PRD for X" / "Spec this out" / "Let's design X"
- "I want to add Y feature"
- "Draft requirements for Z"
- Any open-ended request that would otherwise lead to writing code without alignment

If the request is for a trivial change (renaming a variable, fixing a bug, updating a comment), do NOT use this skill — that level of work does not warrant a spec. Compress to a one-paragraph plan instead.

## The Process

### Step 1: Confirm the input

Before writing the spec, restate the feature in one sentence. Ask the user to confirm or correct it. This catches misunderstandings before they get baked into the spec.

Example: *"Before I draft the spec — I'm reading this as: a CLI command that takes a directory and returns a summary of test coverage gaps. Is that right?"*

If the user confirms, proceed. If they correct you, restate again until aligned.

### Step 2: Pull in project context

Read `CLAUDE.md` (if present). Note the relevant sections — conventions, quality bar, approval rules, build commands. The PRD must align with these. If the proposed feature conflicts with anything in `CLAUDE.md`, flag the conflict in the spec.

### Step 3: Generate the PRD

Produce a markdown file at `PRD/PRD-<short-feature-name>.md` using the template below. Use kebab-case for the filename (e.g., `PRD-test-coverage-gaps.md`).

Create the `PRD/` directory if it does not exist.

### Step 4: Surface open questions

End the PRD with explicit open questions. These are decisions the user has not made yet but will need to before implementation. The spec is not "done" until the open questions are answered.

## The Template

```markdown
# PRD: <Feature Name>

**Status:** Draft
**Owner:** <to fill>
**Created:** <today's date in YYYY-MM-DD>

---

## Product Lens

### Problem statement
One paragraph. What's broken or missing? Why does it matter now?

### Users and use cases
- Who uses this?
- What are they trying to do?
- What's the current workaround (if any)?

### Success metrics
- How will we know this worked?
- Quantitative if possible. Qualitative if not.
- Pick 1-3 metrics. More than that = unfocused.

### Scope
**In scope:**
- Bullet list of what this feature DOES include

**Out of scope:**
- Bullet list of what this feature does NOT include
- Be explicit. Out-of-scope items prevent scope creep later.

### Risks and trade-offs
- What could go wrong?
- What are we trading off (cost vs speed, flexibility vs simplicity, etc.)?

---

## Engineering Lens

### Technical approach
Describe the architecture in 2-3 paragraphs. What are the major components, how do they connect, where does data flow?

Include a simple diagram if it helps — ASCII or a mermaid block.

### Data model
What new tables, schemas, files, or data structures are needed?
What existing data does this touch?

### API surface / interface
If this is an API: list the endpoints, request/response shapes.
If this is a CLI: list the commands, flags, output format.
If this is a library: list the public functions and signatures.

### Conventions check
Cross-reference `CLAUDE.md` conventions. For each relevant rule, confirm the spec respects it:
- [ ] Follows Python 3.11+ conventions (type hints, pathlib, etc.) — *if applicable*
- [ ] Test framework matches project standard
- [ ] No new top-level directories or modules without flagging
- [ ] No new dependencies without flagging

If any of the above are violated, explain why and propose how to handle it.

### Test plan
- Unit tests: which modules, what behaviors
- Integration tests: which end-to-end flows
- Edge cases worth testing
- What does "done" look like for tests (coverage target, specific scenarios)

### Rollout plan
- How will this ship? (one PR, multi-PR series, feature-flagged, etc.)
- Are there migrations or data backfills?
- Are there downstream services or users to notify?
- How do we roll back if something goes wrong?

---

## Open Questions

List explicit questions the user must answer before implementation begins.

Format each as a numbered question with a default suggestion if you have one.

Example:
1. Should the CLI support YAML output in addition to JSON? *(Suggested default: JSON only for v1.)*
2. Do we need a config file, or are CLI flags sufficient? *(Suggested default: CLI flags for v1.)*
3. Should this be a new package or live inside the existing `tools/` directory? *(Suggested default: `tools/`.)*

---

## Decision Log

(Empty for v1 — filled in as decisions get made.)
```

## What Not to Do

- Do NOT write any code while in this skill. The PRD is the deliverable.
- Do NOT fabricate metrics, users, or success criteria. If the user did not provide them, surface them as open questions.
- Do NOT skip the "Conventions check" section — it is the rig's whole point.
- Do NOT produce a PRD longer than ~2 pages of markdown. If it gets bigger than that, the feature is too big and should be split into multiple PRDs.

## When the User Provides Limited Context

If the user describes the feature in one sentence and asks for a PRD, do not try to fill in every section by inference. Instead:

1. Fill in what you can from their input
2. Mark unknown sections with `[needs input]`
3. List the gaps as open questions at the bottom

A half-filled PRD with clear open questions is more useful than a fully-filled PRD with fabricated content.

## When to Deviate

If the user says "skip the product lens, this is internal tooling" or "skip the engineering lens, this is a one-pager for the exec team" — comply, but note in the spec which lens was skipped and why.

If the user says "give me a one-pager" or "compress this" — produce a 1-page version with only Problem, Approach, and Open Questions. Note explicitly that this is a compressed PRD.
