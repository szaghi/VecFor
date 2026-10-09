# 11. On the GPU

`probe` computes the signed distance of 100000 points from the slanted face inside an OpenACC parallel loop, then
compares the result with the method of chapter 5 on the host.

<<< @/examples/snippets/probe_11.f90

<<< @/examples/output/probe_11.txt{console}

The output above comes from gfortran without `-fopenacc`: the `!$acc` lines are comments, and the loop runs on the
CPU. Built with NVIDIA nvfortran and `-acc` (the FoBiS mode `tests-nvf-acc`), the same source runs on the GPU.

## Why a separate API

The operators and the methods of the vector cannot be called inside an OpenACC device routine with nvfortran (26.1, the
compiler VecFor is validated on): the type-bound operators dispatch through a table of procedures, an indirect call the
device does not support; the passed object of a method is polymorphic, with the same problem; the assignment between
two vectors is a user-defined assignment, rejected on the device; and a function returning a vector made every thread
of a loop share one temporary. So VecFor exposes a few operations as plain procedures, each an `!$acc routine seq`,
that take and return `type(vector)` arguments:

| Operation | Operator | Device routine |
|---|---|---|
| sum | `c = a + b` | `call vector_sum_vector_oac(a, b, c)` |
| difference | `c = a - b` | `call vector_sub_vector_oac(a, b, c)` |
| number times vector | `c = s * a` | `call R8P_mul_vector_oac(s, a, c)` |
| vector times number | `c = a * s` | `call vector_mul_R8P_oac(a, s, c)` |
| cross product | `c = a .cross. b` | `call crossproduct_oac(a, b, c)` |
| dot product | `d = a .dot. b` | `d = dotproduct_oac(a, b)` |
| assignment | `a = b` | `call assign_vector_oac(a, b)` |

The result of a vector operation is the last argument of a subroutine; only the dot product, a number, is a function.
The scalar of the products is `real(R8P)` whatever the kind of the vector. Each kind has its own set:
`crossproduct_R4P_oac`, `dotproduct_R16P_oac`, ...; the names without a suffix are those of the default `vector`.

## Writing a kernel

The loop body of `probe` is the method `distance_to_plane` written out with these seven routines: two edges, their
cross product, the unit normal by a product with the inverse of its length, the vector from the face to the point,
and its dot product with the normal. The temporaries are `private` to each iteration. Here the differences with the
method are zero; in general, expect differences of the order of the last digit, since the two compute in a different
order.

The OpenACC API covers what its first user, a distance kernel, needed: the other operators and methods, the
comparisons, the rotations and mirrors are not device-callable (see [Device-callable API](/guide/gpu)).

::: tip What you learned
The seven `_oac` routines, their calling convention, an OpenACC loop that uses them; why the operators cannot run on
the device. Reference: [Device-callable API](/guide/gpu).
:::

This is the end of the tutorial. The [cookbook](../cookbook) has a short recipe for each task, the
[reference](/guide/features) every operator, method and argument.
