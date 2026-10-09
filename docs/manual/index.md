---
title: The tutorial
---

# The tutorial

The tutorial teaches VecFor by growing one program, step by step. The [cookbook](./cookbook) then collects short
recipes for everyday tasks, and the [reference](/guide/features) has every operator, every method and every argument.

## The chapters

The tutorial follows `probe`, a program that inspects a small body: the tetrahedron with a corner at the origin and the
other three at the tips of the Cartesian versors. Its numbers can be checked by hand (a volume of 1/6, a slanted face
of area √3/2), and it is enough to meet everything a solver asks of its geometry: edges and centroids, face normals and
areas, a point inside or outside, distances and projections, rotations and mirrors. Each chapter is a complete program
that you can compile and run; every output shown is the real output of that program.

![the tetrahedron of the tutorial with its outward normals, a point q and its foot on the slanted face](/figures/hero.svg){.figure}

| Chapter | You learn |
|---|---|
| [1. First vectors](./tutorial/01-first-vectors) | `type(vector)`, the versors `ex`, `ey`, `ez`, the components, `printf` |
| [2. Arithmetic](./tutorial/02-arithmetic) | `+`, `-`, `*`, `/` between vectors and with numbers, on arrays of vectors |
| [3. Lengths and angles](./tutorial/03-lengths-angles) | `normL2`, `sq_norm`, `normalized`, `normalize`, `.dot.`, `.cross.`, `angle` |
| [4. Faces, area, volume](./tutorial/04-faces) | `face_normal3`, outward normals, area, the volume by the divergence theorem |
| [5. A point and the body](./tutorial/05-point) | distances to planes and lines, projections, `is_collinear`, `is_concyclic`, tolerances |
| [6. Components: a slip wall](./tutorial/06-components) | `.paral.`, `.ortho.`: normal and tangential components, a bounce |
| [7. Rotations and mirrors](./tutorial/07-transforms) | `rotate`, `rotation_matrix`, `.matrix.`, `mirror`, `mirror_matrix` |
| [8. Many vectors at once](./tutorial/08-arrays) | elemental operators and functions on arrays, comparisons by length |
| [9. Precision](./tutorial/09-precision) | `vector_R4P`, `vector_R8P`, `vector_R16P`, true quadruple precision |
| [10. Printing and files](./tutorial/10-io) | `printf`, `save_into_file`, `load_from_file`, `iolen`, I/O errors |
| [11. On the GPU](./tutorial/11-gpu) | the device-callable `_oac` routines inside an OpenACC loop |

```mermaid
flowchart LR
  c1[1 vectors] --> c2[2 arithmetic] --> c3[3 lengths] --> c4[4 faces] --> c5[5 point] --> c6[6 components]
  c6 --> c7[7 rotations] --> c8[8 arrays] --> c9[9 precision] --> c10[10 files] --> c11[11 GPU]
```

## The cookbook

[The cookbook](./cookbook) answers "how do I ...?" in a few lines each: a vector from its components, a unit vector,
the angle between two vectors, the normal of a quadrilateral, the signed distance from a plane, a rotation matrix
applied many times, a mirror across a plane that misses the origin, a text file of vectors, ...

## Building the examples

Every program of the tutorial and of the cookbook is in
[`docs/examples/src`](https://github.com/szaghi/VecFor/tree/master/docs/examples/src). With VecFor built by FoBiS
(`fobis build --mode static-gnu`, see [Installation](/guide/install)):

```bash
gfortran -I static/mod docs/examples/src/probe_1.f90 static/libvecfor.a -o probe
./probe
```

`bash scripts/docs_examples.sh` builds and runs all of them, regenerating the outputs shown in these pages, and draws
the figures: the programs in [`docs/examples/figures`](https://github.com/szaghi/VecFor/tree/master/docs/examples/figures)
compute each drawing with VecFor and project it onto the page with its dot product, and
[foresight](https://github.com/szaghi/foresight) draws it.
