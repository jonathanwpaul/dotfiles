---
name: typescript
description: TypeScript patterns, strict config, formatting with prettier, common pitfalls
---

## Toolchain

- Formatter: `prettier` (via `prettierd` in neovim conform)
- LSP: `ts_ls`
- Package manager: `pnpm` preferred, `npm`/`bun` also in use
- Runtime environments: Node.js (via nvm), browser

## tsconfig baseline

```json
{
  "compilerOptions": {
    "strict": true,
    "noUncheckedIndexedAccess": true,
    "exactOptionalPropertyTypes": true,
    "noImplicitReturns": true,
    "noFallthroughCasesInSwitch": true
  }
}
```

## Patterns to follow

**Early returns over nesting:**
```ts
// good
function process(input: string | null): string {
  if (!input) return ''
  if (input.length < 3) return input
  return input.trim().toLowerCase()
}
```

**Explicit return types on exported functions:**
```ts
export function parseConfig(raw: unknown): Config { ... }
```

**Prefer `type` over `interface` for non-extendable shapes:**
```ts
type ApiResponse<T> = { data: T; error: null } | { data: null; error: string }
```

**Avoid `any` — use `unknown` + narrowing:**
```ts
function parse(raw: unknown): string {
  if (typeof raw !== 'string') throw new Error('expected string')
  return raw
}
```

**Exhaustive switch with never:**
```ts
function assertNever(x: never): never {
  throw new Error(`Unhandled case: ${x}`)
}
```

## Common pitfalls

- `noUncheckedIndexedAccess` means array indexing returns `T | undefined` — guard it
- Don't use `!` non-null assertions; narrow instead
- `Object.keys()` returns `string[]` not `(keyof T)[]` — cast carefully
- Async functions always return `Promise<T>` — callers must handle rejection

## Import style

```ts
// named imports
import { foo, bar } from './module'

// type-only imports (required with isolatedModules)
import type { Foo } from './types'
```
