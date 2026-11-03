---
title: Device-callable API
---

# Device-callable API

Plain procedures, each marked `!$acc routine seq`, that an OpenACC kernel can call on the device. They mirror seven
operators of the vector, the matrices and the matrix product, and the geometric methods (norms, components, distances,
face normals, predicates, rotations, mirrors, angle); the other operators, the comparisons and the input/output run on
the host only.

The suffix `_dev` names what the routines are for, code running on an accelerator, not the directive set: today they
are OpenACC routines, and OpenMP offload (`!$omp declare target`) is planned for the same routines. Until v1.8.0 the
suffix was `_oac`: code written against it renames `_oac` to `_dev`, nothing else changes.

## The routines

### Operators and matrices

| Device routine | Same as | Kind |
|---|---|---|
| `call vector_sum_vector_dev(a, b, c)` | `c = a + b` | subroutine |
| `call vector_sub_vector_dev(a, b, c)` | `c = a - b` | subroutine |
| `call R8P_mul_vector_dev(s, a, c)` | `c = s * a` | subroutine |
| `call vector_mul_R8P_dev(a, s, c)` | `c = a * s` | subroutine |
| `call crossproduct_dev(a, b, c)` | `c = a .cross. b` | subroutine |
| `d = dotproduct_dev(a, b)` | `d = a .dot. b` | function |
| `call assign_vector_dev(lhs, rhs)` | `lhs = rhs` | subroutine |
| `call rotation_matrix_dev(axis, angle, matrix)` | `matrix = rotation_matrix(axis, angle)` | subroutine |
| `call mirror_matrix_dev(normal, matrix)` | `matrix = mirror_matrix(normal)` | subroutine |
| `call matrixproduct_dev(matrix, a, c)` | `c = matrix .matrix. a` | subroutine |

### Geometry

| Device routine | Same as | Kind |
|---|---|---|
| `d = normL2_dev(a)` | `d = a%normL2()` | function |
| `d = sq_norm_dev(a)` | `d = a%sq_norm()` | function |
| `call normalized_dev(a, c)` | `c = a%normalized()` | subroutine |
| `call normalize_dev(a)` | `call a%normalize()` | subroutine, `a` in place |
| `call parallel_dev(a, b, c)` | `c = a .paral. b` | subroutine |
| `call orthogonal_dev(a, b, c)` | `c = a .ortho. b` | subroutine |
| `d = distance_to_line_dev(a, pt1, pt2)` | `d = a%distance_to_line(pt1, pt2)` | function |
| `d = distance_to_plane_dev(a, pt1, pt2, pt3)` | `d = a%distance_to_plane(pt1, pt2, pt3)` | function |
| `call distance_vectorial_to_plane_dev(a, pt1, pt2, pt3, c)` | `c = a%distance_vectorial_to_plane(pt1, pt2, pt3)` | subroutine |
| `call projection_onto_plane_dev(a, pt1, pt2, pt3, c)` | `c = a%projection_onto_plane(pt1, pt2, pt3)` | subroutine |
| `call face_normal3_dev(pt1, pt2, pt3, c [, norm])` | `c = face_normal3(pt1, pt2, pt3 [, norm])` | subroutine |
| `call face_normal4_dev(pt1, pt2, pt3, pt4, c [, norm])` | `c = face_normal4(pt1, pt2, pt3, pt4 [, norm])` | subroutine |
| `l = is_collinear_dev(a, pt1, pt2 [, tolerance])` | `l = a%is_collinear(pt1, pt2 [, tolerance])` | function |
| `l = is_concyclic_dev(a, pt1, pt2, pt3 [, tolerance])` | `l = a%is_concyclic(pt1, pt2, pt3 [, tolerance])` | function |
| `call rotate_by_axis_angle_dev(a, axis, angle)` | `call a%rotate(axis=axis, angle=angle)` | subroutine, `a` in place |
| `call rotate_by_matrix_dev(a, matrix)` | `call a%rotate(matrix=matrix)` | subroutine, `a` in place |
| `call mirror_by_normal_dev(a, normal)` | `call a%mirror(normal=normal)` | subroutine, `a` in place |
| `call mirror_by_matrix_dev(a, matrix)` | `call a%mirror(matrix=matrix)` | subroutine, `a` in place |
| `d = angle_dev(a, b)` | `d = a%angle(b)` | function |

