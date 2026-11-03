# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Project Is

VecFor is a pure Fortran library for 3D vector algebra using OOP. It provides a `vector` derived type (with `x`, `y`, `z` real components) and comprehensive operator overloading for Cartesian geometry.

## Build Commands

### Dependencies
```bash
fobis fetch                              # fetch PENF into src/third_party/ (pinned by src/third_party/fobos.lock)
```

### FoBiS Build (primary; multiple compilers/modes)
```bash
fobis build --mode static-gnu            # GNU static library -> static/libvecfor.a
fobis build --mode shared-gnu            # GNU shared library -> shared/libvecfor.so
fobis build --mode static-intel          # Intel static library
fobis build --lmodes                     # list all modes (gnu/intel/nvf, debug, tests-*)
fobis rule --ex clean                    # delete docs build, exe/, *.gcov
```

### fpm Build
```bash
fpm build --profile release              # library from src/lib only; PENF cloned by fpm into build/dependencies
fpm test                                 # quad_precision, device_loop and device_geometry tests
fpm install --prefix <dir>               # libVecFor.a + VecFor and PENF .mod files
```

`fpm.toml` is project-owned (scaffold category `init-only`); `scripts/release.sh` keeps its `version` aligned with
`VERSION`. `PENF_R16P` is passed both to VecFor (`[preprocess.cpp]`) and to the PENF dependency
(`preprocess.cpp.macros` in its inline table): if only VecFor gets it, PENF aliases R16P to R8P and the R16P/R8P
generic overloads become ambiguous. fpm path is gfortran/ifx only (nvfortran: no real(16), use fobis). Validated
with fpm 0.12.0 and 0.13.0 (the version pinned by the scaffold's `install.yml`, which runs `fpm build --profile release`
on release whenever `fpm.toml` exists).

### Simple Make Build (produces `static/vecfor.a`)
```bash
make          # Build static library with gfortran (compiles PENF sources from src/third_party/ too)
make clean    # Remove object files
make cleanall # Full clean
```

### Running Tests
```bash
fobis doctests --mode tests-gnu-debug    # Build and generate test executables in exe/
./scripts/run_tests.sh                   # Run all exe/* and compare against <name>.result
fobis build --mode tests-nvf-acc --varset local_nvf   # OpenACC device test (local only, not in CI)
```

Tests are mostly doctest-driven: they are extracted from source documentation comments and auto-generated into `src/tests/vecfor_R*/` (the generated snapshots are tracked in git). Hand-written tests sit directly in `src/tests/`: `vecfor_test_device_loop.F90` and `vecfor_test_device_geometry.F90` (`_dev` API; under `_OPENACC` they also fail if any iteration ran on the host), `vecfor_test_quad_precision.f90` (R16P must be real quad whenever the compiler has a 128-bit kind, else the R8P fallback; the expectation comes from `selected_real_kind`, not from the macro, so a dead macro fails it) and `vecfor_test_front_module.f90` (compile-only). `run_tests.sh` is FoBiS scaffold boilerplate: a test passes on exit 0 and, if a `.result` file exists, on matching it.

### CI and the FoBiS scaffold
`fobis scaffold status` must report every managed file `OK`. Scaffold-managed (`verbatim`) files such as `.github/workflows/ci.yml`, `docs.yml`, `install.yml` and the scripts in `scripts/` must stay byte-identical to the FoBiS templates: never add project jobs to them, `fobis scaffold sync` would drop them. Project-specific CI goes into project-owned workflows (the StringiFor convention): `.github/workflows/docs-examples.yml` rebuilds `docs/examples/` and diffs the committed snippets/figures; `.github/workflows/fpm.yml` runs `fpm test` (fpm 0.13.0, gfortran-14), the only CI job that runs the hand-written tests of `src/tests`, since the scaffold's `ci.yml` runs only `fobis doctests` for the coverage. CI runs on gfortran-14 (default of `.github/actions/setup-build-env`).

