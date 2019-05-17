<a name="top"></a>

# VecFor [![GitHub tag](https://img.shields.io/github/tag/szaghi/VecFor.svg)]() [![Join the chat at https://gitter.im/szaghi/VecFor](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/szaghi/VecFor?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

[![License](https://img.shields.io/badge/license-GNU%20GeneraL%20Public%20License%20v3,%20GPLv3-blue.svg)]()
[![License](https://img.shields.io/badge/license-BSD2-red.svg)]()
[![License](https://img.shields.io/badge/license-BSD3-red.svg)]()
[![License](https://img.shields.io/badge/license-MIT-red.svg)]()

[![Status](https://img.shields.io/badge/status-stable-brightgreen.svg)]()
[![Build Status](https://travis-ci.org/szaghi/VecFor.svg?branch=master)](https://travis-ci.org/szaghi/VecFor)
[![Coverage Status](https://img.shields.io/codecov/c/github/szaghi/VecFor.svg)](http://codecov.io/github/szaghi/VecFor?branch=master)

### VecFor, Vector algebra class for Fortran poor people

A KISS pure Fortran OOD class for computing Vectorial (3D) algebra

- VecFor is a pure Fortran (KISS) library for building easily nice Command Line Interfaces (CLI) for modern Fortran projects;
- VecFor is Fortran 2003+ standard compliant;
- VecFor is OOP designed;
- VecFor is a Free, Open Source Project.

#### Table of Contents

- [What is VecFor?](#what-is-vecfor)
- [Main features](#main-features)
- [Copyrights](#copyrights)
- [Documentation](#documentation)
  - [A Taste of VecFor](#a-taste-of-vecfor)

#### Issues

[![GitHub issues](https://img.shields.io/github/issues/szaghi/VecFor.svg)]()
[![Ready in backlog](https://badge.waffle.io/szaghi/VecFor.png?label=ready&title=Ready)](https://waffle.io/szaghi/VecFor)
[![In Progress](https://badge.waffle.io/szaghi/VecFor.png?label=in%20progress&title=In%20Progress)](https://waffle.io/szaghi/VecFor)
[![Open bugs](https://badge.waffle.io/szaghi/VecFor.png?label=bug&title=Open%20Bugs)](https://waffle.io/szaghi/VecFor)

#### Compiler Support

[![Compiler](https://img.shields.io/badge/GNU-v4.9.2+-brightgreen.svg)]()
[![Compiler](https://img.shields.io/badge/Intel-v12.x+-brightgreen.svg)]()
[![Compiler](https://img.shields.io/badge/IBM%20XL-not%20tested-yellow.svg)]()
[![Compiler](https://img.shields.io/badge/g95-not%20tested-yellow.svg)]()
[![Compiler](https://img.shields.io/badge/NAG-not%20tested-yellow.svg)]()
[![Compiler](https://img.shields.io/badge/PGI-not%20tested-yellow.svg)]()

## What is VecFor?

VecFor is a user-friendly and Object-Oriented designed API for handling *vectors* in a (3D) three dimensional frame of reference. It exposes (among others) the *object* **Vector** that posses a far complete set of overloaded operators for performing vectorial calculus algebra.

VecFor adheres to the [KISS](https://en.wikipedia.org/wiki/KISS_principle) concept: it is a pure Fortran (2003+) library coded into a single module file, `vecfor.F90`.

Go to [Top](#top)

## Main features

+ [x] Pure Fortran implementation;
+ [x] KISS and user-friendly:
    + [x] simple API (one main *object* plus few other *helpers*);
    + [x] easy building and porting on heterogeneous architectures:
        + [x] the vector components are defined as real with parametrized kind; the default kind parameter is set to be 64-bit-like finite precision (defined by means of the portable `select_real_kind` intrinsic function), but it can be easily changed at compile time;
+ [x] comprehensive (almost complete set of operators for vectorial calculus algebra);
    + [x] all operators accept mixed type/kind arguments: vectors can be mixed with integers and reals of any kinds by means of generic interfaces with dynamic dispatch resolved at compile time;
+ [x] efficient and *non intrusive* (all object methods and operators are *pure* or *elemental*):
    + [x] threads/processes safe;
+ [x] Tests-Driven Developed ([TDD](https://en.wikipedia.org/wiki/Test-driven_development));
+ [x] well documented:
    + [x] complete [API](http://szaghi.github.io/VecFor/index.html) reference;
    + [x] comprehensive [wiki](https://github.com/szaghi/VecFor/wiki):
+ [x] collaborative developed on [GitHub](https://github.com/szaghi/VecFor);
+ [x] [FOSS licensed](https://github.com/szaghi/VecFor/wiki/Copyrights);

Any feature request is welcome.

Go to [Top](#top)

## Copyrights

VecFor is an open source project, it is distributed under a multi-licensing system:

+ for FOSS projects:
  - [GPL v3](http://www.gnu.org/licenses/gpl-3.0.html);
+ for closed source/commercial projects:
  - [BSD 2-Clause](http://opensource.org/licenses/BSD-2-Clause);
  - [BSD 3-Clause](http://opensource.org/licenses/BSD-3-Clause);
  - [MIT](http://opensource.org/licenses/MIT).

Anyone is interest to use, to develop or to contribute to VecFor is welcome, feel free to select the license that best matches your soul!

More details can be found on [wiki](https://github.com/szaghi/VecFor/wiki/Copyrights).

Go to [Top](#top)

## Documentation

Besides this README file the VecFor documentation is contained into its own [wiki](https://github.com/szaghi/VecFor/wiki). Detailed documentation of the API is contained into the [GitHub Pages](http://szaghi.github.io/VecFor/index.html) that can also be created locally by means of [ford tool](https://github.com/cmacmackin/ford).

### A Taste of VecFor

VecFor allows a very simple, high-level implementation of vectorial calculus algebra.

#### Import VecFor

```fortran
use vecfor ! load vector type and all helpers
```

#### Define some vector variables

```fortran
type(vector) :: point1
type(vector) :: point2
type(vector) :: distance
```

#### Initialize vectors by high-level math-like syntax
```fortran
point1 = 1 * ex ! ex is the versor along x direction exposed by VecFor
point2 = 1 * ex + 2 * ey ! ey is the versor along y direction exposed by VecFor
```
Note that *ex*, *ey* and *ez* are the Cartesian versors exposed by VecFor.

#### Perform vectorial calculus algebra
```fortran
distance = point2 - point1
```

#### Use helper methods to simplify your life
```fortran
print "(A)", " Vectorial distance"
call distance%printf
print "(A)", " Distance module"
print*, distance%normL2()
! expected output
!   Vectorial distance
!   Component x  0.000000000000000E+000
!   Component y +0.200000000000000E+001
!   Component z  0.000000000000000E+000
!   Distance module
!   +0.200000000000000E+001
```

As you can see from the above example, defining and using a *vector* become very close to the mathematical formulation. Note that, using the dynamic dispatching resolved at compile time, there is no performance penalty on using a `type(vector)` variable instead of an *hard-coded* `real, dimension(3)` array variable (or even more verbose and less clear `real :: x, y, z` variables for each vector...).

Go to [Top](#top)
