---
name: debug-systematically
description: Use when something is broken, failing, returning an unexpected result, or behaving in a way the user did not expect. Triggers on phrases like "this is broken", "why isn't this working", "I'm getting an error", "this should be X but it's Y", "help me debug", "what's wrong", or any unexplained failure. Forces a structured reproduce → isolate → hypothesize → test loop instead of fix-and-pray.
---

# Debug Systematically

A repeatable methodology for debugging. The goal is to find the actual cause of a problem before changing any code — most "fixes" that fail are fixes to the wrong cause.

## When This Skill Fires

Use it whenever the user describes a malfunction, unexpected behavior, or error. Specifically:

- "This is broken" / "Why isn't this working" / "It should be X but it's Y"
- "I'm getting an error" / "It crashes when I do Z"
- "Help me debug" / "What's wrong with this"
- Any unexplained failure or surprising output

Do NOT use this skill for:
- Adding a feature (use `write-prd` instead)
- Understanding an unfamiliar codebase (use `investigate-codebase` instead)
- Trivial typos or obvious one-line fixes (just fix them)

## The Process

Work through the four phases in order. Do not skip ahead. If a phase is impossible (e.g., cannot reproduce), say so explicitly and propose how to unblock.

### Phase 1: Reproduce

Goal: Confirm the failure happens reliably and capture it precisely.

1. Ask the user for the exact steps that trigger the bug, or extract them from the conversation
2. Run those steps yourself (or have the user run them) and confirm the failure
3. Capture the exact error message, stack trace, or unexpected output verbatim
4. Identify what *should* have happened — the expected behavior

Output for Phase 1:
- **Steps to reproduce** (numbered, terse)
- **Observed result** (verbatim — error text, output, screenshot description)
- **Expected result**
- **Reproducible?** Yes / Intermittent / No (if intermittent, note frequency)

If the bug is not reproducible, STOP and tell the user. Intermittent bugs need a different approach — capture more logs first.

### Phase 2: Isolate

Goal: Narrow the failing surface to the smallest possible scope.

1. Identify the boundary between "working" and "broken" — last commit that worked, last input that worked, smallest input that still fails
2. Strip the reproduction down to the minimum case — remove unrelated code paths, simplify inputs, eliminate noise
3. Identify which layer the bug lives in: input handling, business logic, external call, output formatting, environment/config

Output for Phase 2:
- **Minimum reproducer** (smallest code/input that still fails)
- **Suspected layer** (with confidence: high / medium / low)
- **Ruled out** (layers/causes you eliminated and why)

### Phase 3: Hypothesize

Goal: Form a specific, falsifiable hypothesis about the cause.

A good hypothesis is:
- **Specific** — names the function, variable, or condition responsible
- **Falsifiable** — could be proven wrong by a clear test
- **Testable cheaply** — does not require rewriting the system to check

List 1-3 hypotheses ranked by likelihood. For each:
- **Hypothesis:** one sentence
- **How to test it:** the cheapest check that would confirm or deny
- **Evidence supporting it:** what we've already seen

Do NOT propose fixes yet. Hypothesizing and fixing are different steps and conflating them is how you fix the wrong thing.

### Phase 4: Test

Goal: Run the cheapest test for the top hypothesis. Confirm or move down the list.

1. Run the test described in Phase 3 for hypothesis #1
2. Report the result
3. If confirmed → propose the minimal fix. Only then suggest code changes.
4. If denied → move to hypothesis #2 and test it
5. If all hypotheses denied → go back to Phase 2 with new evidence and isolate further

When proposing a fix:
- Make it the *smallest* change that addresses the confirmed cause
- Do NOT bundle unrelated refactors with the fix
- Surface any related defects you notice but recommend handling them in separate changes
- Per CLAUDE.md, do NOT apply the fix until I approve

## Reporting Format

Keep the debug session conversational, but produce a final summary in this shape once a fix is proposed:

```
**Reproduced:** <steps>
**Observed:** <actual>
**Expected:** <intended>
**Cause:** <confirmed hypothesis>
**Fix:** <one-line description>
**Diff:** <show the change before applying>
**Related issues noticed (out of scope for this fix):** <list or "none">
```

## What Not to Do

- Do NOT propose a fix before reproducing the bug. "Try this and see if it helps" is the failure mode this skill exists to prevent.
- Do NOT change multiple things at once. One hypothesis, one test, one fix.
- Do NOT silence the error (catch-and-pass, comment out the failing line) unless we have explicitly agreed that's the desired behavior.
- Do NOT skip Phase 2. Most "mysterious" bugs become obvious once isolated.

## When to Deviate

If the bug is genuinely trivial (typo in a string literal, missing import, off-by-one in a line we can see), skip to a one-line fix and explain why the skill was bypassed.

If the user explicitly says "just try X" — comply, but note that we're skipping the systematic approach and may need to come back to it if X doesn't work.

If the bug is in unfamiliar code, run `investigate-codebase` first to orient, then come back to this skill.
