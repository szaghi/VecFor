---
title: The vector type
---

# The vector type

## The type

```fortran
type :: vector
  real(R8P) :: x = 0._R8P   ! Cartesian component along x
  real(R8P) :: y = 0._R8P   ! Cartesian component along y
  real(R8P) :: z = 0._R8P   ! Cartesian component along z
  contains
    ...                     ! operators and methods
endtype vector
```

A `vector` is three real components in a Cartesian frame of reference; every operation of VecFor assumes such a frame.
The components are public and have default values: a new vector is the origin. `vector` is double precision; the same
type exists for each real kind as `vector_R4P`, `vector_R8P` and `vector_R16P` (see [Precision and kinds](./precision)).

The kinds `R4P`, `R8P`, `R16P` and the integer kinds `I1P`, `I2P`, `I4P`, `I8P` come from
[PENF](https://github.com/szaghi/PENF): `use penf, only : R8P` to write literals of the kind of the components.

## Versors

`ex`, `ey`, `ez` are named constants, the unit vectors along x, y and z: `ex = vector(1, 0, 0)`. Each precision has its
own: `ex_R4P`, `ey_R8P`, `ez_R16P`, ...

## Building a vector

| How | Example | Result |
|---|---|---|
| From the versors | `v = 1 * ex + 2 * ey + 3 * ez` | `(1, 2, 3)` |
| Structure constructor | `v = vector(1._R8P, 2._R8P, 3._R8P)` | `(1, 2, 3)` |
| Component by component | `v%x = 1._R8P ; v%y = 2._R8P ; v%z = 3._R8P` | `(1, 2, 3)` |
| One number | `v = 2` | `(2, 2, 2)` |
| A copy | `w = v` | `(1, 2, 3)` |

The structure constructor takes the components in their kind: `vector(1._R8P, 2._R8P, 3._R8P)`. Assigning a number,
of any integer or real kind, sets all three components (see [Assignment](./operators#assignment)).

## Arrays of vectors

Arrays of vectors are ordinary arrays of a derived type: declared, allocated, sliced and indexed as any other. The
operators (but `.matrix.`) and the functions of a vector are elemental, so they apply to arrays element by element and
return arrays; `call p%normalize` normalizes every element of an array. `p%x` is the array of the x components of `p`.

The intrinsic `sum`, `product`, `dot_product`, `matmul`, `maxval` and the like do not apply to arrays of vectors; apply
them to the components (`sum(p%x)`) or to the result of an elemental function (`maxloc(normL2(p))`).

## Methods and free functions

Every method that returns a value has a free function of the same name, with the vector as first argument:

| Method | Free function | Returns |
|---|---|---|
| `v%normL2()` | `normL2(v)` | length |
| `v%sq_norm()` | `sq_norm(v)` | squared length |
| `v%normalized()` | `normalized(v)` | unit vector |
| `v%angle(w)` | `angle(v, w)` | angle [rad] |
| `v%distance_to_line(pt1=, pt2=)` | `distance_to_line(v, pt1=, pt2=)` | distance |
| `v%distance_to_plane(pt1=, pt2=, pt3=)` | `distance_to_plane(v, ...)` | signed distance |
| `v%distance_vectorial_to_plane(...)` | `distance_vectorial_to_plane(v, ...)` | vector |
| `v%projection_onto_plane(...)` | `projection_onto_plane(v, ...)` | point |
| `v%is_collinear(pt1=, pt2=)` | `is_collinear(v, ...)` | logical |
| `v%is_concyclic(pt1=, pt2=, pt3=)` | `is_concyclic(v, ...)` | logical |
| `v%face_normal3(pt1=, pt2=, pt3=)` | `face_normal3(pt1=, pt2=, pt3=)` | normal (does not use `v`) |
| `v%face_normal4(pt1=, ..., pt4=)` | `face_normal4(pt1=, ..., pt4=)` | normal (does not use `v`) |
| `v%iolen()` | `iolen(v)` | storage units |

The method needs a variable (or a named constant) before `%`: `(a - b)%normL2()` is not Fortran; `normL2(a - b)` is.
The free functions have a suffix for each kind (`normL2_R4P`, `angle_R16P`); the methods have the same name for every
kind.

The methods that change the vector have no free function: `normalize`, `rotate`, `mirror`, `load_from_file`; nor do the
ones that only write it: `printf`, `save_into_file`.

## Every public name

`use vecfor` exports:

| Name | What |
|---|---|
| `vector`, `vector_R4P`, `vector_R8P`, `vector_R16P` | the types |
| `ex`, `ey`, `ez` and `_R4P`, `_R8P`, `_R16P` variants | the versors |
| `angle`, `distance_to_line`, `distance_to_plane`, `distance_vectorial_to_plane`, `face_normal3`, `face_normal4`, `iolen`, `is_collinear`, `is_concyclic`, `normalized`, `normL2`, `projection_onto_plane`, `sq_norm`, and their `_R4P`, `_R8P`, `_R16P` variants | the free functions |
| `rotation_matrix`, `mirror_matrix` and their variants | the matrices of [rotations and mirrors](./transforms) |
| `assign_vector_oac`, `crossproduct_oac`, `dotproduct_oac`, `R8P_mul_vector_oac`, `vector_mul_R8P_oac`, `vector_sub_vector_oac`, `vector_sum_vector_oac` and their variants | the [device-callable API](./gpu) |

The operators and the methods come with the types. The kinds are not exported: `use penf`.
