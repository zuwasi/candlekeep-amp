# How MISRA C Makes ISO C Deterministic

## Overview

The ISO C standard contains hundreds of constructs whose behavior is undefined, unspecified, or implementation-defined. MISRA C:2023 addresses these systematically across three layers, effectively transforming C into a restricted, deterministic subset suitable for safety-critical systems.

This analysis is sourced from:
- **MISRA C:2023** (Third Edition, Second Revision, April 2023) — Appendix G, Appendix H, §6.10
- **SEI CERT C Coding Standard** (2016 Edition) — Appendix C, Appendix D

---

## Layer 1: Undefined Behavior → Banned Outright

MISRA C eliminates undefined behavior by **forbidding the constructs entirely**. Appendix H of MISRA C:2023 maps ~203 ISO C undefined behaviors to specific MISRA rules that prevent them.

Any undefined behavior not covered by a specific rule falls under **Rule 1.3** ("There shall be no occurrence of undefined or critical unspecified behaviour"), which acts as a catch-all.

### Memory Safety

| ISO C Undefined Behavior | MISRA Rule | What MISRA Does |
|---|---|---|
| Pointer misalignment from type casting | Rule 11.3 | Bans conversion between different object pointer types |
| Pointer-to-integer / integer-to-pointer conversion | Rule 11.4 | Bans pointer ↔ integer conversions |
| Void pointer conversion to object pointer | Rule 11.5 | Restricts `void*` → object pointer casts |
| Void pointer ↔ arithmetic type | Rule 11.6 | Bans `void*` ↔ arithmetic casts |
| Removing const/volatile qualification via cast | Rule 11.8 | Bans const/volatile removal from pointed-to type |
| Function pointer type conversions | Rule 11.1 | Bans function pointer ↔ any other type conversion |
| Incomplete type pointer conversions | Rule 11.2 | Bans conversions involving incomplete type pointers |
| Use of `restrict` qualifier | Rule 8.14 | Bans `restrict` entirely |
| Overlapping object copy/assignment | Rule 19.1 | Bans assignment/copy to overlapping objects |
| Pointer arithmetic out of array bounds | Rule 18.1 | Pointer arithmetic must stay within same array |
| Pointer subtraction across different arrays | Rule 18.2 | Bans cross-array pointer subtraction |
| Pointer comparison across different objects | Rule 18.3 | Restricts relational operators on pointers |
| Flexible array members | Rule 18.7 | Bans flexible array members |
| Variable-length arrays (VLAs) | Rule 18.8 | Bans VLAs entirely |
| Temporary lifetime object modification | Rule 18.9 | Bans array-to-pointer conversion on temporaries |
| Variably-modified array type pointers | Rule 18.10 | Bans pointers to variably-modified array types |

### Dynamic Memory & Resource Management

| ISO C Undefined Behavior | MISRA Rule | What MISRA Does |
|---|---|---|
| `malloc`/`free`/`calloc`/`realloc` misuse | Rule 21.3 | Bans `<stdlib.h>` memory functions entirely |
| Freeing non-allocated memory | Rule 22.2 | Only free what was allocated by Standard Library |
| Use-after-free (dangling FILE pointers) | Rule 22.6 | Bans use of FILE pointer after stream closed |
| Dangling pointers to automatic storage | Rule 18.6 | Bans copying address of auto/thread-local object to longer-lived object |
| Dynamic memory allocation | Dir 4.12 | Bans dynamic memory allocation entirely |

### Integer & Arithmetic

| ISO C Undefined Behavior | MISRA Rule | What MISRA Does |
|---|---|---|
| Signed integer overflow | Rule 12.4 | No unsigned integer wrap-around in constant expressions |
| Shift by negative or ≥ bit-width | Rule 12.2 | Shift operand must be in range [0, bit-width - 1] |
| Inappropriate essential type operands | Rule 10.1 | Restricts operand types for all operators |
| Narrowing conversions | Rule 10.3 | Bans assignment to narrower or different essential type |

### Control Flow & Functions

| ISO C Undefined Behavior | MISRA Rule | What MISRA Does |
|---|---|---|
| Recursive function calls | Rule 17.2 | Bans direct and indirect recursion |
| Implicit function declarations | Rule 17.3 | Functions must be declared before use |
| Missing return statement in non-void function | Rule 17.4 | All exit paths must have explicit return |
| `_Noreturn` function that returns | Rule 17.9 | `_Noreturn` functions must not return |
| `va_arg` / `<stdarg.h>` misuse | Rule 17.1 | Bans `<stdarg.h>` entirely |

### Banned Standard Library Headers/Functions

