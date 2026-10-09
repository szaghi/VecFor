# 2. Arithmetic

With its vertices set, `probe` computes with them: an edge, the centroid, and three copies of the body, moved, scaled
and stretched. The operators are the ones of the maths.

<<< @/examples/snippets/probe_2.f90

<<< @/examples/output/probe_2.txt{console}

## Between vectors

`p(4) - p(2)` is the edge from `p2` to `p4`, `-edge` the opposite one: `+` and `-` add and subtract the components, and
`-` alone changes their sign. Negating a zero gives `-0.0`, the negative zero of IEEE arithmetic: it compares equal to
`+0.0` and does no harm.

`*` and `/` between two vectors work **component by component**: `p * (3 * ex + ey + ez)` multiplies the x of every
vertex by 3 and leaves y and z alone, a stretch along x. They are not the dot product: that is
[`.dot.`](./03-lengths-angles).

## With numbers

A number multiplies or divides every component: `2 * (p - c)`, `c / 4`. It can be an integer or a real of any kind
(`I1P` to `I8P`, `R4P`, `R8P`, `R16P`), on either side of `*` and on the right of `/`; it is converted to the kind of the
vector first.

A number **added to** or **subtracted from** a vector acts on every component too: `p(1) + 1` is `(1, 1, 1)`. This
is not a translation along any axis: to move a point, add a vector, as `p + (2 * ex - 0.5_R8P * ez)` does.

## On arrays of vectors

`p + (2 * ex - 0.5_R8P * ez)` and `c + 2 * (p - c)` act on all four vertices at once: every operator of VecFor is
elemental, so it applies to arrays element by element, as the intrinsic operators do on arrays of numbers. A
[later chapter](./08-arrays) does the same with the functions.

Fortran has no `sum` of an array of a derived type, so the centroid is summed in a loop, or component by component
(`sum(p%x)`, see [Whole arrays of vectors at once](../cookbook#whole-arrays-of-vectors-at-once)).

::: tip What you learned
`+`, `-`, `*`, `/` between vectors (component by component) and with numbers of any kind; a number added to every
component; the operators on whole arrays. Reference: [Operators](/guide/operators).
:::

Next: [3. Lengths and angles](./03-lengths-angles).
