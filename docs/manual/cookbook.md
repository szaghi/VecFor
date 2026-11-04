---
title: Cookbook
---

# Cookbook

Short answers to "how do I ...?". Each recipe is a whole program with its real output; the
[reference](/guide/features) has the details.

[[toc]]

## Building vectors

### A vector from its components

<<< @/examples/snippets/from_components.f90

<<< @/examples/output/from_components.txt{console}

Three spellings of the same vector: component by component, from the versors, with the structure constructor
`vector(x, y, z)`. A vector never set is the origin.

### Every component set to one number

<<< @/examples/snippets/from_number.f90

<<< @/examples/output/from_number.txt{console}

Any integer or real kind. The number is converted to the kind of the vector, with its own precision: `0.1_R4P` is the
single precision number nearest to 0.1, not the double precision one.

## Arithmetic

### Sum, difference, negation

<<< @/examples/snippets/sum_difference.f90

<<< @/examples/output/sum_difference.txt{console}

`-a` of a zero component is `-0.0`, the IEEE negative zero, equal to `+0.0`.

### A vector times a number

<<< @/examples/snippets/scaling.f90

<<< @/examples/output/scaling.txt{console}

`*` takes the number on either side, `/` on the right; any integer or real kind, converted to the kind of the vector
before the product. `0.1_R4P` carries its single precision error into a double precision vector: write the literals
with the kind of the vector.

### A number added to every component

<<< @/examples/snippets/plus_number.f90

<<< @/examples/output/plus_number.txt{console}

`a + 1` adds 1 to x, y and z alike. To move a point along an axis, add a vector: `a + ex`.

### The product and the quotient of two vectors, component by component

<<< @/examples/snippets/componentwise.f90

<<< @/examples/output/componentwise.txt{console}

`a * s` is $(a_x s_x, a_y s_y, a_z s_z)$: a different scale on each axis. It is not the dot product, `.dot.`, nor the
cross product, `.cross.`.

## Products, lengths, angles

### Dot, cross and triple products

<<< @/examples/snippets/products.f90

<<< @/examples/output/products.txt{console}

The cross product is anti-commutative, zero for parallel vectors; `a .dot. (b .cross. c)` is the signed volume of the
parallelepiped of the three vectors. Parenthesise: user-defined binary operators such as `.dot.` bind more loosely
than any intrinsic one, so `a .dot. b + c` is `a .dot. (b + c)`.

![two vectors, the parallelogram they span and their cross product](/figures/cross.svg){.figure}

### Products of nearly parallel vectors, accurately

<<< @/examples/snippets/accurate_products.f90

<<< @/examples/output/accurate_products.txt{console}

