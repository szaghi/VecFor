---
title: Behaviour and limitations
---

# Behaviour and limitations

What VecFor does at the edges, and what it does not do. Every statement of this page is checked by a program of the
docs or by the sources.

## Comparisons

- `<`, `<=`, `>`, `>=` between two vectors compare their **lengths**: two vectors of equal length and different
  direction are both `<=` and `>=` each other. Between a vector and a number, all six compare the length with the
  number.
- `==` between two vectors compares the lengths and then the components of the unit vectors; `/=` is its negation.
- All are **exact**: no tolerance. For computed vectors, compare `normL2(a - b)` with a tolerance of your own.

## Tolerances of the predicates

`is_collinear` and `is_concyclic` take an optional `tolerance`, 0 by default (the smallest positive number, for
`is_concyclic`). Without it the tests are exact, and points that are collinear or concyclic only up to rounding, as
computed points are, pass or fail by chance: pass a tolerance scaled to your geometry. `is_concyclic` also needs the
points in their order around the circle.

## Zero vectors and degenerate geometry

| Case | Result |
|---|---|
| `normalize`, `normalized` of the zero vector | the zero vector |
| `angle` with a zero vector | 0 |
| `a .paral. b`, `a .ortho. b` with `b` zero | NaN |
| `distance_to_line` with `pt1 = pt2` | NaN |
| `distance_to_plane` and the projections, with three collinear points | 0, and the point itself: silently |
| `face_normal3`, `face_normal4` of a degenerate face | the zero vector, also with `norm` |
| `a / b` with a zero component of `b`; `a / 0` | IEEE infinities or NaN, as for numbers |

## Input and output

- `save_into_file`, `load_from_file` and `printf` **never stop the program** on an I/O error: without `iostat` the
  error is silently ignored, and a vector that fails to load keeps its old value. Always pass `iostat`.
- `fmt` is a format string: `'*'` is not list-directed I/O.
- There is no `rec=` for direct access files: write the components.
- The I/O procedures and `iolen` are not `pure`.

## Types and kinds

- Vectors of two kinds do not mix: no `a4 + a8`, no `a8 = a4`. Convert by components.
- `vector` and `vector_R8P` are two different types, although of the same kind; `ex` and `ex_R8P` likewise.
- `vector_R16P` is quadruple precision only when PENF and VecFor are compiled with `-DPENF_R16P`, which the FoBiS modes
  and the `makefile` do not do: by default it is double precision (see [Precision and kinds](./precision)).
- The scalar arguments of the methods (`angle=`, `tolerance=`) and the matrices must have the kind of the vector; the
  numbers of the operators may have any kind.

## Fortran itself

- A method needs a variable or a named constant: `(a - b)%normL2()` is not Fortran; use the free function,
  `normL2(a - b)`.
- The user-defined operators bind more loosely than any intrinsic one: `a .dot. b + c` is `a .dot. (b + c)`;
  parenthesise (see [Precedence](./operators#precedence)).
- The intrinsics `sum`, `dot_product`, `matmul`, `maxval`, ... do not apply to arrays of vectors.

## Not elemental

`rotate`, `mirror`, `rotation_matrix`, `mirror_matrix`, `.matrix.` and the I/O procedures work on one vector at a time;
loop over arrays. Every other operator and function, and `normalize`, are elemental.

## Not on the device

Only the seven routines of the [device-callable API](./gpu) run inside an OpenACC kernel.

## Not available

Vectors of two or of more than three components; non-Cartesian frames; a type for points distinct from the type for
directions (VecFor uses one type for both); quaternions.
