---
description: Draft a PR title and description from commits on this branch
agent: plan
---
Draft a pull request for this branch.

Branch: !`git branch --show-current`

Commits vs base branch:
!`git log --oneline $(git merge-base HEAD origin/main 2>/dev/null || git merge-base HEAD origin/master 2>/dev/null)..HEAD`

Full diff:
!`git diff $(git merge-base HEAD origin/main 2>/dev/null || git merge-base HEAD origin/master 2>/dev/null)..HEAD --stat`

Write:
1. A concise PR title (conventional commit style)
2. A short summary section (2-4 bullets: what changed and why)
3. A testing section describing how to verify the change

Output in markdown. No fluff.
