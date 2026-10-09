# 6. Components: a slip wall

A particle hits the slanted face of the tetrahedron. At a slip wall the component of its velocity along the wall
survives and the component across the wall reverses. `probe` splits the velocity with two operators.

<<< @/examples/snippets/probe_6.f90

<<< @/examples/output/probe_6.txt{console}

![a velocity hitting a wall, its components along the normal and along the wall, and the velocity after the bounce](/figures/components.svg){.figure}

<p class="figure-caption">The face seen edge-on, from the direction of <code>n .cross. v</code>: the velocities are
drawn at 0.4 of their length.</p>

## Parallel and orthogonal components

`v .paral. n` is the component of `v` along `n`, $(\mathbf v \cdot \hat n)\,\hat n$; `v .ortho. n` is the rest,
$\mathbf v - (\mathbf v \cdot \hat n)\,\hat n$, orthogonal to `n`. Their sum is `v`, their dot product is zero up to
rounding (`-2.2E-16`). Only the direction of `n` matters: here it is the normal of `face_normal3` without `norm`, as long
as the face is large, and the components are the same as with a unit normal.

The right operand must not be the zero vector, which has no direction: `v .paral. 0` is NaN in every component (see
[The components parallel and orthogonal to a vector](../cookbook#the-components-parallel-and-orthogonal-to-a-vector)).

## The bounce

After the bounce the velocity is `vt - vn`: the tangential component unchanged, the normal one reversed. The speed is
the same before and after, and `v . n` changes sign: the particle now leaves the wall. The same reflection is a mirror
across the plane of the wall, `call v%mirror(normal=n)` (see
[A velocity reflected by a wall](../cookbook#a-velocity-reflected-by-a-wall)), the subject of the next chapter.

::: tip What you learned
`.paral.` and `.ortho.`: the components of a vector along and across a direction; a slip-wall reflection. Reference:
[Operators](/guide/operators#parallel-and-orthogonal-components).
:::

Next: [7. Rotations and mirrors](./07-transforms).
