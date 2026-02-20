---
title: API Reference
---

# API Reference

VecFor exposes a single module:

```fortran
use vecfor
```

This re-exports the default-precision (`R8P`) type and all explicit-precision variants. The primary user-facing type is `vector` (alias for `vector_R8P`).

## `vector` type

All three precision variants share the same interface. The following documents `vector` (64-bit); substitute `vector_R4P` or `vector_R16P` for other precisions.

### Public components

| Component | Type | Default | Description |
|-----------|------|---------|-------------|
| `x` | `real(R8P)` | `0.0` | Cartesian x component |
| `y` | `real(R8P)` | `0.0` | Cartesian y component |
| `z` | `real(R8P)` | `0.0` | Cartesian z component |

### Cartesian versors (module-level constants)

| Name | Value | Description |
|------|-------|-------------|
| `ex` / `ex_R8P` | `[1, 0, 0]` | Unit vector along x |
| `ey` / `ey_R8P` | `[0, 1, 0]` | Unit vector along y |
| `ez` / `ez_R8P` | `[0, 0, 1]` | Unit vector along z |

Equivalent constants `ex_R4P`, `ey_R4P`, `ez_R4P` and `ex_R16P`, `ey_R16P`, `ez_R16P` are available for the other precisions.

### Overloaded operators

| Operator | Description |
|----------|-------------|
| `=` | Assignment from vector or any numeric scalar (sets all three components) |
| `+`, `-`, `*`, `/` | Arithmetic with another vector or any numeric scalar (left and right) |
| unary `+`, `-` | Identity and negation |
| `.cross.` | Cross product |
| `.dot.` | Dot product (returns scalar) |
| `.paral.` | Component of the left vector parallel to the right vector |
| `.ortho.` | Component of the left vector orthogonal to the right vector |
| `.matrix.` | Matrix product: `(u.matrix.v)_i = u_i * v_i` (component-wise) |
| `<`, `<=`, `==`, `/=`, `>=`, `>` | Comparison by L2 norm; works with another vector or any numeric scalar |

---

## Type-bound methods

### `init` {#init}

Initialise a vector from three scalar components.

```fortran
call v%init(x=1.0_R8P, y=2.0_R8P, z=3.0_R8P)
```

### `set` {#set}

Set individual components (similar to `init` but intended for partial updates).

```fortran
call v%set(x=1.0_R8P, y=2.0_R8P, z=3.0_R8P)
```

### `normL2` {#normL2}

Return the Euclidean (L2) norm $\|\mathbf{v}\|_2 = \sqrt{x^2+y^2+z^2}$.

```fortran
use vecfor
implicit none
type(vector) :: v
real(R8P)    :: n

v = ex + 2*ey + 3*ez
n = v%normL2()   ! sqrt(14) ~ 3.742
n = normL2(v)    ! stand-alone function form
```

### `sq_norm` {#sq_norm}

Return the squared norm $x^2+y^2+z^2$ (avoids the square root).

```fortran
use vecfor
implicit none
type(vector) :: v
real(R8P)    :: n2

v = ex + 2*ey + 3*ez
n2 = v%sq_norm()   ! 14.0
n2 = sq_norm(v)    ! stand-alone function form
```

### `normalize` {#normalize}

Normalize the vector **in-place** (subroutine). Returns the zero vector if the norm is zero.

```fortran
use vecfor
implicit none
type(vector) :: v

v = ex + 2*ey + 3*ez
call v%normalize()
! v is now [1/sqrt(14), 2/sqrt(14), 3/sqrt(14)]
```

### `normalized` {#normalized}

Return a **normalized copy** of the vector (function). Returns the zero vector if the norm is zero.

```fortran
use vecfor
implicit none
type(vector) :: v, vn

v  = ex + 2*ey + 3*ez
vn = normalized(v)     ! stand-alone function form
vn = v%normalized()    ! type-bound form
```

### `face_normal3` {#face_normal3}

Compute the normal to a triangular face defined by three point-vectors. The norm of the result equals the triangle area. The optional `norm='y'` argument returns a unit normal instead.

**Signature:**
```fortran
call v%face_normal3(pt1=, pt2=, pt3=, norm=)  ! type-bound subroutine
n = face_normal3(pt1=, pt2=, pt3=, norm=)     ! stand-alone function
```

| Argument | Intent | Description |
|----------|--------|-------------|
| `pt1`, `pt2`, `pt3` | `in` | Three vertices of the triangle |
| `norm` | `in`, optional | `'y'` to return a unit normal |

