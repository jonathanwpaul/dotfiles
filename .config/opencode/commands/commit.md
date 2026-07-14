---
description: Draft a conventional commit message for staged changes
agent: plan
---
Write a conventional commit message for the following staged diff.

!`git diff --cached`

Rules:
- Format: `type(scope): description`
- Types: feat, fix, refactor, chore, docs, test, perf, ci
- Subject line: imperative mood, no period, max 72 chars
- If the change warrants it, add a blank line then a short body (what and why, not how)
- Output the message only — no explanation, no markdown fences
