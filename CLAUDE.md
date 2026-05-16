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

### Device-callable `_oac` API (OpenACC)

VecFor exposes a parallel set of `_oac`-suffixed free procedures that mirror a
narrow slice of the TBP-bound operator surface, designed to be reachable from
inside an `!$acc routine seq` device kernel. The host-side TBP-generic operator
forms (`a .dot. b`, `a + b`, etc.) are **not** device-callable on the currently
validated compiler (`nvfortran 26.1`):

1. TBP-generic operator dispatch lowers to a vtable lookup. nvfortran rejects
   indirect procedure calls inside `!$acc routine seq` with NVFORTRAN-W-0155
   *"Accelerator restriction: Indirect function/procedure calls are not
   supported"*.
2. TBP `pass` arguments must be declared `class(...)`, which itself trips the
   same indirect-dispatch restriction even when the procedure is called by
   its concrete name.
3. Any `type(vector_RPP) = type(vector_RPP)` assignment resolves to the user-
   defined `assign_vector` TBP, which nvfortran rejects from device code with
   NVFORTRAN-F-1252.
4. A free function returning `type(vector_RPP)` allocates a single shared
   device temporary that all threads in a parallel loop read/write through,
   producing constant-garbage output. (Observed bug, nvhpc 26.1.)

The current `_oac` API covers exactly the 7 operators FOSSIL's distance kernel
needs. Six are subroutines (intent(out) result argument); only `dotproduct` is
a function because it returns a scalar `real` with no overload entanglement:

| Math op            | Host TBP/operator         | Device `_oac` entry                                       |
|--------------------|---------------------------|-----------------------------------------------------------|
| `a .dot. b`        | `dotproduct`              | `d = dotproduct_<KIND>_oac(a, b)`                         |
| `a .cross. b`      | `crossproduct`            | `call crossproduct_<KIND>_oac(a, b, c)`                   |
| `a + b` (vector)   | `vector_sum_vector`       | `call vector_sum_vector_<KIND>_oac(a, b, c)`              |
| `a - b` (vector)   | `vector_sub_vector`       | `call vector_sub_vector_<KIND>_oac(a, b, c)`              |
| `s * a` (R8P · v)  | `R8P_mul_vector`          | `call R8P_mul_vector_<KIND>_oac(s, a, c)`                 |
| `a * s` (v · R8P)  | `vector_mul_R8P`          | `call vector_mul_R8P_<KIND>_oac(a, s, c)`                 |
| `a = b` (vector)   | `assign_vector`           | `call assign_vector_<KIND>_oac(lhs, rhs)`                 |

`<KIND>` is one of `R4P`, `R8P`, `R16P` (the per-precision template expansion
of `vecfor_RPP.INC`). The default-kind `vecfor_RPP` module exports the same
procedures with no kind suffix (e.g. `crossproduct_oac`).

#### Convention for extending the `_oac` API

Every new entry point must follow the same shape:

1. Implementation lives in `src/lib/vecfor_RPP.INC` as `pure subroutine
   <name>_RPP_oac(...)` (or `pure function` if and only if the result is a
   scalar `real` / `integer` / `logical` — no derived-type returns).
2. Arguments are `type(vector_RPP)`, not `class(vector_RPP)`.
3. Body is open-coded arithmetic — no `.dot.` / `+` / `=` calls into other
   TBP-bound operators (those would re-introduce the vtable dispatch).
4. The first line of the body is `!$acc routine seq`.
5. Per-precision `#define <name>_RPP_oac <name>_<KIND>_oac` mappings go in
   each of `vecfor_R4P.F90`, `vecfor_R8P.F90`, `vecfor_R16P.F90`,
   `vecfor_RPP.F90`. Add a `public :: <name>_RPP_oac` line at the top of
   `vecfor_RPP.INC`, and re-export each per-precision name from `vecfor.F90`.
6. Extend `src/tests/vecfor_test_device_loop.f90` to exercise the new entry
   point inside its `!$acc parallel loop` and bit-exact-compare against the
   host TBP form. The test must run under both `tests-gnu` (serial, !$acc
   inert) and `tests-nvf-acc --varset local_nvf` (real device).

#### Scope statement

Today the `_oac` API covers exactly the FOSSIL distance-kernel needs (the 7
operators above). Other operators (the full +/-/*//, comparisons, full
real/integer mixed-kind matrix), TBP-bound methods (`normL2`, `normalize`,
`angle`, `face_normal3`, `distance_to_*`, `projection_*`, `is_collinear`,
`is_concyclic`), and matrix-returning procedures (`rotation_matrix`,
`mirror_matrix`, `matrixproduct`) are **not** in the `_oac` surface. Add them
on request from a real device consumer, one operator at a time, following the
convention above. Speculative annotation is what produced commits 7e76258 (177
broken procedures) and 4229257 (narrowed back to 7). The minimum-set scope
exists because every entry point must be runtime-validated against at least
one concrete consumer's needs under nvfortran.

#### Two deferred-work hazards

Two procedures in the current implementation are device-incompatible and
deliberately stayed out of the `_oac` surface; if you ever try to add them,
expect these errors:

- `rotation_matrix_RPP`, `mirror_matrix_RPP`, `matrixproduct` return rank-2
  `real(RPP) :: matrix(3,3)` by value. nvfortran rejects with NVFORTRAN-W-0155
  *"No device symbol for address reference"*. Body must be rewritten to take
  the result matrix as an `intent(out)` argument (no return-by-value).
- `angle_RPP` builds `versor = [self%normalized(), other%normalized()]` which
  lowers to `pgf90_poly_asn_i8`, a host-only runtime. Body must be rewritten
  without the polymorphic array constructor.

These rewrites are mechanical but out of scope until a device consumer asks.

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
