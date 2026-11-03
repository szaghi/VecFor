!< VecFor, Vector algebra class for Fortran poor people.

module vecfor
!< VecFor, Vector algebra class for Fortran poor people.
!<
!< This derived type is useful for manipulating vectors in 3D space. The components of the vectors are reals with
!< parametrized kind as defined by the library module. The components are defined in a three-dimensional cartesian frame of
!< reference.
!< All the vectorial math procedures (cross, dot products, parallel...) assume a three-dimensional cartesian frame of reference.
!< The operators of assignment (`=`), multiplication (`*`), division (`/`), sum (`+`) and subtraction (`-`) have been overloaded.
!< Furthermore the *dot* and *cross* products have been defined.
!< Therefore this module provides a far-complete algebra based on Vector derived type.

use vecfor_RPP, only : angle,                       &
                       angle_dev,                   &
                       assign_vector_dev,           &
                       crossproduct_accurate,       &
                       crossproduct_accurate_dev,   &
                       crossproduct_dev,            &
                       distance_to_line,            &
                       distance_to_line_dev,        &
                       distance_to_plane,           &
                       distance_to_plane_dev,       &
                       distance_vectorial_to_plane, &
                       distance_vectorial_to_plane_dev,&
                       dotproduct_accurate,         &
                       dotproduct_accurate_dev,     &
                       dotproduct_dev,              &
                       ex,                          &
                       ey,                          &
                       ez,                          &
                       face_normal3,                &
                       face_normal3_dev,            &
                       face_normal4,                &
                       face_normal4_dev,            &
                       iolen,                       &
                       is_collinear,                &
                       is_collinear_dev,            &
                       is_concyclic,                &
                       is_concyclic_dev,            &
                       matrixproduct_dev,           &
                       mirror_by_matrix_dev,        &
                       mirror_by_normal_dev,        &
                       mirror_matrix,               &
                       mirror_matrix_dev,           &
                       normalize_dev,               &
                       normalized,                  &
                       normalized_checked,          &
                       normalized_checked_dev,      &
                       normalized_dev,              &
                       normL2,                      &
                       normL2_dev,                  &
                       orthogonal_dev,              &
                       parallel_dev,                &
                       projection_onto_plane,       &
                       projection_onto_plane_dev,   &
                       R8P_mul_vector_dev,          &
                       rotate_by_axis_angle_dev,    &
                       rotate_by_matrix_dev,        &
                       rotation_matrix,             &
                       rotation_matrix_dev,         &
                       sq_norm,                     &
                       sq_norm_dev,                 &
                       vector,                      &
                       vector_mul_R8P_dev,          &
                       vector_sub_vector_dev,       &
                       vector_sum_vector_dev

use vecfor_R4P, only : angle_R4P,                       &
                       angle_R4P_dev,                   &
                       assign_vector_R4P_dev,           &
                       crossproduct_accurate_R4P,       &
                       crossproduct_accurate_R4P_dev,   &
                       crossproduct_R4P_dev,            &
                       distance_to_line_R4P,            &
                       distance_to_line_R4P_dev,        &
                       distance_to_plane_R4P,           &
                       distance_to_plane_R4P_dev,       &
                       distance_vectorial_to_plane_R4P, &
                       distance_vectorial_to_plane_R4P_dev,&
                       dotproduct_accurate_R4P,         &
                       dotproduct_accurate_R4P_dev,     &
                       dotproduct_R4P_dev,              &
                       ex_R4P,                          &
                       ey_R4P,                          &
                       ez_R4P,                          &
                       face_normal3_R4P,                &
                       face_normal3_R4P_dev,            &
                       face_normal4_R4P,                &
                       face_normal4_R4P_dev,            &
                       iolen_R4P,                       &
                       is_collinear_R4P,                &
                       is_collinear_R4P_dev,            &
                       is_concyclic_R4P,                &
                       is_concyclic_R4P_dev,            &
                       matrixproduct_R4P_dev,           &
                       mirror_by_matrix_R4P_dev,        &
                       mirror_by_normal_R4P_dev,        &
                       mirror_matrix_R4P,               &
                       mirror_matrix_R4P_dev,           &
                       normalize_R4P_dev,               &
                       normalized_checked_R4P,          &
                       normalized_checked_R4P_dev,      &
                       normalized_R4P,                  &
                       normalized_R4P_dev,              &
                       normL2_R4P,                      &
                       normL2_R4P_dev,                  &
                       orthogonal_R4P_dev,              &
                       parallel_R4P_dev,                &
                       projection_onto_plane_R4P,       &
                       projection_onto_plane_R4P_dev,   &
                       R8P_mul_vector_R4P_dev,          &
                       rotate_by_axis_angle_R4P_dev,    &
                       rotate_by_matrix_R4P_dev,        &
                       rotation_matrix_R4P,             &
                       rotation_matrix_R4P_dev,         &
                       sq_norm_R4P,                     &
                       sq_norm_R4P_dev,                 &
                       vector_R4P,                      &
                       vector_mul_R8P_R4P_dev,          &
                       vector_sub_vector_R4P_dev,       &
                       vector_sum_vector_R4P_dev

