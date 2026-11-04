# 3. Lengths and angles

`probe` measures its edges: their lengths, their directions, the angles between them, and the area of a face from a
cross product.

<<< @/examples/snippets/probe_3.f90

<<< @/examples/output/probe_3.txt{console}

## Lengths

`a%normL2()` is the Euclidean length, $\sqrt{x^2+y^2+z^2}$; `a%sq_norm()` its square, $x^2+y^2+z^2$, cheaper (no square
root) and exact for exact components: compare squared lengths when you only need to know which is longer.

Every method of a vector that returns a value is also a free function, with the vector as first argument:
`normL2(b)` is `b%normL2()`.
The free spelling works on any expression, the type-bound one only on a variable (`(a - b)%normL2()` is not Fortran);
see [A method or a free function](../cookbook#a-method-or-a-free-function).

## Directions

`a%normalized()` returns a unit vector along `a` and leaves `a` alone; `call a%normalize` makes `a` itself a unit
vector. The direction of the edge from `p2` to `p3` is $(-1, 1, 0)/\sqrt 2$: `-0.7071067811865475` is the double
precision number nearest to $1/\sqrt 2$, and the length of the result is 1 to the last digit. The zero vector has no
direction: normalizing it gives the zero vector back, not a division by zero (see
[A unit vector](../cookbook#a-unit-vector)). To be told when a vector is too short to have a direction, call
`normalized_checked(a, u, ok)`: `ok` is false and `u` is zero for such a vector (see
[A unit vector, or a report that there is none](../cookbook#a-unit-vector-or-a-report-that-there-is-none)).

## Dot product

`a .dot. b` is $a_x b_x + a_y b_y + a_z b_z$, a number: 1 for the two edges from `p2`, 0 for the edges from `p1` along
x and y, which are orthogonal.

## Angles

`a%angle(b)`, or `angle(a, b)`, is the angle between the two vectors, in radians, between 0 and π: 60 degrees at
`p2`, where the slanted face is equilateral, 90 degrees at `p1`. VecFor computes it with `atan2`, from the cross and
the dot products of the unit vectors: accurate for nearly parallel and nearly opposite vectors too, where the textbook
$\arccos(\hat a \cdot \hat b)$ loses half of its digits.

## Cross product

`a .cross. b` is the vector orthogonal to `a` and to `b`, oriented by the right-hand rule, as long as the area of the
parallelogram they span: half of it is the area of the triangle `p2 p3 p4`, $\sqrt 3/2 = 0.8660$.

`.cross.` and `.dot.` round each product before they subtract or add them. When the terms nearly cancel, as for
nearly parallel vectors, the result loses digits; `crossproduct_accurate(a, b)` and `dotproduct_accurate(a, b)` keep
them (see [Products of nearly parallel vectors, accurately](../cookbook#products-of-nearly-parallel-vectors-accurately)).

![two vectors a and b, the parallelogram they span and their cross product](/figures/cross.svg){.figure}

::: tip What you learned
`normL2`, `sq_norm`, `normalized`, `normalize`, `.dot.`, `angle`, `.cross.`; every method that returns a value is
also a free function. In passing: `normalized_checked`, `crossproduct_accurate`, `dotproduct_accurate`.
Reference: [Operators](/guide/operators), [Geometry](/guide/geometry).
:::

Next: [4. Faces, area, volume](./04-faces).