`.cross.` and `.dot.` round each product before the subtraction or the sum, and lose digits when the terms nearly
cancel. `crossproduct_accurate` and `dotproduct_accurate` keep them (see
[Accurate products](/guide/geometry#accurate-products)). The operators stay as they are.

### The length of a vector

<<< @/examples/snippets/lengths.f90

<<< @/examples/output/lengths.txt{console}

`sq_norm` is the squared length, without a square root: enough to compare lengths.

### A method or a free function

<<< @/examples/snippets/two_spellings.f90

<<< @/examples/output/two_spellings.txt{console}

The methods that return a value are free functions too, with the vector as first argument: use them on expressions
(`normL2(a - b)`), where `(a - b)%normL2()` is not Fortran.

### A unit vector

<<< @/examples/snippets/unit_vector.f90

<<< @/examples/output/unit_vector.txt{console}

`normalized` returns a copy, `normalize` changes the vector. The zero vector stays zero: a length below `tiny(1._R8P)`
is replaced by that length plus `tiny`, so the division is never by zero. To be told that a vector has no
direction, see the next recipe.

### A unit vector, or a report that there is none

<<< @/examples/snippets/unit_vector_checked.f90

<<< @/examples/output/unit_vector_checked.txt{console}

`ok` is false when the length is not above `min_norm` (by default `tiny`, the threshold of `normalize`); `u` is then the
zero vector. `normalized` returns a unit vector for any vector longer than `tiny`, however short.

### The angle between two vectors

<<< @/examples/snippets/angles.f90

<<< @/examples/output/angles.txt{console}

In radians, between 0 and π, from `atan2`: accurate near 0 and π too. With the zero vector the angle is 0.

### The components parallel and orthogonal to a vector

<<< @/examples/snippets/paral_ortho.f90

<<< @/examples/output/paral_ortho.txt{console}

Only the direction of the right operand matters. The zero vector has none: `.paral.` and `.ortho.` give NaN.

### A velocity reflected by a wall

<<< @/examples/snippets/reflect.f90

<<< @/examples/output/reflect.txt{console}

The same reflection, by components or by a mirror across the plane of the wall (see [tutorial, chapter
6](./tutorial/06-components)).

## Comparisons

### Comparing two vectors

<<< @/examples/snippets/compare.f90

<<< @/examples/output/compare.txt{console}

`<`, `<=`, `>`, `>=` compare lengths: `a` and `b`, as long as each other, are both `<=` and `>=`. `==` and `/=`
compare lengths and directions: `a == b` is false. Both are exact, without a tolerance.

### Comparing the length of a vector with a number

<<< @/examples/snippets/compare_number.f90

<<< @/examples/output/compare_number.txt{console}

The number may be of any integer or real kind, on either side.

## Faces and cells

### The normal and the area of a triangle

<<< @/examples/snippets/triangle.f90

<<< @/examples/output/triangle.txt{console}

The length of the normal is the area; `norm='y'` makes it a unit vector; the order of the points sets its side.
`n%face_normal3(...)` does not use `n`: the method is a free function bound to the type.

![a triangle and a quadrilateral with a normal as long as the face is large and a unit normal](/figures/faces.svg){.figure}

### The normal and the area of a quadrilateral

<<< @/examples/snippets/quadrilateral.f90

<<< @/examples/output/quadrilateral.txt{console}

From the cross product of the diagonals, $\tfrac12 (p_3 - p_1) \times (p_4 - p_2)$: the exact area of a flat
quadrilateral. For a warped one it is the vector area of its four edges, the same for every surface they bound: the
normal to use for a flux through the face.

### The area of a triangle, the volume of a tetrahedron

<<< @/examples/snippets/cell_measures.f90

<<< @/examples/output/cell_measures.txt{console}

The volume is signed: positive when the fourth point lies on the side of the normal of the first three, so swapping
two points changes its sign. The vector area of a planar polygon, convex or not, has its area as length; the outward
vector areas of the faces of a closed surface sum to zero.

## Points, lines, planes

### The distance of a point from a line

<<< @/examples/snippets/to_line.f90

<<< @/examples/output/to_line.txt{console}

The line through the two points, infinite: the point `(5, 3, 4)` is 5 from the x axis, beyond the segment of the two
points.

![a point, a line through two points and their distance](/figures/line.svg){.figure}

### The distance of a point from a plane

<<< @/examples/snippets/to_plane.f90

<<< @/examples/output/to_plane.txt{console}

Signed: positive on the side of `face_normal3(pt1, pt2, pt3)`, which swapping two points reverses. The vectorial
distance goes from the plane to the point; the projection is the foot of the point on the plane.

### Is a point inside a tetrahedron?

<<< @/examples/snippets/point_location.f90

<<< @/examples/output/point_location.txt{console}

The barycentric coordinates sum to 1; the point is inside when none is negative. In a triangle they interpolate a
field given at the vertices; they locate the projection of the point onto the plane of the triangle.

### The point of a triangle closest to a point

<<< @/examples/snippets/closest_point.f90

<<< @/examples/output/closest_point.txt{console}

`feature` is 1, 2, 3 for the vertices, 4, 5, 6 for the edges `ab`, `bc`, `ca`, 7 for the inside of the face. The
distance from a triangulated surface is the smallest over its triangles (see
[Point location](/guide/geometry#point-location) for its sign).

### Are three points on one line?

<<< @/examples/snippets/collinear.f90

<<< @/examples/output/collinear.txt{console}

Exact by default, so computed points need a `tolerance`, a length in the units of the geometry.

### Are four points on one circle?

<<< @/examples/snippets/concyclic_points.f90

<<< @/examples/output/concyclic_points.txt{console}

The four points must be given in their order around the circle. Without `tolerance` the test succeeds or fails on the
rounding of the last digit: for computed points pass a tolerance.

![the circle through three points and a fourth point on it](/figures/concyclic.svg){.figure}

## Rotations and mirrors

### A rotation about an axis

<<< @/examples/snippets/rotate_axis.f90

<<< @/examples/output/rotate_axis.txt{console}

Counter-clockwise seen from the tip of the axis, the angle in radians; the axis passes through the origin and need not
be a unit vector.

![a vector rotated about the diagonal in steps of 30 degrees](/figures/rotation.svg){.figure}

### A rotation matrix applied many times

<<< @/examples/snippets/rotate_matrix.f90

<<< @/examples/output/rotate_matrix.txt{console}

`r .matrix. v` returns a new vector, `call v%rotate(matrix=r)` changes `v`. Matrices compose with `matmul`, the
rightmost first.

### The mirror image across a plane

<<< @/examples/snippets/mirror_plane.f90

<<< @/examples/output/mirror_plane.txt{console}

`mirror` reflects across the plane through the origin orthogonal to `normal`. For a plane through another point,
move the point there first, and back after.

![a tetrahedron and its mirror image across an oblique plane](/figures/mirror.svg){.figure}

### A mirror matrix applied many times

<<< @/examples/snippets/mirror_matrix_reuse.f90

<<< @/examples/output/mirror_matrix_reuse.txt{console}

The Householder matrix $I - 2\hat n \hat n^T$: symmetric, its own inverse. A vector along the normal is reversed, a
vector in the plane stays.

### Any matrix applied to a vector

<<< @/examples/snippets/matrix_product.f90

<<< @/examples/output/matrix_product.txt{console}

`.matrix.` takes any 3 x 3 real matrix of the kind of the vector, on the left.

## Arrays

### Whole arrays of vectors at once

<<< @/examples/snippets/arrays.f90

<<< @/examples/output/arrays.txt{console}

Operators and functions are elemental; `p%x` is the array of the x components. Fortran has no `sum` of an array of a
derived type: sum the components.

## Precision

### Vectors of each precision

<<< @/examples/snippets/kinds.f90

<<< @/examples/output/kinds.txt{console}

Each kind has its type, its versors and its free functions, all exported by `vecfor`. `vector` and `vector_R8P` have
the same kind but are two types: copy the components. `vector_R16P` has the kind 16 here, quadruple precision (see the
next recipe).

### True quadruple precision

<<< @/examples/snippets/quad_precision.f90

<<< @/examples/output/quad_precision.txt{console}

33 significant digits, with VecFor and PENF compiled with `-DPENF_R16P`, as the GNU and Intel builds are (see
[Precision and kinds](/guide/precision#true-quadruple-precision)).

## Input and output

### Printing a vector

<<< @/examples/snippets/printing.f90

<<< @/examples/output/printing.txt{console}

`prefix`, `sep` and `suffix` frame the components; `unit` writes to any open unit. For a fixed format, print the
components.

### A binary file of vectors

<<< @/examples/snippets/binary_file.f90

<<< @/examples/output/binary_file.txt{console}

Unformatted: the exact bits.

### A text file of vectors

<<< @/examples/snippets/text_file.f90

<<< @/examples/output/text_file.txt{console}

`fmt` is a format for three reals; the file keeps the digits of the format, no more: 1/3 comes back
$3.3 \times 10^{-6}$ off.

### The n-th vector of a stream file

<<< @/examples/snippets/stream_file.f90

<<< @/examples/output/stream_file.txt{console}

`pos` is in file storage units, `iolen` the storage units of one vector; vector `n` starts at `(n - 1) * iolen + 1`.

### A direct access file of vectors

<<< @/examples/snippets/direct_access.f90

<<< @/examples/output/direct_access.txt{console}

`iolen` is the record length. `save_into_file` and `load_from_file` have no `rec=`: read and write the components.

### An I/O error caught

<<< @/examples/snippets/io_error.f90

<<< @/examples/output/io_error.txt{console}

Pass `iostat` (and `iomsg`) to every `save_into_file` and `load_from_file`: without them an error is ignored, silently.

## On the GPU

### The device-callable routines in an OpenACC loop

<<< @/examples/snippets/device_routines.f90

<<< @/examples/output/device_routines.txt{console}

The seven `_dev` routines of the vector operators give the same results as the operators; the output is the gfortran
build, without `-fopenacc`, where the `!$acc` lines are comments. The matrices, the geometric and the accurate routines
are listed in [Device-callable API](/guide/gpu); see also [tutorial, chapter 11](./tutorial/11-gpu).
