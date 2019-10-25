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
                       distance_to_line,            &
                       distance_to_plane,           &
                       distance_vectorial_to_plane, &
                       ex,                          &
                       ey,                          &
                       ez,                          &
                       face_normal3,                &
                       face_normal4,                &
                       iolen,                       &
                       is_collinear,                &
                       is_concyclic,                &
                       mirror_matrix,               &
                       normalized,                  &
                       normL2,                      &
                       projection_onto_plane,       &
                       rotation_matrix,             &
                       sq_norm,                     &
                       vector
use vecfor_R4P, only : angle_R4P,                       &
                       distance_to_line_R4P,            &
                       distance_to_plane_R4P,           &
                       distance_vectorial_to_plane_R4P, &
                       ex_R4P,                          &
                       ey_R4P,                          &
                       ez_R4P,                          &
                       face_normal3_R4P,                &
                       face_normal4_R4P,                &
                       iolen_R4P,                       &
                       is_collinear_R4P,                &
                       is_concyclic_R4P,                &
                       mirror_matrix_R4P,               &
                       normalized_R4P,                  &
                       normL2_R4P,                      &
                       projection_onto_plane_R4P,       &
                       rotation_matrix_R4P,             &
                       sq_norm_R4P,                     &
                       vector_R4P
use vecfor_R8P, only : angle_R8P,                       &
                       distance_to_line_R8P,            &
                       distance_to_plane_R8P,           &
                       distance_vectorial_to_plane_R8P, &
                       ex_R8P,                          &
                       ey_R8P,                          &
                       ez_R8P,                          &
                       face_normal3_R8P,                &
                       face_normal4_R8P,                &
                       iolen_R8P,                       &
                       is_collinear_R8P,                &
                       is_concyclic_R8P,                &
                       mirror_matrix_R8P,               &
                       normalized_R8P,                  &
                       normL2_R8P,                      &
                       projection_onto_plane_R8P,       &
                       rotation_matrix_R8P,             &
                       sq_norm_R8P,                     &
                       vector_R8P
use vecfor_R16P, only : angle_R16P,                       &
                        distance_to_line_R16P,            &
                        distance_to_plane_R16P,           &
                        distance_vectorial_to_plane_R16P, &
                        ex_R16P,                          &
                        ey_R16P,                          &
                        ez_R16P,                          &
                        face_normal3_R16P,                &
                        face_normal4_R16P,                &
                        iolen_R16P,                       &
                        is_collinear_R16P,                &
                        is_concyclic_R16P,                &
                        mirror_matrix_R16P,               &
                        normalized_R16P,                  &
                        normL2_R16P,                      &
                        projection_onto_plane_R16P,       &
                        rotation_matrix_R16P,             &
                        sq_norm_R16P,                     &
                        vector_R16P

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
public :: ex_R4P, ey_R4P, ez_R4P, vector_R4P
public :: ex_R8P, ey_R8P, ez_R8P, vector_R8P
public :: ex_R16P, ey_R16P, ez_R16P, vector_R16P

interface angle
   module procedure angle, angle_R4P, angle_R8P, angle_R16P
endinterface angle

interface distance_to_line
   module procedure distance_to_line, distance_to_line_R4P, distance_to_line_R8P, distance_to_line_R16P
endinterface distance_to_line

interface distance_to_plane
   module procedure distance_to_plane, distance_to_plane_R4P, distance_to_plane_R8P, distance_to_plane_R16P
endinterface distance_to_plane

interface distance_vectorial_to_plane
   module procedure distance_vectorial_to_plane, distance_vectorial_to_plane_R4P, distance_vectorial_to_plane_R8P, &
                    distance_vectorial_to_plane_R16P
endinterface distance_vectorial_to_plane

interface face_normal3
   module procedure face_normal3, face_normal3_R4P, face_normal3_R8P, face_normal3_R16P
endinterface face_normal3

interface face_normal4
   module procedure face_normal4, face_normal4_R4P, face_normal4_R8P, face_normal4_R16P
endinterface face_normal4

interface iolen
   module procedure iolen, iolen_R4P, iolen_R8P, iolen_R16P
endinterface iolen

interface is_collinear
   module procedure is_collinear, is_collinear_R4P, is_collinear_R8P, is_collinear_R16P
endinterface is_collinear

interface is_concyclic
   module procedure is_concyclic, is_concyclic_R4P, is_concyclic_R8P, is_concyclic_R16P
endinterface is_concyclic

interface mirror_matrix
   module procedure mirror_matrix, mirror_matrix_R4P, mirror_matrix_R8P, mirror_matrix_R16P
endinterface mirror_matrix

interface normalized
   module procedure normalized, normalized_R4P, normalized_R8P, normalized_R16P
endinterface normalized

interface normL2
   module procedure normL2, normL2_R4P, normL2_R8P, normL2_R16P
endinterface normL2

interface projection_onto_plane
   module procedure projection_onto_plane, projection_onto_plane_R4P, projection_onto_plane_R8P, projection_onto_plane_R16P
endinterface projection_onto_plane

interface rotation_matrix
   module procedure rotation_matrix, rotation_matrix_R4P, rotation_matrix_R8P, rotation_matrix_R16P
endinterface rotation_matrix

interface sq_norm
   module procedure sq_norm, sq_norm_R4P, sq_norm_R8P, sq_norm_R16P
endinterface sq_norm
endmodule vecfor