use vecfor_R8P, only : angle_R8P,                       &
                       angle_R8P_dev,                   &
                       assign_vector_R8P_dev,           &
                       crossproduct_accurate_R8P,       &
                       crossproduct_accurate_R8P_dev,   &
                       crossproduct_R8P_dev,            &
                       distance_to_line_R8P,            &
                       distance_to_line_R8P_dev,        &
                       distance_to_plane_R8P,           &
                       distance_to_plane_R8P_dev,       &
                       distance_vectorial_to_plane_R8P, &
                       distance_vectorial_to_plane_R8P_dev,&
                       dotproduct_accurate_R8P,         &
                       dotproduct_accurate_R8P_dev,     &
                       dotproduct_R8P_dev,              &
                       ex_R8P,                          &
                       ey_R8P,                          &
                       ez_R8P,                          &
                       face_normal3_R8P,                &
                       face_normal3_R8P_dev,            &
                       face_normal4_R8P,                &
                       face_normal4_R8P_dev,            &
                       iolen_R8P,                       &
                       is_collinear_R8P,                &
                       is_collinear_R8P_dev,            &
                       is_concyclic_R8P,                &
                       is_concyclic_R8P_dev,            &
                       matrixproduct_R8P_dev,           &
                       mirror_by_matrix_R8P_dev,        &
                       mirror_by_normal_R8P_dev,        &
                       mirror_matrix_R8P,               &
                       mirror_matrix_R8P_dev,           &
                       normalize_R8P_dev,               &
                       normalized_checked_R8P,          &
                       normalized_checked_R8P_dev,      &
                       normalized_R8P,                  &
                       normalized_R8P_dev,              &
                       normL2_R8P,                      &
                       normL2_R8P_dev,                  &
                       orthogonal_R8P_dev,              &
                       parallel_R8P_dev,                &
                       projection_onto_plane_R8P,       &
                       projection_onto_plane_R8P_dev,   &
                       R8P_mul_vector_R8P_dev,          &
                       rotate_by_axis_angle_R8P_dev,    &
                       rotate_by_matrix_R8P_dev,        &
                       rotation_matrix_R8P,             &
                       rotation_matrix_R8P_dev,         &
                       sq_norm_R8P,                     &
                       sq_norm_R8P_dev,                 &
                       vector_R8P,                      &
                       vector_mul_R8P_R8P_dev,          &
                       vector_sub_vector_R8P_dev,       &
                       vector_sum_vector_R8P_dev

use vecfor_R16P, only : angle_R16P,                       &
                        angle_R16P_dev,                   &
                        assign_vector_R16P_dev,           &
                        crossproduct_accurate_R16P,       &
                        crossproduct_accurate_R16P_dev,   &
                        crossproduct_R16P_dev,            &
                        distance_to_line_R16P,            &
                        distance_to_line_R16P_dev,        &
                        distance_to_plane_R16P,           &
                        distance_to_plane_R16P_dev,       &
                        distance_vectorial_to_plane_R16P, &
                        distance_vectorial_to_plane_R16P_dev,&
                        dotproduct_accurate_R16P,         &
                        dotproduct_accurate_R16P_dev,     &
                        dotproduct_R16P_dev,              &
                        ex_R16P,                          &
                        ey_R16P,                          &
                        ez_R16P,                          &
                        face_normal3_R16P,                &
                        face_normal3_R16P_dev,            &
                        face_normal4_R16P,                &
                        face_normal4_R16P_dev,            &
                        iolen_R16P,                       &
                        is_collinear_R16P,                &
                        is_collinear_R16P_dev,            &
                        is_concyclic_R16P,                &
                        is_concyclic_R16P_dev,            &
                        matrixproduct_R16P_dev,           &
                        mirror_by_matrix_R16P_dev,        &
                        mirror_by_normal_R16P_dev,        &
                        mirror_matrix_R16P,               &
                        mirror_matrix_R16P_dev,           &
                        normalize_R16P_dev,               &
                        normalized_checked_R16P,          &
                        normalized_checked_R16P_dev,      &
                        normalized_R16P,                  &
                        normalized_R16P_dev,              &
                        normL2_R16P,                      &
                        normL2_R16P_dev,                  &
                        orthogonal_R16P_dev,              &
                        parallel_R16P_dev,                &
                        projection_onto_plane_R16P,       &
                        projection_onto_plane_R16P_dev,   &
                        R8P_mul_vector_R16P_dev,          &
                        rotate_by_axis_angle_R16P_dev,    &
                        rotate_by_matrix_R16P_dev,        &
                        rotation_matrix_R16P,             &
                        rotation_matrix_R16P_dev,         &
                        sq_norm_R16P,                     &
                        sq_norm_R16P_dev,                 &
                        vector_R16P,                      &
                        vector_mul_R8P_R16P_dev,          &
                        vector_sub_vector_R16P_dev,       &
                        vector_sum_vector_R16P_dev