```fortran
use vecfor
implicit none
type(vector) :: p1, p2, p3, normal

p1 = -ex + ey
p2 = ey
p3 = -ey
call normal%face_normal3(pt1=p1, pt2=p2, pt3=p3)         ! [0, 0, -1]
call normal%face_normal3(norm='y', pt1=p1, pt2=p2, pt3=p3) ! unit normal
```

### `face_normal4` {#face_normal4}

Compute the normal to a quadrilateral face defined by four point-vectors (in order). The norm of the result equals the quad area. The optional `norm='y'` argument returns a unit normal.

```fortran
use vecfor
implicit none
type(vector) :: p1, p2, p3, p4, normal

p1 = -ex + ey
p2 = ey
p3 = -ey
p4 = -ex - ey
normal = face_normal4(pt1=p1, pt2=p2, pt3=p3, pt4=p4)        ! [0, 0, -2]
call normal%face_normal4(norm='y', pt1=p1, pt2=p2, pt3=p3, pt4=p4)  ! [0, 0, -1]
```

### `angle` {#angle}

Return the angle between two vectors in radians.

```fortran
use vecfor
use penf, only: R8P
implicit none
type(vector) :: v1, v2
real(R8P)    :: theta

v1 = ex
v2 = ey
theta = v1%angle(v2)   ! pi/2
```

### `rotate` {#rotate}

Return a new vector obtained by rotating `self` by `angle` radians around `axis`.

```fortran
use vecfor
use penf, only: R8P
implicit none
type(vector) :: v, rotated
real(R8P), parameter :: pi = acos(-1.0_R8P)

v = ex
rotated = v%rotate(axis=ez, angle=pi/2.0_R8P)  ! ~ ey
```

### `mirror` {#mirror}

Return the mirror image of the vector across the plane whose normal is given.

```fortran
use vecfor
implicit none
type(vector) :: v, mirrored

v = ex + ey
mirrored = v%mirror(plane_normal=ez)
```

### `distance_to_line` {#distance_to_line}

Return the distance from the vector (treated as a point) to the line defined by a point `pt` and direction `dir`.

```fortran
use vecfor
use penf, only: R8P
implicit none
type(vector) :: p, line_pt, line_dir
real(R8P)    :: d

p        = ey                ! point [0,1,0]
line_pt  = 0 * ex            ! line passes through origin
line_dir = ex                ! line along x-axis
d = p%distance_to_line(pt=line_pt, dir=line_dir)  ! 1.0
```

### `distance_to_plane` {#distance_to_plane}

Return the signed distance from the vector (as a point) to the plane defined by a point `pt` and unit normal `normal`.

```fortran
use vecfor
use penf, only: R8P
implicit none
type(vector) :: p, plane_pt, plane_n
real(R8P)    :: d

p        = 3 * ez
plane_pt = 0 * ex
plane_n  = ez
d = p%distance_to_plane(pt=plane_pt, normal=plane_n)  ! 3.0
```

### `projection_onto_plane` {#projection_onto_plane}

Return the orthogonal projection of the vector onto the plane with the given unit normal.

```fortran
use vecfor
implicit none
type(vector) :: v, proj

v    = ex + ey + ez
proj = v%projection_onto_plane(normal=ez)  ! [1, 1, 0]
```

### `is_collinear` {#is_collinear}

Return `.true.` if the calling vector and two other vectors are collinear (treated as points).

```fortran
use vecfor
implicit none
type(vector) :: p1, p2, p3

p1 = 0 * ex
p2 = ex
p3 = 2 * ex
print *, p1%is_collinear(p2, p3)  ! T
```

### `is_concyclic` {#is_concyclic}

Return `.true.` if the four point-vectors (calling + three arguments) lie on a common circle.

### `print` {#print}

Print the x, y, z components to stdout in formatted form.

```fortran
use vecfor
implicit none
type(vector) :: v

v = ex + 2*ey + 3*ez
call v%print
! Component x +1.000000000000000E+000
! Component y +2.000000000000000E+000
! Component z +3.000000000000000E+000
```

### `save` / `load` {#save-load}

Write and read vector components to/from a Fortran unit (sequential or stream access).

```fortran
use vecfor
use penf, only: I4P
implicit none
type(vector) :: v
integer(I4P) :: unit

v = ex + 2*ey + 3*ez
open(newunit=unit, file='v.dat', form='unformatted')
call v%save(unit=unit)
close(unit)

open(newunit=unit, file='v.dat', form='unformatted')
call v%load(unit=unit)
close(unit)
```

### `iolen` {#iolen}

Return the record length of the vector (for direct-access I/O).

```fortran
use vecfor
implicit none
type(vector) :: v

print *, v%iolen()   ! 24  (3 × 8 bytes for R8P)
```
