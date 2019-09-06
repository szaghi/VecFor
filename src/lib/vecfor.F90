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

use vecfor_R4P, only : angle_R4P                       => angle,                       &
                       distance_to_line_R4P            => distance_to_line,            &
                       distance_to_plane_R4P           => distance_to_plane,           &
                       distance_vectorial_to_plane_R4P => distance_vectorial_to_plane, &
                       ex_R4P                          => ex,                          &
                       ey_R4P                          => ey,                          &
                       ez_R4P                          => ez,                          &
                       face_normal3_R4P                => face_normal3,                &
                       face_normal4_R4P                => face_normal4,                &
                       iolen_R4P                       => iolen,                       &
                       is_collinear_R4P                => is_collinear,                &
                       is_concyclic_R4P                => is_concyclic,                &
                       mirror_matrix_R4P               => mirror_matrix,               &
                       normalized_R4P                  => normalized,                  &
                       normL2_R4P                      => normL2,                      &
                       projection_onto_plane_R4P       => projection_onto_plane,       &
                       rotation_matrix_R4P             => rotation_matrix,             &
                       RPP_R4P                         => RPP,                         &
                       smallRPP_R4P                    => smallRPP,                    &
                       ZeroRPP_R4P                     => ZeroRPP,                     &
                       sq_norm_R4P                     => sq_norm,                     &
                       vector_R4P                      => vector

use vecfor_R8P, only : angle_R8P                       => angle,                       &
                       distance_to_line_R8P            => distance_to_line,            &
                       distance_to_plane_R8P           => distance_to_plane,           &
                       distance_vectorial_to_plane_R8P => distance_vectorial_to_plane, &
                       ex_R8P                          => ex,                          &
                       ey_R8P                          => ey,                          &
                       ez_R8P                          => ez,                          &
                       face_normal3_R8P                => face_normal3,                &
                       face_normal4_R8P                => face_normal4,                &
                       iolen_R8P                       => iolen,                       &
                       is_collinear_R8P                => is_collinear,                &
                       is_concyclic_R8P                => is_concyclic,                &
                       mirror_matrix_R8P               => mirror_matrix,               &
                       normalized_R8P                  => normalized,                  &
                       normL2_R8P                      => normL2,                      &
                       projection_onto_plane_R8P       => projection_onto_plane,       &
                       rotation_matrix_R8P             => rotation_matrix,             &
                       RPP_R8P                         => RPP,                         &
                       smallRPP_R8P                    => smallRPP,                    &
                       ZeroRPP_R8P                     => ZeroRPP,                     &
                       sq_norm_R8P                     => sq_norm,                     &
                       vector_R8P                      => vector

use vecfor_R16P, only : angle_R16P                       => angle,                       &
                        distance_to_line_R16P            => distance_to_line,            &
                        distance_to_plane_R16P           => distance_to_plane,           &
                        distance_vectorial_to_plane_R16P => distance_vectorial_to_plane, &
                        ex_R16P                          => ex,                          &
                        ey_R16P                          => ey,                          &
                        ez_R16P                          => ez,                          &
                        face_normal3_R16P                => face_normal3,                &
                        face_normal4_R16P                => face_normal4,                &
                        iolen_R16P                       => iolen,                       &
                        is_collinear_R16P                => is_collinear,                &
                        is_concyclic_R16P                => is_concyclic,                &
                        mirror_matrix_R16P               => mirror_matrix,               &
                        normalized_R16P                  => normalized,                  &
                        normL2_R16P                      => normL2,                      &
                        projection_onto_plane_R16P       => projection_onto_plane,       &
                        rotation_matrix_R16P             => rotation_matrix,             &
                        RPP_R16P                         => RPP,                         &
                        smallRPP_R16P                    => smallRPP,                    &
                        ZeroRPP_R16P                     => ZeroRPP,                     &
                        sq_norm_R16P                     => sq_norm,                     &
                        vector_R16P                      => vector

use penf, only : DR8P, FR8P, I1P, I2P, I4P, I8P, R_P, R4P, R8P, R16P, smallR_P, str, ZeroR_P

! R4P kind
public :: angle_R4P
public :: distance_to_line_R4P
public :: distance_to_plane_R4P
public :: distance_vectorial_to_plane_R4P
public :: ex_R4P
public :: ey_R4P
public :: ez_R4P
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
public :: RPP_R4P
public :: smallRPP_R4P
public :: ZeroRPP_R4P
public :: sq_norm_R4P
public :: vector_R4P
! R8P kind
public :: angle_R8P
public :: distance_to_line_R8P
public :: distance_to_plane_R8P
public :: distance_vectorial_to_plane_R8P
public :: ex_R8P
public :: ey_R8P
public :: ez_R8P
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
public :: RPP_R8P
public :: smallRPP_R8P
public :: ZeroRPP_R8P
public :: sq_norm_R8P
public :: vector_R8P
! R16P kind
public :: angle_R16P
public :: distance_to_line_R16P
public :: distance_to_plane_R16P
public :: distance_vectorial_to_plane_R16P
public :: ex_R16P
public :: ey_R16P
public :: ez_R16P
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
public :: RPP_R16P
public :: smallRPP_R16P
public :: ZeroRPP_R16P
public :: sq_norm_R16P
public :: vector_R16P

! PENF object
public :: DR8P, FR8P, I1P, I2P, I4P, I8P, R_P, R4P, R8P, R16P, smallR_P, str, ZeroR_P
endmodule vecfor
