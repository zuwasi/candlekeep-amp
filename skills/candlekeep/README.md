# CandleKeep Skill for Amp

An Amp skill that integrates with [CandleKeep Cloud](https://getcandlekeep.com) — your personal document library. Search, read, upload, manage, and cross-reference documents (PDFs, markdown, standards) directly from Amp.

## What This Skill Does

- **Research** — Search your uploaded documents and return answers with citations (document title + page numbers)
- **Cross-reference** — Compare rules and concepts across multiple standards (e.g., MISRA, CERT-C, AUTOSAR) and produce traceability matrices
- **Library management** — List, upload, and remove documents from your CandleKeep library
- **Document writing** — Create and edit documents stored in your library
- **Parallel reading** — Dispatches multiple readers for large research tasks spanning many documents

## Prerequisites

1. **Install the `ck` CLI** from [github.com/CandleKeepAgents/candlekeep-cli](https://github.com/CandleKeepAgents/candlekeep-cli)
2. **Authenticate** — Run `ck auth whoami` to verify your login. Follow the CLI setup instructions if not yet authenticated.

## Installation

Copy the `candlekeep` skill folder into your Amp skills directory:

```
# Global (available in all projects)
~/.agents/skills/candlekeep/

# Project-specific
<project-root>/skills/candlekeep/
```

The folder should contain:
```
candlekeep/
├── SKILL.md
└── README.md
```

Amp will automatically detect and load the skill when a matching trigger is used.

## Usage Examples

**Research your library:**
> "What does my library say about pointer casting?"

**Upload a document:**
> "Upload C:\docs\MISRA-C-2023.pdf to my library"

**Cross-reference standards:**
> "Cross-reference MISRA Rule 11.3 across all my standards"

**List your documents:**
> "List my documents"

**Create a new document:**
> "Create a document called 'Project Coding Guidelines' with a summary of our standards"

## Links

- **CandleKeep Cloud**: https://getcandlekeep.com
- **CLI Repository**: https://github.com/CandleKeepAgents/candlekeep-cli
