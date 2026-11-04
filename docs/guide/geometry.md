---
title: Geometry
---

# Geometry

The procedures that measure a vector or relate it, as a point, to other points. Each method that returns a value is
also a free function (see [Methods and free functions](./vector#methods-and-free-functions)).
`normalized_checked`, the accurate products, the measures and the point location are free procedures only, without a
method. All are elemental, except `polygon_vector_area`, `barycentric_triangle` and `barycentric_tetrahedron`, which
are `pure`: the first takes an array of vertices, the other two return an array of coordinates. In the formulas,
$\mathbf p$ is the vector the method is called on (`self`) or the point `p`, and $\mathbf p_1, \mathbf p_2, \ldots$
the arguments `pt1`, `pt2`, ...; the results are of the kind of the vectors.

## Lengths and directions

| Call | Result |
|---|---|
| `v%normL2()` | $\lvert\mathbf v\rvert = \sqrt{v_x^2 + v_y^2 + v_z^2}$ |
| `v%sq_norm()` | $v_x^2 + v_y^2 + v_z^2$ |
| `v%normalized()` | $\mathbf v / \lvert\mathbf v\rvert$, a new vector |
| `call v%normalize` | `v` becomes $\mathbf v / \lvert\mathbf v\rvert$ |
| `call normalized_checked(v, u, ok [, min_norm])` | `u` = $\mathbf v / \lvert\mathbf v\rvert$ and `ok` true when $\lvert\mathbf v\rvert >$ `min_norm`; otherwise `ok` false and `u` the zero vector |

When $\lvert\mathbf v\rvert$ is below `tiny` (the smallest positive normal number of the kind), `normalize` and
`normalized` divide by $\lvert\mathbf v\rvert$ + `tiny` instead: the zero vector stays zero, it is not divided by zero.
`normalize` is an elemental subroutine: `call p%normalize` normalizes a whole array.

`normalized_checked` reports the degenerate case instead. It is a subroutine: `u` is a `type(vector)`, `ok` a
`logical`, both `intent(out)`. `min_norm` (a real of the kind of the vector) defaults to `tiny`, the threshold of
`normalize`; pass a larger one when a short vector has no reliable direction. When `ok` is false `u` is the zero
vector, which makes an unchecked use obviously wrong rather than plausible.

## Accurate products

| Call | Result |
|---|---|
| `crossproduct_accurate(a, b)` | $\mathbf a \times \mathbf b$, each component within 2 units in the last place |
| `dotproduct_accurate(a, b)` | $\mathbf a \cdot \mathbf b$ as if computed in twice the precision, then rounded |

`.cross.` rounds both products of a component, $a_y b_z - a_z b_y$, before subtracting them: when they nearly cancel
(nearly parallel vectors, the normal of a sliver face) the result can lose every digit. `crossproduct_accurate`
computes each component by Kahan's algorithm with a fused multiply-add, `dotproduct_accurate` by Dot2 (Ogita, Rump
and Oishi). On 2000 nearly parallel pairs in double precision, checked against quadruple precision, the error of
`crossproduct_accurate` stayed below $\varepsilon\lvert\mathbf c\rvert$ ($\varepsilon$ the machine epsilon), that of
`.cross.` reached $2.4 \times 10^{11}\,\varepsilon\lvert\mathbf c\rvert$. They cost two to three times the operators,
and the operators are unchanged: use them where the cancellation matters.

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

## Measures

| Call | Result |
|---|---|
| `triangle_area(pt1, pt2, pt3)` | $\tfrac12 \lvert(\mathbf p_2 - \mathbf p_1) \times (\mathbf p_3 - \mathbf p_1)\rvert$ |
| `tetrahedron_volume(pt1, pt2, pt3, pt4)` | $\tfrac16 (\mathbf p_2 - \mathbf p_1) \cdot \big((\mathbf p_3 - \mathbf p_1) \times (\mathbf p_4 - \mathbf p_1)\big)$, signed |
| `polygon_vector_area(pts)` | $\tfrac12 \sum_i (\mathbf p_i - \mathbf p_1) \times (\mathbf p_{i+1} - \mathbf p_1)$ |

The volume is positive when `pt4` lies on the side where $(\mathbf p_2 - \mathbf p_1) \times (\mathbf p_3 - \mathbf p_1)$
points. The vector area of a polygon (its vertices in order, an array of vectors) has the area of a planar polygon as
its length and its normal as its direction; it does not depend on the origin, and the outward vector areas of the faces
of a closed cell sum to zero, the discrete geometric conservation law of finite volumes. With nvfortran pass a named
array: an array constructor of vectors as the argument crashes nvfortran 26.9.

## Point location

| Call | Result |
|---|---|
| `barycentric_triangle(p, pt1, pt2, pt3)` | `real` array of 3: the barycentric coordinates of `p` (of its projection onto the plane) |
| `barycentric_tetrahedron(p, pt1, pt2, pt3, pt4)` | `real` array of 4: the barycentric coordinates of `p` |
| `call closest_point_triangle(p, a, b, c, q, feature)` | `q` (`type(vector)`), the point of the triangle closest to `p`, and `feature` (`integer`), the feature it lies on |

The coordinates $\lambda_i$ give $\mathbf p = \sum_i \lambda_i \mathbf p_i$ with $\sum_i \lambda_i = 1$, and are all in
$[0, 1]$ inside the triangle or the tetrahedron: the point-in-cell test of a donor search. A degenerate triangle or
tetrahedron (collinear or coplanar vertices) gives IEEE infinities or NaN. `feature` is 1, 2, 3 for the vertices `a`, `b`, `c`, 4, 5, 6 for the edges `ab`, `bc`, `ca`, 7 for the
face. For the signed distance of a point from a closed triangulated surface, take the closest point over the triangles
and sign $\lvert\mathbf p - \mathbf q\rvert$ with the angle-weighted pseudo-normal of that feature: the face normal on
the face, the weighted average of the normals of the faces sharing the edge or the vertex otherwise (VecFor has no mesh,
so the caller assembles them). The barycentric coordinates in a triangle use Kahan's algorithm for their 2x2
determinants, and so do the region tests of the closest point, which cancel badly for skinny triangles.

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
