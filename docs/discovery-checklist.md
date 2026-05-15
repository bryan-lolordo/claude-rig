# FDE Discovery Checklist

A structured set of questions to walk through with an engineering team in week one of an engagement. The goal is to extract everything needed to build the project layer of their Claude Code rig.

For each rig component:
- **Probe questions** — what to ask
- **Common patterns** — the typical answers you'll hear
- **Trade-offs** — what each answer implies for the build
- **Red flags** — answers that signal trouble or extra discovery is needed

---

## 1. CLAUDE.md — Project Context, Conventions, Approval Rules

### Probe questions

- What does this codebase do, and who are the primary users?
- What stage is the project at — early, scaling, mature, legacy?
- What are the build, test, and lint commands every developer uses?
- What are your code style conventions? Is there a written style guide?
- What's your team's policy on AI making changes? What should it ask before doing?
- What does "done" mean here — what has to be true before code merges?

### Common patterns

**Project stage:**
- Greenfield (no conventions yet, you help establish)
- Active scaling (conventions exist, evolving fast)
- Mature (locked-in conventions, hard to change)
- Legacy (inconsistent conventions, depends on the module)

**Approval rule patterns:**
- *Strict:* "Never commit without human review"
- *Tiered:* "Auto-commit for docs/tests, review for production code"
- *Trusted-context:* "Feature branches OK, main branch locked"
- *Permissive:* "Trust the AI, flag exceptions"

**Quality bar patterns:**
- Tests + lint + types pass
- Tests + lint pass, types are aspirational
- "Tests pass on the CI"
- "It runs"

### Trade-offs

- **Strict approval** = safe, slow. Right for regulated industries, financial code, anything customer-facing.
- **Permissive approval** = fast, risky. Right for internal tools, prototypes, low-stakes scripts.
- **Tiered approval** = best of both, but requires the AI to correctly classify the change. Add hooks to enforce the boundaries.

### Red flags

- *"We don't really have rules"* → no AI governance exists; you'll build it before the rig.
- *"Just match what's already there"* → conventions are tribal; codify them in writing as part of your engagement.
- *"We don't run tests / we don't lint"* → quality bar is undefined; introduce one before encoding it.
- *"Don't worry about that"* → real risk being downplayed; document it explicitly and revisit.

---

## 2. Skills — Project-Specific Methodology

### Probe questions

- Walk me through how a developer adds a new feature here, end-to-end.
- What's the testing pattern? Framework, structure, what gets mocked?
- How do you write database migrations? What tool, naming, rollback expectations?
- How do you add a new API endpoint, function, module?
- What's your review checklist? What do reviewers look for?
- Are there recurring patterns where engineers re-explain the same thing to new hires?

### Common patterns

**The "shape" of a feature:**
- Spec → branch → code → tests → PR → review → merge → deploy
- Issue → PR → review → merge (no upfront spec)
- Ticket → implement → demo → ship (no formal review)

**Testing patterns to encode:**
- Test framework choice (pytest, jest, vitest, go test)
- Test organization (unit/integration/e2e split)
- Fixture and mock conventions
- Coverage expectations

**API/endpoint patterns to encode:**
- Routing structure (Flask routes, FastAPI routers, Express middleware)
- Validation library (Pydantic, Zod, Joi)
- Error handling shape (status codes, error formats)
- Auth/authz patterns

**Skills you'll commonly build for a project:**
- `add-feature` — their full feature workflow
- `add-endpoint` — their API endpoint pattern
- `write-migration` — their database migration pattern
- `write-test` — their testing framework + structure
- `review-pr` — their review checklist
- `deploy` — their deployment flow

### Trade-offs

- **3-5 skills is the sweet spot.** Fewer = doesn't cover enough. More = the team won't remember which skill does what.
- **Granular skills (`add-rest-endpoint`, `add-graphql-endpoint`)** vs. **broad skills (`add-endpoint`)** — broad is easier to write, granular is more deterministic.
- **Encoding existing patterns** is safer than **prescribing new ones**. Match the team's reality, then suggest improvements separately.

