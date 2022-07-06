!< VecFor, Vector algebra class for Fortran poor people, R4P kind.

module vecfor_R4P
!< VecFor, Vector algebra class for Fortran poor people, R4P kind.

use, intrinsic :: iso_fortran_env, only : stdout=>output_unit
use penf, only : I1P, I2P, I4P, I8P, R4P, R8P, R16P, str
use penf, only : RPP=>R4P, smallRPP=>smallR4P, ZeroRPP=>ZeroR4P

#define vector_RPP vector_R4P
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
#define normalized_RPP normalized_R4P
#define normL2_RPP normL2_R4P
#define projection_onto_plane_RPP projection_onto_plane_R4P
#define rotation_matrix_RPP rotation_matrix_R4P
#define sq_norm_RPP sq_norm_R4P

#include "vecfor_RPP.INC"

endmodule vecfor_R4P
