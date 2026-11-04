# 11. On the GPU

`probe` computes the signed distance of 100000 points from the slanted face inside an OpenACC parallel loop, then
compares the result with the method of chapter 5 on the host.

<<< @/examples/snippets/probe_11.f90

<<< @/examples/output/probe_11.txt{console}

The output above comes from gfortran without `-fopenacc`: the `!$acc` lines are comments, and the loop runs on the
CPU. Built with NVIDIA nvfortran and `-acc` (the FoBiS mode `tests-nvf-acc`), the same source runs on the GPU.

## Why a separate API

The operators and the methods of the vector cannot run on the device with nvfortran (26.1 and 26.9, the compilers
VecFor is validated with). A type-bound operator dispatches through a table of procedures: an indirect call, which
the device does not support. The passed object of a method is polymorphic, with the same problem. The assignment
between two vectors is a user-defined assignment, rejected on the device. And with nvfortran 26.1, a function
returning a vector made every thread of a loop share one temporary. So VecFor exposes the operations as plain
procedures, each an `!$acc routine seq`, that take and return `type(vector)` arguments. The loop of `probe` uses seven
of them:

| Operation | Operator | Device routine |
|---|---|---|
| sum | `c = a + b` | `call vector_sum_vector_dev(a, b, c)` |
| difference | `c = a - b` | `call vector_sub_vector_dev(a, b, c)` |
| number times vector | `c = s * a` | `call R8P_mul_vector_dev(s, a, c)` |
| vector times number | `c = a * s` | `call vector_mul_R8P_dev(a, s, c)` |
| cross product | `c = a .cross. b` | `call crossproduct_dev(a, b, c)` |
| dot product | `d = a .dot. b` | `d = dotproduct_dev(a, b)` |
| assignment | `a = b` | `call assign_vector_dev(a, b)` |

The result of a vector operation is the last argument of a subroutine; only the dot product, a number, is a function.
The scalar of the products is `real(R8P)` whatever the kind of the vector. Each kind has its own set:
`crossproduct_R4P_dev`, `dotproduct_R16P_dev`, ...; the names without a suffix are those of the default `vector`.

## Writing a kernel

The loop body of `probe` is the method `distance_to_plane` written out with these seven routines: two edges, their
cross product, the unit normal by a product with the inverse of its length, the vector from the face to the point,
and its dot product with the normal. The temporaries are `private` to each iteration. Here the differences with the
method are zero; in general, expect differences of the order of the last digit, since the two compute in a different
order.

The loop body is written out to show the routines at work: the API has the methods too, and
`distance_to_plane_dev(g(i), p(2), p(3), p(4))` does the same in one call. The device API has 38 routines for each
kind: the operators above, the rotation and mirror matrices, the geometric methods, the accurate products, the
measures and the point location. The other operators (`*` and `/` between vectors, numbers of other kinds) and the
comparisons are not device-callable (see [Device-callable API](/guide/gpu)).

::: tip What you learned
The `_dev` routines of the operators, their calling convention, an OpenACC loop that uses them; why the operators
cannot run on the device. Reference: [Device-callable API](/guide/gpu).
:::

This is the end of the tutorial. The [cookbook](../cookbook) has a short recipe for each task, the
[reference](/guide/features) every operator, method and argument.
