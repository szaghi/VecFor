---
layout: home

hero:
  name: VecFor
  text: Vector algebra for Fortran
  tagline: A pure Fortran 2003+ OOP library for 3D Cartesian vector calculus.
  actions:
    - theme: brand
      text: Guide
      link: /guide/
    - theme: alt
      text: API Reference
      link: /api/
    - theme: alt
      text: View on GitHub
      link: https://github.com/szaghi/VecFor

features:
  - icon: 🧮
    title: Vectorial Calculus Algebra
    details: Cross product, dot product, parallel and orthogonal projections, face normals — all via expressive infix operators like <code>.cross.</code>, <code>.dot.</code>, <code>.paral.</code>, <code>.ortho.</code>
  - icon: ➕
    title: Full Arithmetic Overloading
    details: Standard operators (+, -, *, /) work between vectors and between a vector and any numeric scalar — integers and reals of all supported PENF kinds, resolved at compile time with no runtime cost.
  - icon: 📐
    title: Geometry Methods
    details: Compute angles, distances to lines and planes, orthogonal projections, rotations, mirror reflections, and triangle/quad face normals with a single method call.
  - icon: 🔢
    title: Multi-Precision Support
    details: Choose 32-bit (<code>vector_R4P</code>), 64-bit (<code>vector_R8P</code>, default), or 128-bit (<code>vector_R16P</code>) components. The master <code>use vecfor</code> re-exports all precisions.
  - icon: 🧪
    title: OOP / TDD Designed
    details: All methods and operators are <code>pure</code> or <code>elemental</code> — thread- and process-safe. Every public procedure is exercised by automated doctests.
  - icon: 🆓
    title: Free & Open Source
    details: Multi-licensed — GPLv3 for FOSS projects, BSD 2/3-Clause or MIT for commercial use. Fortran 2003+ standard compliant.
---

## Quick start

Import VecFor, define some vectors using the built-in Cartesian versors, and perform vectorial algebra:

```fortran
use vecfor
implicit none
type(vector) :: point1, point2, distance

point1 = 1 * ex                  ! ex is the x-direction versor [1, 0, 0]
point2 = 1 * ex + 2 * ey         ! ey is the y-direction versor [0, 1, 0]

distance = point2 - point1       ! [0, 2, 0]

call distance%print              ! Component x  0.000...
                                 ! Component y +2.000...
                                 ! Component z  0.000...
print *, distance%normL2()       ! +2.000...
```

## Authors

- Stefano Zaghi — [@szaghi](https://github.com/szaghi)

Contributions are welcome — see the [Contributing](/guide/contributing) page.

## Copyrights

VecFor is distributed under a multi-licensing system:

| Use case | License |
|----------|---------|
| FOSS projects | [GPL v3](http://www.gnu.org/licenses/gpl-3.0.html) |
| Closed source / commercial | [BSD 2-Clause](http://opensource.org/licenses/BSD-2-Clause) |
| Closed source / commercial | [BSD 3-Clause](http://opensource.org/licenses/BSD-3-Clause) |
| Closed source / commercial | [MIT](http://opensource.org/licenses/MIT) |

> Anyone interested in using, developing, or contributing to VecFor is welcome — pick the license that best fits your needs.
