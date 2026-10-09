---
title: Geometry
---

# Geometry

The methods of a vector that measure it or relate it, as a point, to other points. Each method that returns a value is
also a free function (see [Methods and free functions](./vector#methods-and-free-functions)); all of them are elemental.
In the formulas, $\mathbf p$ is the vector the method is called on (`self`) and $\mathbf p_1, \mathbf p_2, \ldots$ its
arguments `pt1`, `pt2`, ...; the results are of the kind of the vectors.

## Lengths and directions

| Call | Result |
|---|---|
| `v%normL2()` | $\lvert\mathbf v\rvert = \sqrt{v_x^2 + v_y^2 + v_z^2}$ |
| `v%sq_norm()` | $v_x^2 + v_y^2 + v_z^2$ |
| `v%normalized()` | $\mathbf v / \lvert\mathbf v\rvert$, a new vector |
| `call v%normalize` | `v` becomes $\mathbf v / \lvert\mathbf v\rvert$ |

When $\lvert\mathbf v\rvert$ is below `tiny` (the smallest positive normal number of the kind), `normalize` and
`normalized` divide by $\lvert\mathbf v\rvert$ + `tiny` instead: the zero vector stays zero, it is not divided by zero.
`normalize` is an elemental subroutine: `call p%normalize` normalizes a whole array.

## Angle

`v%angle(w)` is the angle between the two vectors in radians, in $[0, \pi]$:

$$\theta = \operatorname{atan2}\bigl(\lvert\hat v \times \hat w\rvert,\; \hat v \cdot \hat w\bigr)$$

accurate for nearly parallel and nearly opposite vectors, unlike $\arccos(\hat v \cdot \hat w)$. With a zero vector the
angle is 0.

## Face normals

```
 3.----.2            3.----------.2
   \   |              |          |
    \  |              |          |
     \ |              |          |
      \|              |          |
       .1            4.----------.1
 face_normal3         face_normal4
```

| Call | Result |
|---|---|
| `face_normal3(pt1=, pt2=, pt3=)` | $\tfrac12 (\mathbf p_2 - \mathbf p_1) \times (\mathbf p_3 - \mathbf p_1)$ |
| `face_normal4(pt1=, pt2=, pt3=, pt4=)` | $\tfrac12 (\mathbf p_3 - \mathbf p_1) \times (\mathbf p_4 - \mathbf p_2)$ |
| either, with `norm=` | the same, normalized |

The length of the normal is the area of the triangle, and of a flat quadrilateral; for a warped quadrilateral it is
the vector area of its four edges. The normal points to the side from which the points are seen counter-clockwise.
`norm` is a `character(1)`: **any** value, even `'n'`, asks for the unit normal; leave it out for the area-weighted
one. Both are also methods (`v%face_normal3(...)`), which do not use the vector they are called on.

## Distances and projections

```
         . self                   3.----.2
         |                          \   |
         |                           \  *------> . self
 1.-------------.2                    \ |
  distance_to_line                     \|
                                        .1
                                   distance_to_plane
```

| Call | Result |
|---|---|
| `p%distance_to_line(pt1=, pt2=)` | $\lvert(\mathbf p - \mathbf p_1) \times (\mathbf p - \mathbf p_2)\rvert \,/\, \lvert\mathbf p_2 - \mathbf p_1\rvert$ |
| `p%distance_to_plane(pt1=, pt2=, pt3=)` | $\hat n \cdot (\mathbf p - \mathbf p_1)$, signed |
| `p%distance_vectorial_to_plane(pt1=, pt2=, pt3=)` | $\bigl(\hat n \cdot (\mathbf p - \mathbf p_1)\bigr)\,\hat n$, from the plane to `p` |
| `p%projection_onto_plane(pt1=, pt2=, pt3=)` | $\mathbf p - \bigl(\hat n \cdot (\mathbf p - \mathbf p_1)\bigr)\,\hat n$, the foot of `p` |

$\hat n$ is `face_normal3(pt1=, pt2=, pt3=, norm='y')`: the signed distance is positive on its side, and swapping two
of the points changes its sign. The line through `pt1` and `pt2` is infinite, as is the plane through the three points.
The points must define the line or the plane: two coincident points give a distance from the line of NaN; three
collinear points give a zero normal, and every distance from their "plane" comes out 0, silently.

## Collinear and concyclic points

| Call | True when |
|---|---|
| `p%is_collinear(pt1=, pt2=)` | `p%distance_to_line(pt1=, pt2=)` $\le$ `tolerance` |
| `p%is_concyclic(pt1=, pt2=, pt3=)` | $\lvert\mathbf p\mathbf p_1\rvert\,\lvert\mathbf p_2\mathbf p_3\rvert + \lvert\mathbf p_1\mathbf p_2\rvert\,\lvert\mathbf p_3\mathbf p\rvert - \lvert\mathbf p\mathbf p_2\rvert\,\lvert\mathbf p_1\mathbf p_3\rvert \le$ `tiny` + `tolerance` |

`is_concyclic` tests Ptolemy's theorem: the expression is never negative, and is zero exactly when the four points lie
on a circle **in the order** `p`, `pt1`, `pt2`, `pt3`. `tolerance` is optional, a real of the kind of the vectors, 0 by
default: without it both tests are exact, and a point computed in floating point, on the line or on the circle up to
rounding, passes or fails by chance. Pass a tolerance scaled to the geometry: a length for `is_collinear`, a length
squared for `is_concyclic`.