### Documentation
```bash
fobis rule --ex makedoc          # API docs via `formal` into docs/api/, then VitePress build (docs/)
fobis rule --ex makecoverage     # gcov coverage analysis
bash scripts/docs_examples.sh    # rebuild docs/examples programs, snippets, outputs and figures
```

## Architecture

### Precision Variants via Preprocessor
The library provides the same `vector` type at multiple precisions using C preprocessor (`#include`). The implementation lives in a single template file:

- `src/lib/vecfor_RPP.INC` — the actual implementation (~3000 lines), included by each precision-specific module
- `src/lib/vecfor_R4P.F90` — single precision (`real(R4P)` components)
- `src/lib/vecfor_R8P.F90` — double precision (`real(R8P)` components)
- `src/lib/vecfor_R16P.F90` — quad precision, guarded by `#ifdef PENF_R16P` in `vecfor_RPP.INC` (the same macro PENF uses). GNU/Intel `fobos` templates and `makefile` pass `-DPENF_R16P`. Without the macro PENF silently aliases `R16P` to double precision, so `vector_R16P` becomes a duplicate R8P type. nvfortran has no real(16) on x86-64 (`real_kinds = [4, 8]`), so the nvf templates must NOT define it
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
Kind parameters (R4P, R8P, R16P) come from PENF, fetched into `src/third_party/PENF/` by `fobis fetch` (declared in the `[dependencies]` section of `fobos`, pinned by `src/third_party/fobos.lock`). It is not a git submodule. Both `fobos` and `makefile` compile the PENF sources directly; `fobos` excludes PENF's tests/docs/scripts via `$EXDIRS`.

### All procedures are `pure` or `elemental`
This is a design invariant — all vector operations are side-effect-free and thread-safe.

### Device-callable `_dev` API (OpenACC, OpenMP offload planned)

The suffix was `_oac` until v1.8.0; renamed to `_dev` (2026-11-03) because the same
procedures are meant to get `!$omp declare target` too, and `_oac` would misname them.
The suffix names the purpose (device-callable), not the directive set. FOSSIL still
calls five of them by the old `_oac` names (assign_vector, dotproduct,
R8P_mul_vector, vector_sub_vector, vector_sum_vector, `_R8P_oac`) and names its own
device routines `_oac`; migrating it is a separate job.

VecFor exposes a parallel set of `_dev`-suffixed free procedures that mirror a
narrow slice of the TBP-bound operator surface, designed to be reachable from
inside an `!$acc routine seq` device kernel. The host-side TBP-generic operator
forms (`a .dot. b`, `a + b`, etc.) are **not** device-callable on the currently
validated compilers (`nvfortran 26.1` and `26.9`). Each restriction below was re-probed on
2026-11-03 on an RTX 4070 (cc89), with 26.1 as the control: one isolated program per restriction mirroring
VecFor's shapes, every procedure `!$acc routine seq`, kernel launches counted with `NV_ACC_NOTIFY=1`, results
compared bit-exact against the host over 4096 elements.

| # | Pattern | nvfortran 26.1 | nvfortran 26.9 |
|---|---------|----------------|----------------|
| 1 | TBP-generic operator (`a .dot. b`) in a compute region | W-0155 *indirect call*, then the loop **silently runs on the host** (0 kernel launches; results "correct") | same |
| 2 | `class(...)` dummy, procedure called by its specific name | works on device, bit-exact | same |
| 2b | TBP called *through* a `class` dummy inside a `routine seq` procedure (`self%dotproduct(o)`) | W-0155, no device version generated, `nvlink: Undefined reference` | same |
| 3 | `type(vector) = type(vector)` (defined assignment `assign_vector` TBP) | F-1252, build fails | same |
| 4 | free function returning a derived type, in a parallel loop | **constant garbage** (shared device temporary) | **fixed**: bit-exact |

Consequences:

