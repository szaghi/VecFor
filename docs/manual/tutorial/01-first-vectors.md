# 1. First vectors

`probe` starts by describing its body: the four vertices of a tetrahedron, one at the origin and three at the tips of the
Cartesian axes, and a point `q` it will inspect in the next chapters.

<<< @/examples/snippets/probe_1.f90

<<< @/examples/output/probe_1.txt{console}

- `use vecfor` brings the type `vector` and the versors `ex`, `ey`, `ez`, the unit vectors along x, y and z. Import
  with `only` what you use: the module exports many names (one set for each [precision](./09-precision)).
- A `vector` is three real components, `x`, `y` and `z`, of kind `R8P` (double precision). A new vector is `(0, 0, 0)`:
  the components have default values, so `o` is the origin without being set.
- Vectors are assigned with `=` and built from expressions of vectors: `2 * ex + 3 * ey` is the point `(2, 3, 0)`.
  The [next chapter](./02-arithmetic) has all of them.
- The components are ordinary variables: read them, write them. They are `real(R8P)`, so write the literals with the
  kind `_R8P` (`R8P` comes from [PENF](https://github.com/szaghi/PENF), the library of kinds VecFor depends on): a
  plain `0.8` is a single precision number, and `q%x = 0.8` would store `0.800000011920929`.
- `printf` prints a vector, its components separated by commas, after an optional `prefix`. Each number is written
  with the shortest digits that read back as the same value: `+0.8` is the double precision number nearest to 0.8.

## Three ways to build a vector

From the versors as here, component by component as `q`, or with the structure constructor, `vector(0.8_R8P,
0.6_R8P, 0.8_R8P)`: the same vector (see [A vector from its components](../cookbook#a-vector-from-its-components)).
A number assigned to a vector sets all three components: `v = 1` is `(1, 1, 1)` (see
[Every component set to one number](../cookbook#every-component-set-to-one-number)).

::: tip What you learned
`use vecfor`, `type(vector)`, the versors `ex`, `ey`, `ez`, the components `x`, `y`, `z` of kind `R8P`, `printf`.
Reference: [The vector type](/guide/vector).
:::

Next: [2. Arithmetic](./02-arithmetic).
