---
name: owasp-llm-top-10
description: |
  Comprehensive checklist and mitigation strategies for the OWASP Top 10 for Large
  Language Model Applications (LLM01 to LLM10). Use when conducting security audits,
  architectural risk reviews, compliance checks, or threat modeling on LLM applications.
  Do NOT use for traditional OWASP Top 10 web vulnerabilities.
license: Apache-2.0
metadata:
  version: v1
  publisher: carthworks
  tags:
    - owasp-llm
    - ai-security
    - compliance
    - threat-modeling
---

# OWASP Top 10 for LLM Applications

> [!IMPORTANT]
> The OWASP Top 10 for LLM Applications provides a standardized framework for identifying,
> evaluating, and mitigating the most critical vulnerabilities in Generative AI systems.

---

## Quick Reference Matrix

| ID | Vulnerability Name | Primary Threat Vector | Key Mitigation |
|---|---|---|---|
| **LLM01** | **Prompt Injection** | Untrusted user input or retrieved web/RAG content overriding system logic. | Delimiter tagging, quarantine LLMs, canary tokens, input sanitization. |
| **LLM02** | **Sensitive Information Disclosure** | Model revealing PII, API keys, credentials, or proprietary data in responses. | Ingestion scrubbing, output PII filters, differential privacy, DLP rules. |
| **LLM03** | **Supply Chain Vulnerabilities** | Compromised base models, poisoned third-party LoRAs, untrusted plugins/dependencies. | Cryptographic hash verification, model provenance (SLSA), dependency scanning. |
| **LLM04** | **Data and Model Poisoning** | Malicious training/fine-tuning data introducing backdoors or biased generation. | Data lineage tracking, anomaly detection on training sets, fine-tuning verification. |
| **LLM05** | **Improper Output Handling** | Unvalidated model outputs passed directly to shells, browsers, or downstream APIs. | Context-aware output encoding (HTML, SQL), strict schema validation before execution. |
| **LLM06** | **Excessive Agency** | Agents granted broad capabilities, permissions, or autonomy without human verification. | Principle of Least Privilege, human-in-the-loop for irreversible actions, sandboxing. |
| **LLM07** | **System Prompt Leakage** | Extraction of proprietary business logic, internal secrets, or confidential prompts. | Strict boundary rules, canary tokens, output classifiers detecting meta-reflections. |
| **LLM08** | **Vector and Embedding Weaknesses** | Malicious injection into vector stores causing unauthorized or poisoned context retrieval. | Multi-tenant namespace isolation, embedding similarity bounds, metadata ACLs. |
| **LLM09** | **Misinformation & Hallucination** | Fabricated facts, false citations, or non-existent API packages. | Grounding validation, claim extraction vs trusted evidence, cross-encoder scoring. |
| **LLM10** | **Unbounded Consumption** | Resource exhaustion ("Denial of Wallet"), infinite loops, massive context exploitation. | Token rate limiting, strict max_tokens, timeout caps, cost monitoring per user. |

---

## Detailed Audit & Remediation Playbook

### LLM01: Prompt Injection
- **Risk**: Attackers manipulate prompt context to execute arbitrary instructions.
- **Checklist**:
  - [ ] Are inputs wrapped in structural delimiters (`<user_input>`, `<data>`)?
  - [ ] Are closing tag injections filtered/escaped?
  - [ ] Are external documents (emails, URLs, PDFs) processed via a tool-less quarantine model?

### LLM02: Sensitive Information Disclosure
- **Risk**: Unintentional exposure of proprietary secrets or user PII.
- **Checklist**:
  - [ ] Is input scrubbed of PII before sending to third-party LLM providers?
  - [ ] Are regex/NER DLP scanners running on model responses before returning to users?
  - [ ] Is fine-tuning data sanitized to remove credentials and internal tokens?

### LLM05: Improper Output Handling
- **Risk**: Model output treated as trusted input by web clients or backend systems (leading to XSS, SSRF, SQLi, or RCE).
- **Checklist**:
  - [ ] If rendering markdown/HTML in browser, is DOMPurify or equivalent sanitizer applied?
  - [ ] If generating SQL, are queries parameterized rather than string-interpolated?
  - [ ] If executing CLI commands, are arguments strictly parsed with an allowlist?

### LLM06: Excessive Agency
- **Risk**: AI agent has destructive capabilities (delete files, transfer funds, send public emails) without review.
- **Checklist**:
  - [ ] Are write/delete operations classified as high-risk?
  - [ ] Is explicit user confirmation required before high-impact tool execution?
  - [ ] Are tools scoped with granular API tokens rather than admin/superuser access?

### LLM08: Vector and Embedding Weaknesses
- **Risk**: Attackers poison vector database or bypass tenant isolation to retrieve unauthorized embeddings.
- **Checklist**:
  - [ ] Does every vector search query enforce a strict tenant ID / user ID filter in metadata?
  - [ ] Is raw document ingestion verified for provenance before embedding?
  - [ ] Are embedding cosine similarity score thresholds applied to reject out-of-distribution noise?

### LLM10: Unbounded Consumption
- **Risk**: Malicious requests consume massive token volumes, causing financial denial-of-service.
- **Checklist**:
  - [ ] Are per-user and per-IP token rate limits enforced?
  - [ ] Is `max_tokens` (or `max_output_tokens`) strictly capped on all inference calls?
  - [ ] Are agent tool loops capped with a maximum iteration count (e.g., max 5 iterations)?

---

## Production Readiness Audit Sign-off

```markdown
### OWASP LLM Audit Report
- **Application Name**: [App Name]
- **Auditor**: [Author/Team]
- **Date**: [YYYY-MM-DD]

| Category | Status | Notes |
|---|---|---|
| LLM01: Prompt Injection | PASS / FAIL | Structural delimiters enforced |
| LLM02: Sensitive Info Disclosure | PASS / FAIL | Output PII scanning active |
| LLM03: Supply Chain | PASS / FAIL | Model hashes pinned |
| LLM04: Poisoning | PASS / FAIL | Ingestion pipelines validated |
| LLM05: Improper Output Handling | PASS / FAIL | Contextual sanitization verified |
| LLM06: Excessive Agency | PASS / FAIL | Human confirmation gates active |
| LLM07: System Prompt Leakage | PASS / FAIL | Canary token checks enabled |
| LLM08: Vector Weaknesses | PASS / FAIL | Metadata tenancy filtering enforced |
| LLM09: Misinformation | PASS / FAIL | Grounding pipeline in place |
| LLM10: Unbounded Consumption | PASS / FAIL | Token budgets & rate limits active |
```
