# VecFor

**3D Cartesian vector algebra for Fortran** — a pure Fortran 2003+ OOP library for vectorial calculus in a three-dimensional frame of reference.

[![CI](https://github.com/szaghi/VecFor/actions/workflows/ci.yml/badge.svg)](https://github.com/szaghi/VecFor/actions)
[![Coverage](https://img.shields.io/codecov/c/github/szaghi/VecFor.svg)](https://app.codecov.io/gh/szaghi/VecFor)
[![GitHub tag](https://img.shields.io/github/tag/szaghi/VecFor.svg)](https://github.com/szaghi/VecFor/releases)
[![License](https://img.shields.io/badge/license-GPLv3%20%7C%20BSD%20%7C%20MIT-blue.svg)](#copyrights)

---

## Features

- `vector` derived type with overloaded arithmetic (`+`, `-`, `*`, `/`) and vectorial operators (`.cross.`, `.dot.`, `.paral.`, `.ortho.`)
- Mixed-kind operands: vector OP scalar for any integer or real [PENF](https://github.com/szaghi/PENF) kind, resolved at compile time with no runtime overhead
- Geometry methods: `angle`, `rotate`, `mirror`, `face_normal3/4`, `distance_to_line`, `distance_to_plane`, `projection_onto_plane`
- Multi-precision: `vector_R4P`, `vector_R8P` (default), `vector_R16P` — all re-exported from a single `use vecfor`
- All procedures are `pure` or `elemental` — thread-safe, no side effects
- OOP / TDD designed — one derived type, comprehensive automated doctests

**[Documentation](https://szaghi.github.io/VecFor/)** | **[API Reference](https://szaghi.github.io/VecFor/api/)**

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

Clone with submodules (PENF dependency) and build:

```sh
git clone https://github.com/szaghi/VecFor --recursive
cd VecFor
```

| Tool | Command | Output |
|------|---------|--------|
| make | `make` | `static/vecfor.a` |
| FoBiS.py | `FoBiS.py build -mode vecfor-static-gnu` | `static/libvecfor.a` |
