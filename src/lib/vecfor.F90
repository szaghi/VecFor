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
                       assign_vector_oac,           &
                       crossproduct_oac,            &
                       distance_to_line,            &
                       distance_to_line_oac,        &
                       distance_to_plane,           &
                       distance_to_plane_oac,       &
                       distance_vectorial_to_plane, &
                       distance_vectorial_to_plane_oac,&
                       dotproduct_oac,              &
                       ex,                          &
                       ey,                          &
                       ez,                          &
                       face_normal3,                &
                       face_normal3_oac,            &
                       face_normal4,                &
                       face_normal4_oac,            &
                       iolen,                       &
                       is_collinear,                &
                       is_concyclic,                &
                       matrixproduct_oac,           &
                       mirror_matrix,               &
                       mirror_matrix_oac,           &
                       normalize_oac,               &
                       normalized,                  &
                       normalized_oac,              &
                       normL2,                      &
                       normL2_oac,                  &
                       orthogonal_oac,              &
                       parallel_oac,                &
                       projection_onto_plane,       &
                       projection_onto_plane_oac,   &
                       R8P_mul_vector_oac,          &
                       rotation_matrix,             &
                       rotation_matrix_oac,         &
                       sq_norm,                     &
                       sq_norm_oac,                 &
                       vector,                      &
                       vector_mul_R8P_oac,          &
                       vector_sub_vector_oac,       &
                       vector_sum_vector_oac

use vecfor_R4P, only : angle_R4P,                       &
                       assign_vector_R4P_oac,           &
                       crossproduct_R4P_oac,            &
                       distance_to_line_R4P,            &
                       distance_to_line_R4P_oac,        &
                       distance_to_plane_R4P,           &
                       distance_to_plane_R4P_oac,       &
                       distance_vectorial_to_plane_R4P, &
                       distance_vectorial_to_plane_R4P_oac,&
                       dotproduct_R4P_oac,              &
                       ex_R4P,                          &
                       ey_R4P,                          &
                       ez_R4P,                          &
                       face_normal3_R4P,                &
                       face_normal3_R4P_oac,            &
                       face_normal4_R4P,                &
                       face_normal4_R4P_oac,            &
                       iolen_R4P,                       &
                       is_collinear_R4P,                &
                       is_concyclic_R4P,                &
                       matrixproduct_R4P_oac,           &
                       mirror_matrix_R4P,               &
                       mirror_matrix_R4P_oac,           &
                       normalize_R4P_oac,               &
                       normalized_R4P,                  &
                       normalized_R4P_oac,              &
                       normL2_R4P,                      &
                       normL2_R4P_oac,                  &
                       orthogonal_R4P_oac,              &
                       parallel_R4P_oac,                &
                       projection_onto_plane_R4P,       &
                       projection_onto_plane_R4P_oac,   &
                       R8P_mul_vector_R4P_oac,          &
                       rotation_matrix_R4P,             &
                       rotation_matrix_R4P_oac,         &
                       sq_norm_R4P,                     &
                       sq_norm_R4P_oac,                 &
                       vector_R4P,                      &
                       vector_mul_R8P_R4P_oac,          &
                       vector_sub_vector_R4P_oac,       &
                       vector_sum_vector_R4P_oac

use vecfor_R8P, only : angle_R8P,                       &
                       assign_vector_R8P_oac,           &
                       crossproduct_R8P_oac,            &
                       distance_to_line_R8P,            &
                       distance_to_line_R8P_oac,        &
                       distance_to_plane_R8P,           &
                       distance_to_plane_R8P_oac,       &
                       distance_vectorial_to_plane_R8P, &
                       distance_vectorial_to_plane_R8P_oac,&
                       dotproduct_R8P_oac,              &
                       ex_R8P,                          &
                       ey_R8P,                          &
                       ez_R8P,                          &
                       face_normal3_R8P,                &
                       face_normal3_R8P_oac,            &
                       face_normal4_R8P,                &
                       face_normal4_R8P_oac,            &
                       iolen_R8P,                       &
                       is_collinear_R8P,                &
                       is_concyclic_R8P,                &
                       matrixproduct_R8P_oac,           &
                       mirror_matrix_R8P,               &
                       mirror_matrix_R8P_oac,           &
                       normalize_R8P_oac,               &
                       normalized_R8P,                  &
                       normalized_R8P_oac,              &
                       normL2_R8P,                      &
                       normL2_R8P_oac,                  &
                       orthogonal_R8P_oac,              &
                       parallel_R8P_oac,                &
                       projection_onto_plane_R8P,       &
                       projection_onto_plane_R8P_oac,   &
                       R8P_mul_vector_R8P_oac,          &
                       rotation_matrix_R8P,             &
                       rotation_matrix_R8P_oac,         &
                       sq_norm_R8P,                     &
                       sq_norm_R8P_oac,                 &
                       vector_R8P,                      &
                       vector_mul_R8P_R8P_oac,          &
                       vector_sub_vector_R8P_oac,       &
                       vector_sum_vector_R8P_oac

