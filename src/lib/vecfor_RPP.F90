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
#define normalized_RPP normalized
#define normL2_RPP normL2
#define projection_onto_plane_RPP projection_onto_plane
#define rotation_matrix_RPP rotation_matrix
#define sq_norm_RPP sq_norm

#include "vecfor_RPP.INC"

endmodule vecfor_RPP
