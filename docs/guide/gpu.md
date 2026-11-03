---
title: Device-callable API
---

# Device-callable API

A small set of plain procedures, each marked `!$acc routine seq`, that an OpenACC kernel can call on the device. They
mirror seven operators of the vector, the rotation matrix and the mirror matrix; everything else of VecFor runs on the host only.

## The routines

| Device routine | Same as | Kind |
|---|---|---|
| `call vector_sum_vector_oac(a, b, c)` | `c = a + b` | subroutine |
| `call vector_sub_vector_oac(a, b, c)` | `c = a - b` | subroutine |
| `call R8P_mul_vector_oac(s, a, c)` | `c = s * a` | subroutine |
| `call vector_mul_R8P_oac(a, s, c)` | `c = a * s` | subroutine |
| `call crossproduct_oac(a, b, c)` | `c = a .cross. b` | subroutine |
| `d = dotproduct_oac(a, b)` | `d = a .dot. b` | function |
| `call assign_vector_oac(lhs, rhs)` | `lhs = rhs` | subroutine |
| `call rotation_matrix_oac(axis, angle, matrix)` | `matrix = rotation_matrix(axis, angle)` | subroutine |
| `call mirror_matrix_oac(normal, matrix)` | `matrix = mirror_matrix(normal)` | subroutine |

`a`, `b`, `c`, `lhs`, `rhs`, `axis`, `normal` are `type(vector)` (not `class`); `c`, `lhs` and `matrix`, a `(3, 3)` real array
of the kind of the vector, are `intent(out)`. `s` is `real(R8P)` for
every kind of vector. `dotproduct_oac` returns a real of the kind of the vectors. Each kind has its set, with the
suffix of the kind before `_oac`: `vector_sum_vector_R4P_oac`, `crossproduct_R16P_oac`, ...; the names without a kind
are those of the default `vector`. All are exported by `use vecfor`.

The routines do the arithmetic of the operators in the same order, with the same conversions: on the host the results
are identical, as the [cookbook](/manual/cookbook#the-device-callable-routines-in-an-openacc-loop) checks. On a GPU the
compiler may fuse a product and a sum into one instruction (FMA), which can change the last bit of a cross or dot
product. The rotation matrix differs from the host one in the last bit on a GPU also because the device `sin` and
`cos` do (at most one unit in the last place of 1.0, measured with nvfortran 26.1 and 26.9).

## Why not the operators

On nvfortran 26.1 and 26.9, the compilers the API is validated with, the operators and the methods cannot run on the
device:

1. A type-bound operator is a generic resolved through the type's table of procedures, an indirect call. In a compute
   region nvfortran warns (`NVFORTRAN-W-0155`, *Indirect function/procedure calls are not supported*) and runs the
   whole loop on the host: the results are right, the GPU is not used. A type-bound call through a `class(vector)`
   argument inside a device routine fails the same way, at link time.
2. `a = b` between two vectors is the user-defined assignment of the type, rejected in device code
   (`NVFORTRAN-F-1252`).
3. A function returning a `type(vector)`, called in a parallel loop, gave every thread one shared temporary and
   garbage results with nvfortran 26.1 (fixed in 26.9). A `(3, 3)` matrix returned by value still does, with both.

Hence subroutines with the result as last argument, and a function only for the scalar dot product.

## Using them

```fortran
use vecfor, only : crossproduct_oac, dotproduct_oac, vector, vector_sub_vector_oac
...
!$acc parallel loop copyin(g, p1, p2, p3) copyout(d) private(s12, s13, n, r)
do i = 1, size(g)
   call vector_sub_vector_oac(p2, p1, s12)
   call vector_sub_vector_oac(p3, p1, s13)
   call crossproduct_oac(s12, s13, n)
   call vector_sub_vector_oac(g(i), p1, r)
   d(i) = dotproduct_oac(n, r) / sqrt(dotproduct_oac(n, n))
enddo
```

Temporaries are `private` to the iteration. Compile with nvfortran and `-acc` (FoBiS: `fobis build --mode
tests-nvf-acc --varset local_nvf`, with the GPU target `$NVF_CC`, `cc89` by default). Without OpenACC the directives
are comments and the same source runs on the host: the [tutorial](/manual/tutorial/11-gpu) and the
[cookbook](/manual/cookbook#the-device-callable-routines-in-an-openacc-loop) show such runs.

## Outside the API

Not device-callable: the other operators (`/`, numbers of other kinds, `.paral.`, `.ortho.`, `.matrix.`, the
comparisons), every method (`normL2`, `normalize`, `angle`, `face_normal3`, the distances, the projections, the
predicates, `rotate`, `mirror`). Two of them need more than a new wrapper:

- `.matrix.` takes a `(3, 3)` array by value, which nvfortran compiles in device code but gets wrong; a device version
  must pass the matrix as an argument, as `rotation_matrix_oac` and `mirror_matrix_oac` do.
- `angle` builds an array of two polymorphic vectors, which lowers to a host-only runtime call.

The API grows one routine at a time, when a device code needs it, following the convention of the existing ones (see
`CLAUDE.md` in the repository).
