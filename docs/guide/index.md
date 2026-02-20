---
title: About VecFor
---

# About VecFor

**VecFor** is a pure Fortran 2003+ library for 3D Cartesian vector algebra. It provides a single OOP-designed `vector` type with a comprehensive set of overloaded operators and methods for performing vectorial calculus, making Fortran vector math as close as possible to its mathematical notation.

VecFor adheres to the [KISS](https://en.wikipedia.org/wiki/KISS_principle) principle: the library is coded into a single module file (`vecfor.F90`) with no external C dependencies. All operations are `pure` or `elemental`, meaning they are side-effect-free and safe for use in parallel environments.

## Authors

- Stefano Zaghi — [@szaghi](https://github.com/szaghi)

Contributions are welcome — see the [Contributing](contributing) page.

## Copyrights

VecFor is distributed under a multi-licensing system:

| Use case | License |
|----------|---------|
| FOSS projects | [GPL v3](http://www.gnu.org/licenses/gpl-3.0.html) |
| Closed source / commercial | [BSD 2-Clause](http://opensource.org/licenses/BSD-2-Clause) |
| Closed source / commercial | [BSD 3-Clause](http://opensource.org/licenses/BSD-3-Clause) |
| Closed source / commercial | [MIT](http://opensource.org/licenses/MIT) |

> Anyone interested in using, developing, or contributing to VecFor is welcome — pick the license that best fits your needs.