The optional arguments are those of the host: `norm` (`character(1)`, present for a unit normal, whatever its value)
and `tolerance` (a real of the kind of the vector, 0 when absent); optional arguments work in device code with
nvfortran 26.1 and 26.9.

`a`, `b`, `c`, `lhs`, `rhs`, `axis`, `normal`, `pt1` to `pt4` are `type(vector)` (not `class`); `c`, `lhs` and `matrix`, a `(3, 3)` real array
of the kind of the vector, are `intent(out)` (`matrix` is `intent(in)` in `matrixproduct_dev`). `s` is `real(R8P)` for
every kind of vector. `dotproduct_dev` returns a real of the kind of the vectors. Each kind has its set, with the
suffix of the kind before `_dev`: `vector_sum_vector_R4P_dev`, `crossproduct_R16P_dev`, ...; the names without a kind
are those of the default `vector`. All are exported by `use vecfor`.

The routines do the arithmetic of the operators in the same order, with the same conversions: on the host the results
are identical, as the [cookbook](/manual/cookbook#the-device-callable-routines-in-an-openacc-loop) checks. On a GPU the
compiler may fuse a product and a sum into one instruction (FMA), which can change the last bit of a cross or dot
product. The rotation matrix differs from the host one in the last bit on a GPU also because the device `sin` and
`cos` do (at most one unit in the last place of 1.0, measured with nvfortran 26.1 and 26.9). `.matrix.` calls
`matmul`, whose order of summation is the compiler's: with gfortran `matrixproduct_dev` can differ from it in the last
bit; with nvfortran they agree. The geometric routines are built from products and sums too: with nvfortran, which
contracts them into FMAs differently in different places, on the host as on the GPU, expect differences from the
methods in the last bits (for a unit normal, amplified by the condition of the cross product of the face), and a
different answer from `is_collinear_dev` or `is_concyclic_dev` without a tolerance for points exactly on the line or
circle. With gfortran the routines reproduce the methods exactly on the host.

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
use vecfor, only : crossproduct_dev, dotproduct_dev, vector, vector_sub_vector_dev
...
!$acc parallel loop copyin(g, p1, p2, p3) copyout(d) private(s12, s13, n, r)
do i = 1, size(g)
   call vector_sub_vector_dev(p2, p1, s12)
   call vector_sub_vector_dev(p3, p1, s13)
   call crossproduct_dev(s12, s13, n)
   call vector_sub_vector_dev(g(i), p1, r)
   d(i) = dotproduct_dev(n, r) / sqrt(dotproduct_dev(n, n))
enddo
```

Temporaries are `private` to the iteration. Compile with nvfortran and `-acc` (FoBiS: `fobis build --mode
tests-nvf-acc --varset local_nvf`, with the GPU target `$NVF_CC`, `cc89` by default). Without OpenACC the directives
are comments and the same source runs on the host: the [tutorial](/manual/tutorial/11-gpu) and the
[cookbook](/manual/cookbook#the-device-callable-routines-in-an-openacc-loop) show such runs.

## Outside the API

Not device-callable: the other operators (`*` and `/` between vectors, `/`, the numbers of other kinds than `R8P`, the
unary `+` and `-`), the comparisons, the assignment of a number to a vector, and the input/output (`printf`,
`save_into_file`, `load_from_file`, `iolen`), which is host-only by nature.

The API grows one routine at a time, when a device code needs it, following the convention of the existing ones (see
`CLAUDE.md` in the repository).