1. Pattern 1 is the dangerous one: it compiles, runs and passes a results-only test without touching the GPU.
   A device test must also prove the kernel launched (`NV_ACC_NOTIFY=1`, or `acc_on_device` inside the loop).
2. `class` dummies are not the problem in themselves (old claim corrected); dynamic dispatch is. Device entry
   points take `type(...)` because any TBP call through `class` inside them breaks the device build.
3. Pattern 3 still forbids `c = f(...)` / `c = a` on `type(vector_RPP)` in device code, so on 26.9 a function
   returning `type(vector_RPP)` is usable only as an actual argument. The vector-producing `_dev` entry points
   stay subroutines, which also keeps 26.1 working.
4. Pattern 4 is fixed on 26.9 only: keep the subroutine convention while 26.1 is supported.

The current `_dev` API covers the 7 operators FOSSIL's distance kernel needs,
the rotation and mirror matrices and the matrix product, and the geometric
methods (added 2026-11-03 on request). Vector and matrix results are `intent(out)`
subroutine arguments (in-place methods take the vector `intent(inout)`); only
scalar results (`real`, `logical`) are function results:

| Math op            | Host TBP/operator         | Device `_dev` entry                                       |
|--------------------|---------------------------|-----------------------------------------------------------|
| `a .dot. b`        | `dotproduct`              | `d = dotproduct_<KIND>_dev(a, b)`                         |
| `a .cross. b`      | `crossproduct`            | `call crossproduct_<KIND>_dev(a, b, c)`                   |
| `a + b` (vector)   | `vector_sum_vector`       | `call vector_sum_vector_<KIND>_dev(a, b, c)`              |
| `a - b` (vector)   | `vector_sub_vector`       | `call vector_sub_vector_<KIND>_dev(a, b, c)`              |
| `s * a` (R8P · v)  | `R8P_mul_vector`          | `call R8P_mul_vector_<KIND>_dev(s, a, c)`                 |
| `a * s` (v · R8P)  | `vector_mul_R8P`          | `call vector_mul_R8P_<KIND>_dev(a, s, c)`                 |
| `a = b` (vector)   | `assign_vector`           | `call assign_vector_<KIND>_dev(lhs, rhs)`                 |
| rotation matrix    | `rotation_matrix_<KIND>`  | `call rotation_matrix_<KIND>_dev(axis, angle, matrix)`    |
| mirror matrix      | `mirror_matrix_<KIND>`    | `call mirror_matrix_<KIND>_dev(normal, matrix)`           |
| `m .matrix. a`     | `matrixproduct`           | `call matrixproduct_<KIND>_dev(matrix, a, c)`             |
| `a%normL2()`       | `normL2_<KIND>`           | `d = normL2_<KIND>_dev(a)`                                |
| `a%sq_norm()`      | `sq_norm_<KIND>`          | `d = sq_norm_<KIND>_dev(a)`                               |
| `a%normalized()`   | `normalized_<KIND>`       | `call normalized_<KIND>_dev(a, c)`                        |
| `a%normalize()`    | `normalize`               | `call normalize_<KIND>_dev(a)` (inout)                    |
| `a .paral. b`      | `parallel`                | `call parallel_<KIND>_dev(a, b, c)`                       |
| `a .ortho. b`      | `orthogonal`              | `call orthogonal_<KIND>_dev(a, b, c)`                     |
| distance to line   | `distance_to_line_<KIND>` | `d = distance_to_line_<KIND>_dev(a, pt1, pt2)`            |
| distance to plane  | `distance_to_plane_<KIND>`| `d = distance_to_plane_<KIND>_dev(a, pt1, pt2, pt3)`      |
| vectorial distance | `distance_vectorial_to_plane_<KIND>` | `call distance_vectorial_to_plane_<KIND>_dev(a, pt1, pt2, pt3, c)` |
| projection         | `projection_onto_plane_<KIND>` | `call projection_onto_plane_<KIND>_dev(a, pt1, pt2, pt3, c)` |
| face normals       | `face_normal3/4_<KIND>`   | `call face_normal3_<KIND>_dev(pt1, pt2, pt3, c[, norm])`, `face_normal4_..._dev(pt1, pt2, pt3, pt4, c[, norm])` |
| predicates         | `is_collinear/is_concyclic_<KIND>` | `l = is_collinear_<KIND>_dev(a, pt1, pt2[, tolerance])`, `l = is_concyclic_<KIND>_dev(a, pt1, pt2, pt3[, tolerance])` |
| `a%rotate(...)`    | `rotate_by_axis_angle`, `rotate_by_matrix` | `call rotate_by_axis_angle_<KIND>_dev(a, axis, angle)`, `call rotate_by_matrix_<KIND>_dev(a, matrix)` (inout) |
| `a%mirror(...)`    | `mirror_by_normal`, `mirror_by_matrix` | `call mirror_by_normal_<KIND>_dev(a, normal)`, `call mirror_by_matrix_<KIND>_dev(a, matrix)` (inout) |
| `a%angle(b)`       | `angle_<KIND>`            | `d = angle_<KIND>_dev(a, b)`                              |

