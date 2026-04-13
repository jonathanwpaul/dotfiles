---
name: python
description: Python patterns, black+isort formatting, pyenv, type hints, common project structures
---

## Toolchain

- Formatter: `black` + `isort` (run via neovim conform on save)
- Version manager: `pyenv`
- Package management: `pip` with `venv`, or `poetry`

## Style rules (black-compatible)

- Line length: 88 chars (black default)
- Double quotes
- `isort` profile: `black`

```python
# isort config in pyproject.toml or setup.cfg:
[tool.isort]
profile = "black"
```

## Type hints

Always annotate function signatures. Use `from __future__ import annotations` for forward refs:

```python
from __future__ import annotations
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from mymodule import MyType

def process(items: list[str], limit: int = 10) -> list[str]:
    return items[:limit]
```

Use `TypeAlias` and `TypedDict` over ad-hoc dicts:

```python
from typing import TypedDict

class Config(TypedDict):
    host: str
    port: int
    debug: bool
```

## Patterns to follow

**Early returns:**
```python
def parse(value: str | None) -> str:
    if not value:
        return ""
    return value.strip()
```

**Context managers over try/finally:**
```python
with open(path) as f:
    data = f.read()
```

**Dataclasses over plain classes for data:**
```python
from dataclasses import dataclass, field

@dataclass
class Result:
    value: str
    errors: list[str] = field(default_factory=list)
```

## pyenv workflow

```bash
pyenv install 3.12.0
pyenv local 3.12.0        # writes .python-version
python -m venv .venv
source .venv/bin/activate
```

## Project structure

```
project/
├── src/
│   └── mypackage/
│       ├── __init__.py
│       └── module.py
├── tests/
│   └── test_module.py
├── pyproject.toml
└── .python-version
```
