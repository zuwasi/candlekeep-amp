# CandleKeep + Amp Package

Research your document library (PDFs, standards, specs) directly from [Amp](https://ampcode.com) with cited answers.

## What's Inside

```
candlekeep-package/
├── README.md                 ← You are here
├── install.ps1               ← One-click setup script (Windows)
├── bin/
│   └── ck.exe                ← CandleKeep CLI v0.6.0 (Windows x64)
├── skills/
│   └── candlekeep/
│       ├── SKILL.md          ← Amp skill definition
│       └── README.md         ← Skill documentation
└── examples/
    ├── MISRA_C_vs_ISO_C_Determinism_Analysis.md   ← Example output
    └── Amp_Integration_Guide.md                    ← Full guide
```

## Quick Setup (2 minutes)

### Automatic (recommended)

```powershell
powershell -ExecutionPolicy Bypass -File install.ps1
```

This will:
1. Install `ck.exe` to `%USERPROFILE%\.local\bin` and add it to PATH
2. Install the CandleKeep skill to `%USERPROFILE%\.agents\skills\candlekeep`
3. Open browser for CandleKeep Cloud authentication

### Manual

1. Copy `bin\ck.exe` somewhere on your PATH
2. Copy the `skills\candlekeep\` folder to `%USERPROFILE%\.agents\skills\candlekeep\`
3. Run `ck auth login`

## Usage

After setup, open a **new terminal** and:

```bash
# Upload a document
ck items add "C:\path\to\MISRA-C-2023.pdf"

# Verify
ck items list
```

Then in Amp, just ask naturally:
- *"What does my library say about pointer casting?"*
- *"Cross-reference MISRA Rule 11.3 across all my standards"*
- *"What issues in ISO C are solved by MISRA C?"*

## Example: MISRA C × CERT C × ISO C Analysis

See `examples\MISRA_C_vs_ISO_C_Determinism_Analysis.md` for a real analysis produced using this setup. It shows:

- How MISRA C addresses ~203 ISO C undefined behaviors
- How MISRA C constrains ~58 unspecified behaviors
- Cross-reference table mapping MISRA → CERT C → CWE
- Nuanced comparison (e.g., MISRA Rule 11.3 vs. CERT EXP36-C scope differences)

This entire analysis was generated conversationally in a single Amp session by uploading two PDFs and asking questions.

## Requirements

- Windows 10/11 (x64)
- [Amp](https://ampcode.com) installed
- CandleKeep Cloud account (free tier available at [getcandlekeep.com](https://getcandlekeep.com))

## Links

- [CandleKeep Cloud](https://getcandlekeep.com)
- [CandleKeep CLI (GitHub)](https://github.com/CandleKeepAgents/candlekeep-cli)
- [Amp](https://ampcode.com)
