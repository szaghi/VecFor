---
title: Installation
---

# Installation

## Requirements

- A Fortran compiler of the 2008 standard, with the C preprocessor (the sources are `.F90`). VecFor is tested on every
  push with gfortran; its FoBiS modes also build it with the Intel compiler (`static-intel`, `tests-intel`) and with
  NVIDIA nvfortran (`tests-nvf`, and `tests-nvf-acc` for the [OpenACC API](./gpu)).
- [PENF](https://github.com/szaghi/PENF), the library of portable kinds (`R4P`, `R8P`, `I4P`, ...), fetched into
  `src/third_party` by FoBiS and by the install script; the library archive contains it.

## FoBiS

[FoBiS](https://github.com/szaghi/FoBiS) (3.8+) is the reference build system of VecFor.

```bash
git clone https://github.com/szaghi/VecFor && cd VecFor
fobis fetch                       # PENF into src/third_party
fobis build --mode static-gnu     # static/libvecfor.a, modules in static/mod
fobis build --mode shared-gnu     # shared/libvecfor.so
fobis build --mode static-intel   # the same with the Intel compiler
fobis build --lmodes              # every mode (GNU, Intel, NVIDIA; debug variants; tests)
```

A program needs the archive and the module directory:

```bash
gfortran -I static/mod my_program.f90 static/libvecfor.a -o my_program
```

The library has the vector in [single, double and quadruple precision](./precision); quadruple is true quadruple
precision when PENF and VecFor are compiled with `-DPENF_R16P`, as the GNU and Intel FoBiS modes, the `makefile` and
`fpm.toml` do; with nvfortran, which has no 128-bit real kind, it is double precision (see
[True quadruple precision](./precision#true-quadruple-precision)).

### Tests

```bash
fobis build --mode tests-gnu      # the test programs of src/tests into exe/
bash scripts/run_tests.sh         # run them
fobis rule --ex makecoverage      # extract the doctests of the sources, run them, measure the coverage
```

The tests are mostly *doctests*: the examples in the documentation comments of the sources, each a small program
with its expected output, extracted and run by `fobis doctests`.

### VecFor in a FoBiS project

Declare it in the `fobos` of your project and let FoBiS fetch it, with PENF:

```ini
[dependencies]
deps_dir = src/third_party
VecFor   = https://github.com/szaghi/VecFor
```

```bash
fobis fetch
```

## fpm

`fpm.toml` builds the library from `src/lib`, with PENF fetched by fpm. It is tested with gfortran; nvfortran has no
128-bit real kind, use FoBiS there:

```bash
git clone https://github.com/szaghi/VecFor && cd VecFor
fpm build --profile release       # libVecFor.a, PENF fetched into build/dependencies
fpm test                          # the hand-written tests of src/tests
fpm install --prefix ~/.local     # the archive and the modules of VecFor and PENF
```

### VecFor in an fpm project

```toml
[dependencies]
VecFor = { git = "https://github.com/szaghi/VecFor" }
```

VecFor passes `-DPENF_R16P` to itself and to its PENF. If your project declares PENF too, your declaration replaces
that of VecFor: give it the flag, or VecFor fails to compile with ambiguous `R16P` and `R8P` generics.

```toml
[dependencies]
VecFor = { git = "https://github.com/szaghi/VecFor" }
PENF   = { git = "https://github.com/szaghi/PENF", preprocess.cpp.macros = ["PENF_R16P"] }
```

## The install script

Each release has `install.sh`, which downloads the release (with `wget`, or `git`) and builds it, fetching PENF:

```bash
wget https://github.com/szaghi/VecFor/releases/latest/download/install.sh
bash install.sh --download wget --build fobis     # or --build make, --build fpm
```

`--tag vX.Y.Z` picks a release, `--mode` a FoBiS mode.

## GNU Make

The `makefile` builds `static/vecfor.a` with gfortran, from the sources of VecFor and of PENF; fetch PENF first:

```bash
fobis fetch       # or git clone https://github.com/szaghi/PENF src/third_party/PENF
make              # static/vecfor.a, modules in static/mod
```

## Repository layout

```
src/lib/vecfor.F90          the module to use: re-exports every precision
src/lib/vecfor_RPP.INC      the implementation, included once per precision
src/lib/vecfor_R4P.F90      single precision: vector_R4P
src/lib/vecfor_R8P.F90      double precision: vector_R8P
src/lib/vecfor_R16P.F90     quadruple precision: vector_R16P
src/lib/vecfor_RPP.F90      the default kind: vector (double precision)
src/tests/                  tests, and the doctests extracted from the sources
docs/                       this documentation; docs/examples has its programs
```
