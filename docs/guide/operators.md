---
title: Operators
---

# Operators

In this page `a` and `b` are vectors of one kind, `s` is a number of any of the kinds below, `m` a 3 x 3 real matrix,
and $\hat b = \mathbf b / |\mathbf b|$.

| Numbers | Kinds |
|---|---|
| integers | `I1P`, `I2P`, `I4P`, `I8P` |
| reals | `R4P`, `R8P`, `R16P` |

A number is converted to the kind of the vector before the operation, with `real(s, kind)`. Two vectors must have the
same kind (and the same type: `vector` and `vector_R8P` do not mix, see [Precision and kinds](./precision)).

## Assignment

| Statement | Result |
|---|---|
| `a = b` | a copy of `b` |
| `a = s` | `(s, s, s)` |

## Arithmetic

| Expression | Result | Note |
|---|---|---|
| `+a` | $(a_x, a_y, a_z)$ | |
| `-a` | $(-a_x, -a_y, -a_z)$ | |
| `a + b`, `a - b` | $(a_x \pm b_x, a_y \pm b_y, a_z \pm b_z)$ | |
| `a * b` | $(a_x b_x, a_y b_y, a_z b_z)$ | component by component, **not** the dot product |
| `a / b` | $(a_x / b_x, a_y / b_y, a_z / b_z)$ | component by component |
| `s * a`, `a * s` | $(s a_x, s a_y, s a_z)$ | |
| `a / s` | $(a_x / s, a_y / s, a_z / s)$ | no `s / a` |
| `a + s`, `s + a` | $(a_x + s, a_y + s, a_z + s)$ | the number on every component |
| `a - s` | $(a_x - s, a_y - s, a_z - s)$ | |
| `s - a` | $(s - a_x, s - a_y, s - a_z)$ | |

## Products

| Expression | Result | Type |
|---|---|---|
| `a .dot. b` | $a_x b_x + a_y b_y + a_z b_z$ | real, the kind of the vectors |
| `a .cross. b` | $(a_y b_z - a_z b_y,\; a_z b_x - a_x b_z,\; a_x b_y - a_y b_x)$ | vector |
| `m .matrix. a` | $m\,\mathbf a$, the matrix on the left | vector |

`m` is a `real` array of shape `(3, 3)` of the kind of the vector, in Fortran's column-major order: `m(i, j)` is row `i`,
column `j`. Rotation and mirror matrices come from [`rotation_matrix` and `mirror_matrix`](./transforms).

### Parallel and orthogonal components

| Expression | Result |
|---|---|
| `a .paral. b` | $(\mathbf a \cdot \hat b)\, \hat b$, the component of `a` along `b` |
| `a .ortho. b` | $\mathbf a - (\mathbf a \cdot \hat b)\, \hat b$, the component of `a` orthogonal to `b` |

Only the direction of `b` matters. If `b` is the zero vector both are NaN.

### Precedence

Fortran gives every user-defined binary operator (`.dot.`, `.cross.`, `.matrix.`, `.paral.`, `.ortho.`) the lowest
precedence, below `+`, `-`, `*`, `/` and the comparisons, and evaluates a chain of them from left to right:

| Written | Means |
|---|---|
| `a .dot. b + c` | `a .dot. (b + c)` |
| `2 * a .cross. b` | `(2 * a) .cross. b` |
| `a .cross. b .dot. c` | `(a .cross. b) .dot. c` |
| `a .dot. b > 0` | `a .dot. (b > 0)`: does not compile |

Parenthesise products: `(a .dot. b) > 0._R8P`.

## Comparisons

| Expression | True when |
|---|---|
| `a < b`, `a <= b`, `a > b`, `a >= b` | the lengths compare so: $\lvert a \rvert < \lvert b \rvert$, ... |
| `a == b` | same length, and the unit vectors have equal components |
| `a /= b` | not `a == b` |
| `a < s`, `s < a`, ... (all six) | the length of `a` compares so with `s` |

The comparisons between vectors order them **by length**, not component by component: `3 * ex <= 3 * ey` and
`3 * ex >= 3 * ey` are both true, `3 * ex == 3 * ey` is false. All comparisons are exact, without tolerance: for
computed vectors compare `normL2(a - b)` with a tolerance of your own.

## Elemental

All operators but `.matrix.` are elemental: with arrays of vectors (and arrays of numbers) they work element by
element. The defined assignment of a vector to a vector is not elemental, but Fortran's intrinsic assignment copies
arrays of vectors element by element anyway.
