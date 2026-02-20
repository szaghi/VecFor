---
title: Installation
---

# Installation

## Prerequisites

A Fortran 2003+ compliant compiler is required. The following compilers are known to work:

| Compiler | Minimum version |
|----------|----------------|
| GNU gfortran | ≥ 4.9.2 |
| Intel Fortran (ifort) | ≥ 12.x |
| NVIDIA nvfortran | recent |

VecFor is developed on GNU/Linux. Windows should work out of the box but is not officially tested.

## Download

VecFor uses **git submodules** for the [PENF](https://github.com/szaghi/PENF) dependency (portable numeric kind parameters). Clone recursively:

```bash
git clone https://github.com/szaghi/VecFor --recursive
cd VecFor
```

If you already have a non-recursive clone:

```bash
git submodule update --init --recursive
```

### Minimal manual download

A minimal installation requires only `src/lib/vecfor.F90` (and PENF sources). The file can be copied directly into your project and compiled alongside your code.

### Repository structure

```
├── fobos                   # FoBiS.py build configuration
├── makefile                # Simple GNU make build
├── src/
│   ├── lib/
│   │   ├── vecfor.F90      # Master module (re-exports all precisions)
│   │   ├── vecfor_RPP.INC  # Implementation template (included by precision modules)
│   │   ├── vecfor_R4P.F90  # 32-bit precision variant
│   │   ├── vecfor_R8P.F90  # 64-bit precision variant
│   │   └── vecfor_R16P.F90 # 128-bit precision variant (optional)
│   ├── tests/
│   │   ├── simple.f90      # Basic usage example
│   │   └── kinds.f90       # Operator coverage test (all numeric kinds)
│   └── third_party/
│       └── PENF/           # Kind parameter definitions (git submodule)
└── scripts/
    └── run_tests.sh        # Test runner
```

## Build with `make` (simplest)

The plain `makefile` builds a static library using gfortran:

```bash
make                # produces static/vecfor.a
make clean          # remove object files
make cleanall       # full clean
```

Output:

| Path | Contents |
|------|----------|
| `static/vecfor.a` | Static library archive |
| `static/mod/` | Fortran module files (`.mod`) |
| `static/obj/` | Object files |

## Build with FoBiS.py

[FoBiS.py](https://github.com/szaghi/FoBiS) supports multiple compilers and build variants.

```bash
pip install FoBiS.py
```

### List all build modes

```bash
FoBiS.py build -lmodes
```

Available modes:

| Mode | Description |
|------|-------------|
| `vecfor-static-gnu` | Static library, gfortran, release |
| `vecfor-static-gnu-debug` | Static library, gfortran, debug |
| `vecfor-shared-gnu` | Shared library, gfortran, release |
| `vecfor-shared-gnu-debug` | Shared library, gfortran, debug |
| `vecfor-static-intel` | Static library, ifort, release |
| `vecfor-static-intel-debug` | Static library, ifort, debug |
| `vecfor-shared-intel` | Shared library, ifort, release |
| `vecfor-shared-intel-debug` | Shared library, ifort, debug |
| `vecfor-static-gnu-coverage` | Static library, gfortran, coverage |

### Build the library

```bash
# Static library (GNU gfortran, release)
FoBiS.py build -mode vecfor-static-gnu

# Shared library (GNU gfortran, release)
FoBiS.py build -mode vecfor-shared-gnu

# Static library (Intel Fortran, release)
FoBiS.py build -mode vecfor-static-intel
```

Library files are placed in `./static/` or `./shared/`.

### Build and run tests

```bash
# Build test executables (release)
FoBiS.py build -f src/tests/fobos

# Build test executables (debug)
FoBiS.py build -f src/tests/fobos -mode gnu-debug

# Run all tests
./scripts/run_tests.sh
```

Test executables are placed in `./exe/`. The script checks that each program prints `"Are all tests passed?"`.

### Rules

```bash
FoBiS.py rule -ls                       # list all rules
FoBiS.py rule -ex makedoc               # build API docs with FORD → doc/html/
FoBiS.py rule -ex makecoverage          # build + run tests + gcov report
FoBiS.py rule -ex coverage-analysis     # coverage report saved to wiki/ as markdown
FoBiS.py rule -ex clean                 # clean all build artifacts
```

## Using VecFor in your project

Compile VecFor first, then link against the library and add the module directory to your compiler search path:

```bash
gfortran -I static/mod -o my_program my_program.f90 static/vecfor.a
```

Or include the source directly (single-file approach):

```bash
gfortran -c src/lib/vecfor.F90 -D_R16P_SUPPORTED   # optional quad-precision flag
gfortran -o my_program my_program.f90 vecfor.o
```