| ISO C Undefined Behavior | MISRA Rule | What MISRA Does |
|---|---|---|
| `setjmp`/`longjmp` misuse | Rule 21.4 | Bans `<setjmp.h>` entirely |
| `signal()` handler issues | Rule 21.5 | Bans `<signal.h>` entirely |
| `stdio.h` I/O undefined behaviors (~40 UBs) | Rule 21.6 | Bans Standard Library I/O functions |
| `atoi`/`atof`/`atol` on invalid input | Rule 21.7 | Bans these functions |
| `abort`/`exit`/`_Exit` misuse | Rule 21.8 | Bans termination functions |
| `bsearch`/`qsort` misuse | Rule 21.9 | Bans both functions |
| Time/date function misuse | Rule 21.10 | Bans time/date functions |
| `system()` command injection | Rule 21.21 | Bans `system()` entirely |
| `rand()`/`srand()` predictability | Rule 21.24 | Bans random number functions |
| Reserved identifier redefinition | Rule 21.1, 21.2 | Bans `#define`/`#undef` on reserved names |

### Concurrency (C11)

| ISO C Undefined Behavior | MISRA Rule | What MISRA Does |
|---|---|---|
| Data races between threads | Dir 5.1 | No data races allowed |
| Deadlocks between threads | Dir 5.2 | No deadlocks allowed |
| Dynamic thread creation | Dir 5.3 | Bans dynamic thread creation |
| Mutex double-lock (non-recursive) | Rule 22.18 | Bans recursive locking of non-recursive mutexes |
| Unlocking mutex not owned | Rule 22.17 | Thread must own the mutex it unlocks |
| Thread join/detach after already joined/detached | Rule 22.11 | Bans re-joining or re-detaching |
| Uninitialized synchronization objects | Rule 22.14 | Must initialize before access |

### Preprocessing

| ISO C Undefined Behavior | MISRA Rule | What MISRA Does |
|---|---|---|
| `#` and `##` operator misuse | Rule 20.10, 20.11, 20.12 | Restricts stringification/concatenation operators |
| Macro-expanded `#include` argument | Rule 20.3 | `#include` must use `<file>` or `"file"` directly |
| Macro name same as keyword | Rule 20.4 | Bans keyword-named macros |
| Preprocessing directives in macro arguments | Rule 20.6 | Bans directives inside macro args |
| Invalid preprocessing line | Rule 20.13 | Lines starting with `#` must be valid directives |

---

## Layer 2: Unspecified Behavior → Constrained

ISO C says "the compiler can do it any way" for unspecified behaviors. MISRA C says "don't rely on it" — it constrains code so the outcome is the same regardless of which valid choice the compiler makes.

Appendix H.2 of MISRA C:2023 maps ~58 critical unspecified behaviors.

### Evaluation Order & Side Effects

| ISO C Unspecified Behavior | MISRA Rule | What MISRA Does |
|---|---|---|
| Order of evaluation of sub-expressions | Rule 13.2 | Side effects must be order-independent |
| Side effects in initializer lists | Rule 13.1 | Bans persistent side effects in initializer lists |
| Side effects in `sizeof` operands | Rule 13.6 | Bans side effects in `sizeof` expressions |
| Side effects in `&&`/`||` right operand | Rule 13.5 | Bans persistent side effects in short-circuit operands |
| Result of assignment operator used as value | Rule 13.4 | Bans using assignment result as a value |
| Increment/decrement with other side effects | Rule 13.3 | Restricts `++`/`--` in complex expressions |

### Type & Pointer Safety

| ISO C Unspecified Behavior | MISRA Rule | What MISRA Does |
|---|---|---|
| `union` member access after storing another member | Rule 19.2 | Discourages `union` usage entirely |
| Padding bytes in struct comparison | Rule 21.16 | Restricts `memcmp` argument types |
| String literal mutability | Rule 7.4 | String literals must be assigned to `const char*` |
| Negative zero generation | Rule 10.1 | Restricts operand types to prevent generation |
| Identifier significance beyond minimum | Rule 5.1 | External identifiers must be distinct |
| `inline` function linkage | Rule 8.10 | Inline functions must be `static` |

### Library Functions

| ISO C Unspecified Behavior | MISRA Rule | What MISRA Does |
|---|---|---|
| `qsort`/`bsearch` element comparison order | Rule 21.9 | Bans both functions |
| `<fenv.h>` rounding modes | Rule 21.12 | Bans `<fenv.h>` |
| Floating-point exception handling | Dir 4.15 | Must handle infinities and NaNs |
| Library function argument validity | Dir 4.11 | Must validate arguments before calling |

