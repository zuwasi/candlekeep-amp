# CandleKeep + Amp Demo: MISRA C × CERT C × ISO C

Reproduce the cross-standard compliance analysis step by step.

## Prerequisites

- Run `install.ps1` first (see main README.md)
- Have copies of these PDFs (your team's licensed copies):
  - **MISRA C:2023** (Third Edition)
  - **SEI CERT C Coding Standard** (2016 Edition)

## Step 1 — Upload Your Standards

Open a terminal and upload both documents:

```bash
ck items add "C:\path\to\MISRA-C-2023.pdf"
ck items add "C:\path\to\SEI_CERT_C_Coding_Standard_2016.pdf"
```

Wait about 1 minute for processing, then verify:

```bash
ck items list
```

You should see both documents with status `READY` and page counts.

## Step 2 — Open Amp and Try These Prompts

Open Amp (CLI or VS Code) and type the following prompts one at a time.

### Demo 1: Simple Rule Lookup

```
What does my library say about commenting out sections of code?
```

**Expected:** Amp finds MISRA Dir 4.4 (page 31) and related Rules 3.1, 3.2 with full citations.

### Demo 2: Cross-Standard Overlap

```
What is the overlap between MISRA C and CERT C?
```

**Expected:** Amp reads appendices from both documents and produces a cross-reference table mapping MISRA rules to CERT rules and CWE IDs.

### Demo 3: Can I Skip a Scan?

```
If a MISRA C scan shows no Rule 11.3 or 11.4 violations, is it necessary to scan for EXP36-C and INT36-C in a CERT C scan?
```

**Expected:** Amp reads the specific rule pages from both standards and explains the scope differences — MISRA is broader but CERT catches `void*` round-trip edge cases.

### Demo 4: ISO C Determinism Analysis

```
What issues that are undefined or unspecified in ISO C are solved in MISRA C by making them deterministic and 100% clear?
```

**Expected:** Amp reads MISRA Appendix G and Appendix H and produces a comprehensive three-layer analysis:
- Layer 1: ~203 undefined behaviors → banned
- Layer 2: ~58 unspecified behaviors → constrained
- Layer 3: ~100+ implementation-defined behaviors → must document

### Demo 5: Save the Analysis

```
Put that in a document
```

**Expected:** Amp generates a formatted markdown document and can save it back to your CandleKeep library for future reference.

## Step 3 — Try Your Own Questions

Once comfortable, try questions relevant to your project:

- *"Which of my standards cover memory allocation restrictions?"*
- *"What does CERT C say about errno handling, and what's the MISRA equivalent?"*
- *"Compare how MISRA and CERT handle thread safety"*
- *"Upload C:\docs\AUTOSAR-CPP14.pdf to my library"* — then cross-reference three standards at once

## Reference Output

See `MISRA_C_vs_ISO_C_Determinism_Analysis.md` in this folder for the exact output produced by Demo 4.

## Tips

- **First prompt in a session:** Amp runs `ck items list` to discover your documents — this happens automatically
- **Page citations:** Every finding includes document name and page numbers — verify against your PDFs
- **Multiple standards:** The more standards you upload, the richer the cross-referencing. Try adding AUTOSAR, IEC 62443, HIC++, or DISA STIG
- **Parallel research:** For questions spanning 4+ documents, Amp dispatches parallel readers automatically