### Red flags

- *"Every developer does it differently"* → no conventions to encode; you'll surface the inconsistency and propose a standard.
- *"It's all in [senior engineer]'s head"* → high bus factor; skills become *the* documentation.
- *"We have a wiki but no one reads it"* → docs exist but don't surface at the right moment; skills fix this exact problem.
- *"Skip the testing skill, we don't really write tests"* → flag this and decide whether to address it in scope or document it as a separate risk.

---

## 3. Slash Commands — Frequently-Repeated Workflows

### Probe questions

- What tasks does the team do over and over, multiple times a week?
- What questions do new hires ask in their first month? Same questions every time?
- Are there scripts or runbooks that get used a lot?
- What would a developer love to invoke with one keystroke?

### Common patterns

**Common slash commands for a team:**
- `/review-pr <number>` — pulls PR diff, applies review checklist
- `/new-endpoint <name>` — scaffolds a new endpoint following team conventions
- `/incident <description>` — kicks off incident-response runbook
- `/explain <thing>` — explains a concept using team-specific examples
- `/migrate <description>` — drafts a database migration
- `/onboard <topic>` — walks a new hire through a specific area

### Trade-offs

- **Commands vs skills:** commands are user-invoked, skills are auto-discovered. Use commands for things developers actively reach for. Use skills for things that should happen automatically based on context.
- **Don't over-build.** Start with 1-2 commands. Add more only when the team asks.

### Red flags

- *"We don't repeat anything"* → almost never true; ask "what do you wish was easier?" instead.
- *"Build commands for everything"* → command sprawl. The team won't remember the ones that exist.

---

## 4. Hooks — Non-Negotiable Guardrails

### Probe questions

- What's your security team's policy on AI-assisted development?
- Are there commands or operations that must NEVER run automatically?
- What lint, format, or type checks must pass before code can be edited?
- What CI steps need to run locally before pushing?
- Are there secrets, credentials, or data exfiltration concerns?

### Common patterns

**Common hooks for a project:**
- *PreToolUse on Bash:* block destructive commands (`rm -rf`, `git push --force`, anything against prod)
- *PreToolUse on Edit:* check files aren't on a protected list (`.env`, `secrets/`, etc.)
- *PostToolUse on Edit:* run linter automatically
- *PostToolUse on Edit:* run formatter automatically
- *PostToolUse on Edit:* run type checker
- *Stop:* generate a summary of changes for changelog / PR description
- *UserPromptSubmit:* inject project context or compliance reminders

**Format choices for hooks:**
- Shell script (bash on Linux/Mac, PowerShell on Windows)
- HTTP endpoint to a central service (good for shared policy)
- MCP tool invocation (good when the check is already a tool)

### Trade-offs

- **Hooks vs skills:** hooks are deterministic and cannot be skipped. Skills are advisory. If a human reviewer would consider it a process violation when something is skipped, it belongs in a hook.
- **Hook performance matters.** A hook that takes 5+ seconds is friction. Keep them fast or run them async.
- **Failure modes matter more than success modes.** What happens when the hook fails? Block or warn? Exit code 2 surfaces to the model; exit code 1 hides the failure.

### Red flags

- *"We don't have any security policies"* → most likely they have implicit ones; surface them through scenario questions.
- *"We've never enforced anything programmatically"* → expect resistance to introducing hooks; start with one low-risk hook (linter) and earn trust.
- *"Everything must be blocked"* → over-restrictive; the team will turn hooks off. Find the minimum viable set.

---

## 5. MCP Servers — External System Connections

### Probe questions

- What internal systems do developers need to query day-to-day?
- Where does institutional knowledge live? (Confluence, Notion, internal wiki?)
- What's your source control? Issue tracker? Ticketing system?
- Are there internal APIs developers commonly hit?
- What's your observability stack? Datadog, Splunk, custom?
- Are there compliance constraints on what data the AI can touch?

### Common patterns

