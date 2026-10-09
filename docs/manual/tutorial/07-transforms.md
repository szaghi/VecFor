# 7. Rotations and mirrors

`probe` turns its tetrahedron about an axis and reflects it across a plane, then checks what a rotation keeps and what
a mirror changes: the volume of chapter 4, computed by a function of the program.

<<< @/examples/snippets/probe_7.f90

<<< @/examples/output/probe_7.txt{console}

## A rotation about an axis

`call v%rotate(axis=, angle=)` turns `v` in place about the axis through the origin along `axis`, by `angle` radians,
counter-clockwise when seen from the tip of the axis (the right-hand rule). The axis need not be a unit vector. A
quarter turn about z takes `p2 = ex` to `ey` and `p3 = ey` to `-ex`; `p4`, on the axis, stays.

`rotate` is not elemental: it changes its vector in place, so a loop turns the vertices one by one.

![the unit vector along x rotated about the diagonal (1,1,1) in steps of 30 degrees, on a cone](/figures/rotation.svg){.figure}

## A rotation matrix

`rotation_matrix(axis=, angle=)` returns the 3 x 3 matrix of the same rotation (Rodrigues' formula), and
`r .matrix. v` applies a matrix to a vector, returning a new vector; `call v%rotate(matrix=r)` applies it in place.
Compute the matrix once when many vectors turn the same way. A third of a turn about the diagonal `(1, 1, 1)` takes
`ex` to `ey`, `ey` to `ez` and `ez` to `ex`: the tetrahedron onto itself, its vertices renamed, its volume unchanged.

## A mirror

`call v%mirror(normal=)` reflects `v` across the plane through the origin orthogonal to `normal`, of any length. The
plane `x = y`, of normal `ex - ey`, swaps x and y: `p2` and `p3` change places. The mirrored tetrahedron occupies the
same space, but its faces, still listed in the same order, now turn clockwise seen from outside, and the volume of
chapter 4 comes out **negative**: a mirror reverses orientation, a rotation does not.

![a tetrahedron and its mirror image across an oblique plane](/figures/mirror.svg){.figure}

`mirror_matrix(normal=)` returns the matrix of the reflection, the Householder matrix $I - 2\hat n \hat n^T$, and
`call v%mirror(matrix=m)` applies it in place. A reflection is its own inverse: twice, and every vertex is back.

A rotation about an axis that misses the origin, or a mirror across a plane that misses it, is a move to the origin,
the transformation, and the move back (see [The mirror image across a plane](../cookbook#the-mirror-image-across-a-plane)).

::: tip What you learned
`rotate` by axis and angle or by matrix, `rotation_matrix`, `.matrix.`, `mirror` by normal or by matrix,
`mirror_matrix`; rotations keep the orientation, mirrors reverse it. Reference:
[Rotations and mirrors](/guide/transforms).
:::

Next: [8. Many vectors at once](./08-arrays).
