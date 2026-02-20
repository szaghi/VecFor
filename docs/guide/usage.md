---
title: Usage
---

# Usage

All examples use `use vecfor` which re-exports all precision variants and the Cartesian versors.

## Importing and declaring vectors

```fortran
use vecfor
implicit none
type(vector) :: v1, v2, v3   ! default 64-bit (R8P) precision
type(vector_R4P) :: vf       ! 32-bit precision
type(vector_R16P) :: vq      ! 128-bit precision (if compiler supports it)
```

The module also exposes `vector_R4P`, `vector_R8P`, and `vector_R16P` for explicit precision control. All three sets of Cartesian versors are available:

```fortran
v1 = ex        ! [1, 0, 0]  (64-bit versor)
v1 = ex_R4P    ! [1, 0, 0]  (32-bit versor)
v1 = ex_R16P   ! [1, 0, 0]  (128-bit versor)
```

---

## Standard arithmetic

Use `ex`, `ey`, `ez` (the Cartesian unit versors) and standard operators to build and combine vectors:

```fortran
use vecfor
implicit none
type(vector) :: v1, v2

v1 = ex                ! [1, 0, 0]
v2 = v1 + 2            ! [3, 2, 2]  (scalar added to each component)
v2 = v1 - 2            ! [-1, -2, -2]
v2 = v1 / 2            ! [0.5, 0, 0]
v2 = v1 * 2            ! [2, 0, 0]
v2 = ey + ez           ! [0, 1, 1]
v1 = v1 + v2           ! [1, 1, 1]
```

All operators work with any supported numeric kind on either side:

```fortran
use vecfor
use penf, only: R4P, I4P
implicit none
type(vector) :: v

v = ex * 2.0_R4P       ! mix with 32-bit real scalar
v = 3_I4P * ey         ! mix with 32-bit integer scalar
```

---

## Vectorial calculus algebra

### Cross product

```fortran
use vecfor
implicit none
type(vector) :: v1, v2, cross

v1 = ex
v2 = ex + 2 * ey
cross = v1 .cross. v2   ! [0, 0, 2]
```

### Dot product

```fortran
use vecfor
use penf, only: R8P
implicit none
type(vector) :: v1, v2
real(R8P)    :: dot

v1 = ex
v2 = ex + 2 * ey
dot = v1 .dot. v2   ! 1.0  (ex · (ex + 2*ey) = 1)
```

### Parallel and orthogonal projections

```fortran
use vecfor
implicit none
type(vector) :: v1, v2, parallel_comp, orthogonal_comp

v1 = 2 * ex
v2 = ex + ey
parallel_comp   = v1 .paral. v2   ! component of v1 parallel to v2: [1, 1, 0]
orthogonal_comp = v1 .ortho. v2   ! component of v1 orthogonal to v2: [1, -1, 0]
```

---

## Norms and normalization

```fortran
use vecfor
implicit none
type(vector) :: v

v = ex + 2 * ey + 3 * ez          ! [1, 2, 3]

print *, v%sq_norm()               !  14.0
print *, sq_norm(v)                !  14.0  (stand-alone function)
print *, v%normL2()                ! ~3.742
print *, normL2(v)                 ! ~3.742  (stand-alone function)

call v%normalize()                 ! normalize v in-place
! v is now [1/sqrt(14), 2/sqrt(14), 3/sqrt(14)]

v = ex + 2 * ey + 3 * ez
print *, normalized(v)%normL2()   ! 1.0  (stand-alone: returns normalized copy)
```

::: tip
`normalize()` and `normalized()` handle the zero-vector gracefully — they return a zero vector instead of dividing by zero.
:::

---

## Face normals

VecFor computes the geometric normal to a triangular or quad face. The norm of the result equals the face area.

### Triangle (3-point face)

```
 1.----.2
   \   |
    \  |
     \ |
      \|
       .3
```

