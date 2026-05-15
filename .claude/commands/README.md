# Slash Commands

User-invoked shortcuts. A file at `commands/<name>.md` creates `/<name>`
in Claude Code.

## Structure

```
commands/
├── prd.md       → /prd
├── review.md    → /review
└── adr.md       → /adr
```

## Command format

```markdown
Single prompt template Claude runs when /<name> is invoked.

Use $ARGUMENTS to capture everything the user typed after the command.

Example:
  /prd add multi-factor authentication
  → $ARGUMENTS = "add multi-factor authentication"
```

## Commands vs skills

- **Commands** are user-invoked. I type `/prd` to fire one.
- **Skills** are auto-discovered. Claude loads them when the description matches.

For simple repeatable prompts → command.
For methodology that should fire automatically based on context → skill.
