---
title: Rotations and mirrors
---

# Rotations and mirrors

Rotations about an axis through the origin and reflections across a plane through the origin, applied in place by a
method or computed as a 3 x 3 matrix. The angles are in radians; the axis and the normal need not be unit vectors, and
the matrices are `real` arrays of shape `(3, 3)` of the kind of the vector.

## Rotations

| Call | Effect |
|---|---|
| `call v%rotate(axis=a, angle=t)` | `v` turned by `t` about `a` |
| `call v%rotate(matrix=r)` | `v` becomes `r .matrix. v` |
| `r = rotation_matrix(axis=a, angle=t)` | the matrix of the rotation |

The rotation is counter-clockwise seen from the tip of `a` (the right-hand rule). With $\hat a$ the unit axis,
$c = \cos t$, $s = \sin t$, the matrix is Rodrigues':

$$R = c\,I + s\,[\hat a]_\times + (1 - c)\,\hat a \hat a^T, \qquad
[\hat a]_\times = \begin{pmatrix} 0 & -a_z & a_y \\ a_z & 0 & -a_x \\ -a_y & a_x & 0 \end{pmatrix}$$

$R$ is orthogonal ($R^T R = I$, $\det R = 1$): lengths, angles and orientation are kept. Rotations compose by
`matmul(r2, r1)`, `r1` applied first; the inverse is `transpose(r)`, or the same axis with `-t`.

## Mirrors

| Call | Effect |
|---|---|
| `call v%mirror(normal=n)` | `v` reflected across the plane through the origin orthogonal to `n` |
| `call v%mirror(matrix=m)` | `v` becomes `m .matrix. v` |
| `m = mirror_matrix(normal=n)` | the matrix of the reflection |

The matrix is Householder's, with $\hat n$ the unit normal:

$$M = I - 2\,\hat n \hat n^T, \qquad M\mathbf v = \mathbf v - 2\,(\mathbf v \cdot \hat n)\,\hat n$$

$M$ is symmetric and orthogonal, its own inverse, with $\det M = -1$: a reflection keeps lengths and angles and
reverses orientation (a right-handed frame becomes left-handed, the faces of a closed body turn clockwise seen from
outside). `mirror(normal=n)` gives the same vector as `v - 2 * (v .paral. n)`.

::: info Fixed after v1.5.1
Up to v1.5.1 the off-diagonal terms of `mirror_matrix` lacked the factor $-2$: `mirror` was right only for a normal
along an axis.
:::

## Away from the origin

Both transformations act about the origin. For an axis through a point `o`, or a plane through `o`, move `o` to the
origin, transform, move back:

```fortran
w = v - o
call w%rotate(axis=a, angle=t)     ! or: call w%mirror(normal=n)
w = w + o
```

## Not elemental

`rotate` and `mirror` change their vector in place and are `pure`, not elemental; `rotation_matrix`, `mirror_matrix`
and `.matrix.` return or take a matrix. Loop over an array of vectors, computing the matrix once:

```fortran
r = rotation_matrix(axis=a, angle=t)
do i = 1, size(p)
   p(i) = r .matrix. p(i)
enddo
```

None of these is available in device code: see [Device-callable API](./gpu#outside-the-api).
