# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Project Is

VecFor is a pure Fortran library for 3D vector algebra using OOP. It provides a `vector` derived type (with `x`, `y`, `z` real components) and comprehensive operator overloading for Cartesian geometry.

## Build Commands

### Simple Make Build (produces `static/vecfor.a`)
```bash
make          # Build static library with gfortran
make clean    # Remove object files
make cleanall # Full clean
```

### FoBiS.py Build (supports multiple compilers/modes)
```bash
FoBiS.py build -mode static-gnu          # GNU static library
FoBiS.py build -mode shared-gnu          # GNU shared library
FoBiS.py build -mode static-intel        # Intel static library
FoBiS.py rule -ex clean                  # Clean all build artifacts
```

### Running Tests
```bash
FoBiS.py doctests -mode tests-gnu-debug  # Build and generate test executables
./scripts/run_tests.sh                    # Run all test executables in ./exe/
```

Tests are doctest-driven: they are extracted from source documentation comments and auto-generated into `src/tests/`. Test programs check for the string "Are all tests passed?" in their output.

### Documentation
```bash
FoBiS.py rule -ex makedoc       # Generate HTML docs with FORD into doc/html/
FoBiS.py rule -ex makecoverage  # Generate gcov coverage analysis
```

## Architecture

### Precision Variants via Preprocessor
The library provides the same `vector` type at multiple precisions using C preprocessor (`#include`). The implementation lives in a single template file:

- `src/lib/vecfor_RPP.INC` — the actual implementation (~3000 lines), included by each precision-specific module
- `src/lib/vecfor_R4P.F90` — single precision (`real(R4P)` components)
- `src/lib/vecfor_R8P.F90` — double precision (`real(R8P)` components)
- `src/lib/vecfor_R16P.F90` — quad precision, guarded by `-D_R16P_SUPPORTED`
- `src/lib/vecfor_RPP.F90` — default precision (uses R8P by default)
- `src/lib/vecfor.F90` — master aggregator module that re-exports all precisions

User code only needs `use vecfor`.

### Key Public Interface
- **Types**: `vector`, `vector_R4P`, `vector_R8P`, `vector_R16P`
- **Versors**: `ex`, `ey`, `ez` (unit vectors along Cartesian axes, available for each precision)
- **Arithmetic operators**: `+`, `-`, `*`, `/` (support mixed vector/real/integer operands)
- **Custom operators**: `.cross.` (cross product), `.dot.` (dot product), `.matrix.` (matrix product), `.paral.` (parallel component), `.ortho.` (orthogonal component)
- **Methods**: `normL2()`, `normalized()`, `normalize()`, `sq_norm()`, `angle()`, `rotate()`, `mirror()`, `distance_to_line()`, `distance_to_plane()`, `projection_onto_plane()`, `is_collinear()`, `is_concyclic()`

### PENF Dependency
Kind parameters (R4P, R8P, R16P) come from the PENF submodule at `src/third_party/PENF/`. Always initialize with `git submodule update --init --recursive`. The `fobos` file references PENF sources; the plain `makefile` only needs the PENF `.mod` files pre-built.

### All procedures are `pure` or `elemental`
This is a design invariant — all vector operations are side-effect-free and thread-safe.

## Coding Conventions

- `implicit none` everywhere
- 2-space indentation, no tabs, no trailing whitespace
- Modern Fortran relational operators (`>`, `<`, `==`, not `.gt.`, `.lt.`, `.eq.`)
- Explicit `intent` on all dummy arguments
- Documentation comments use FORD docmark syntax (`!<` for trailing comments)
- Quadruple precision code must be guarded with `#ifdef _R16P_SUPPORTED` preprocessor blocks

## Build Outputs

| Path | Contents |
|------|----------|
| `static/vecfor.a` | Static library (make build) |
| `static/mod/` | Module files (.mod) |
| `exe/` | Test executables (FoBiS doctests) |
| `src/tests/` | Auto-generated test source files |
| `doc/html/` | FORD-generated documentation |
