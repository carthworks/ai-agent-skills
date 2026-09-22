---
name: agent-tool-guardrails
description: |
  Guides designing and implementing security guardrails, permission scoping, and execution
  boundaries for autonomous AI agents and tool use. Covers principle of least privilege,
  human-in-the-loop approvals, sandbox execution, argument validation, and blast-radius
  containment. Use when exposing APIs, functions, bash commands, or databases to AI agents.
  Do NOT use for UI button access control.
license: Apache-2.0
metadata:
  version: v1
  publisher: carthworks
  tags:
    - agent-security
    - tool-use
    - blast-radius
    - execution-sandbox
---

# Agent Tool Guardrails & Blast Radius Containment

> [!IMPORTANT]
> When an LLM is granted tool-calling capabilities, it ceases to be a text generator and
> becomes an execution engine. Unconstrained tool access turns a prompt injection into an
> arbitrary code execution or remote database breach.

---

## Action Risk Classification Matrix

Classify every tool in your agent's registry into one of three risk tiers:

```
┌────────────────────────────────────────────────────────┐
│ TIER 1: READ-ONLY / IDEMPOTENT (Auto-Execute)          │
│ Examples: search_docs, get_weather, list_files         │
└──────────────────────────┬─────────────────────────────┘
                           ↓
┌────────────────────────────────────────────────────────┐
│ TIER 2: LOW-RISK REVERSIBLE WRITE (Auto with Audit)    │
│ Examples: create_draft, add_todo, set_user_preference  │
└──────────────────────────┬─────────────────────────────┘
                           ↓
┌────────────────────────────────────────────────────────┐
│ TIER 3: HIGH-RISK IRREVERSIBLE (HUMAN-IN-THE-LOOP)     │
│ Examples: delete_table, send_email, execute_shell,     │
│           transfer_funds, update_production_config     │
└────────────────────────────────────────────────────────┘
```

---

## Tool Execution Guardrail Architecture

```python
from enum import Enum
from pydantic import BaseModel, Field, field_validator
import re

class RiskTier(Enum):
    READ_ONLY = "read_only"
    REVERSIBLE_WRITE = "reversible_write"
    IRREVERSIBLE_CRITICAL = "irreversible_critical"

class BaseToolGuardrail:
    risk_tier: RiskTier

    def execute(self, params: dict, context: dict):
        # 1. Validate parameters against strict schema
        validated_params = self.validate_params(params)

        # 2. Check risk tier and human confirmation
        if self.risk_tier == RiskTier.IRREVERSIBLE_CRITICAL:
            if not context.get("human_confirmed", False):
                raise PermissionError(
                    f"Action '{self.__class__.__name__}' requires explicit human approval."
                )

        # 3. Execute inside sandbox boundary
        return self._run(validated_params)
```

---

## Parameter Validation & Attack Mitigation

### 1. File Path Traversal Defense

Never allow relative directory traversal (`../`) or root filesystem access:

```python
import os
from pathlib import Path

class ReadFileParams(BaseModel):
    file_path: str

    @field_validator("file_path")
    @classmethod
    def sanitize_path(cls, v: str) -> str:
        # Resolve path against strict workspace root
        WORKSPACE_ROOT = Path("/app/workspace").resolve()
        target = (WORKSPACE_ROOT / v).resolve()

        # Reject path traversal outside workspace
        if not str(target).startswith(str(WORKSPACE_ROOT)):
            raise ValueError(f"Path traversal detected: {v} is outside allowed directory.")

        return str(target)
```

### 2. Shell Command Allowlisting & Shell Injection Defense

Never execute arbitrary shell strings through `subprocess.run(shell=True)`. Use strict command allowlists and argument arrays:

```python
import subprocess

ALLOWED_COMMANDS = {
    "git": ["status", "diff", "log"],
    "npm": ["test", "run build", "list"],
    "pytest": []
}

def execute_safe_command(binary: str, args: list[str]) -> str:
    # 1. Check binary against allowlist
    if binary not in ALLOWED_COMMANDS:
        raise PermissionError(f"Command '{binary}' is not in the approved tool allowlist.")

    # 2. Check subcommands/flags if restricted
    allowed_subcmds = ALLOWED_COMMANDS[binary]
    if allowed_subcmds and (not args or args[0] not in allowed_subcmds):
        raise PermissionError(f"Subcommand '{args}' not permitted for binary '{binary}'.")

    # 3. Execute without shell interpolation
    res = subprocess.run(
        [binary] + args,
        shell=False,  # CRITICAL: Prevent shell injection (; && | `)
        capture_output=True,
        text=True,
        timeout=30
    )
    return res.stdout
```

### 3. SQL Query Guardrails

When granting SQL tools:
- Create a read-only database user with strict timeouts and row limits.
- Block `DROP`, `TRUNCATE`, `ALTER`, `GRANT`, and `UPDATE` on sensitive tables.

```python
FORBIDDEN_SQL_KEYWORDS = ["DROP", "TRUNCATE", "ALTER", "GRANT", "REVOKE"]

def validate_sql_query(query: str) -> str:
    cleaned = query.strip().upper()
    for kw in FORBIDDEN_SQL_KEYWORDS:
        if re.search(r'\b' + kw + r'\b', cleaned):
            raise PermissionError(f"Destructive SQL keyword '{kw}' is blocked by guardrails.")
    return query
```

---

## Blast Radius Containment Rules

1. **Ephemeral Execution** — Agent tools that compile code or run scripts must execute inside disposable containers (Docker, WebAssembly, gVisor) with network egress disabled by default.
2. **Credential Scoping** — Do not pass master API keys or global tokens to agent tools. Issue short-lived, scoped tokens (e.g. AWS STS assume-role, GitHub fine-grained installation tokens).
3. **Loop & Rate Caps** — Impose strict execution limits:
   - Maximum 10 tool calls per user task.
   - Timeout of 30 seconds per individual tool execution.
   - Circuit breaker if a tool fails 3 consecutive times.

---

## Agent Tooling Checklist

- [ ] Every registered tool classified into a Risk Tier (Tier 1, 2, or 3).
- [ ] Tier 3 tools require explicit user confirmation before execution.
- [ ] All tool arguments validated via Pydantic or Zod with path traversal and injection protections.
- [ ] No tool uses `shell=True` or raw string concatenation into system commands.
- [ ] Database tools use dedicated read-only credentials with enforced `LIMIT` clauses.
- [ ] Tool execution loop bounded by iteration and timeout caps to prevent runaway execution.
- [ ] Full audit logging records timestamp, tool name, arguments, and outcome for forensic review.
