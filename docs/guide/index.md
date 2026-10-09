---
title: About VecFor
---

# About VecFor

VecFor is a pure Fortran library of vector algebra in three-dimensional Cartesian space. It gives Fortran one derived
type, `vector`, with three real components, and the operators and procedures that let a program write vector maths as
it is written on paper: `a + b`, `2 * a`, `a .dot. b`, `a .cross. b`, `a .paral. n`, `a%normL2()`,
`a%angle(b)`. On top of the algebra it has the geometry a solver asks of its mesh: face normals and areas, distances
from lines and planes, projections, collinear and concyclic points, rotations and mirrors.

The same type exists in single, double and quadruple precision, `vector_R4P`, `vector_R8P` and `vector_R16P`, with
scalars of any integer or real kind accepted by every operator. The operators and the functions are elemental: they
work on whole arrays of vectors, element by element. A narrow set of routines is callable from OpenACC kernels. VecFor
is standard Fortran 2008 and depends on one small library by the same author, [PENF](https://github.com/szaghi/PENF),
for its kinds.

This documentation reads in order, and each page links to the next one:

1. [Installation](./install): get VecFor into your project.
2. The [tutorial](/manual/): eleven short chapters that grow one program, around a tetrahedron.
3. The [cookbook](/manual/cookbook): short recipes, one for each "how do I ...?".
4. The reference, from the [feature map](./features) on: every operator, every method, every argument, every
   limitation.

The [API](/api/) documents the source itself.

Every code sample of this documentation is part of a program that is compiled and run to produce the output shown, and
every figure is drawn from data computed by VecFor (see
[`docs/examples`](https://github.com/szaghi/VecFor/tree/master/docs/examples)).

## Authors

- Stefano Zaghi — [@szaghi](https://github.com/szaghi)

Contributions are welcome — see the [Contributing](contributing) page.

## Copyrights

VecFor is distributed under a multi-licensing system:

| Use case | License |
|---|---|
| FOSS projects | [GPL v3](http://www.gnu.org/licenses/gpl-3.0.html) |
| Closed source / commercial | [BSD 2-Clause](http://opensource.org/licenses/BSD-2-Clause) |
| Closed source / commercial | [BSD 3-Clause](http://opensource.org/licenses/BSD-3-Clause) |
| Closed source / commercial | [MIT](http://opensource.org/licenses/MIT) |

> Anyone interested in using, developing, or contributing to VecFor is welcome — pick the license that best fits your
> needs.
