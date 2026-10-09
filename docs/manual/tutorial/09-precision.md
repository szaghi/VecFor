# 9. Precision

`probe` has computed in double precision so far. VecFor has the same vector in single, double and quadruple
precision; `probe` measures the edge from `p2` to `p3`, of length $\sqrt2$, in each of them.

<<< @/examples/snippets/probe_9.f90

With VecFor built as by its FoBiS modes:

<<< @/examples/output/probe_9.txt{console}

With VecFor built with `-DPENF_R16P`:

<<< @/examples/output/probe_9q.txt{console}

## Three precisions, one module

`use vecfor` exports a vector type for each real kind of [PENF](https://github.com/szaghi/PENF): `vector_R4P` (single
precision), `vector_R8P` (double) and `vector_R16P` (quadruple), each with its versors (`ex_R4P`, `ey_R8P`, `ez_R16P`,
...) and its free functions (`normL2_R4P`, `angle_R16P`, ...). The type-bound methods and the operators have the same
names for every kind: `a4%normL2()`, `a16 .cross. b16`. `vector` is the default kind, double precision, with `ex`,
`ey`, `ez` and the unsuffixed functions.

A single precision vector has 6 significant digits: its length is off by $2.4 \times 10^{-8}$. A double precision one
has 15, and is off by $9.7 \times 10^{-17}$, less than half a unit in the last place: correctly rounded.

## True quadruple precision

`vector_R16P` is as precise as the kind `R16P` of PENF, and PENF makes `R16P` a true quadruple precision kind only when
it is compiled with `-DPENF_R16P`. The FoBiS modes of VecFor do not define it, so in their builds `R16P` is double
precision and `vector_R16P` has 15 digits, as the first run shows. Built with `-DPENF_R16P` (library and program
alike, see [Precision and kinds](/guide/precision#true-quadruple-precision)), `vector_R16P` has 33 digits and the
length is exact to all the digits printed, as the second run shows. The reference here is `real128` of
`iso_fortran_env`, which does not depend on PENF.

## Scalars of other kinds, vectors of other kinds

A scalar of any kind can meet a vector of any kind: `a4 * 0.1_R8P` converts 0.1 to single precision first, and the
result is a single precision vector, with the error of single precision (`-1.00000001E-01`).

Two vectors of different kinds cannot: there is no `a4 + a8`, nor `a8 = a4`. Convert component by component, with
`real(a4%x, R8P)`: the result carries the error of the single precision value (`-1.0000000149011612E-01`), digits
cannot be recovered. Note that `vector` and `vector_R8P` are two different types too, although both are double
precision: `vector` comes from its own module, so a `vector_R8P` is not assigned to a `vector` either (see
[Vectors of each precision](../cookbook#vectors-of-each-precision)).

::: tip What you learned
`vector_R4P`, `vector_R8P`, `vector_R16P` and their versors and functions; true quadruple precision with
`-DPENF_R16P`; scalars of any kind, vectors converted by components. Reference:
[Precision and kinds](/guide/precision).
:::

Next: [10. Printing and files](./10-io).