Optional dummies (`norm`, `tolerance`) keep the host signatures: optional `real`,
`character(*)`, `character(1)` and `logical` dummies with `present()` were probed in
`!$acc routine seq` on nvfortran 26.1 and 26.9 (2026-11-03) and work. `_dev`
routines may call each other by specific name (no dispatch): the geometric ones are
built from the operator ones.

`<KIND>` is one of `R4P`, `R8P`, `R16P` (the per-precision template expansion
of `vecfor_RPP.INC`). The default-kind `vecfor_RPP` module exports the same
procedures with no kind suffix (e.g. `crossproduct_dev`).

#### Convention for extending the `_dev` API

Every new entry point must follow the same shape:

1. Implementation lives in `src/lib/vecfor_RPP.INC` as `pure subroutine
   <name>_RPP_dev(...)` (or `pure function` if and only if the result is a
   scalar `real` / `integer` / `logical` — no derived-type returns).
2. Arguments are `type(vector_RPP)`, not `class(vector_RPP)`.
3. Body is open-coded arithmetic — no `.dot.` / `+` / `=` calls into other
   TBP-bound operators (those would re-introduce the vtable dispatch).
4. The first line of the body is `!$acc routine seq`.
5. Per-precision `#define <name>_RPP_dev <name>_<KIND>_dev` mappings go in
   each of `vecfor_R4P.F90`, `vecfor_R8P.F90`, `vecfor_R16P.F90`,
   `vecfor_RPP.F90`. Add a `public :: <name>_RPP_dev` line at the top of
   `vecfor_RPP.INC`, and re-export each per-precision name from `vecfor.F90`.
6. Extend `src/tests/vecfor_test_device_loop.F90` (operators, matrices) or
   `src/tests/vecfor_test_device_geometry.F90` (geometric methods) to exercise the
   new entry point inside its `!$acc parallel loop` and compare against the host
   TBP form, the `_dev` form run on the host too. The test must run under both `tests-gnu` (serial, !$acc
   inert) and `tests-nvf-acc --varset local_nvf` (real device).
   Exception: an entry point calling transcendental intrinsics (`sin`, `cos`,
   `sqrt` is exact) cannot be bit-exact device vs host: the device math library
   differs from the host one in the last bit, and the device contracts FMAs.
   Then compare the `_dev` form run *on the host* bit-exact against the host
   form (this catches transcription errors in the open-coded body), and device
   vs host within a tolerance derived from measurement (rotation matrix: at
   most 1 ulp of 1.0 measured, tested at `4*epsilon`). Without transcendentals
   keep bit-exact and measure before assuming FMA breaks it: the mirror matrix
   (`1 - 2*n*n`) is bit-exact device vs host on 26.1 and 26.9. When the host
   form calls an intrinsic whose order of operations is the compiler's
   (`matmul`, `sum`, `dot_product`), compare against the rounding bound of the
   two orders instead: `matrixproduct` vs its open-coded `_dev` form differs on
   gfortran 16.2 (below 1 ulp), is bit-exact on nvfortran; the test bounds it by
   `6*epsilon*sum(|m_ij*a_j|)`.
   Composites of sums of products (the geometric entries) are NOT reproducibly
   bit-exact under nvfortran, on the host or on the device: FMA contraction
   depends on the compilation context (parallel_dev passed bit-exact in one build
   and failed in the next after an unrelated test edit); gfortran is bit-exact.
   vecfor_test_device_geometry therefore compares every entry, host `_dev` and
   device, against a per-component rounding bound `c*eps*S` derived next to the
   check (S dominates the computation; for unit normals it includes the cross
   product condition `|s12||s13|/|s12 x s13|`), and predicates without tolerance
   only on data clearly off the threshold. Mutations (2026-11-03 night) confirm the
   bounds still catch transcription errors.