public :: angle
public :: crossproduct_accurate
public :: distance_to_line
public :: distance_to_plane
public :: distance_vectorial_to_plane
public :: dotproduct_accurate
public :: face_normal3
public :: face_normal4
public :: iolen
public :: is_collinear
public :: is_concyclic
public :: mirror_matrix
public :: normalized
public :: normalized_checked
public :: normL2
public :: projection_onto_plane
public :: rotation_matrix
public :: sq_norm
public :: ex, ey, ez, vector
public :: angle_dev
public :: assign_vector_dev
public :: crossproduct_accurate_dev
public :: crossproduct_dev
public :: distance_to_line_dev
public :: distance_to_plane_dev
public :: distance_vectorial_to_plane_dev
public :: dotproduct_accurate_dev
public :: dotproduct_dev
public :: face_normal3_dev
public :: face_normal4_dev
public :: is_collinear_dev
public :: is_concyclic_dev
public :: matrixproduct_dev
public :: mirror_by_matrix_dev
public :: mirror_by_normal_dev
public :: mirror_matrix_dev
public :: normalize_dev
public :: normalized_checked_dev
public :: normalized_dev
public :: normL2_dev
public :: orthogonal_dev
public :: parallel_dev
public :: projection_onto_plane_dev
public :: R8P_mul_vector_dev
public :: rotate_by_axis_angle_dev
public :: rotate_by_matrix_dev
public :: rotation_matrix_dev
public :: angle_R8P_dev
public :: crossproduct_accurate_R8P_dev
public :: distance_to_line_R8P_dev
public :: distance_to_plane_R8P_dev
public :: distance_vectorial_to_plane_R8P_dev
public :: dotproduct_accurate_R8P_dev
public :: face_normal3_R8P_dev
public :: face_normal4_R8P_dev
public :: is_collinear_R8P_dev
public :: is_concyclic_R8P_dev
public :: mirror_by_matrix_R8P_dev
public :: mirror_by_normal_R8P_dev
public :: normalize_R8P_dev
public :: normalized_checked_R8P_dev
public :: normalized_R8P_dev
public :: normL2_R8P_dev
public :: orthogonal_R8P_dev
public :: parallel_R8P_dev
public :: projection_onto_plane_R8P_dev
public :: rotate_by_axis_angle_R8P_dev
public :: rotate_by_matrix_R8P_dev
public :: sq_norm_R8P_dev
public :: vector_mul_R8P_dev
public :: sq_norm_dev
public :: vector_sub_vector_dev
public :: vector_sum_vector_dev

