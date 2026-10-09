# 5. A point and the body

`probe` now inspects the point `q = (0.8, 0.6, 0.8)` of chapter 1: is it inside the tetrahedron, how far from each face,
where does it fall on the slanted one? Then it checks points against lines and circles.

![the tetrahedron, the point q outside it and its foot on the slanted face](/figures/hero.svg){.figure}

<<< @/examples/snippets/probe_5.f90

<<< @/examples/output/probe_5.txt{console}

## Inside or outside

`q%distance_to_plane(pt1=, pt2=, pt3=)` is the **signed** distance of `q` from the plane through the three points:
positive on the side the normal `face_normal3(pt1, pt2, pt3)` points to, negative on the other. With the faces listed
as in [chapter 4](./04-faces), every normal points outward, so a point is inside when all its distances are negative
or zero. `q` is 0.6928 ($0.4\sqrt3$) outside the slanted face; the centroid is inside, a quarter from each face on
the coordinate planes.

## The foot of a point

`q%distance_vectorial_to_plane(...)` is the vector from the plane to `q`, along the normal: its length is the distance,
its direction tells the side. `q%projection_onto_plane(...)` is the foot of `q`, the point of the plane nearest to it,
`(0.4, 0.2, 0.4)`; foot plus vectorial distance gives `q` back.

## Lines

`q%distance_to_line(pt1=, pt2=)` is the distance of `q` from the line through two points, computed as
$|(q - p_1) \times (q - p_2)| / |p_2 - p_1|$: the line is infinite, not the segment between the points.

![a point, the line through two points, the distance between them and a point on the line](/figures/line.svg){.figure}

## Collinear points and tolerances

`m%is_collinear(pt1=, pt2=)` asks whether `m` lies on the line through two points. Without `tolerance` the test is
exact: the distance must be zero. The midpoint of `p2 p3` passes, because its coordinates are exact in binary; the
point `0.3 p2 + 0.7 p3` lies on the line in exact arithmetic, but 0.3 and 0.7 are not exact in binary, and it misses
by $2 \times 10^{-17}$. With `tolerance=1.e-12_R8P` it passes, and a point 1e-9 off the line still fails. Pass a
tolerance whenever the points are computed: scale it to the size of your geometry.

## Concyclic points

`a%is_concyclic(pt1=, pt2=, pt3=)` asks whether four points lie on one circle, **in this order** around it:
VecFor tests Ptolemy's theorem, $|a p_1|\,|p_2 p_3| + |p_1 p_2|\,|p_3 a| = |a p_2|\,|p_1 p_3|$, which holds for the
points of a circle taken in their order along it. `a`, the point of the circle through the slanted face opposite to
`p2`, lies between `p3` and `p4`: the order `a, p4, p2, p3` passes, `a, p2, p4, p3` does not. Its default tolerance is
the smallest positive number, so computed points need a `tolerance` here too (see
[Are four points on one circle?](../cookbook#are-four-points-on-one-circle)).

![the circle through the corners of the slanted face, and a point a on it](/figures/concyclic.svg){.figure}

::: tip What you learned
`distance_to_plane` (signed), `distance_vectorial_to_plane`, `projection_onto_plane`, `distance_to_line`,
`is_collinear` and `is_concyclic` with their `tolerance`. Reference: [Geometry](/guide/geometry).
:::

Next: [6. Components: a slip wall](./06-components).
