---
title: Precision and kinds
---

# Precision and kinds

## One type per kind

VecFor is written once, in `src/lib/vecfor_RPP.INC`, and compiled once per real kind of
[PENF](https://github.com/szaghi/PENF) by the preprocessor:

| Module | Type | Versors | Free functions | Components |
|---|---|---|---|---|
| `vecfor_R4P` | `vector_R4P` | `ex_R4P`, `ey_R4P`, `ez_R4P` | `normL2_R4P`, `angle_R4P`, ... | `real(R4P)` |
| `vecfor_R8P` | `vector_R8P` | `ex_R8P`, `ey_R8P`, `ez_R8P` | `normL2_R8P`, `angle_R8P`, ... | `real(R8P)` |
| `vecfor_R16P` | `vector_R16P` | `ex_R16P`, `ey_R16P`, `ez_R16P` | `normL2_R16P`, `angle_R16P`, ... | `real(R16P)` |
| `vecfor_RPP` | `vector` | `ex`, `ey`, `ez` | `normL2`, `angle`, ... | `real(R8P)`, by default |

`use vecfor` re-exports all of them. The operators and the methods have the same names in every module; the free
functions, the versors and the device routines carry the suffix of their kind.

## Two types, one kind

`vector` and `vector_R8P` both have `real(R8P)` components, but they are **two different types**, defined in two
modules: one cannot be assigned to the other, nor passed where the other is expected, nor combined with it by an
operator; `ex` is not `ex_R8P`. Use one of them throughout a program, and copy the components where the two meet:

```fortran
d%x = b%x ; d%y = b%y ; d%z = b%z     ! d is a vector, b a vector_R8P
```

## Kinds of scalars and of vectors

A scalar of any integer kind (`I1P`, `I2P`, `I4P`, `I8P`) or real kind (`R4P`, `R8P`, `R16P`) is accepted by every
operator with a vector of any kind, and converted to the kind of the vector first, with `real(s, kind)`: the result has
the precision of the vector. The scalar arguments of the methods (`angle=` of `rotate`, `tolerance=`) and the matrices
of `.matrix.`, `rotate(matrix=)` and `mirror(matrix=)` must have the kind of the vector.

There are no operations between vectors of two kinds: convert by components, `real(a4%x, R8P)`.

## True quadruple precision

PENF defines `R16P` as a true quadruple precision kind (33 decimal digits, `real128` with gfortran) only when it is
compiled with `-DPENF_R16P`; otherwise `R16P` is `R8P`, and `vector_R16P` is double precision. The FoBiS modes and the
`makefile` of VecFor do not define it. To build VecFor with true quadruple precision:

```bash
fobis clean --mode static-gnu
fobis build --mode static-gnu --preproc "-DPENF_R16P"
```

The flag must reach PENF and VecFor alike, as it does here; the modules then define `vector_R16P` with `real128`
components, and the operators accept `real(R16P)` scalars. `precision(v%x)` tells which build a program has: 33 or
15. Quadruple precision arithmetic is done in software on most processors, many times slower than double precision.

## The default kind

`vector`, the versors `ex`, `ey`, `ez` and the unsuffixed functions have the kind `R8P` unless `vecfor_RPP.F90` is
compiled with one of `-DDEFKIND_R4P`, `-DDEFKIND_R8P`, `-DDEFKIND_R16P`, which make it `R4P`, `R8P` or `R16P` (the
last one quadruple precision only with `-DPENF_R16P` too). A program written with `vector` changes precision by a
compiler flag; the explicit types keep theirs.
