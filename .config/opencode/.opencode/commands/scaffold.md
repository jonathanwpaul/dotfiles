---
description: Scaffold a new file or module. Usage: /scaffold <type> <name>
agent: build
---
Scaffold a new $1 named $2.

Detect the project type from the surrounding files and match its conventions exactly:
- File location: follow the project's existing directory structure
- Imports: match the import style already used in the project
- Exports: named vs default — match what the project uses
- Types: if TypeScript, include proper types; no `any`
- Tests: if a test directory exists, create a matching test file

Do not add placeholder comments like `// TODO: implement`. Leave the scaffold minimal but functional.
