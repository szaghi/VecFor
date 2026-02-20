---
title: Features
---

# Features

## Vectorial Calculus Algebra

- Cross product via `.cross.` infix operator
- Dot product via `.dot.` infix operator
- Parallel projection via `.paral.` infix operator
- Orthogonal projection via `.ortho.` infix operator
- Matrix product via `.matrix.` infix operator
- Triangle face normals: `face_normal3` (also as stand-alone procedure)
- Quad face normals: `face_normal4` (also as stand-alone procedure) — norm equals face area

## Arithmetic Operators

All standard operators work between two vectors and between a vector and any scalar:

- `+`, `-`, `*`, `/` between two `vector` objects
- `+`, `-`, `*`, `/` between a `vector` and a numeric scalar of any supported kind (left and right)
- Unary `+` and `-`
- All operators resolved at compile time via generic interfaces — no runtime dispatch overhead

## Comparison Operators

Vectors are compared by their L2 norm:

- `<`, `<=`, `==`, `/=`, `>=`, `>` — work between two vectors and between a vector and any numeric scalar

## Geometry Methods

- `normL2()` — Euclidean (L2) norm
- `sq_norm()` — squared norm (avoids a square root when only ordering is needed)
- `normalize()` — normalize the vector in-place (subroutine); falls back to zero vector if norm is zero
- `normalized()` — return the normalized vector (function)
- `angle(vec)` — angle between two vectors in radians
- `rotate(axis, angle)` — rotate the vector around a given axis by the given angle
- `mirror(plane_normal)` — mirror the vector across a plane defined by its normal
- `distance_to_line(pt, dir)` — distance from the vector (treated as a point) to a line
- `distance_to_plane(pt, normal)` — distance from the vector to a plane
- `projection_onto_plane(normal)` — orthogonal projection onto a plane
- `is_collinear(v1, v2)` — test collinearity of three vectors (as points)
- `is_concyclic(v1, v2, v3)` — test whether four vectors lie on a common circle

## I/O and Printing

- `print` — formatted output of x, y, z components to any Fortran unit
- `save` / `load` — binary I/O for vector data (sequential and stream access)
- `iolen()` — returns the record length needed for direct-access I/O

## Multi-Precision Support

| Type | Kind | Precision |
|------|------|-----------|
| `vector` / `vector_R8P` | `R8P = selected_real_kind(15,307)` | 64-bit, ~15 digits |
| `vector_R4P` | `R4P = selected_real_kind(6,37)` | 32-bit, ~6 digits |
| `vector_R16P` | `R16P = selected_real_kind(33,4931)` | 128-bit, ~33 digits (if compiler supports it) |

The single `use vecfor` statement re-exports all precision variants and the corresponding Cartesian versors (`ex`, `ey`, `ez` for each kind).

## Mixed-Kind Operands

All operators accept mixed-kind arguments. Supported scalar kinds:

| Kind | Type | Width |
|------|------|-------|
| `R16P` | real | 128-bit |
| `R8P`  | real | 64-bit |
| `R4P`  | real | 32-bit |
| `I8P`  | integer | 64-bit |
| `I4P`  | integer | 32-bit |
| `I2P`  | integer | 16-bit |
| `I1P`  | integer | 8-bit |

## Compiler Support

| Compiler | Status |
|----------|--------|
| GNU gfortran ≥ 4.9.2 | Supported |
| Intel Fortran ≥ 12.x | Supported |
| NVIDIA nvfortran | Supported |
| IBM XL Fortran | Not tested |
| g95 | Not tested |
| NAG Fortran | Not tested |

## Design Principles

- **Pure Fortran** — no C extensions, no system calls beyond standard I/O
- **OOP** — a single `vector` derived type exposes all functionality as type-bound procedures and operators
- **TDD** — every public procedure is exercised by automated doctests in `src/tests/`
- **KISS** — simple, focused API; the entire library fits in one file
- **Thread-safe** — all procedures are `pure` or `elemental`
- **Free & Open Source** — multi-licensed for FOSS and commercial use
