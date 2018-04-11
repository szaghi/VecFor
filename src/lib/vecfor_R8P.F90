!< VecFor, Vector algebra class for Fortran poor people, R8P kind.

module vecfor_R8P
!< VecFor, Vector algebra class for Fortran poor people, R8P kind.

use, intrinsic :: iso_fortran_env, only : stdout=>output_unit
use penf, only : DR8P, FR8P, I1P, I2P, I4P, I8P, R_P, R4P, R8P, R16P, smallR_P, str, ZeroR_P
use penf, only : RPP=>R8P, smallRPP=>smallR8P, ZeroRPP=>ZeroR8P

#include "vecfor_RPP.INC"

endmodule vecfor_R8P
