!< VecFor, Vector algebra class for Fortran poor people, R16P kind.

module vecfor_R16P
!< VecFor, Vector algebra class for Fortran poor people, R16P kind.

use, intrinsic :: iso_fortran_env, only : stdout=>output_unit
use penf, only : I1P, I2P, I4P, I8P, R4P, R8P, R16P, str
use penf, only : RPP=>R16P, smallRPP=>smallR16P, ZeroRPP=>ZeroR16P

#define vector_RPP vector_R16P
#define ex_RPP ex_R16P
#define ey_RPP ey_R16P
#define ez_RPP ez_R16P
#define RPP R16P

#define angle_RPP angle_R16P
#define distance_to_line_RPP distance_to_line_R16P
#define distance_to_plane_RPP distance_to_plane_R16P
#define distance_vectorial_to_plane_RPP distance_vectorial_to_plane_R16P
#define face_normal3_RPP face_normal3_R16P
#define face_normal4_RPP face_normal4_R16P
#define iolen_RPP iolen_R16P
#define is_collinear_RPP is_collinear_R16P
#define is_concyclic_RPP is_concyclic_R16P
#define mirror_matrix_RPP mirror_matrix_R16P
#define normalized_RPP normalized_R16P
#define normL2_RPP normL2_R16P
#define projection_onto_plane_RPP projection_onto_plane_R16P
#define rotation_matrix_RPP rotation_matrix_R16P
#define sq_norm_RPP sq_norm_R16P

#include "vecfor_RPP.INC"

endmodule vecfor_R16P