use vecfor_R16P, only : angle_R16P,                       &
                        assign_vector_R16P_oac,           &
                        crossproduct_R16P_oac,            &
                        distance_to_line_R16P,            &
                        distance_to_line_R16P_oac,        &
                        distance_to_plane_R16P,           &
                        distance_to_plane_R16P_oac,       &
                        distance_vectorial_to_plane_R16P, &
                        distance_vectorial_to_plane_R16P_oac,&
                        dotproduct_R16P_oac,              &
                        ex_R16P,                          &
                        ey_R16P,                          &
                        ez_R16P,                          &
                        face_normal3_R16P,                &
                        face_normal3_R16P_oac,            &
                        face_normal4_R16P,                &
                        face_normal4_R16P_oac,            &
                        iolen_R16P,                       &
                        is_collinear_R16P,                &
                        is_concyclic_R16P,                &
                        matrixproduct_R16P_oac,           &
                        mirror_matrix_R16P,               &
                        mirror_matrix_R16P_oac,           &
                        normalize_R16P_oac,               &
                        normalized_R16P,                  &
                        normalized_R16P_oac,              &
                        normL2_R16P,                      &
                        normL2_R16P_oac,                  &
                        orthogonal_R16P_oac,              &
                        parallel_R16P_oac,                &
                        projection_onto_plane_R16P,       &
                        projection_onto_plane_R16P_oac,   &
                        R8P_mul_vector_R16P_oac,          &
                        rotation_matrix_R16P,             &
                        rotation_matrix_R16P_oac,         &
                        sq_norm_R16P,                     &
                        sq_norm_R16P_oac,                 &
                        vector_R16P,                      &
                        vector_mul_R8P_R16P_oac,          &
                        vector_sub_vector_R16P_oac,       &
                        vector_sum_vector_R16P_oac

public :: angle
public :: distance_to_line
public :: distance_to_plane
public :: distance_vectorial_to_plane
public :: face_normal3
public :: face_normal4
public :: iolen
public :: is_collinear
public :: is_concyclic
public :: mirror_matrix
public :: normalized
public :: normL2
public :: projection_onto_plane
public :: rotation_matrix
public :: sq_norm
public :: ex, ey, ez, vector
public :: assign_vector_oac
public :: crossproduct_oac
public :: distance_to_line_oac
public :: distance_to_plane_oac
public :: distance_vectorial_to_plane_oac
public :: dotproduct_oac
public :: face_normal3_oac
public :: face_normal4_oac
public :: matrixproduct_oac
public :: mirror_matrix_oac
public :: normalize_oac
public :: normalized_oac
public :: normL2_oac
public :: orthogonal_oac
public :: parallel_oac
public :: projection_onto_plane_oac
public :: R8P_mul_vector_oac
public :: rotation_matrix_oac
public :: distance_to_line_R8P_oac
public :: distance_to_plane_R8P_oac
public :: distance_vectorial_to_plane_R8P_oac
public :: face_normal3_R8P_oac
public :: face_normal4_R8P_oac
public :: normalize_R8P_oac
public :: normalized_R8P_oac
public :: normL2_R8P_oac
public :: orthogonal_R8P_oac
public :: parallel_R8P_oac
public :: projection_onto_plane_R8P_oac
public :: sq_norm_R8P_oac
public :: vector_mul_R8P_oac
public :: sq_norm_oac
public :: vector_sub_vector_oac
public :: vector_sum_vector_oac

