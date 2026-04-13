---
name: git-workflow
description: Conventional commits, branch strategy, PR workflow with gh CLI and lazygit
---

## Commit conventions

Format: `type(scope): description`

Types and when to use them:
- `feat` — new user-facing capability
- `fix` — bug fix
- `refactor` — restructuring without behaviour change
- `perf` — measurable performance improvement
- `test` — adding or fixing tests only
- `chore` — tooling, deps, config with no production impact
- `ci` — CI/CD pipeline changes
- `docs` — documentation only

Rules:
- Imperative mood: "add feature" not "added feature"
- No period at end of subject
- Max 72 chars on subject line
- Body explains *why*, not *what* (the diff already shows what)
- Breaking changes: add `!` after type or `BREAKING CHANGE:` footer

## Branch naming

```
feat/short-description
fix/issue-or-description
chore/what-is-changing
```

## PR workflow (gh CLI)

```bash
gh pr create --title "feat(scope): description" --body "$(cat <<'EOF'
## Summary
- What changed and why

## Testing
- How to verify
EOF
)"

gh pr view --web          # open in browser
gh pr checks              # check CI status
gh pr merge --squash      # squash merge when ready
```

## Useful git operations

```bash
# Interactive rebase to clean up before PR
git rebase -i origin/main

# Amend last commit (unpushed only)
git commit --amend --no-edit

# Stash with a name
git stash push -m "wip: description"

# Find when a line was introduced
git log -S "search string" --source --all
```

## lazygit notes

- `space` to stage/unstage
- `c` to commit
- `P` to push, `p` to pull
- `i` for interactive rebase
- `e` to open file in $EDITOR
