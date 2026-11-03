!< VecFor, Vector algebra class for Fortran poor people, R4P kind.

module vecfor_R4P
!< VecFor, Vector algebra class for Fortran poor people, R4P kind.

use, intrinsic :: iso_fortran_env, only : stdout=>output_unit
use penf, only : I1P, I2P, I4P, I8P, R4P, R8P, R16P, str
use penf, only : RPP=>R4P, smallRPP=>smallR4P, ZeroRPP=>ZeroR4P

#define vector_RPP vector_R4P
#define crossproduct_accurate_RPP crossproduct_accurate_R4P
#define dotproduct_accurate_RPP dotproduct_accurate_R4P
#define ex_RPP ex_R4P
#define ey_RPP ey_R4P
#define ez_RPP ez_R4P
#define RPP R4P

#define angle_RPP angle_R4P
#define distance_to_line_RPP distance_to_line_R4P
#define distance_to_plane_RPP distance_to_plane_R4P
#define distance_vectorial_to_plane_RPP distance_vectorial_to_plane_R4P
#define face_normal3_RPP face_normal3_R4P
#define face_normal4_RPP face_normal4_R4P
#define iolen_RPP iolen_R4P
#define is_collinear_RPP is_collinear_R4P
#define is_concyclic_RPP is_concyclic_R4P
#define mirror_matrix_RPP mirror_matrix_R4P
#define normalized_checked_RPP normalized_checked_R4P
#define normalized_RPP normalized_R4P
#define normL2_RPP normL2_R4P
#define projection_onto_plane_RPP projection_onto_plane_R4P
#define rotation_matrix_RPP rotation_matrix_R4P
#define sq_norm_RPP sq_norm_R4P

#define angle_RPP_dev angle_R4P_dev
#define assign_vector_RPP_dev assign_vector_R4P_dev
#define crossproduct_accurate_RPP_dev crossproduct_accurate_R4P_dev
#define crossproduct_RPP_dev crossproduct_R4P_dev
#define distance_to_line_RPP_dev distance_to_line_R4P_dev
#define distance_to_plane_RPP_dev distance_to_plane_R4P_dev
#define distance_vectorial_to_plane_RPP_dev distance_vectorial_to_plane_R4P_dev
#define dotproduct_accurate_RPP_dev dotproduct_accurate_R4P_dev
#define dotproduct_RPP_dev dotproduct_R4P_dev
#define face_normal3_RPP_dev face_normal3_R4P_dev
#define face_normal4_RPP_dev face_normal4_R4P_dev
#define is_collinear_RPP_dev is_collinear_R4P_dev
#define is_concyclic_RPP_dev is_concyclic_R4P_dev
#define matrixproduct_RPP_dev matrixproduct_R4P_dev
#define mirror_by_matrix_RPP_dev mirror_by_matrix_R4P_dev
#define mirror_by_normal_RPP_dev mirror_by_normal_R4P_dev
#define mirror_matrix_RPP_dev mirror_matrix_R4P_dev
#define normalize_RPP_dev normalize_R4P_dev
#define normalized_checked_RPP_dev normalized_checked_R4P_dev
#define normalized_RPP_dev normalized_R4P_dev
#define normL2_RPP_dev normL2_R4P_dev
#define orthogonal_RPP_dev orthogonal_R4P_dev
#define parallel_RPP_dev parallel_R4P_dev
#define projection_onto_plane_RPP_dev projection_onto_plane_R4P_dev
#define R8P_mul_vector_RPP_dev R8P_mul_vector_R4P_dev
#define rotate_by_axis_angle_RPP_dev rotate_by_axis_angle_R4P_dev
#define rotate_by_matrix_RPP_dev rotate_by_matrix_R4P_dev
#define rotation_matrix_RPP_dev rotation_matrix_R4P_dev
#define sq_norm_RPP_dev sq_norm_R4P_dev
#define vector_mul_R8P_RPP_dev vector_mul_R8P_R4P_dev
#define vector_sub_vector_RPP_dev vector_sub_vector_R4P_dev
#define vector_sum_vector_RPP_dev vector_sum_vector_R4P_dev

#include "vecfor_RPP.INC"

endmodule vecfor_R4P