#### Scope statement

Today the `_dev` API covers the FOSSIL distance-kernel needs (the 7 operators
above), the rotation and mirror matrices, the matrix product and every geometric
method. The other operators (`*` and `/` between vectors, `/`, the unary `+`/`-`,
the scalars of other kinds than R8P), the comparisons and the scalar assignments are
**not** in the `_dev` surface (I/O never can be). Add them
on request from a real device consumer, one operator at a time, following the
convention above. Speculative annotation is what produced commits 7e76258 (177
broken procedures) and 4229257 (narrowed back to 7). The minimum-set scope
exists because every entry point must be runtime-validated against at least
one concrete consumer's needs under nvfortran.

#### Device hazards, resolved 2026-11-03 (kept for the record)

- `angle_RPP` builds `versor = [self%normalized(), other%normalized()]` which
  lowers to `pgf90_poly_asn_i8`, a host-only runtime (NVFORTRAN-S-1058 on 26.1 and
  26.9), and calls TBPs through `class` (pattern 2b). `angle_RPP_dev` builds both
  versors with `normalized_RPP_dev` and keeps the host `atan2(|v1 x v2|, v1.v2)`.

- `rotation_matrix_RPP` and `mirror_matrix_RPP` return their matrix by value.
  Re-probed 2026-11-03: such a function **compiles without diagnostics on 26.1 and
  26.9 but returns garbage** in device code (relative errors ~1e3, 4096/4096 wrong),
  worse than the W-0155 *"No device symbol"* recorded earlier; the same body with the
  matrix as an `intent(out)` argument is bit-exact on both. Hence their device forms
  `rotation_matrix_RPP_dev` and `mirror_matrix_RPP_dev`, the matrix `intent(out)`.
- `matrixproduct` was once listed with them by mistake: its matrix is an `intent(in)`
  argument, never returned. Its device obstacles were the `class` dispatch of
  `.matrix.`, the `type(vector)` result and `matmul`; hence `matrixproduct_RPP_dev`.

## Coding Conventions

- `implicit none` everywhere
- 2-space indentation, no tabs, no trailing whitespace
- Modern Fortran relational operators (`>`, `<`, `==`, not `.gt.`, `.lt.`, `.eq.`)
- Explicit `intent` on all dummy arguments
- Documentation comments use FORD docmark syntax (`!<` for trailing comments)
- Quadruple precision code must be guarded with `#ifdef PENF_R16P` preprocessor blocks

## Build Outputs

| Path | Contents |
|------|----------|
| `static/vecfor.a` | Static library (make build) |
| `static/libvecfor.a`, `shared/libvecfor.so` | Libraries (FoBiS `static-*` / `shared-*` modes) |
| `static/mod/` | Module files (.mod) |
| `exe/` | Test executables (FoBiS doctests) |
| `src/tests/` | Auto-generated doctest sources (tracked in git) |
| `docs/api/` | API reference generated by `formal` (committed) |
| `docs/.vitepress/dist/` | Built VitePress site |