---

## Layer 3: Implementation-Defined Behavior → Must Document

MISRA C doesn't ban implementation-defined behaviors but **Dir 1.1** requires that every instance your code depends on be documented and understood. Appendix G provides a checklist of ~100+ items.

### Key Implementation-Defined Behaviors Requiring Documentation

| ISO C Implementation-Defined Behavior | MISRA Approach |
|---|---|
| Size of `int`, `long`, `short`, etc. | Dir 4.6 — use fixed-width types (`uint32_t`, `int16_t`) instead |
| Signed integer representation (2's complement vs. others) | Document per Dir 1.1 |
| `char` signedness (signed vs. unsigned) | Document; use explicit `signed char`/`unsigned char` |
| Bit-field allocation order within storage unit | Document per Dir 1.1; Rules 6.1-6.3 constrain usage |
| Whether bit-fields can straddle storage boundaries | Document per Dir 1.1 |
| Floating-point precision and rounding | Document per Dir 1.1 |
| `#pragma` behavior | Document per Dir 1.1 |
| Integer division/remainder with negative operands | Document per Dir 1.1 |
| Header file search paths | Document per Dir 1.1 |
| Character set and encoding | Document per Dir 1.1 |
| `__DATE__` and `__TIME__` when unavailable | Document per Dir 1.1 |

---

## Summary Statistics

| Category | ISO C Count | MISRA Approach | Coverage |
|---|---|---|---|
| **Undefined Behaviors** | ~203 | Banned via specific rules or Rule 1.3 catch-all | ~100% |
| **Critical Unspecified Behaviors** | ~58 | Constrained to be order/choice-independent | ~100% of critical ones |
| **Implementation-Defined Behaviors** | ~100+ | Must document per Dir 1.1 | Documentation required |

## The Key Insight

MISRA C does not make C "safe" — it creates a **restricted, deterministic subset** by eliminating approximately 60% of the language features that cause problems:

- **Banned entirely:** dynamic memory, VLAs, recursion, unions (discouraged), goto (discouraged), `<stdarg.h>`, `<signal.h>`, `<setjmp.h>`, `<stdio.h>`, `system()`, `<fenv.h>`
- **Heavily restricted:** pointer casting, type conversions, side effects, preprocessing operators, bit-fields
- **Required documentation:** all implementation-defined behaviors the code depends on

What remains after applying MISRA C is a language where **every construct has one predictable outcome**, regardless of compiler, platform, or optimization level.

---

## Cross-Reference: MISRA C vs. CERT C vs. CWE

For the undefined behaviors addressed above, the following table maps the most significant overlaps:

| Topic | MISRA C:2023 | CERT C | CWE |
|---|---|---|---|
| Pointer casting / alignment | Rule 11.3, 11.4 | EXP36-C, INT36-C | CWE-704 |
| Null pointer dereference | Rule 1.3 (UB) | EXP34-C | CWE-476 |
| Uninitialized memory read | Rule 9.1 | EXP33-C | CWE-457 |
| Signed integer overflow | Rule 12.4 | INT32-C | CWE-190 |
| Shift out of range | Rule 12.2 | INT34-C | CWE-682 |
| Use-after-free | Rule 18.6, 22.6 | MEM30-C | CWE-416 |
| Free non-allocated memory | Rule 22.2 | MEM34-C | CWE-761 |
| Buffer overflow (string ops) | Rule 21.17, 21.18 | STR31-C | CWE-120 |
| Format string vulnerability | Rule 21.6 (banned) | FIO30-C | CWE-134 |
| Command injection via `system()` | Rule 21.21 | ENV33-C | CWE-78 |
| errno mishandling | Rule 22.8, 22.9, 22.10 | ERR30-C | CWE-456 |
| Data races | Dir 5.1 | CON32-C, CON33-C | CWE-362 |
| Deadlocks | Dir 5.2 | CON35-C | CWE-833 |
| Reserved identifier collision | Rule 21.1, 21.2 | DCL37-C | CWE-733 |
| Const modification | Rule 11.8 | EXP40-C | CWE-471 |

**Note:** MISRA takes a **restrictive** approach (bans constructs) while CERT takes a **prescriptive** approach (says "if you use it, do it safely"). Passing MISRA generally implies passing the corresponding CERT rules, but CERT may catch additional edge cases not covered by MISRA's scope (e.g., `void*` round-trip alignment issues).

---

*Document generated from CandleKeep library analysis — MISRA C:2023 and SEI CERT C 2016 Edition*
*Analysis date: March 13, 2026*