public :: angle_R4P
public :: crossproduct_accurate_R4P
public :: distance_to_line_R4P
public :: distance_to_plane_R4P
public :: distance_vectorial_to_plane_R4P
public :: dotproduct_accurate_R4P
public :: face_normal3_R4P
public :: face_normal4_R4P
public :: iolen_R4P
public :: is_collinear_R4P
public :: is_concyclic_R4P
public :: mirror_matrix_R4P
public :: normalized_checked_R4P
public :: normalized_R4P
public :: normL2_R4P
public :: projection_onto_plane_R4P
public :: rotation_matrix_R4P
public :: sq_norm_R4P
public :: ex_R4P, ey_R4P, ez_R4P, vector_R4P
public :: angle_R4P_dev
public :: assign_vector_R4P_dev
public :: crossproduct_accurate_R4P_dev
public :: crossproduct_R4P_dev
public :: distance_to_line_R4P_dev
public :: distance_to_plane_R4P_dev
public :: distance_vectorial_to_plane_R4P_dev
public :: dotproduct_accurate_R4P_dev
public :: dotproduct_R4P_dev
public :: face_normal3_R4P_dev
public :: face_normal4_R4P_dev
public :: is_collinear_R4P_dev
public :: is_concyclic_R4P_dev
public :: matrixproduct_R4P_dev
public :: mirror_by_matrix_R4P_dev
public :: mirror_by_normal_R4P_dev
public :: mirror_matrix_R4P_dev
public :: normalize_R4P_dev
public :: normalized_checked_R4P_dev
public :: normalized_R4P_dev
public :: normL2_R4P_dev
public :: orthogonal_R4P_dev
public :: parallel_R4P_dev
public :: projection_onto_plane_R4P_dev
public :: R8P_mul_vector_R4P_dev
public :: rotate_by_axis_angle_R4P_dev
public :: rotate_by_matrix_R4P_dev
public :: rotation_matrix_R4P_dev
public :: sq_norm_R4P_dev
public :: vector_mul_R8P_R4P_dev
public :: vector_sub_vector_R4P_dev
public :: vector_sum_vector_R4P_dev

public :: angle_R8P
public :: crossproduct_accurate_R8P
public :: distance_to_line_R8P
public :: distance_to_plane_R8P
public :: distance_vectorial_to_plane_R8P
public :: dotproduct_accurate_R8P
public :: face_normal3_R8P
public :: face_normal4_R8P
public :: iolen_R8P
public :: is_collinear_R8P
public :: is_concyclic_R8P
public :: mirror_matrix_R8P
public :: normalized_checked_R8P
public :: normalized_R8P
public :: normL2_R8P
public :: projection_onto_plane_R8P
public :: rotation_matrix_R8P
public :: sq_norm_R8P
public :: ex_R8P, ey_R8P, ez_R8P, vector_R8P
public :: assign_vector_R8P_dev
public :: crossproduct_R8P_dev
public :: dotproduct_R8P_dev
public :: matrixproduct_R8P_dev
public :: mirror_matrix_R8P_dev
public :: R8P_mul_vector_R8P_dev
public :: rotation_matrix_R8P_dev
public :: vector_mul_R8P_R8P_dev
public :: vector_sub_vector_R8P_dev
public :: vector_sum_vector_R8P_dev

public :: angle_R16P
public :: crossproduct_accurate_R16P
public :: distance_to_line_R16P
public :: distance_to_plane_R16P
public :: distance_vectorial_to_plane_R16P
public :: dotproduct_accurate_R16P
public :: face_normal3_R16P
public :: face_normal4_R16P
public :: iolen_R16P
public :: is_collinear_R16P
public :: is_concyclic_R16P
public :: mirror_matrix_R16P
public :: normalized_checked_R16P
public :: normalized_R16P
public :: normL2_R16P
public :: projection_onto_plane_R16P
public :: rotation_matrix_R16P
public :: sq_norm_R16P
public :: ex_R16P, ey_R16P, ez_R16P, vector_R16P
public :: angle_R16P_dev
public :: assign_vector_R16P_dev
public :: crossproduct_accurate_R16P_dev
public :: crossproduct_R16P_dev
public :: distance_to_line_R16P_dev
public :: distance_to_plane_R16P_dev
public :: distance_vectorial_to_plane_R16P_dev
public :: dotproduct_accurate_R16P_dev
public :: dotproduct_R16P_dev
public :: face_normal3_R16P_dev
public :: face_normal4_R16P_dev
public :: is_collinear_R16P_dev
public :: is_concyclic_R16P_dev
public :: matrixproduct_R16P_dev
public :: mirror_by_matrix_R16P_dev
public :: mirror_by_normal_R16P_dev
public :: mirror_matrix_R16P_dev
public :: normalize_R16P_dev
public :: normalized_checked_R16P_dev
public :: normalized_R16P_dev
public :: normL2_R16P_dev
public :: orthogonal_R16P_dev
public :: parallel_R16P_dev
public :: projection_onto_plane_R16P_dev
public :: R8P_mul_vector_R16P_dev
public :: rotate_by_axis_angle_R16P_dev
public :: rotate_by_matrix_R16P_dev
public :: rotation_matrix_R16P_dev
public :: sq_norm_R16P_dev
public :: vector_mul_R8P_R16P_dev
public :: vector_sub_vector_R16P_dev
public :: vector_sum_vector_R16P_dev

endmodule vecfor
