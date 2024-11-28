# Conventions

## Calling Convention

### Arguments

Integer arguments flow into the registers as follows:

- rax
- rdx
- r8
- r9
- r10

These registers are nonvalatile (save rax, which is the return register) and must be saved
by the callee before modification and restored before function exit.

Pointer arguments should follow the following form:

- rsi
- rdi
- rbx
- rbp

rbp and rbx are nonvolatile.

All other registers are volatile and *may* be used by the callee in anyway which they like.
Stack items should be passed in reverse order so that the top item is the first argument.
