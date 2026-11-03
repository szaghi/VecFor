!< VecFor, Vector algebra class for Fortran poor people, default kind.

module vecfor_RPP
!< VecFor, Vector algebra class for Fortran poor people, default kind.
!< If not defined otherwise, the default kind is R8P.

use, intrinsic :: iso_fortran_env, only : stdout=>output_unit
use penf, only : I1P, I2P, I4P, I8P, R4P, R8P, R16P, str
#if   defined DEFKIND_R4P
use penf, only : RPP=>R4P, smallRPP=>smallR4P, ZeroRPP=>ZeroR4P
#define RPP R4P
#elif defined DEFKIND_R8P
use penf, only : RPP=>R8P, smallRPP=>smallR8P, ZeroRPP=>ZeroR8P
#define RPP R8P
#elif defined DEFKIND_R16P
use penf, only : RPP=>R16P, smallRPP=>smallR16P, ZeroRPP=>ZeroR16P
#define RPP R16P
#else
use penf, only : RPP=>R8P, smallRPP=>smallR8P, ZeroRPP=>ZeroR8P
#define RPP R8P
#endif

#define vector_RPP vector
#define barycentric_tetrahedron_RPP barycentric_tetrahedron
#define barycentric_triangle_RPP barycentric_triangle
#define closest_point_triangle_RPP closest_point_triangle
#define crossproduct_accurate_RPP crossproduct_accurate
#define dotproduct_accurate_RPP dotproduct_accurate
#define ex_RPP ex
#define ey_RPP ey
#define ez_RPP ez

#define angle_RPP angle
#define distance_to_line_RPP distance_to_line
#define distance_to_plane_RPP distance_to_plane
#define distance_vectorial_to_plane_RPP distance_vectorial_to_plane
#define face_normal3_RPP face_normal3
#define face_normal4_RPP face_normal4
#define iolen_RPP iolen
#define is_collinear_RPP is_collinear
#define is_concyclic_RPP is_concyclic
#define mirror_matrix_RPP mirror_matrix
#define normalized_checked_RPP normalized_checked
#define normalized_RPP normalized
#define normL2_RPP normL2
#define polygon_vector_area_RPP polygon_vector_area
#define projection_onto_plane_RPP projection_onto_plane
#define rotation_matrix_RPP rotation_matrix
#define sq_norm_RPP sq_norm
#define tetrahedron_volume_RPP tetrahedron_volume
#define triangle_area_RPP triangle_area

#define angle_RPP_dev angle_dev
#define assign_vector_RPP_dev assign_vector_dev
#define barycentric_tetrahedron_RPP_dev barycentric_tetrahedron_dev
#define barycentric_triangle_RPP_dev barycentric_triangle_dev
#define closest_point_triangle_RPP_dev closest_point_triangle_dev
#define crossproduct_accurate_RPP_dev crossproduct_accurate_dev
#define crossproduct_RPP_dev crossproduct_dev
#define distance_to_line_RPP_dev distance_to_line_dev
#define distance_to_plane_RPP_dev distance_to_plane_dev
#define distance_vectorial_to_plane_RPP_dev distance_vectorial_to_plane_dev
#define dotproduct_accurate_RPP_dev dotproduct_accurate_dev
#define dotproduct_RPP_dev dotproduct_dev
#define face_normal3_RPP_dev face_normal3_dev
#define face_normal4_RPP_dev face_normal4_dev
#define is_collinear_RPP_dev is_collinear_dev
#define is_concyclic_RPP_dev is_concyclic_dev
#define matrixproduct_RPP_dev matrixproduct_dev
#define mirror_by_matrix_RPP_dev mirror_by_matrix_dev
#define mirror_by_normal_RPP_dev mirror_by_normal_dev
#define mirror_matrix_RPP_dev mirror_matrix_dev
#define normalize_RPP_dev normalize_dev
#define normalized_checked_RPP_dev normalized_checked_dev
#define normalized_RPP_dev normalized_dev
#define normL2_RPP_dev normL2_dev
#define orthogonal_RPP_dev orthogonal_dev
#define parallel_RPP_dev parallel_dev
#define polygon_vector_area_RPP_dev polygon_vector_area_dev
#define projection_onto_plane_RPP_dev projection_onto_plane_dev
#define R8P_mul_vector_RPP_dev R8P_mul_vector_dev
#define rotate_by_axis_angle_RPP_dev rotate_by_axis_angle_dev
#define rotate_by_matrix_RPP_dev rotate_by_matrix_dev
#define rotation_matrix_RPP_dev rotation_matrix_dev
#define sq_norm_RPP_dev sq_norm_dev
#define tetrahedron_volume_RPP_dev tetrahedron_volume_dev
#define triangle_area_RPP_dev triangle_area_dev
#define vector_mul_R8P_RPP_dev vector_mul_R8P_dev
#define vector_sub_vector_RPP_dev vector_sub_vector_dev
#define vector_sum_vector_RPP_dev vector_sum_vector_dev

#include "vecfor_RPP.INC"

endmodule vecfor_RPP
