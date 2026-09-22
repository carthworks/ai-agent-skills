---
name: rag-data-leakage-prevention
description: |
  Guides prevention of sensitive data leakage, PII exposure, and unauthorized cross-tenant
  data access in Retrieval-Augmented Generation (RAG) systems. Covers document-level access
  control, embedding sanitization, PII redaction, and output filtering. Use when building
  or securing RAG pipelines, vector databases, or multi-tenant knowledge retrieval.
  Do NOT use for traditional database access control.
license: Apache-2.0
metadata:
  version: v1
  publisher: carthworks
  tags:
    - rag-security
    - data-leakage
    - pii-redaction
    - vector-database
---

# RAG Data Leakage Prevention

> [!IMPORTANT]
> In Retrieval-Augmented Generation (RAG), vector similarity search does NOT respect user permissions
> unless strict access control filters are applied at the database query level. Unfiltered retrieval
> is the #1 cause of cross-tenant data exposure in enterprise AI.

---

## The 3 Vulnerability Checkpoints in RAG

```
┌────────────────────────────────────────────────────────┐
│ 1. INGESTION CHECKPOINT                                │
│ Scrub PII, mask credentials, attach tenant/role ACLs   │
└──────────────────────────┬─────────────────────────────┘
                           ↓ (Clean Embeddings + ACL Metadata)
┌────────────────────────────────────────────────────────┐
│ 2. RETRIEVAL CHECKPOINT                                │
│ Enforce hard tenant & permission filters in vector DB  │
└──────────────────────────┬─────────────────────────────┘
                           ↓ (Authorized Chunks Only)
┌────────────────────────────────────────────────────────┐
│ 3. GENERATION & OUTPUT CHECKPOINT                      │
│ Redact secrets, enforce DLP scanning on LLM output     │
└────────────────────────────────────────────────────────┘
```

---

## 1. Ingestion-Time Sanitization & ACL Tagging

### PII Masking & Tokenization
Never store raw social security numbers, credit cards, or internal credentials in vector chunks:

```python
import re
from typing import Dict, Any

PII_PATTERNS = {
    "SSN": r"\b\d{3}-\d{2}-\d{4}\b",
    "CREDIT_CARD": r"\b(?:\d{4}[-\s]?){3}\d{4}\b",
    "API_KEY": r"(?i)(bearer\s+[a-z0-9_\-\.]{20,}|(?:ghp|sk|akia)[a-z0-9]{16,})",
    "EMAIL": r"\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,7}\b"
}

def redact_sensitive_entities(text: str) -> str:
    redacted = text
    for entity_type, pattern in PII_PATTERNS.items():
        redacted = re.sub(pattern, f"[{entity_type}_REDACTED]", redacted)
    return redacted

def prepare_chunk_metadata(doc_id: str, tenant_id: str, allowed_roles: list) -> Dict[str, Any]:
    """
    Every chunk MUST carry access control metadata.
    """
    return {
        "doc_id": doc_id,
        "tenant_id": tenant_id,
        "allowed_roles": allowed_roles,
        "ingested_at": "2026-09-22T00:00:00Z"
    }
```

---

## 2. Retrieval-Time Enforcement (Pre-Retrieval Filtering)

> [!CAUTION]
> Never filter retrieved chunks in Python *after* the vector search. If you retrieve top 5 results
> and 4 belong to another tenant, post-filtering leaves you with only 1 chunk.
> Filtering MUST occur inside the vector engine before similarity ranking.

### Vector DB Metadata Filtering Examples

#### Pinecone
```python
results = index.query(
    vector=query_embedding,
    top_k=5,
    filter={
        "tenant_id": {"$eq": current_user.tenant_id},
        "allowed_roles": {"$in": current_user.roles}
    },
    include_metadata=True
)
```

#### Qdrant
```python
from qdrant_client.http import models

results = client.search(
    collection_name="knowledge_base",
    query_vector=query_embedding,
    query_filter=models.Filter(
        must=[
            models.FieldCondition(
                key="tenant_id",
                match=models.MatchValue(value=current_user.tenant_id),
            ),
            models.FieldCondition(
                key="allowed_roles",
                match=models.MatchAny(any=current_user.roles),
            )
        ]
    ),
    limit=5
)
```

#### pgvector (PostgreSQL with Row Level Security)
```sql
-- RLS ensures query cannot see rows outside the session tenant
SET LOCAL app.current_tenant_id = 'tenant_123';

SELECT id, content, 1 - (embedding <=> $1) AS similarity
FROM document_chunks
WHERE tenant_id = current_setting('app.current_tenant_id')
  AND allowed_roles && $2::text[]
ORDER BY embedding <=> $1
LIMIT 5;
```

---

## 3. Output-Time Data Loss Prevention (DLP)

Even when retrieval is authorized, the LLM might synthesize or regurgitate sensitive entities that should not be displayed in the current user's session:

```python
def output_dlp_guardrail(generated_response: str, user_clearance_level: str) -> str:
    """
    Scans the generated response for sensitive data disclosure before sending to client.
    """
    # Reject or redact any internal API keys or credentials
    clean_output = redact_sensitive_entities(generated_response)
    
    # Internal confidential markers
    if "CONFIDENTIAL_INTERNAL_ONLY" in clean_output and user_clearance_level != "admin":
        return "I am sorry, but the response contained confidential internal information that cannot be displayed."
        
    return clean_output
```

---

## RAG Security Checklist

- [ ] Raw source documents scrubbed of credentials, API tokens, and PII before embedding.
- [ ] Every chunk indexed with explicit `tenant_id` and role/group access control metadata.
- [ ] Vector search enforces hard metadata filters natively in the vector database query.
- [ ] Multi-tenant isolation verified by cross-tenant query tests in test suites.
- [ ] Context window size audited to prevent inadvertent injection of large unredacted documents.
- [ ] Output DLP scanner runs on all generated responses prior to client rendering.
