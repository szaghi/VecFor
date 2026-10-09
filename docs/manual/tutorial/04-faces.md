# 4. Faces, area, volume

A solver sees a body through its faces: their normals, their areas, and the volume they enclose. `probe` computes all
of them for its tetrahedron.

<<< @/examples/snippets/probe_4.f90

<<< @/examples/output/probe_4.txt{console}

## The normal of a face

`face_normal3(pt1=, pt2=, pt3=)` is the normal of the triangle through the three points:
$\tfrac12 (p_2 - p_1) \times (p_3 - p_1)$. Its length is the area of the triangle, 0.5 for the three faces on the
coordinate planes and $\sqrt3/2$ for the slanted one; its direction follows the right-hand rule, so it points towards
the side from which the three points are seen counter-clockwise. With `norm='y'` (any character does) the normal is
a unit vector; swapping two points reverses it, as the last line shows.

![a quadrilateral and a triangle, each with a normal as long as the face is large and a unit normal](/figures/faces.svg){.figure}

`face_normal4(pt1=, pt2=, pt3=, pt4=)` does the same for a quadrilateral, from its diagonals:
$\tfrac12 (p_3 - p_1) \times (p_4 - p_2)$, the exact area of a flat quadrilateral (see
[The normal and the area of a quadrilateral](../cookbook#the-normal-and-the-area-of-a-quadrilateral)).

## Outward normals

`face` lists the vertices of each face counter-clockwise **seen from outside**, so every normal points out of the
body: `(0, 0, -0.5)` for the face on the plane z = 0, `(0.5, 0.5, 0.5)` for the slanted one. A mesh generator
usually guarantees such an order; when it does not, compare each normal with the vector from the centroid of the body
to the centroid of the face, and swap two vertices where their dot product is negative.

## Surface and volume

The surface is the sum of the lengths of the normals. The volume comes from the divergence theorem: for a closed
surface of flat faces, $V = \tfrac13 \sum_f \mathbf c_f \cdot \mathbf N_f$, with $\mathbf c_f$ the centroid of a face
and $\mathbf N_f$ its outward normal as long as its area. `probe` finds 0.1667, the volume of the corner tetrahedron,
1/6. The same sum gives the volume of any closed mesh of triangles, and a negative volume reveals faces listed
clockwise.

::: tip What you learned
`face_normal3` and `face_normal4`, with and without `norm`; areas from normals; outward normals from the order of the
vertices; the volume of a body by the divergence theorem. Reference: [Geometry](/guide/geometry#face-normals).
:::

Next: [5. A point and the body](./05-point).
