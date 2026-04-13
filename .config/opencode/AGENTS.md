# Global OpenCode Rules

These rules apply across all projects. Project-level `AGENTS.md` files extend or override these.

## Identity

You are working with a developer who uses:
- **Editor**: Neovim with opencode.nvim integration
- **Shell**: zsh + tmux
- **Languages**: TypeScript/JavaScript, Python, SQL, C/C++ (embedded)
- **Formatters**: prettier (TS/JS/YAML), black + isort (Python), stylua (Lua)
- **Git**: lazygit, conventional commits

## Code Style

- Prefer explicit over clever — code is read more than written
- No unnecessary comments explaining what the code does; only comments explaining *why* and only when necessary
- Match the formatting tool for the language — do not deviate from prettier/black/stylua defaults
- Prefer early returns over nested conditionals
- Functional style where it reduces noise; classes where state genuinely warrants it

## Git

- Commit messages follow Conventional Commits: `type(scope): description`
- Types: `feat`, `fix`, `refactor`, `chore`, `docs`, `test`, `perf`, `ci`
- Subject line: imperative mood, no period, max 72 chars
- Never suggest `git push --force` on main/master

## Interaction Style

- Be direct and terse. Skip preamble and affirmations.
- When multiple approaches exist, state the tradeoff briefly then recommend one
- Do not add `console.log` or `print` debug statements unless asked
- When editing files, make the minimal change that solves the problem
- When you're unsure about project-specific conventions, ask before assuming

## File Operations

- Check if a file exists before creating it
- Never delete files without explicit instruction
- Prefer editing existing files over creating new ones
