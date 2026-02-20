---
title: vecfor
---

# vecfor

> VecFor, Vector algebra class for Fortran poor people.

 This derived type is useful for manipulating vectors in 3D space. The components of the vectors are reals with
 parametrized kind as defined by the library module. The components are defined in a three-dimensional cartesian frame of
 reference.
 All the vectorial math procedures (cross, dot products, parallel...) assume a three-dimensional cartesian frame of reference.
 The operators of assignment (`=`), multiplication (`*`), division (`/`), sum (`+`) and subtraction (`-`) have been overloaded.
 Furthermore the *dot* and *cross* products have been defined.
 Therefore this module provides a far-complete algebra based on Vector derived type.

**Source**: `src/lib/vecfor.F90`

**Dependencies**

```mermaid
graph LR
  vecfor["vecfor"] --> vecfor_R16P["vecfor_R16P"]
  vecfor["vecfor"] --> vecfor_R4P["vecfor_R4P"]
  vecfor["vecfor"] --> vecfor_R8P["vecfor_R8P"]
  vecfor["vecfor"] --> vecfor_RPP["vecfor_RPP"]
```
