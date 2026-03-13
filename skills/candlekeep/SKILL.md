---
name: candlekeep
description: "Search and research your CandleKeep Cloud document library for answers with citations. Upload, manage, read, and cross-reference documents (PDFs, markdown). Use when the user mentions their document library, wants to research across uploaded standards/documents, or references CandleKeep."
allowed-tools:
  - Bash
  - Read
  - Grep
  - finder
  - Task
  - look_at
---

# CandleKeep Document Library Skill

CandleKeep Cloud is a personal document library service. The `ck` CLI provides full access to your library — search, read, upload, manage, and cross-reference documents (PDFs, markdown, standards). All commands support `--json` for structured output.

## Prerequisites

The `ck` CLI must be installed and authenticated before use.

```bash
# Verify authentication
ck auth whoami
```

If authentication fails, direct the user to https://getcandlekeep.com to set up their account and CLI.

## When to Activate

### Research Triggers
- "research", "look up", "search my documents", "find in my library"
- "my library", "my books", "my PDFs", "my standards"
- "according to my documents", "what do my standards say"
- "what does [document name] say about..."

### Library Management Triggers
- "upload", "add to library", "add to my documents"
- "list my documents", "show my library"
- "remove document", "delete from library"

### Writing Triggers
- "write a document", "create a book", "create a document"
- "edit document", "update document"

### Cross-Reference Triggers
- "cross-reference", "compare standards"
- "which standards cover", "rule mapping"
- "traceability matrix", "equivalent rules"
- "what do all my standards say about..."

## When NOT to Activate

- Web searches or external research not involving the personal library
- Code file read/write operations (use Read/edit_file directly)
- General knowledge questions answerable without library documents
- User explicitly says not to check their library

## Workflow: Research

### Phase 1 — Assess Library
Run `ck items list --json` to get the full inventory of documents with their IDs, titles, and descriptions.

### Phase 2 — Identify Relevant Documents
Review document titles and descriptions to determine which are relevant to the user's question.

### Phase 3 — Check Table of Contents
Use `ck items toc <ids> --json` to inspect the structure and page count of relevant documents before reading.

### Phase 4 — Read Specific Pages
Use `ck items read <id>:<pages> --json` to read targeted sections. **Always specify a page range**:
- `id:all` — read entire document
- `id:1-5` — read pages 1 through 5
- `id:1,3,5` — read specific pages

Never pass a bare `id` without a page specifier.

### Phase 5 — Synthesize with Citations
Combine findings into a coherent answer. Always cite the document title and page numbers for every claim.

### Parallel Research (4+ documents or multiple topics)
Use the **Task tool** to dispatch parallel readers. Each task should receive:
- A focused sub-question
- Assigned document IDs to read
- Instructions to return findings with citations

Collect results from all tasks and synthesize into a unified answer.

## Workflow: Cross-Standard Lookup

When the user asks about rule equivalents across standards (e.g., "What is the CERT-C equivalent of MISRA Rule 11.3?"):

1. Run `ck items list --json` to identify all standards documents in the library
2. Use `ck items toc <ids> --json` on each standard to locate relevant sections
3. Use the **Task tool** to read relevant sections from each standard in parallel
4. Produce a traceability matrix:

```
| Standard       | Rule ID    | Rule Name                  | Category      |
|----------------|------------|----------------------------|---------------|
| MISRA-C:2023   | Rule 11.3  | Cast between pointer types | Type Safety   |
| CERT-C         | EXP36-C   | Pointer cast alignment     | Expressions   |
| AUTOSAR C++14  | A5-2-6    | Cast restrictions          | Conversions   |
```

## Workflow: Library Management

```bash
ck items list [--json]           # List all documents with IDs, titles, descriptions
ck items add <file>              # Upload a PDF or markdown file
ck items remove <ids> --yes      # Delete documents by ID (requires --yes)
ck items toc <ids> [--json]      # Show table of contents for documents
ck auth whoami                   # Check current authentication status
```

## Workflow: Document Writing

```bash
ck items create "Title" [-d "description"] [-c "content"]  # Create a new document
ck items get <id>                                           # Download content to stdout
ck items put <id> --file path.md                            # Upload updated content from file
```

Typical edit flow:
1. `ck items get <id> > document.md` — download current content
2. Edit `document.md` locally
3. `ck items put <id> --file document.md` — upload changes

## Key Rules

1. **Always refresh IDs** — Run `ck items list --json` fresh at the start of every session. Never reuse document IDs from a previous conversation.
2. **Always check TOC first** — Before reading pages, run `ck items toc` to verify page count and structure. Do not read beyond the document's page count.
3. **Always specify page ranges** — Every `ck items read` call must include a page specifier (e.g., `id:1-5`, `id:all`, `id:1,3,5`). Never pass a bare `id`.
4. **Always cite sources** — Every research finding must include the document title and page number(s).
5. **Parallelize when possible** — For research spanning 4+ documents or multiple topics, use the Task tool to dispatch parallel readers. Never read documents sequentially when they can be read concurrently.
6. **Use `--json` for programmatic access** — Always pass `--json` when processing command output programmatically.

## Complete CLI Reference

| Command | Arguments | Flags | Description |
|---------|-----------|-------|-------------|
| `ck auth whoami` | — | — | Show current authenticated user |
| `ck items list` | — | `--json` | List all documents in the library |
| `ck items add` | `<file>` | — | Upload a PDF or markdown file |
| `ck items remove` | `<ids>` | `--yes` | Delete documents by ID |
| `ck items toc` | `<ids>` | `--json` | Show table of contents |
| `ck items read` | `<id>:<pages>` | `--json` | Read specific pages from a document |
| `ck items create` | `"Title"` | `-d "desc"`, `-c "content"` | Create a new document |
| `ck items get` | `<id>` | — | Download document content to stdout |
| `ck items put` | `<id>` | `--file <path>` | Upload updated content from a file |

**Page specifier formats for `ck items read`:**
- `id:all` — all pages
- `id:1-5` — page range (inclusive)
- `id:1,3,5` — specific pages
- `id:3` — single page

## Output Format

Research results should follow this structure:

```
## Sources Consulted
- Document Title (pages X-Y)
- Another Document (pages A, B, C)

## Findings
[Synthesized answer with inline citations, e.g., "Pointer casts between incompatible types
are prohibited (MISRA-C:2023, Rule 11.3, p. 42)."]

## Cross-References (if applicable)
| Standard | Rule ID | Rule Name | Category |
|----------|---------|-----------|----------|
| ...      | ...     | ...       | ...      |
```
