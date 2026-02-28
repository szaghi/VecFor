# VecFor

>#### 3D Cartesian vector algebra for Fortran
>a pure Fortran 2003+ OOP library for vectorial calculus in a three-dimensional frame of reference.

[![GitHub tag](https://img.shields.io/github/v/tag/szaghi/VecFor)](https://github.com/szaghi/VecFor/tags)
[![GitHub issues](https://img.shields.io/github/issues/szaghi/VecFor)](https://github.com/szaghi/VecFor/issues)
[![CI](https://github.com/szaghi/VecFor/actions/workflows/ci.yml/badge.svg)](https://github.com/szaghi/VecFor/actions/workflows/ci.yml)
[![coverage](https://img.shields.io/endpoint?url=https://szaghi.github.io/VecFor/coverage.json)](https://github.com/szaghi/VecFor/actions/workflows/ci.yml)
[![License](https://img.shields.io/badge/license-GPLv3%20%7C%20BSD%20%7C%20MIT-blue.svg)](#copyrights)

| 📐 **Rich Operator Set**<br>`+`, `-`, `*`, `/`, `.cross.`, `.dot.`, `.paral.`, `.ortho.` — full Cartesian algebra in operator notation | 🔢 **Mixed-Kind Operands**<br>Vector OP scalar for any integer or real [PENF](https://github.com/szaghi/PENF) kind, resolved at compile time with no runtime overhead | 📏 **Geometry Methods**<br>`angle`, `rotate`, `mirror`, `face_normal3/4`, `distance_to_line`, `distance_to_plane`, `projection_onto_plane` | 🎚️ **Multi-Precision**<br>`vector_R4P`, `vector_R8P` (default), `vector_R16P` — all re-exported from a single `use vecfor` |
|:---:|:---:|:---:|:---:|
| ⚡ **Pure & Elemental**<br>All procedures are `pure` or `elemental` — thread-safe, no side effects | 🔓 **Multi-licensed**<br>GPL v3 · BSD 2/3-Clause · MIT | 📦 **Multiple build systems**<br>fpm, FoBiS, CMake, Make | 📖 **OOP / TDD designed**<br>One derived type, comprehensive automated doctests |

For full documentations (guide, tutorial, examples, etc...) see the [VecFor website](https://szaghi.github.io/VecFor/).

---

## Authors

- Stefano Zaghi — [@szaghi](https://github.com/szaghi)

Contributions are welcome — see the [Contributing](https://szaghi.github.io/VecFor/guide/contributing) page.

## Copyrights

This project is distributed under a multi-licensing system:

- **FOSS projects**: [GPL v3](http://www.gnu.org/licenses/gpl-3.0.html)
- **Closed source / commercial**: [BSD 2-Clause](http://opensource.org/licenses/BSD-2-Clause), [BSD 3-Clause](http://opensource.org/licenses/BSD-3-Clause), or [MIT](http://opensource.org/licenses/MIT)

> Anyone interested in using, developing, or contributing to VecFor is welcome — pick the license that best fits your needs.

---

## Quick start

Import VecFor, build vectors from the built-in Cartesian versors, and perform algebra:

```fortran
use vecfor
implicit none
type(vector) :: point1, point2, distance

point1 = 1 * ex                  ! ex, ey, ez are the Cartesian unit versors
point2 = 1 * ex + 2 * ey

distance = point2 - point1       ! [0, 2, 0]
call distance%print              ! Component y +2.000...
print *, distance%normL2()       ! 2.0
```

Vectorial operators:

```fortran
use vecfor
use penf, only: R8P
implicit none
type(vector) :: v1, v2, cross
real(R8P)    :: dot

v1 = ex
v2 = ex + 2 * ey
cross = v1 .cross. v2   ! [0, 0, 2]
dot   = v1 .dot.   v2   ! 1.0
```

---

## Install

### FoBiS

**Standalone** — clone, build, and install in one command:

```bash
FoBiS.py install szaghi/VecFor -mode static-gnu
FoBiS.py install szaghi/VecFor -mode static-gnu --prefix /path/to/prefix
```

**As a project dependency** — declare VecFor in your `fobos` and run `fetch`:

```ini
[dependencies]
deps_dir = src/third_party
VecFor   = https://github.com/szaghi/VecFor
```

```bash
FoBiS.py fetch           # fetch and build
FoBiS.py fetch --update  # re-fetch and rebuild
```

### fpm

Add to your `fpm.toml`:

```toml
[dependencies]
VecFor = { git = "https://github.com/szaghi/VecFor" }
```

```bash
fpm build
fpm test
```

### CMake

```bash
cmake -B build && cmake --build build
```

### Makefile

```bash
make              # static library
make TESTS=yes    # build and run tests
```
