!< VecFor, Vector algebra class for Fortran poor people, R8P kind.

module vecfor_R8P
!< VecFor, Vector algebra class for Fortran poor people, R8P kind.

use, intrinsic :: iso_fortran_env, only : stdout=>output_unit
use penf, only : I1P, I2P, I4P, I8P, R4P, R8P, R16P, str
use penf, only : RPP=>R8P, smallRPP=>smallR8P, ZeroRPP=>ZeroR8P

#define vector_RPP vector_R8P
#define ex_RPP ex_R8P
#define ey_RPP ey_R8P
#define ez_RPP ez_R8P
#define RPP R8P

#define angle_RPP angle_R8P
#define distance_to_line_RPP distance_to_line_R8P
#define distance_to_plane_RPP distance_to_plane_R8P
#define distance_vectorial_to_plane_RPP distance_vectorial_to_plane_R8P
#define face_normal3_RPP face_normal3_R8P
#define face_normal4_RPP face_normal4_R8P
#define iolen_RPP iolen_R8P
#define is_collinear_RPP is_collinear_R8P
#define is_concyclic_RPP is_concyclic_R8P
#define mirror_matrix_RPP mirror_matrix_R8P
#define normalized_RPP normalized_R8P
#define normL2_RPP normL2_R8P
#define projection_onto_plane_RPP projection_onto_plane_R8P
#define rotation_matrix_RPP rotation_matrix_R8P
#define sq_norm_RPP sq_norm_R8P

#include "vecfor_RPP.INC"

endmodule vecfor_R8P
