# 8. Many vectors at once

A mesh has thousands of faces, a particle cloud millions of points. `probe` estimates the volume of its tetrahedron by
counting the points of a 40 x 40 x 40 grid that fall inside it, testing all 64000 points with one call per face.

<<< @/examples/snippets/probe_8.f90

<<< @/examples/output/probe_8.txt{console}

![the points of a grid inside the tetrahedron](/figures/grid.svg){.figure}

## Elemental functions

The operators of VecFor (but `.matrix.`) and its functions of vectors are **elemental**: called with arrays, they work
element by element and return an array. `face_normal3(pt1=p(face(1,:)), ...)` takes three arrays of four points
(vector subscripts pick the vertices of each face) and returns the four unit normals; `normL2(normal)` returns their
four lengths. `g%distance_to_plane(...)` calls the method on an array of vectors and returns 64000 distances.

`normal%x` is the array of the x components of the four normals: a component of an array of vectors is an array of
numbers, usable anywhere an array is, as in `sum(p%x)`.

`call p%normalize` is elemental too, and normalizes a whole array in place. `rotate` and `mirror`, the matrices of
`rotation_matrix` and `mirror_matrix`, `.matrix.` and the input/output procedures are not: call them in a loop.

## The volume, counted

A point is inside when its signed distances to the four faces are all non-positive (chapter 5). 10660 points of 64000
pass: 0.1666, against the exact 1/6. The cells cut by the slanted face make the difference, and it shrinks as the grid
gets finer.

## Comparisons are by length

`g < 0.5_R8P` compares the **length** of every point with 0.5, so `count(g < 0.5_R8P)` counts the points within 0.5 of
the origin: 4194, the volume of an eighth of a ball of radius 0.5 (0.0654) times 64000. Between two vectors, `<`,
`<=`, `>` and `>=` compare lengths too; `==` and `/=` compare length and direction (see
[Comparing two vectors](../cookbook#comparing-two-vectors)). `maxloc(normL2(g), dim=1)` finds the farthest point, the
corner cell at `(0.9875, 0.9875, 0.9875)`.

::: tip What you learned
Elemental operators and functions on arrays of vectors, a component of an array of vectors, comparisons by length.
Reference: [The vector type](/guide/vector#arrays-of-vectors), [Operators](/guide/operators#comparisons).
:::

Next: [9. Precision](./09-precision).