public :: angle_R4P
public :: distance_to_line_R4P
public :: distance_to_plane_R4P
public :: distance_vectorial_to_plane_R4P
public :: face_normal3_R4P
public :: face_normal4_R4P
public :: iolen_R4P
public :: is_collinear_R4P
public :: is_concyclic_R4P
public :: mirror_matrix_R4P
public :: normalized_R4P
public :: normL2_R4P
public :: projection_onto_plane_R4P
public :: rotation_matrix_R4P
public :: sq_norm_R4P
public :: ex_R4P, ey_R4P, ez_R4P, vector_R4P
public :: assign_vector_R4P_oac
public :: crossproduct_R4P_oac
public :: distance_to_line_R4P_oac
public :: distance_to_plane_R4P_oac
public :: distance_vectorial_to_plane_R4P_oac
public :: dotproduct_R4P_oac
public :: face_normal3_R4P_oac
public :: face_normal4_R4P_oac
public :: matrixproduct_R4P_oac
public :: mirror_matrix_R4P_oac
public :: normalize_R4P_oac
public :: normalized_R4P_oac
public :: normL2_R4P_oac
public :: orthogonal_R4P_oac
public :: parallel_R4P_oac
public :: projection_onto_plane_R4P_oac
public :: R8P_mul_vector_R4P_oac
public :: rotation_matrix_R4P_oac
public :: sq_norm_R4P_oac
public :: vector_mul_R8P_R4P_oac
public :: vector_sub_vector_R4P_oac
public :: vector_sum_vector_R4P_oac

public :: angle_R8P
public :: distance_to_line_R8P
public :: distance_to_plane_R8P
public :: distance_vectorial_to_plane_R8P
public :: face_normal3_R8P
public :: face_normal4_R8P
public :: iolen_R8P
public :: is_collinear_R8P
public :: is_concyclic_R8P
public :: mirror_matrix_R8P
public :: normalized_R8P
public :: normL2_R8P
public :: projection_onto_plane_R8P
public :: rotation_matrix_R8P
public :: sq_norm_R8P
public :: ex_R8P, ey_R8P, ez_R8P, vector_R8P
public :: assign_vector_R8P_oac
public :: crossproduct_R8P_oac
public :: dotproduct_R8P_oac
public :: matrixproduct_R8P_oac
public :: mirror_matrix_R8P_oac
public :: R8P_mul_vector_R8P_oac
public :: rotation_matrix_R8P_oac
public :: vector_mul_R8P_R8P_oac
public :: vector_sub_vector_R8P_oac
public :: vector_sum_vector_R8P_oac

public :: angle_R16P
public :: distance_to_line_R16P
public :: distance_to_plane_R16P
public :: distance_vectorial_to_plane_R16P
public :: face_normal3_R16P
public :: face_normal4_R16P
public :: iolen_R16P
public :: is_collinear_R16P
public :: is_concyclic_R16P
public :: mirror_matrix_R16P
public :: normalized_R16P
public :: normL2_R16P
public :: projection_onto_plane_R16P
public :: rotation_matrix_R16P
public :: sq_norm_R16P
public :: ex_R16P, ey_R16P, ez_R16P, vector_R16P
public :: assign_vector_R16P_oac
public :: crossproduct_R16P_oac
public :: distance_to_line_R16P_oac
public :: distance_to_plane_R16P_oac
public :: distance_vectorial_to_plane_R16P_oac
public :: dotproduct_R16P_oac
public :: face_normal3_R16P_oac
public :: face_normal4_R16P_oac
public :: matrixproduct_R16P_oac
public :: mirror_matrix_R16P_oac
public :: normalize_R16P_oac
public :: normalized_R16P_oac
public :: normL2_R16P_oac
public :: orthogonal_R16P_oac
public :: parallel_R16P_oac
public :: projection_onto_plane_R16P_oac
public :: R8P_mul_vector_R16P_oac
public :: rotation_matrix_R16P_oac
public :: sq_norm_R16P_oac
public :: vector_mul_R8P_R16P_oac
public :: vector_sub_vector_R16P_oac
public :: vector_sum_vector_R16P_oac

endmodule vecfor
