---
description: Review staged changes before committing
agent: plan
---
Review the staged changes below and give a concise assessment:

!`git diff --cached`

Check for:
- Logic errors or unintended side effects
- Missing error handling
- Hardcoded values that should be config/env
- Anything that will break tests or type-check
- Violations of the conventions in AGENTS.md

Be brief. Flag real problems only — no style nitpicks that the formatter will handle.