**MCP servers commonly added to a client rig:**
- *GitHub / GitLab / Bitbucket:* PR context, issue tracking, code search
- *Filesystem (extended):* beyond the repo, into shared design docs or specs
- *Ticketing:* Jira, Linear, Asana, ServiceNow
- *Knowledge base:* Confluence, Notion, internal wiki
- *Database:* read-only access to dev/staging DBs for schema queries
- *Internal APIs:* custom MCP server wrapping their service catalog
- *Observability:* Datadog, Sentry, CloudWatch query access

**Transport choices:**
- *stdio:* runs locally alongside the developer's Claude Code session
- *SSE / HTTP:* runs as a shared service, accessible to multiple developers

### Trade-offs

- **Context cost is real.** A 5-server setup can eat 50K+ tokens before any conversation. Use Tool Search or selective enabling to reduce.
- **Stdio vs shared service.** Stdio is simpler but every developer needs the server. Shared HTTP is harder to set up but scales across the team.
- **Read-only vs read-write.** Default to read-only for first MCP rollout. Earn trust before write access.
- **Compliance scope.** Some clients can't have AI access certain data. Get this in writing before connecting anything.

### Red flags

- *"Just connect everything"* → context explosion incoming; be selective.
- *"We don't have an MCP server for that"* → you may need to build one. Adds significant scope.
- *"Production database access is fine"* → not fine. Push back. Mock it with a staging clone.
- *"We don't have an audit log for AI access"* → discuss what the audit trail will look like before any MCP server goes live.

---

## 6. Documentation & Handoff

### Probe questions

- Who will maintain this rig after I leave?
- How does the team learn new tools today? Wiki? Pair programming? Talks?
- What's the team's appetite for adopting new workflows?
- How will we measure whether the rig is actually being used after the engagement ends?

### Common patterns

**Handoff deliverables:**
- `.claude/README.md` — what's in the rig and how to use it
- `RUNBOOKS.md` — common scenarios and the rig response (debugging, new feature, incident)
- Short video walkthrough of `/prd` and the key skills
- 1-hour team workshop showing the rig live
- A named owner from the client team for each rig component

**Success metrics:**
- Skills get invoked weekly (measurable via Claude Code logs)
- The team extends the rig themselves (adds new skills, modifies hooks)
- New hires onboard faster (anecdotal but valuable)
- Code review cycle time decreases (if measurable)

### Trade-offs

- **Workshop vs documentation vs video.** Workshop is best for adoption, video is best for re-watching, documentation is best for reference. Do all three for important components.
- **Single owner vs shared ownership.** Single owner creates accountability but bus factor. Shared ownership avoids bus factor but diffuses responsibility. Both is right: one named champion, two co-owners.

### Red flags

- *"We'll figure out maintenance after you leave"* → guarantees the rig will rot.
- *"Just leave us the files, we'll figure it out"* → low adoption likely; push for at least a 1-hour walkthrough.
- *"We don't have time for a workshop"* → push back; the workshop *is* the engagement's outcome.
- *"It's all good, we got it"* → confirm by having someone on the team add a skill while you watch.

---

## Discovery Sequence

A practical order to run discovery in week one:

| Day | Activity | Output |
|---|---|---|
| 1 | Kickoff + section 1 (CLAUDE.md context) | Draft project CLAUDE.md |
| 2 | Section 2 (skills) — shadow a developer | List of 3-5 skills to build |
| 3 | Section 3 (commands) + section 4 (hooks) | Command and hook plan |
| 4 | Section 5 (MCP) + technical setup | MCP server roadmap |
| 5 | Section 6 (handoff) + plan workshop | Engagement plan with owners |

The deliverable at end of week one is a **rig build plan** the client approves before any code goes in their repo. That's the discovery → spec → build pattern Caylent calls "specification-first engineering."

---

## Bonus: The First Question to Ask

Before any of the above, ask:

> *"What's the single biggest friction point in how your engineering team works today?"*

Whatever they answer is the highest-leverage place to start. Build the rig to attack that first.