```fortran
use vecfor
implicit none
type(vector) :: p1, p2, p3, normal

p1 = -ex + ey   ! [-1, 1, 0]
p2 = ey          ! [ 0, 1, 0]
p3 = -ey         ! [ 0,-1, 0]

! Stand-alone function
normal = face_normal3(pt1=p1, pt2=p2, pt3=p3)         ! [0, 0, -1]

! Type-bound method
call normal%face_normal3(pt1=p1, pt2=p2, pt3=p3)      ! [0, 0, -1]

! With normalisation (unit normal)
call normal%face_normal3(norm='y', pt1=p1, pt2=p2, pt3=p3)  ! [0, 0, -1]
```

### Quad (4-point face)

```
 1.----------.2
  |          |
  |          |
  4.----------.3
```

```fortran
use vecfor
implicit none
type(vector) :: p1, p2, p3, p4, normal

p1 = -ex + ey    ! [-1, 1, 0]
p2 = ey           ! [ 0, 1, 0]
p3 = -ey          ! [ 0,-1, 0]
p4 = -ex - ey    ! [-1,-1, 0]

normal = face_normal4(pt1=p1, pt2=p2, pt3=p3, pt4=p4)        ! [0, 0, -2]
call normal%face_normal4(norm='y', pt1=p1, pt2=p2, pt3=p3, pt4=p4) ! [0, 0, -1]
```

::: tip
The norm of the face normal equals the face area. Pass `norm='y'` to get a unit normal instead.
:::

---

## Comparison operators

Vectors are compared by their L2 norm. The result is a logical scalar:

```fortran
use vecfor
use penf, only: R8P, I4P
implicit none
type(vector) :: v1, v2

v1 = ex + 2 * ey + 3 * ez   ! normL2 = sqrt(14) ~ 3.742
v2 = ex + ey + ez            ! normL2 = sqrt(3)  ~ 1.732

print *, v1 > v2             ! T
print *, v1 == v2            ! F
print *, v1 /= v2            ! T
print *, v1 < 1.0_R8P        ! F  (compare norm to scalar)
print *, 1_I4P < v1          ! T
```

---

## I/O

### Formatted print

```fortran
use vecfor
implicit none
type(vector) :: v

v = ex + 2 * ey + 3 * ez
call v%print   ! Component x +1.000000000000000E+000
               ! Component y +2.000000000000000E+000
               ! Component z +3.000000000000000E+000
```

### File save and load

```fortran
use vecfor
use penf, only: I4P
implicit none
type(vector) :: v
integer(I4P) :: unit

v = ex + 2 * ey + 3 * ez

! Sequential access
open(newunit=unit, file='vector.dat', form='unformatted')
call v%save(unit=unit)
close(unit)

open(newunit=unit, file='vector.dat', form='unformatted')
call v%load(unit=unit)
close(unit)

! Stream access
open(newunit=unit, file='vector.str', form='unformatted', access='stream')
call v%save(unit=unit)
close(unit)
```

---

## Quick reference — test program output

Running `src/tests/simple.f90` produces the following output (abbreviated):

```
 Assign vector1 = [1, 2, 3]
 Assign vector2 = [-1, -2, -3]
 vector1%sq_norm() =  14.0
 vector1%normL2()  =   3.7
 normalized(vector1):
 Component x +0.267261241912424E+000
 Component y +0.534522483824849E+000
 Component z +0.801783725737273E+000
 vector1.dot.ex  =   1.0
 vector1.dot.ey  =   2.0
 vector1.dot.ez  =   3.0
 vector1.dot.vector2 = -14.0
 vector1.cross.vector2:
 Component x  0.000000000000000E+000
 Component y  0.000000000000000E+000
 Component z  0.000000000000000E+000
 vector1.paral.vector2:
 Component x +0.100000000000000E+001
 Component y +0.200000000000000E+001
 Component z +0.300000000000000E+001
```
