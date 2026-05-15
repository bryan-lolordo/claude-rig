Invoke the `write-prd` skill to draft a Product Requirements Document for the feature described below.

Feature description: $ARGUMENTS

Follow the skill's full process:
1. Restate the feature in one sentence and confirm with me before drafting.
2. Read CLAUDE.md and pull in relevant conventions, quality bar, and approval rules.
3. Generate the PRD at `PRD/PRD-<kebab-feature-name>.md` using the hybrid template (Product Lens + Engineering Lens + Conventions check + Open Questions).
4. End with explicit Open Questions I need to answer before implementation.

If no feature description was provided (i.e., `$ARGUMENTS` is empty), ask me what feature I want a PRD for rather than fabricating one.
