# FDE Engagement Playbook

A step-by-step guide for running a Claude Code rig engagement on someone else's codebase.

This playbook is meant to be reused. Each step is short and concrete. The `fde-discovery` skill handles the heavy lifting on steps 3-6.

---

## Step 1: Find and Clone the Repo

Pick a target. Criteria:
- Active development (commits in last month)
- Mid-size (50-500 files)
- Real conventions (style guide, tests, contributing doc)
- Public if you want to publish the engagement

```powershell
cd C:\Users\bjlol\Desktop
git clone https://github.com/<owner>/<repo>.git
cd <repo>
```

---

## Step 2: Open in VS Code

```powershell
code .
```

Keep your `claude-rig` window open too — for reference.

---

## Step 3: Run FDE Discovery

In Claude Code:

> Run FDE discovery on this repo

This invokes the `fde-discovery` universal skill. It will:
- Surface scan the repo
- Read CLAUDE.md, build config, and contributor docs
- Audit each of the 6 rig components
- Produce `.claude/discovery.md` — a filled-in engagement briefing

**Output:** `.claude/discovery.md` at the repo root with evidence, recommendations, trade-offs, red flags, and the top 3 highest-leverage additions.

---

## Step 4: Review the Briefing

Open `.claude/discovery.md` and review each of the 6 sections.

For each section ask yourself:
- Is the **finding** accurate? (Sanity check against the repo.)
- Is the **recommendation** defensible? Could I explain this to a senior engineer?
- Are the **trade-offs** real questions for the client, or filler?
- Is the **red flag** (if any) a real risk?

Mark anything that needs more discovery or that you want to push back on.

---

## Step 5: Run Discovery Conversations with the Team

For a real engagement, walk the briefing with the engineering team. Use each section's "Trade-offs to discuss" and "Red flag to ask about" as your conversation script.

For a mock engagement, simulate this:
- Pick a stance for the team (terse, opinionated, etc.)
- Answer the open questions in the briefing yourself
- Note where the answers change the recommendation

**Output:** Confirmed findings + answers to the open questions.

---

## Step 6: Present the Build Plan

Now that the briefing's recommendations are confirmed, organize them into a concrete plan.

Use this template:

```markdown
## Build Plan

### Deliverables (in order)
1. <highest leverage item> — <effort estimate>
2. <next> — <effort>
3. <next> — <effort>

### Not in scope
- <things explicitly NOT building>

### Timeline
<week 1, week 2, etc.>

### Owners
<who maintains each component after handoff>
```

Get sign-off before building.

---

## Step 7: Fork + Branch

```powershell
gh repo fork --remote
git checkout -b engagement/claude-rig
```

---

## Step 8: Build the Rig Artifacts

Build each deliverable from the approved plan. For each:
1. Write the file
2. Test it against the codebase
3. Iterate if it doesn't behave right
4. Commit with a focused message

---

## Step 9: Write the Handoff Document

Write `.claude/HANDOFF.md` covering:
- What was built
- How to use each component
- How to extend
- Who maintains it after the engagement

---

## Step 10: Publish

If public OSS target: push to your fork, link from your personal rig as a case study.
If private client: package into a private repo with the engagement memo.

---

## Time Estimate

- Steps 1-4: ~1 hour (clone + skill run + review)
- Step 5: 2-5 days in real engagement, 1 hour in mock
- Steps 6-7: ~30 minutes
- Step 8: 1-2 weeks in real engagement, 4-8 hours in mock
- Steps 9-10: ~2 hours

---

## Current Engagement Log

### Mock Engagement: PrefectHQ/Marvin ✅ COMPLETE

- **Step 1:** ✅ Cloned to `C:\Users\bjlol\Desktop\marvin`
- **Step 2:** ✅ Opened in VS Code
- **Step 3:** ✅ `fde-discovery` skill produced `.claude/discovery.md`
- **Step 4:** ✅ Reviewed — 2 stale CLAUDE.mds, MCP referenced but not wired, no Stop hook, slackbot is the active surface
- **Step 5:** ✅ Mock-confirmed — recommendations stand
- **Step 6:** ✅ Build plan: 5 deliverables (refresh stale CLAUDE.mds, .mcp.json, Stop hook, /repro, handoff doc)
- **Step 7:** ✅ Fork (`bryan-lolordo/marvin`), branch `engagement/claude-rig`
- **Step 8:** ✅ All 5 deliverables built, 3 semantic commits
- **Step 9:** ✅ `.claude/README.md` handoff doc written
- **Step 10:** ✅ Pushed to https://github.com/bryan-lolordo/marvin/tree/engagement/claude-rig and referenced as case study in main rig README

### Skill State (as of this engagement)

- `investigate-codebase` (universal) — general repo orientation, lighter weight
- `fde-discovery` (universal) — FDE engagement briefing, fills the discovery checklist
- `write-prd` (universal) — hybrid PRD generator
- `debug-systematically` (universal) — reproduce → isolate → hypothesize → test
- `add-feature` (Marvin project-local) — Marvin's feature workflow
