---
name: token-efficiency
category: efficiency
description: Universal rules for minimizing token consumption, enforcing surgical diffs, avoiding redundant reads, and streamlining agent responses.
metadata:
  version: v1
  publisher: carthworks
  tags:
    - tokens
    - efficiency
    - performance
    - agent-behavior
---

# Token Efficiency & Context Economy Rules

## Behavioral Directives

1. **Surgical Diffs Only**:
   - Never output or rewrite whole unmodified files unless creating a file from scratch.
   - Always produce targeted, concise diff blocks or line replacements.
2. **Context-Conscious Exploration**:
   - Use bounded line ranges when reading large files (`view_file` with `StartLine`/`EndLine`).
   - Use `grep_search` with specific query patterns rather than recursively reading whole directories.
3. **No Redundant Summaries**:
   - Do not regurgitate artifact contents or explain boilerplate line-by-line.
   - Summarize the *why* and the *impact* in 2-3 sentences.
4. **Tool Result Conservation**:
   - Avoid repeating long tool outputs back into user messages.
   - Keep answers dense, precise, and actionable.
