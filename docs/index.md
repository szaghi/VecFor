---
layout: home

hero:
  name: VecFor
  text: Vector algebra for Fortran
  tagline: "One vector type, written as you write the maths: a + b, 2 * a, a .dot. b, a .cross. b. Lengths, angles, face normals, distances, projections, rotations and mirrors, in single, double or quadruple precision, on whole arrays at once, and inside an OpenACC kernel."
  image:
    src: /logo.svg
    alt: VecFor
  actions:
    - theme: brand
      text: Tutorial
      link: /manual/tutorial/01-first-vectors
    - theme: alt
      text: Cookbook
      link: /manual/cookbook
    - theme: alt
      text: Reference
      link: /guide/features
    - theme: alt
      text: API
      link: /api/
    - theme: alt
      text: View on GitHub
      link: https://github.com/szaghi/VecFor

features:
  - icon: ➕
    title: The maths, as you write it
    details: "a + b, a - b, -a, 2 * a, a / 4, a .dot. b, a .cross. b, a .paral. n, a .ortho. n, R .matrix. a: a scalar of any integer or real kind on either side, converted for you."
    link: /manual/tutorial/02-arithmetic
    linkText: Arithmetic
  - icon: 📐
    title: Lengths, angles, directions
    details: "normL2, sq_norm, a unit vector in place or as a copy, the angle between two vectors with atan2, so it is accurate near 0 and 180 degrees."
    link: /manual/tutorial/03-lengths-angles
    linkText: Lengths and angles
  - icon: 🔺
    title: Faces of a mesh
    details: "The normal of a triangle or a quadrilateral, as long as the face is large or of unit length: areas, outward normals, the volume of a body by the divergence theorem."
    link: /manual/tutorial/04-faces
    linkText: Faces, area, volume
  - icon: 📍
    title: Points, lines, planes
    details: "The distance from a line, the signed distance from a plane, the foot of a point on it, collinear and concyclic points, with a tolerance when the points are computed."
    link: /manual/tutorial/05-point
    linkText: A point and the body
  - icon: 🔄
    title: Rotations and mirrors
    details: "A rotation about any axis, a reflection across any plane, as a call or as a matrix computed once and applied to many vectors."
    link: /manual/tutorial/07-transforms
    linkText: Rotations and mirrors
  - icon: 🧮
    title: Whole arrays at once
    details: "Every operator and function is elemental: one call computes the normals of all the faces, or the distances of a million points."
    link: /manual/tutorial/08-arrays
    linkText: Many vectors at once
  - icon: 🎚️
    title: Single, double, quadruple
    details: "vector_R4P, vector_R8P, vector_R16P, each with its versors and functions, from one use vecfor; the default vector is double precision."
    link: /manual/tutorial/09-precision
    linkText: Precision
  - icon: 🚀
    title: On the GPU
    details: "A device-callable API for OpenACC kernels: sum, difference, scaling, dot and cross products, assignment, the same results as the operators."
    link: /manual/tutorial/11-gpu
    linkText: On the GPU
---

<div class="showcase">

![a tetrahedron with its outward unit normals, a point q outside it and its foot on the slanted face](/figures/hero.svg){.figure}

<p class="caption">The tetrahedron of the <a href="/VecFor/manual/">tutorial</a>: its outward
<a href="/VecFor/manual/tutorial/04-faces">face normals</a>, a point <code>q</code> and its
<a href="/VecFor/manual/tutorial/05-point">foot</a> on the slanted face. Every figure of these pages is computed by
VecFor, projected onto the page with its own dot product, and drawn by
<a href="https://github.com/szaghi/foresight">foresight</a>.</p>

</div>

## Quick start

A triangle in space, its normal and area, an angle, a point above it, its distance and its foot: this is a whole program.

<<< @/examples/snippets/quickstart.f90

<<< @/examples/output/quickstart.txt{console}

## Gallery

Each figure is the output of a program of the docs; the title leads to the recipe or the chapter that computes it.

<div class="gallery">
<figure>

![two vectors, the parallelogram they span and their cross product](/figures/cross.svg){.figure}

<figcaption><a href="/VecFor/manual/cookbook#dot-cross-and-triple-products">The cross product</a></figcaption>
</figure>
<figure>

![a triangle and a quadrilateral with their normals, one as long as the face is large and one of unit length](/figures/faces.svg){.figure}

<figcaption><a href="/VecFor/manual/cookbook#the-normal-and-the-area-of-a-triangle">Face normals and areas</a></figcaption>
</figure>
<figure>

![a velocity hitting a wall, split into normal and tangential components, and the velocity after the bounce](/figures/components.svg){.figure}

<figcaption><a href="/VecFor/manual/tutorial/06-components">A slip wall: .paral. and .ortho.</a></figcaption>
</figure>
<figure>

![a point, a line through two points, the distance between them and a point on the line](/figures/line.svg){.figure}

<figcaption><a href="/VecFor/manual/cookbook#the-distance-of-a-point-from-a-line">The distance from a line</a></figcaption>
</figure>
<figure>

![the unit vector along x rotated about the diagonal in twelve steps, on a cone](/figures/rotation.svg){.figure}

<figcaption><a href="/VecFor/manual/cookbook#a-rotation-about-an-axis">A rotation about an axis</a></figcaption>
</figure>
<figure>

![a tetrahedron and its mirror image across an oblique plane](/figures/mirror.svg){.figure}

<figcaption><a href="/VecFor/manual/cookbook#the-mirror-image-across-a-plane">A mirror across a plane</a></figcaption>
</figure>
<figure>

![the circle through the three corners of a triangle and a fourth point on it](/figures/concyclic.svg){.figure}

<figcaption><a href="/VecFor/manual/cookbook#are-four-points-on-one-circle">Concyclic points</a></figcaption>
</figure>
<figure>

![the points of a grid that lie inside a tetrahedron](/figures/grid.svg){.figure}

<figcaption><a href="/VecFor/manual/tutorial/08-arrays">Inside or outside, a grid at once</a></figcaption>
</figure>
</div>

## Where next

Learn VecFor step by step in the [tutorial](/manual/tutorial/01-first-vectors), find quick answers in the
[cookbook](/manual/cookbook), look up every operator and method in the [reference](/guide/features).

## Authors

- Stefano Zaghi — [@szaghi](https://github.com/szaghi)

Contributions are welcome — see the [Contributing](/guide/contributing) page.
