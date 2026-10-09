---
title: Feature map
---

# Feature map

Every feature of VecFor, where the tutorial teaches it, where the cookbook shows it and where the reference describes
it.

| Feature | How | Tutorial | Cookbook | Reference |
|---|---|---|---|---|
| The vector type | `type(vector)`, components `x`, `y`, `z` | [1](/manual/tutorial/01-first-vectors) | [components](/manual/cookbook#a-vector-from-its-components) | [The vector type](./vector) |
| Versors | `ex`, `ey`, `ez` | [1](/manual/tutorial/01-first-vectors) | [components](/manual/cookbook#a-vector-from-its-components) | [Versors](./vector#versors) |
| Structure constructor | `vector(x, y, z)` | [1](/manual/tutorial/01-first-vectors#three-ways-to-build-a-vector) | [components](/manual/cookbook#a-vector-from-its-components) | [Building a vector](./vector#building-a-vector) |
| Assignment of a number | `v = 2.5_R8P`, any integer or real kind | [1](/manual/tutorial/01-first-vectors#three-ways-to-build-a-vector) | [one number](/manual/cookbook#every-component-set-to-one-number) | [Assignment](./operators#assignment) |
| Sum, difference, sign | `a + b`, `a - b`, `-a`, `+a` | [2](/manual/tutorial/02-arithmetic) | [sum](/manual/cookbook#sum-difference-negation) | [Arithmetic](./operators#arithmetic) |
| Scaling | `s * a`, `a * s`, `a / s`, any kind | [2](/manual/tutorial/02-arithmetic#with-numbers) | [scaling](/manual/cookbook#a-vector-times-a-number) | [Arithmetic](./operators#arithmetic) |
| A number on every component | `a + s`, `s + a`, `a - s`, `s - a` | [2](/manual/tutorial/02-arithmetic#with-numbers) | [plus a number](/manual/cookbook#a-number-added-to-every-component) | [Arithmetic](./operators#arithmetic) |
| Component-wise product, quotient | `a * b`, `a / b` | [2](/manual/tutorial/02-arithmetic#between-vectors) | [component-wise](/manual/cookbook#the-product-and-the-quotient-of-two-vectors-component-by-component) | [Arithmetic](./operators#arithmetic) |
| Dot product | `a .dot. b` | [3](/manual/tutorial/03-lengths-angles#dot-product) | [products](/manual/cookbook#dot-cross-and-triple-products) | [Products](./operators#products) |
| Cross product | `a .cross. b` | [3](/manual/tutorial/03-lengths-angles#cross-product) | [products](/manual/cookbook#dot-cross-and-triple-products) | [Products](./operators#products) |
| Length | `normL2`, `sq_norm` | [3](/manual/tutorial/03-lengths-angles#lengths) | [length](/manual/cookbook#the-length-of-a-vector) | [Lengths and directions](./geometry#lengths-and-directions) |
| Unit vector | `normalized`, `normalize` | [3](/manual/tutorial/03-lengths-angles#directions) | [unit vector](/manual/cookbook#a-unit-vector) | [Lengths and directions](./geometry#lengths-and-directions) |
| Angle | `angle` | [3](/manual/tutorial/03-lengths-angles#angles) | [angle](/manual/cookbook#the-angle-between-two-vectors) | [Angle](./geometry#angle) |
| Parallel and orthogonal components | `a .paral. n`, `a .ortho. n` | [6](/manual/tutorial/06-components) | [components](/manual/cookbook#the-components-parallel-and-orthogonal-to-a-vector) | [Products](./operators#parallel-and-orthogonal-components) |
| Face normals and areas | `face_normal3`, `face_normal4`, `norm` | [4](/manual/tutorial/04-faces) | [triangle](/manual/cookbook#the-normal-and-the-area-of-a-triangle), [quadrilateral](/manual/cookbook#the-normal-and-the-area-of-a-quadrilateral) | [Face normals](./geometry#face-normals) |
| Distance from a line | `distance_to_line` | [5](/manual/tutorial/05-point#lines) | [line](/manual/cookbook#the-distance-of-a-point-from-a-line) | [Distances](./geometry#distances-and-projections) |
| Distance from a plane | `distance_to_plane`, `distance_vectorial_to_plane` | [5](/manual/tutorial/05-point#inside-or-outside) | [plane](/manual/cookbook#the-distance-of-a-point-from-a-plane) | [Distances](./geometry#distances-and-projections) |
| Projection onto a plane | `projection_onto_plane` | [5](/manual/tutorial/05-point#the-foot-of-a-point) | [plane](/manual/cookbook#the-distance-of-a-point-from-a-plane) | [Distances](./geometry#distances-and-projections) |
| Collinear points | `is_collinear`, `tolerance` | [5](/manual/tutorial/05-point#collinear-points-and-tolerances) | [collinear](/manual/cookbook#are-three-points-on-one-line) | [Predicates](./geometry#collinear-and-concyclic-points) |
| Concyclic points | `is_concyclic`, `tolerance` | [5](/manual/tutorial/05-point#concyclic-points) | [concyclic](/manual/cookbook#are-four-points-on-one-circle) | [Predicates](./geometry#collinear-and-concyclic-points) |
| Rotation | `rotate(axis=, angle=)`, `rotate(matrix=)`, `rotation_matrix` | [7](/manual/tutorial/07-transforms) | [axis](/manual/cookbook#a-rotation-about-an-axis), [matrix](/manual/cookbook#a-rotation-matrix-applied-many-times) | [Rotations](./transforms#rotations) |
| Mirror | `mirror(normal=)`, `mirror(matrix=)`, `mirror_matrix` | [7](/manual/tutorial/07-transforms#a-mirror) | [plane](/manual/cookbook#the-mirror-image-across-a-plane), [matrix](/manual/cookbook#a-mirror-matrix-applied-many-times) | [Mirrors](./transforms#mirrors) |
| Matrix times vector | `m .matrix. a` | [7](/manual/tutorial/07-transforms#a-rotation-matrix) | [any matrix](/manual/cookbook#any-matrix-applied-to-a-vector) | [Products](./operators#products) |
| Comparisons | `==`, `/=`, `<`, `<=`, `>`, `>=`, with vectors and numbers | [8](/manual/tutorial/08-arrays#comparisons-are-by-length) | [vectors](/manual/cookbook#comparing-two-vectors), [numbers](/manual/cookbook#comparing-the-length-of-a-vector-with-a-number) | [Comparisons](./operators#comparisons) |
| Arrays of vectors | elemental operators and functions, `p%x` | [8](/manual/tutorial/08-arrays) | [arrays](/manual/cookbook#whole-arrays-of-vectors-at-once) | [Arrays](./vector#arrays-of-vectors) |
| Methods or free functions | `a%normL2()` or `normL2(a)` | [3](/manual/tutorial/03-lengths-angles#lengths) | [two spellings](/manual/cookbook#a-method-or-a-free-function) | [Names](./vector#methods-and-free-functions) |
| Precisions | `vector_R4P`, `vector_R8P`, `vector_R16P`, versors and functions of each | [9](/manual/tutorial/09-precision) | [each precision](/manual/cookbook#vectors-of-each-precision) | [Precision and kinds](./precision) |
| True quadruple precision | `-DPENF_R16P` | [9](/manual/tutorial/09-precision#true-quadruple-precision) | [quadruple](/manual/cookbook#true-quadruple-precision) | [Quadruple](./precision#true-quadruple-precision) |
| Printing | `printf(prefix=, sep=, suffix=, unit=)` | [10](/manual/tutorial/10-io#printing) | [printing](/manual/cookbook#printing-a-vector) | [printf](./io#printf) |
| Files | `save_into_file`, `load_from_file`, `fmt`, `pos` | [10](/manual/tutorial/10-io#saving-and-loading) | [binary](/manual/cookbook#a-binary-file-of-vectors), [text](/manual/cookbook#a-text-file-of-vectors), [stream](/manual/cookbook#the-n-th-vector-of-a-stream-file) | [Files](./io#save-into-file-and-load-from-file) |
| Record length | `iolen` | [10](/manual/tutorial/10-io#stream-files-and-positions) | [direct access](/manual/cookbook#a-direct-access-file-of-vectors) | [iolen](./io#iolen) |
| I/O errors | `iostat`, `iomsg` | [10](/manual/tutorial/10-io#errors) | [errors](/manual/cookbook#an-i-o-error-caught) | [Errors](./io#errors) |
| OpenACC device routines | `*_oac` | [11](/manual/tutorial/11-gpu) | [device](/manual/cookbook#the-device-callable-routines-in-an-openacc-loop) | [Device-callable API](./gpu) |

Not available: vectors of other dimensions than three; operations between vectors of two different kinds; `sum`,
`dot_product` or `matmul` of the intrinsics on vectors; a tolerance in the comparisons (see
[Behaviour and limitations](./limitations)).
