---
title: Device-callable API
---

# Device-callable API

A small set of plain procedures, each marked `!$acc routine seq`, that an OpenACC kernel can call on the device. They
mirror seven operators of the vector; everything else of VecFor runs on the host only.

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

`a`, `b`, `c`, `lhs`, `rhs` are `type(vector)` (not `class`); `c` and `lhs` are `intent(out)`. `s` is `real(R8P)` for
every kind of vector. `dotproduct_oac` returns a real of the kind of the vectors. Each kind has its set, with the
suffix of the kind before `_oac`: `vector_sum_vector_R4P_oac`, `crossproduct_R16P_oac`, ...; the names without a kind
are those of the default `vector`. All are exported by `use vecfor`.

The routines do the arithmetic of the operators in the same order, with the same conversions: on the host the results
are identical, as the [cookbook](/manual/cookbook#the-device-callable-routines-in-an-openacc-loop) checks. On a GPU the
compiler may fuse a product and a sum into one instruction (FMA), which can change the last bit of a cross or dot
product.

## Why not the operators

On nvfortran 26.1, the compiler the API is validated with, the operators and the methods cannot run on the device:

1. A type-bound operator is a generic resolved through the type's table of procedures, an indirect call: nvfortran
   rejects indirect calls in device code (`NVFORTRAN-W-0155`, *Indirect function/procedure calls are not supported*).
2. The passed object of a type-bound procedure is `class(vector)`, polymorphic, with the same restriction even when
   the procedure is called by its specific name.
3. `a = b` between two vectors is the user-defined assignment of the type, rejected in device code
   (`NVFORTRAN-F-1252`).
4. A function returning a `type(vector)`, called in a parallel loop, gave every thread one shared temporary, and
   garbage results (nvhpc 26.1).

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
predicates, `rotate`, `mirror`) and the matrices. Two of them need more than a new wrapper:

- `rotation_matrix`, `mirror_matrix` and `.matrix.` return or take a `(3, 3)` array by value, which nvfortran rejects in
  device code (*No device symbol for address reference*); a device version must take the matrix as an `intent(out)`
  argument.
- `angle` builds an array of two polymorphic vectors, which lowers to a host-only runtime call.

The API grows one routine at a time, when a device code needs it, following the convention of the existing ones (see
`CLAUDE.md` in the repository).
