!< VecFor, Vector algebra class for Fortran poor people

module vecfor
!< VecFor, Vector algebra class for Fortran poor people
!<
!< This derived type is useful for manipulating vectors in 3D space. The components of the vectors are reals with
!< parametrized kind as defined by the library module. The components are defined in a three-dimensional cartesian frame of
!< reference.
!< All the vectorial math procedures (cross, dot products, parallel...) assume a three-dimensional cartesian frame of reference.
!< The operators of assignment (`=`), multiplication (`*`), division (`/`), sum (`+`) and subtraction (`-`) have been overloaded.
!< Furthermore the *dot* and *cross* products have been defined.
!< Therefore this module provides a far-complete algebra based on Vector derived type.
use, intrinsic :: iso_fortran_env, only : stdout=>output_unit
use penf, only : DR8P, FR8P, I1P, I2P, I4P, I8P, R_P, R4P, R8P, R16P, smallR_P, str, Zero

implicit none
private
public :: distance_to_line
public :: distance_to_plane
public :: distance_vectorial_to_plane
public :: ex, ey, ez
public :: face_normal3, face_normal4
public :: iolen
public :: is_collinear
public :: is_concyclic
public :: normalized
public :: normL2
public :: projection_onto_plane
public :: sq_norm
public :: vector

type :: vector
  !< Vector class.
  real(R_P) :: x = 0._R_P !< Cartesian component in x direction.
  real(R_P) :: y = 0._R_P !< Cartesian component in y direction.
  real(R_P) :: z = 0._R_P !< Cartesian component in z direction.
  contains
     ! public new operators
     generic :: operator(.cross.) => crossproduct !< Compute the cross product.
     generic :: operator(.dot.)   => dotproduct   !< Compute the scalar (dot) product.
     generic :: operator(.paral.) => parallel     !< Compute the component of `lhs` parallel to `rhs`.
     generic :: operator(.ortho.) => orthogonal   !< Compute the component of `lhs` orthogonal to `rhs`.
     ! public methods
     procedure, pass(self) :: distance_to_line            !< Calculate the distance (scalar) to line defined by 2 points.
     procedure, pass(self) :: distance_to_plane           !< Calculate the distance (signed, scalar) to plane defined by 3 points.
     procedure, pass(self) :: distance_vectorial_to_plane !< Calculate the distance (vectorial) to plane defined by 3 points.
     procedure, nopass     :: face_normal3                !< Calculate the normal of the face defined by 3 points.
     procedure, nopass     :: face_normal4                !< Calculate the normal of the face defined by 4 points.
     procedure, pass(self) :: iolen                       !< Compute IO length.
     procedure, pass(self) :: is_collinear                !< Return true if the point is collinear with other two given points.
     procedure, pass(self) :: is_concyclic                !< Return true if the point is concyclic with other three given points.
     procedure, pass(self) :: load_from_file              !< Load vector from file.
     procedure, pass(self) :: normalize                   !< Normalize a vector.
     procedure, pass(self) :: normalized                  !< Return a normalized copy of vector.
     procedure, pass(self) :: normL2                      !< Return the norm L2 of vector.
     procedure, pass(self) :: printf                      !< Print vector components with a "pretty" format.
     procedure, pass(self) :: projection_onto_plane       !< Calculate the projection of point onto plane defined by 3 points.
     procedure, pass(self) :: save_into_file              !< Save vector into file.
     procedure, pass(self) :: sq_norm                     !< Return the square of the norm of a vector.
     ! operators overloading
     generic :: assignment(=) => assign_vector, &
#ifdef _R16P_SUPPORTED
                                 assign_R16P,   &
#endif
                                 assign_R8P,    &
                                 assign_R4P,    &
                                 assign_I8P,    &
                                 assign_I4P,    &
                                 assign_I2P,    &
                                 assign_I1P !< Overloading `=`.
     generic :: operator(*) => vector_mul_vector,                &
#ifdef _R16P_SUPPORTED
                               R16P_mul_vector, vector_mul_R16P, &
#endif
                               R8P_mul_vector, vector_mul_R8P,   &
                               R4P_mul_vector, vector_mul_R4P,   &
                               I8P_mul_vector, vector_mul_I8P,   &
                               I4P_mul_vector, vector_mul_I4P,   &
                               I2P_mul_vector, vector_mul_I2P,   &
                               I1P_mul_vector, vector_mul_I1P !< Overloading `*`.
     generic :: operator(/) => vector_div_vector, &
#ifdef _R16P_SUPPORTED
                               vector_div_R16P,   &
#endif
                               vector_div_R8P,    &
                               vector_div_R4P,    &
                               vector_div_I8P,    &
                               vector_div_I4P,    &
                               vector_div_I2P,    &
                               vector_div_I1P !< Overloading `/`.
     generic :: operator(+) => positive, vector_sum_vector,      &
#ifdef _R16P_SUPPORTED
                               R16P_sum_vector, vector_sum_R16P, &
#endif
                               R8P_sum_vector, vector_sum_R8P,   &
                               R4P_sum_vector, vector_sum_R4P,   &
                               I8P_sum_vector, vector_sum_I8P,   &
                               I4P_sum_vector, vector_sum_I4P,   &
                               I2P_sum_vector, vector_sum_I2P,   &
                               I1P_sum_vector, vector_sum_I1P !< Overloading `+`.
     generic :: operator(-) => negative, vector_sub_vector,      &
#ifdef _R16P_SUPPORTED
                               R16P_sub_vector, vector_sub_R16P, &
#endif
                               R8P_sub_vector, vector_sub_R8P,   &
                               R4P_sub_vector, vector_sub_R4P,   &
                               I8P_sub_vector, vector_sub_I8P,   &
                               I4P_sub_vector, vector_sub_I4P,   &
                               I2P_sub_vector, vector_sub_I2P,   &
                               I1P_sub_vector, vector_sub_I1P !< Overloading `-`.
     generic :: operator(/=) => vector_not_eq_vector,                   &
#ifdef _R16P_SUPPORTED
                                R16P_not_eq_vector, vector_not_eq_R16P, &
#endif
                                R8P_not_eq_vector, vector_not_eq_R8P,   &
                                R4P_not_eq_vector, vector_not_eq_R4P,   &
                                I8P_not_eq_vector, vector_not_eq_I8P,   &
                                I4P_not_eq_vector, vector_not_eq_I4P,   &
                                I2P_not_eq_vector, vector_not_eq_I2P,   &
                                I1P_not_eq_vector, vector_not_eq_I1P !< Overloading `/=`.
     generic :: operator(<) => vector_low_vector,                &
#ifdef _R16P_SUPPORTED
                               R16P_low_vector, vector_low_R16P, &
#endif
                               R8P_low_vector, vector_low_R8P,   &
                               R4P_low_vector, vector_low_R4P,   &
                               I8P_low_vector, vector_low_I8P,   &
                               I4P_low_vector, vector_low_I4P,   &
                               I2P_low_vector, vector_low_I2P,   &
                               I1P_low_vector, vector_low_I1P !< Overloading `<`.
     generic :: operator(<=) => vector_low_eq_vector,                   &
#ifdef _R16P_SUPPORTED
                                R16P_low_eq_vector, vector_low_eq_R16P, &
#endif
                                R8P_low_eq_vector, vector_low_eq_R8P,   &
                                R4P_low_eq_vector, vector_low_eq_R4P,   &
                                I8P_low_eq_vector, vector_low_eq_I8P,   &
                                I4P_low_eq_vector, vector_low_eq_I4P,   &
                                I2P_low_eq_vector, vector_low_eq_I2P,   &
                                I1P_low_eq_vector, vector_low_eq_I1P !< Overloading `<=`.
     generic :: operator(==) => vector_eq_vector,               &
#ifdef _R16P_SUPPORTED
                                R16P_eq_vector, vector_eq_R16P, &
#endif
                                R8P_eq_vector, vector_eq_R8P,   &
                                R4P_eq_vector, vector_eq_R4P,   &
                                I8P_eq_vector, vector_eq_I8P,   &
                                I4P_eq_vector, vector_eq_I4P,   &
                                I2P_eq_vector, vector_eq_I2P,   &
                                I1P_eq_vector, vector_eq_I1P !< Overloading `==`.
     generic :: operator(>=) => vector_great_eq_vector,                     &
#ifdef _R16P_SUPPORTED
                                R16P_great_eq_vector, vector_great_eq_R16P, &
#endif
                                R8P_great_eq_vector, vector_great_eq_R8P,   &
                                R4P_great_eq_vector, vector_great_eq_R4P,   &
                                I8P_great_eq_vector, vector_great_eq_I8P,   &
                                I4P_great_eq_vector, vector_great_eq_I4P,   &
                                I2P_great_eq_vector, vector_great_eq_I2P,   &
                                I1P_great_eq_vector, vector_great_eq_I1P !< Overloading `>=`.
     generic :: operator(>) => vector_great_vector,                  &
#ifdef _R16P_SUPPORTED
                               R16P_great_vector, vector_great_R16P, &
#endif
                               R8P_great_vector, vector_great_R8P,   &
                               R4P_great_vector, vector_great_R4P,   &
                               I8P_great_vector, vector_great_I8P,   &
                               I4P_great_vector, vector_great_I4P,   &
                               I2P_great_vector, vector_great_I2P,   &
                               I1P_great_vector, vector_great_I1P !< Overloading `>`.
     ! private methods
     procedure, pass(lhs), private :: crossproduct           !< Compute the cross product.
     procedure, pass(lhs), private :: dotproduct             !< Compute the scalar (dot) product.
     procedure, pass(lhs), private :: orthogonal             !< Compute the component of `lhs` orthogonal to `rhs`.
     procedure, pass(lhs), private :: parallel               !< Compute the component of `lhs` parallel to `rhs`.
     procedure, pass(lhs), private :: assign_vector          !< Operator `=`.
     procedure, pass(lhs), private :: assign_R16P            !< Operator `= real(R16P)`.
     procedure, pass(lhs), private :: assign_R8P             !< Operator `= real(R8P)`.
     procedure, pass(lhs), private :: assign_R4P             !< Operator `= real(R4P)`.
     procedure, pass(lhs), private :: assign_I8P             !< Operator `= integer(I8P)`.
     procedure, pass(lhs), private :: assign_I4P             !< Operator `= integer(I4P)`.
     procedure, pass(lhs), private :: assign_I2P             !< Operator `= integer(I2P)`.
     procedure, pass(lhs), private :: assign_I1P             !< Operator `= integer(I1P)`.
     procedure, pass(lhs), private :: vector_mul_vector      !< Operator `*`.
     procedure, pass(rhs), private :: R16P_mul_vector        !< Operator `real(R16P) *`.
     procedure, pass(lhs), private :: vector_mul_R16P        !< Operator `* real(R16P)`.
     procedure, pass(rhs), private :: R8P_mul_vector         !< Operator `real(R8P) *`.
     procedure, pass(lhs), private :: vector_mul_R8P         !< Operator `* real(R8P)`.
     procedure, pass(rhs), private :: R4P_mul_vector         !< Operator `real(R4P) *`.
     procedure, pass(lhs), private :: vector_mul_R4P         !< Operator `* real(R4P)`.
     procedure, pass(rhs), private :: I8P_mul_vector         !< Operator `integer(I8P) *`.
     procedure, pass(lhs), private :: vector_mul_I8P         !< Operator `* integer(I8P)`.
     procedure, pass(rhs), private :: I4P_mul_vector         !< Operator `integer(I4P) *`.
     procedure, pass(lhs), private :: vector_mul_I4P         !< Operator `* integer(I4P)`.
     procedure, pass(rhs), private :: I2P_mul_vector         !< Operator `integer(I2P) *`.
     procedure, pass(lhs), private :: vector_mul_I2P         !< Operator `* integer(I2P)`.
     procedure, pass(rhs), private :: I1P_mul_vector         !< Operator `integer(I1P) *`.
     procedure, pass(lhs), private :: vector_mul_I1P         !< Operator `* integer(I1P)`.
     procedure, pass(lhs), private :: vector_div_vector      !< Operator `/`.
     procedure, pass(lhs), private :: vector_div_R16P        !< Operator `/ real(R16P)`.
     procedure, pass(lhs), private :: vector_div_R8P         !< Operator `/ real(R8P)`.
     procedure, pass(lhs), private :: vector_div_R4P         !< Operator `/ real(R4P)`.
     procedure, pass(lhs), private :: vector_div_I8P         !< Operator `/ integer(I8P)`.
     procedure, pass(lhs), private :: vector_div_I4P         !< Operator `/ integer(I4P)`.
     procedure, pass(lhs), private :: vector_div_I2P         !< Operator `/ integer(I2P)`.
     procedure, pass(lhs), private :: vector_div_I1P         !< Operator `/ integer(I1P)`.
     procedure, pass(rhs), private :: positive               !< Operator `+`, unary.
     procedure, pass(lhs), private :: vector_sum_vector      !< Operator `+`.
     procedure, pass(rhs), private :: R16P_sum_vector        !< Operator `real(R16P) +`.
     procedure, pass(lhs), private :: vector_sum_R16P        !< Operator `+ real(R16P)`.
     procedure, pass(rhs), private :: R8P_sum_vector         !< Operator `real(R8P) +`.
     procedure, pass(lhs), private :: vector_sum_R8P         !< Operator `+ real(R8P)`.
     procedure, pass(rhs), private :: R4P_sum_vector         !< Operator `real(R4P) +`.
     procedure, pass(lhs), private :: vector_sum_R4P         !< Operator `+ real(R4P)`.
     procedure, pass(rhs), private :: I8P_sum_vector         !< Operator `integer(I8P) +`.
     procedure, pass(lhs), private :: vector_sum_I8P         !< Operator `+ integer(I8P)`.
     procedure, pass(rhs), private :: I4P_sum_vector         !< Operator `integer(I4P) +`.
     procedure, pass(lhs), private :: vector_sum_I4P         !< Operator `+ integer(I4P)`.
     procedure, pass(rhs), private :: I2P_sum_vector         !< Operator `integer(I2P) +`.
     procedure, pass(lhs), private :: vector_sum_I2P         !< Operator `+ integer(I2P)`.
     procedure, pass(rhs), private :: I1P_sum_vector         !< Operator `integer(I1P) +`.
     procedure, pass(lhs), private :: vector_sum_I1P         !< Operator `+ integer(I1P)`.
     procedure, pass(rhs), private :: negative               !< Operator `-`, unary.
     procedure, pass(lhs), private :: vector_sub_vector      !< Operator `-`.
     procedure, pass(rhs), private :: R16P_sub_vector        !< Operator `real(R16P) -`.
     procedure, pass(lhs), private :: vector_sub_R16P        !< Operator `- real(R16P)`.
     procedure, pass(rhs), private :: R8P_sub_vector         !< Operator `real(R8P) -`.
     procedure, pass(lhs), private :: vector_sub_R8P         !< Operator `- real(R8P)`.
     procedure, pass(rhs), private :: R4P_sub_vector         !< Operator `real(R4P) -`.
     procedure, pass(lhs), private :: vector_sub_R4P         !< Operator `- real(R4P)`.
     procedure, pass(rhs), private :: I8P_sub_vector         !< Operator `integer(I8P) -`.
     procedure, pass(lhs), private :: vector_sub_I8P         !< Operator `- integer(I8P)`.
     procedure, pass(rhs), private :: I4P_sub_vector         !< Operator `integer(I4P) -`.
     procedure, pass(lhs), private :: vector_sub_I4P         !< Operator `- integer(I4P)`.
     procedure, pass(rhs), private :: I2P_sub_vector         !< Operator `integer(I2P) -`.
     procedure, pass(lhs), private :: vector_sub_I2P         !< Operator `- integer(I2P)`.
     procedure, pass(rhs), private :: I1P_sub_vector         !< Operator `integer(I1P) -`.
     procedure, pass(lhs), private :: vector_sub_I1P         !< Operator `- integer(I1P)`.
     procedure, pass(lhs), private :: vector_not_eq_vector   !< Operator `/=`.
     procedure, pass(rhs), private :: R16P_not_eq_vector     !< Operator `real(R16P) /=`.
     procedure, pass(lhs), private :: vector_not_eq_R16P     !< Operator `/= real(R16P)`.
     procedure, pass(rhs), private :: R8P_not_eq_vector      !< Operator `real(R8P) /=`.
     procedure, pass(lhs), private :: vector_not_eq_R8P      !< Operator `/= real(R8P)`.
     procedure, pass(rhs), private :: R4P_not_eq_vector      !< Operator `real(R4P) /=`.
     procedure, pass(lhs), private :: vector_not_eq_R4P      !< Operator `/= real(R4P)`.
     procedure, pass(rhs), private :: I8P_not_eq_vector      !< Operator `integer(I8P) /=`.
     procedure, pass(lhs), private :: vector_not_eq_I8P      !< Operator `/= integer(I8P)`.
     procedure, pass(rhs), private :: I4P_not_eq_vector      !< Operator `integer(I4P) /=`.
     procedure, pass(lhs), private :: vector_not_eq_I4P      !< Operator `/= integer(I4P)`.
     procedure, pass(rhs), private :: I2P_not_eq_vector      !< Operator `integer(I2P) /=`.
     procedure, pass(lhs), private :: vector_not_eq_I2P      !< Operator `/= integer(I2P)`.
     procedure, pass(rhs), private :: I1P_not_eq_vector      !< Operator `integer(I1P) /=`.
     procedure, pass(lhs), private :: vector_not_eq_I1P      !< Operator `/= integer(I1P)`.
     procedure, pass(lhs), private :: vector_low_vector      !< Operator `<`.
     procedure, pass(rhs), private :: R16P_low_vector        !< Operator `real(R16P) <`.
     procedure, pass(lhs), private :: vector_low_R16P        !< Operator `< real(R16P)`.
     procedure, pass(rhs), private :: R8P_low_vector         !< Operator `real(R8P) <`.
     procedure, pass(lhs), private :: vector_low_R8P         !< Operator `< real(R8P)`.
     procedure, pass(rhs), private :: R4P_low_vector         !< Operator `real(R4P) <`.
     procedure, pass(lhs), private :: vector_low_R4P         !< Operator `< real(R4P)`.
     procedure, pass(rhs), private :: I8P_low_vector         !< Operator `integer(I8P) <`.
     procedure, pass(lhs), private :: vector_low_I8P         !< Operator `< integer(I8P)`.
     procedure, pass(rhs), private :: I4P_low_vector         !< Operator `integer(I4P) <`.
     procedure, pass(lhs), private :: vector_low_I4P         !< Operator `< integer(I4P)`.
     procedure, pass(rhs), private :: I2P_low_vector         !< Operator `integer(I2P) <`.
     procedure, pass(lhs), private :: vector_low_I2P         !< Operator `< integer(I2P)`.
     procedure, pass(rhs), private :: I1P_low_vector         !< Operator `integer(I1P) <`.
     procedure, pass(lhs), private :: vector_low_I1P         !< Operator `< integer(I1P)`.
     procedure, pass(lhs), private :: vector_low_eq_vector   !< Operator `<=`.
     procedure, pass(rhs), private :: R16P_low_eq_vector     !< Operator `real(R16P) <=`.
     procedure, pass(lhs), private :: vector_low_eq_R16P     !< Operator `<= real(R16P)`.
     procedure, pass(rhs), private :: R8P_low_eq_vector      !< Operator `real(R8P) <=`.
     procedure, pass(lhs), private :: vector_low_eq_R8P      !< Operator `<= real(R8P)`.
     procedure, pass(rhs), private :: R4P_low_eq_vector      !< Operator `real(R4P) <=`.
     procedure, pass(lhs), private :: vector_low_eq_R4P      !< Operator `<= real(R4P)`.
     procedure, pass(rhs), private :: I8P_low_eq_vector      !< Operator `integer(I8P) <=`.
     procedure, pass(lhs), private :: vector_low_eq_I8P      !< Operator `<= integer(I8P)`.
     procedure, pass(rhs), private :: I4P_low_eq_vector      !< Operator `integer(I4P) <=`.
     procedure, pass(lhs), private :: vector_low_eq_I4P      !< Operator `<= integer(I4P)`.
     procedure, pass(rhs), private :: I2P_low_eq_vector      !< Operator `integer(I2P) <=`.
     procedure, pass(lhs), private :: vector_low_eq_I2P      !< Operator `<= integer(I2P)`.
     procedure, pass(rhs), private :: I1P_low_eq_vector      !< Operator `integer(I1P) <=`.
     procedure, pass(lhs), private :: vector_low_eq_I1P      !< Operator `<= integer(I1P)`.
     procedure, pass(lhs), private :: vector_eq_vector       !< Operator `==`.
     procedure, pass(rhs), private :: R16P_eq_vector         !< Operator `real(R16P) ==`.
     procedure, pass(lhs), private :: vector_eq_R16P         !< Operator `== real(R16P)`.
     procedure, pass(rhs), private :: R8P_eq_vector          !< Operator `real(R8P) ==`.
     procedure, pass(lhs), private :: vector_eq_R8P          !< Operator `== real(R8P)`.
     procedure, pass(rhs), private :: R4P_eq_vector          !< Operator `real(R4P) ==`.
     procedure, pass(lhs), private :: vector_eq_R4P          !< Operator `== real(R4P)`.
     procedure, pass(rhs), private :: I8P_eq_vector          !< Operator `integer(I8P) ==`.
     procedure, pass(lhs), private :: vector_eq_I8P          !< Operator `== integer(I8P)`.
     procedure, pass(rhs), private :: I4P_eq_vector          !< Operator `integer(I4P) ==`.
     procedure, pass(lhs), private :: vector_eq_I4P          !< Operator `== integer(I4P)`.
     procedure, pass(rhs), private :: I2P_eq_vector          !< Operator `integer(I2P) ==`.
     procedure, pass(lhs), private :: vector_eq_I2P          !< Operator `== integer(I2P)`.
     procedure, pass(rhs), private :: I1P_eq_vector          !< Operator `integer(I1P) ==`.
     procedure, pass(lhs), private :: vector_eq_I1P          !< Operator `== integer(I1P)`.
     procedure, pass(lhs), private :: vector_great_eq_vector !< Operator `>=`.
     procedure, pass(rhs), private :: R16P_great_eq_vector   !< Operator `real(R16P) >=`.
     procedure, pass(lhs), private :: vector_great_eq_R16P   !< Operator `>= real(R16P)`.
     procedure, pass(rhs), private :: R8P_great_eq_vector    !< Operator `real(R8P) >=`.
     procedure, pass(lhs), private :: vector_great_eq_R8P    !< Operator `>= real(R8P)`.
     procedure, pass(rhs), private :: R4P_great_eq_vector    !< Operator `real(R4P) >=`.
     procedure, pass(lhs), private :: vector_great_eq_R4P    !< Operator `>= real(R4P)`.
     procedure, pass(rhs), private :: I8P_great_eq_vector    !< Operator `integer(I8P) >=`.
     procedure, pass(lhs), private :: vector_great_eq_I8P    !< Operator `>= integer(I8P)`.
     procedure, pass(rhs), private :: I4P_great_eq_vector    !< Operator `integer(I4P) >=`.
     procedure, pass(lhs), private :: vector_great_eq_I4P    !< Operator `>= integer(I4P)`.
     procedure, pass(rhs), private :: I2P_great_eq_vector    !< Operator `integer(I2P) >=`.
     procedure, pass(lhs), private :: vector_great_eq_I2P    !< Operator `>= integer(I2P)`.
     procedure, pass(rhs), private :: I1P_great_eq_vector    !< Operator `integer(I1P) >=`.
     procedure, pass(lhs), private :: vector_great_eq_I1P    !< Operator `>= integer(I1P)`.
     procedure, pass(lhs), private :: vector_great_vector    !< Operator `>`.
     procedure, pass(rhs), private :: R16P_great_vector      !< Operator `real(R16P) >`.
     procedure, pass(lhs), private :: vector_great_R16P      !< Operator `> real(R16P)`.
     procedure, pass(rhs), private :: R8P_great_vector       !< Operator `real(R8P) >`.
     procedure, pass(lhs), private :: vector_great_R8P       !< Operator `> real(R8P)`.
     procedure, pass(rhs), private :: R4P_great_vector       !< Operator `real(R4P) >`.
     procedure, pass(lhs), private :: vector_great_R4P       !< Operator `> real(R4P)`.
     procedure, pass(rhs), private :: I8P_great_vector       !< Operator `integer(I8P) >`.
     procedure, pass(lhs), private :: vector_great_I8P       !< Operator `> integer(I8P)`.
     procedure, pass(rhs), private :: I4P_great_vector       !< Operator `integer(I4P) >`.
     procedure, pass(lhs), private :: vector_great_I4P       !< Operator `> integer(I4P)`.
     procedure, pass(rhs), private :: I2P_great_vector       !< Operator `integer(I2P) >`.
     procedure, pass(lhs), private :: vector_great_I2P       !< Operator `> integer(I2P)`.
     procedure, pass(rhs), private :: I1P_great_vector       !< Operator `integer(I1P) >`.
     procedure, pass(lhs), private :: vector_great_I1P       !< Operator `> integer(I1P)`.
endtype vector

type, public :: vector_ptr
  !< Pointer of Vector for creating array of pointers of Vector.
  type(vector), pointer:: p=>null()
endtype vector_ptr

type(vector), parameter :: ex = vector(1._R_P, 0._R_P, 0._R_P) !< X direction versor.
type(vector), parameter :: ey = vector(0._R_P, 1._R_P, 0._R_P) !< Y direction versor.
type(vector), parameter :: ez = vector(0._R_P, 0._R_P, 1._R_P) !< Z direction versor.

contains
   ! public methods
   elemental function distance_to_line(self, pt1, pt2) result(distance)
   !< Calculate the distance (scalar) to line defined by the 2 points.
   !<
   !< The convention for the points numeration is the following:
   !<```
   !<         . self
   !<         ^
   !<         |
   !<         |
   !< 1.-------------.2
   !<```
   !<
   !<```fortran
   !< use penf, only : R_P
   !< type(vector) :: pt(0:2)
   !< real(R_P)    :: d
   !<
   !< pt(0) = 5.3 * ez
   !< pt(1) = ex
   !< pt(2) = ey
   !< d = pt(0)%distance_to_line(pt1=pt(1), pt2=pt(2))
   !< print "(F3.1)", d
   !<```
   !=> 5.3 <<<
   !<
   !<```fortran
   !< use penf, only : R_P
   !< type(vector) :: pt(0:2)
   !< real(R_P)    :: d
   !<
   !< pt(0) = 5.3 * ez
   !< pt(1) = ex
   !< pt(2) = ey
   !< d = distance_to_line(pt(0), pt1=pt(1), pt2=pt(2))
   !< print "(F3.1)", d
   !<```
   !=> 5.3 <<<
   class(vector), intent(in) :: self     !< The point from which computing the distance.
   type(vector),  intent(in) :: pt1      !< First line point.
   type(vector),  intent(in) :: pt2      !< Second line point.
   real(R_P)                 :: distance !< Face normal.

   distance = normL2((self - pt1).cross.(self - pt2)) / normL2(pt2 - pt1)
   endfunction distance_to_line

   elemental function distance_to_plane(self, pt1, pt2, pt3) result(distance)
   !< Calculate the distance (signed, scalar) to plane defined by the 3 points.
   !<
   !< The convention for the points numeration is the following:
   !<```
   !< 1.----.2
   !<   \   |
   !<    \ *---------> . self
   !<     \ |
   !<      \|
   !<       .3
   !<```
   !<
   !<```fortran
   !< use penf, only : R_P
   !< type(vector) :: pt(0:3)
   !< real(R_P)    :: d
   !<
   !< pt(0) = 5.3 * ez
   !< pt(1) = ex
   !< pt(2) = ey
   !< pt(3) = ex - ey
   !< d = pt(0)%distance_to_plane(pt1=pt(1), pt2=pt(2), pt3=pt(3))
   !< print "(F3.1)", d
   !<```
   !=> 5.3 <<<
   !<
   !<```fortran
   !< use penf, only : R_P
   !< type(vector) :: pt(0:3)
   !< real(R_P)    :: d
   !<
   !< pt(0) = 5.3 * ez
   !< pt(1) = ex
   !< pt(2) = ey
   !< pt(3) = ex - ey
   !< d = distance_to_plane(pt(0), pt1=pt(1), pt2=pt(2), pt3=pt(3))
   !< print "(F3.1)", d
   !<```
   !=> 5.3 <<<
   class(vector), intent(in) :: self     !< The point from which computing the distance.
   type(vector),  intent(in) :: pt1      !< First plane point.
   type(vector),  intent(in) :: pt2      !< Second plane point.
   type(vector),  intent(in) :: pt3      !< Third plane point.
   real(R_P)                 :: distance !< Face normal.
   type(vector)              :: normal   !< Normal (versor) of plane.

   normal = face_normal3(pt1=pt1, pt2=pt2, pt3=pt3, norm='y')
   distance = normal.dot.(self - pt1)
   endfunction distance_to_plane

   elemental function distance_vectorial_to_plane(self, pt1, pt2, pt3) result(distance)
   !< Calculate the distance (vectorial) to plane defined by the 3 points.
   !<
   !< The convention for the points numeration is the following:
   !<```
   !< 1.----.2
   !<   \   |
   !<    \ *---------> . self
   !<     \ |
   !<      \|
   !<       .3
   !<```
   !<
   !<```fortran
   !< type(vector) :: pt(0:3)
   !<
   !< pt(0) = 5.3 * ez
   !< pt(1) = ex
   !< pt(2) = ey
   !< pt(3) = ex - ey
   !< pt(0) = pt(0)%distance_vectorial_to_plane(pt1=pt(1), pt2=pt(2), pt3=pt(3))
   !< print "(3(F3.1,1X))", pt(0)%x, pt(0)%y, pt(0)%z
   !<```
   !=> 0.0 0.0 5.3 <<<
   !<
   !<```fortran
   !< type(vector) :: pt(0:3)
   !<
   !< pt(0) = 5.3 * ez
   !< pt(1) = ex
   !< pt(2) = ey
   !< pt(3) = ex - ey
   !< pt(0) = distance_vectorial_to_plane(pt(0), pt1=pt(1), pt2=pt(2), pt3=pt(3))
   !< print "(3(F3.1,1X))", pt(0)%x, pt(0)%y, pt(0)%z
   !<```
   !=> 0.0 0.0 5.3 <<<
   class(vector), intent(in) :: self     !< The point from which computing the distance.
   type(vector),  intent(in) :: pt1      !< First plane point.
   type(vector),  intent(in) :: pt2      !< Second plane point.
   type(vector),  intent(in) :: pt3      !< Third plane point.
   type(vector)              :: distance !< Face normal.
   type(vector)              :: normal   !< Normal (versor) of plane.

   normal = face_normal3(pt1=pt1, pt2=pt2, pt3=pt3, norm='y')
   distance = normal * (normal.dot.(self - pt1))
   endfunction distance_vectorial_to_plane

   elemental function face_normal3(pt1, pt2, pt3, norm) result(normal)
   !< Calculate the normal of the face defined by the 3 points.
   !<
   !< The convention for the points numeration is the following:
   !<```
   !< 1.----.2
   !<   \   |
   !<    \  |
   !<     \ |
   !<      \|
   !<       .3
   !<```
   !< The normal is calculated by the cross product of the side s12 for the side s13: s12 x s13.
   !< The normal is normalized if the variable *norm* is passed (with any value).
   !<
   !<```fortran
   !< type(vector) :: pt(0:3)
   !<
   !< pt(1) = ex
   !< pt(2) = ey
   !< pt(3) = ex - ey
   !< pt(0) = pt(1)%face_normal3(pt1=pt(1), pt2=pt(2), pt3=pt(3), norm='y')
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 0.0 0.0 1.0 <<<
   !<
   !<```fortran
   !< type(vector) :: pt(0:3)
   !<
   !< pt(1) = ex
   !< pt(2) = ey
   !< pt(3) = ex - ey
   !< pt(0) = face_normal3(pt1=pt(1), pt2=pt(2), pt3=pt(3), norm='y')
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 0.0 0.0 1.0 <<<
   type(vector),  intent(in)           :: pt1    !< First face point.
   type(vector),  intent(in)           :: pt2    !< Second face point.
   type(vector),  intent(in)           :: pt3    !< Third face point.
   character(1),  intent(in), optional :: norm   !< If 'norm' is passed as argument the normal is normalized.
   type(vector)                        :: normal !< Face normal.
   type(vector)                        :: s12    !< Face 1-2 diagonals.
   type(vector)                        :: s13    !< Face 1-3 diagonals.

   s12 = pt2 - pt1
   s13 = pt3 - pt1
   if (present(norm)) then
     normal = normalized(s12.cross.s13)
   else
     normal = 0.5_R_P * (s12.cross.s13)
   endif
   endfunction face_normal3

   elemental function face_normal4(pt1, pt2, pt3, pt4, norm) result(normal)
   !< Calculate the normal of the face defined by 4 points.
   !<
   !< The convention for the points numeration is the following:
   !<```
   !< 1.----------.2
   !<  |          |
   !<  |          |
   !<  |          |
   !<  |          |
   !< 4.----------.3
   !<```
   !< The normal is calculated by the cross product of the diagonal d13 for the diagonal d24: d13 x d24.
   !< The normal is normalized if the variable *norm* is passed (with any value).
   !<
   !<```fortran
   !< type(vector) :: pt(0:4)
   !<
   !< pt(1) = ex
   !< pt(2) = ey
   !< pt(3) = ex - ey
   !< pt(4) = ex + ey
   !< pt(0) = pt(1)%face_normal4(pt1=pt(1), pt2=pt(2), pt3=pt(3), pt4=pt(4), norm='y')
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 0.0 0.0 1.0 <<<
   !<
   !<```fortran
   !< type(vector) :: pt(0:4)
   !<
   !< pt(1) = ex
   !< pt(2) = ey
   !< pt(3) = ex - ey
   !< pt(4) = ex + ey
   !< pt(0) = face_normal4(pt1=pt(1), pt2=pt(2), pt3=pt(3), pt4=pt(4), norm='y')
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 0.0 0.0 1.0 <<<
   type(vector),  intent(in)           :: pt1  !< First face point.
   type(vector),  intent(in)           :: pt2  !< Second face point.
   type(vector),  intent(in)           :: pt3  !< Third face point.
   type(vector),  intent(in)           :: pt4  !< Fourth face point.
   character(1),  intent(in), optional :: norm !< If 'norm' is passed as argument the normal is normalized.
   type(vector)                        :: normal !< Face normal.
   type(vector)                        :: d13  !< Face 1-3 diagonals.
   type(vector)                        :: d24  !< Face 2-4 diagonals.

   d13 = pt3 - pt1
   d24 = pt4 - pt2
   if (present(norm)) then
     normal = normalized(d13.cross.d24)
   else
     normal = 0.5_R_P * (d13.cross.d24)
   endif
   endfunction face_normal4

   function iolen(self) result(iolen_)
   !< Compute IO length.
   !<
   !<```fortran
   !< type(vector) :: pt
   !< print*, pt%iolen()
   !<```
   !=> 24 <<<
   !<
   !<```fortran
   !< type(vector) :: pt
   !< print*, iolen(pt)
   !<```
   !=> 24 <<<
   class(vector), intent(in) :: self   !< Vector.
   integer(I4P)              :: iolen_ !< IO length.

   inquire(iolength=iolen_) self%x, self%y, self%z
   endfunction iolen

   elemental function is_collinear(self, pt1, pt2, tolerance) result(is_collinear_)
   !< Return true if the point is collinear with other two given points.
   !<
   !<```fortran
   !< type(vector) :: pt(0:2)
   !<
   !< pt(0) = 3 * ex
   !< pt(1) = 1 * ex
   !< pt(2) = 2 * ex
   !< print "(L1)", pt(0)%is_collinear(pt1=pt(1), pt2=pt(2))
   !<```
   !=> T <<<
   !<
   !<```fortran
   !< type(vector) :: pt(0:2)
   !<
   !< pt(0) = 3 * ex
   !< pt(1) = 1 * ex
   !< pt(2) = 2 * ex
   !< print "(L1)", is_collinear(pt(0), pt1=pt(1), pt2=pt(2))
   !<```
   !=> T <<<
   class(vector), intent(in)           :: self          !< Vector.
   type(vector),  intent(in)           :: pt1           !< First line point.
   type(vector),  intent(in)           :: pt2           !< Second line point.
   real(R_P),     intent(in), optional :: tolerance     !< Tolerance for collinearity check.
   logical                             :: is_collinear_ !< Inquire result.
   real(R_P)                           :: tolerance_    !< Tolerance for collinearity check, local variable.

   tolerance_ = 0._R_P ; if (present(tolerance)) tolerance_ = tolerance
   is_collinear_ = self%distance_to_line(pt1=pt1, pt2=pt2) <= Zero + tolerance_
   endfunction is_collinear

   elemental function is_concyclic(self, pt1, pt2, pt3, tolerance) result(is_concyclic_)
   !< Return true if the point is concyclic with other three given points.
   !<
   !< Based on Ptolemy's Theorem.
   !<
   !<```fortran
   !< type(vector) :: pt(0:3)
   !<
   !< pt(0) = -1 * ey
   !< pt(1) =  1 * ex
   !< pt(2) =  1 * ey
   !< pt(3) = -1 * ex
   !< print "(L1)", pt(0)%is_concyclic(pt1=pt(1), pt2=pt(2), pt3=pt(3))
   !<```
   !=> T <<<
   !<
   !<```fortran
   !< type(vector) :: pt(0:3)
   !<
   !< pt(0) = -1 * ey
   !< pt(1) =  1 * ex
   !< pt(2) =  1 * ey
   !< pt(3) = -1 * ex
   !< print "(L1)", is_concyclic(pt(0), pt1=pt(1), pt2=pt(2), pt3=pt(3))
   !<```
   !=> T <<<
   class(vector), intent(in)           :: self          !< Vector.
   type(vector),  intent(in)           :: pt1           !< First arc point.
   type(vector),  intent(in)           :: pt2           !< Second arc point.
   type(vector),  intent(in)           :: pt3           !< Third arc point.
   real(R_P),     intent(in), optional :: tolerance     !< Tolerance for concyclicity check.
   logical                             :: is_concyclic_ !< Inquire result.
   real(R_P)                           :: tolerance_    !< Tolerance for concyclicity check, local variable.
   real(R_P)                           :: a, b, c       !< Temporary storage to avoid bad conditioned math (lost of precision).

   a = sq_norm(self - pt1) * sq_norm(pt2 - pt3)
   b = sq_norm(pt1 - pt2) * sq_norm(pt3 - self)
   c = sq_norm(self - pt2) * sq_norm(pt1 - pt3)
   tolerance_ = 0._R_P ; if (present(tolerance)) tolerance_ = tolerance
   is_concyclic_ = sqrt(a) + sqrt(b) - sqrt(c) <= smallR_P + tolerance_
   endfunction is_concyclic

   subroutine load_from_file(self, unit, fmt, pos, iostat, iomsg)
   !< Load vector from file.
   !<
   !<```fortran
   !< type(vector) :: pt
   !< pt = 1 * ex + 2 * ey + 3 * ez
   !< open(unit=10, form='unformatted', status='scratch')
   !< call pt%save_into_file(unit=10)
   !< rewind(unit=10)
   !< call pt%load_from_file(unit=10)
   !< close(unit=10)
   !< print "(3(F3.1,1X))", pt%x, pt%y, pt%z
   !<```
   !=> 1.0 2.0 3.0 <<<
   class(vector), intent(inout)         :: self    !< Vector.
   integer(I4P),  intent(in)            :: unit    !< Logic unit.
   character(*),  intent(in),  optional :: fmt     !< IO format.
   integer(I8P),  intent(in),  optional :: pos     !< Position specifier.
   integer(I4P),  intent(out), optional :: iostat  !< IO error.
   character(*),  intent(out), optional :: iomsg   !< IO error message.
   integer(I4P)                         :: iostat_ !< IO error, local variable.
   character(len=:), allocatable        :: iomsg_  !< IO error message, local variable.

   iomsg_ = repeat(' ', 500)
   if (present(fmt)) then
      if (present(pos)) then
         read(unit=unit, fmt=trim(adjustl(fmt)), pos=pos, iostat=iostat_, iomsg=iomsg_)self%x, self%y, self%z
      else
         read(unit=unit, fmt=trim(adjustl(fmt)),          iostat=iostat_, iomsg=iomsg_)self%x, self%y, self%z
      endif
   else
      if (present(pos)) then
         read(unit=unit, pos=pos, iostat=iostat_, iomsg=iomsg_)self%x, self%y, self%z
      else
         read(unit=unit,          iostat=iostat_, iomsg=iomsg_)self%x, self%y, self%z
      endif
   endif
   if (present(iostat)) iostat = iostat_
   if (present(iomsg))  iomsg  = trim(adjustl(iomsg_))
   endsubroutine load_from_file

   elemental subroutine normalize(self)
   !< Normalize vector.
   !<
   !< The normalization is made by means of norm L2. If the norm L2 of the vector is less than the parameter smallR_P the
   !< normalization value is set to `normL2 + smallR_P`.
   !<
   !<```fortran
   !< type(vector) :: pt
   !< pt = ex + ey
   !< call pt%normalize
   !< print "(3(F4.2,1X))", abs(pt%x), abs(pt%y), abs(pt%z)
   !<```
   !=> 0.71 0.71 0.00 <<<
   class(vector), intent(inout) :: self !< Vector.
   real(R_P)                    :: nm   !< Norm L2 of vector.

   nm = normL2(self)
   if (nm < smallR_P) then
     nm = nm + smallR_P
   endif
   self%x = self%x / nm
   self%y = self%y / nm
   self%z = self%z / nm
   endsubroutine normalize

   elemental function normalized(self) result(norm)
   !< Return a normalized copy of vector.
   !<
   !< The normalization is made by means of norm L2. If the norm L2 of the vector is less than the parameter smallR_P the
   !< normalization value is set to normL2(vec)+smallR_P.
   !<
   !<```fortran
   !< type(vector) :: pt
   !< pt = ex + ey
   !< pt = pt%normalized()
   !< print "(3(F4.2,1X))", abs(pt%x), abs(pt%y), abs(pt%z)
   !<```
   !=> 0.71 0.71 0.00 <<<
   !<
   !<```fortran
   !< type(vector) :: pt
   !< pt = ex + ey
   !< pt = normalized(pt)
   !< print "(3(F4.2,1X))", abs(pt%x), abs(pt%y), abs(pt%z)
   !<```
   !=> 0.71 0.71 0.00 <<<
   class(vector), intent(in) :: self !< Vector.
   type(vector)              :: norm !< Normalized copy.

   norm = self
   call norm%normalize
   endfunction normalized

   elemental function normL2(self) result(norm)
   !< Return the norm L2 of vector.
   !<
   !< The norm L2 if defined as \( N = \sqrt {x^2  + y^2  + z^2 } \).
   !<
   !<```fortran
   !< type(vector) :: pt
   !< pt = ex + ey
   !< print "(F4.2)", pt%normL2()
   !<```
   !=> 1.41 <<<
   !<
   !<```fortran
   !< type(vector) :: pt
   !< pt = ex + ey
   !< print "(F4.2)", normL2(pt)
   !<```
   !=> 1.41 <<<
   class(vector), intent(in) :: self !< Vector.
   real(R_P)                 :: norm !< Norm L2.

   norm = sqrt(self%sq_norm())
   endfunction normL2

   subroutine printf(self, unit, prefix, sep, suffix, iostat, iomsg)
   !< Print in a pretty ascii format the components of type Vector.
   !<
   !<```fortran
   !< type(vector) :: pt
   !< pt = ex + ey
   !< call pt%printf(prefix='[x, y, z] = ', sep=', ')
   !<```
   !=> [x, y, z] = +0.1E+1, +0.1E+1, 0.0E+0 <<<
   class(vector), intent(in)            :: self    !< Vector.
   integer(I4P),  intent(in),  optional :: unit    !< Logic unit.
   character(*),  intent(in),  optional :: prefix  !< Prefix string.
   character(*),  intent(in),  optional :: sep     !< Components separator.
   character(*),  intent(in),  optional :: suffix  !< Suffix string.
   integer(I4P),  intent(out), optional :: iostat  !< IO error.
   character(*),  intent(out), optional :: iomsg   !< IO error message.
   character(len=:), allocatable        :: prefix_ !< Prefix string, local variable.
   character(len=:), allocatable        :: sep_    !< Components separator, local variable.
   character(len=:), allocatable        :: suffix_ !< Suffix string, local variable.
   integer(I4P)                         :: unit_   !< Logic unit.
   integer(I4P)                         :: iostat_ !< IO error, local variable.
   character(len=:), allocatable        :: iomsg_  !< IO error message, local variable.

   unit_ = stdout ; if (present(unit)) unit_ = unit
   prefix_ = '' ; if (present(prefix)) prefix_ = prefix
   sep_ = ', ' ; if (present(sep)) sep_ = sep
   suffix_ = '' ; if (present(suffix)) suffix_ = suffix
   iomsg_ = repeat(' ', 500)
   write(unit_, '(A)', iostat=iostat_, iomsg=iomsg_)prefix_//trim(str(n=self%x, compact=.true.))//sep_//&
                                                             trim(str(n=self%y, compact=.true.))//sep_//&
                                                             trim(str(n=self%z, compact=.true.))//suffix_
   if (present(iostat)) iostat = iostat_
   if (present(iomsg))  iomsg  = trim(adjustl(iomsg_))
   endsubroutine printf

   elemental function projection_onto_plane(self, pt1, pt2, pt3) result(projection)
   !< Calculate the projection of point onto plane defined by 3 points.
   !<
   !< The convention for the points numeration is the following:
   !<```
   !< 1.----.2
   !<   \   |
   !<    \ *---------> . self
   !<     \ |
   !<      \|
   !<       .3
   !<```
   !<
   !<```fortran
   !< type(vector) :: pt(0:3)
   !<
   !< pt(0) = 1 * ex + 2 * ey + 5.3 * ez
   !< pt(1) = ex
   !< pt(2) = ey
   !< pt(3) = ex - ey
   !< pt(0) = pt(0)%projection_onto_plane(pt1=pt(1), pt2=pt(2), pt3=pt(3))
   !< print "(3(F3.1,1X))", pt(0)%x, pt(0)%y, pt(0)%z
   !<```
   !=> 1.0 2.0 0.0 <<<
   !<
   !<```fortran
   !< type(vector) :: pt(0:3)
   !<
   !< pt(0) = 1 * ex + 2 * ey + 5.3 * ez
   !< pt(1) = ex
   !< pt(2) = ey
   !< pt(3) = ex - ey
   !< pt(0) = projection_onto_plane(pt(0), pt1=pt(1), pt2=pt(2), pt3=pt(3))
   !< print "(3(F3.1,1X))", pt(0)%x, pt(0)%y, pt(0)%z
   !<```
   !=> 1.0 2.0 0.0 <<<
   class(vector), intent(in) :: self       !< The point from which computing the distance.
   type(vector),  intent(in) :: pt1        !< First plane point.
   type(vector),  intent(in) :: pt2        !< Second plane point.
   type(vector),  intent(in) :: pt3        !< Third plane point.
   type(vector)              :: projection !< Point projection.
   type(vector)              :: distance   !< Vectorial distance.

   distance = self%distance_vectorial_to_plane(pt1=pt1, pt2=pt2, pt3=pt3)
   projection = self - distance
   endfunction projection_onto_plane

   subroutine save_into_file(self, unit, fmt, pos, iostat, iomsg)
   !< Save vector into file.
   !<
   !<```fortran
   !< type(vector) :: pt
   !< pt = 1 * ex + 2 * ey + 3 * ez
   !< open(unit=10, form='unformatted', status='scratch')
   !< call pt%save_into_file(unit=10)
   !< rewind(unit=10)
   !< call pt%load_from_file(unit=10)
   !< close(unit=10)
   !< print "(3(F3.1,1X))", pt%x, pt%y, pt%z
   !<```
   !=> 1.0 2.0 3.0 <<<
   class(vector), intent(in)            :: self    !< Vector data.
   integer(I4P),  intent(in)            :: unit    !< Logic unit.
   character(*),  intent(in),  optional :: fmt     !< IO format.
   integer(I8P),  intent(in),  optional :: pos     !< Position specifier.
   integer(I4P),  intent(out), optional :: iostat  !< IO error.
   character(*),  intent(out), optional :: iomsg   !< IO error message.
   integer(I4P)                         :: iostat_ !< IO error, local variable.
   character(len=:), allocatable        :: iomsg_  !< IO error message, local variable.

   iomsg_ = repeat(' ', 500)
   if (present(fmt)) then
      if (present(pos)) then
         write(unit=unit, fmt=trim(adjustl(fmt)), pos=pos, iostat=iostat_, iomsg=iomsg_)self%x, self%y, self%z
      else
         write(unit=unit, fmt=trim(adjustl(fmt)),          iostat=iostat_, iomsg=iomsg_)self%x, self%y, self%z
      endif
   else
      if (present(pos)) then
         write(unit=unit, pos=pos, iostat=iostat_, iomsg=iomsg_)self%x, self%y, self%z
      else
         write(unit=unit,          iostat=iostat_, iomsg=iomsg_)self%x, self%y, self%z
      endif
   endif
   if (present(iostat)) iostat = iostat_
   if (present(iomsg))  iomsg  = trim(adjustl(iomsg_))
   endsubroutine save_into_file

   elemental function sq_norm(self) result(sq)
   !< Return the square of the norm of vector.
   !<
   !< The square norm if defined as \( N = x^2  + y^2  + z^2 \).
   !<
   !<```fortran
   !< type(vector) :: pt
   !< pt = ex + ey
   !< print "(F3.1)", pt%sq_norm()
   !<```
   !=> 2.0 <<<
   !<
   !<```fortran
   !< type(vector) :: pt
   !< pt = ex + ey
   !< print "(F3.1)", sq_norm(pt)
   !<```
   !=> 2.0 <<<
   class(vector), intent(in) :: self !< Vector.
   real(R_P)                 :: sq   !< Square of the Norm.

   sq = (self%x * self%x) + (self%y * self%y) + (self%z * self%z)
   endfunction sq_norm

   ! private methods
   ! new operators
   elemental function crossproduct(lhs, rhs) result(cross)
   !< Compute the cross product.
   !<
   !< $$ \vec V=\left({y_1 z_2 - z_1 y_2}\right)\vec i +
   !<           \left({z_1 x_2 - x_1 z_2}\right)\vec j +
   !<           \left({x_1 y_2 - y_1 x_2}\right)\vec k $$
   !< where \( x_i \), \( y_i \) and \( z_i \) \( i=1,2 \) are the components of the vectors.
   !<
   !<```fortran
   !< type(vector) :: pt(0:2)
   !< pt(1) = 2 * ex
   !< pt(2) = ex
   !< pt(0) = pt(1).cross.pt(2)
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 0.0 0.0 0.0 <<<
   class(vector), intent(in) :: lhs   !< Left hand side.
   type(vector),  intent(in) :: rhs   !< Right hand side.
   type(vector)              :: cross !< Cross product vector.

   cross%x = (lhs%y * rhs%z) - (lhs%z * rhs%y)
   cross%y = (lhs%z * rhs%x) - (lhs%x * rhs%z)
   cross%z = (lhs%x * rhs%y) - (lhs%y * rhs%x)
   endfunction crossproduct

   elemental function dotproduct(lhs, rhs) result(dot)
   !< Compute the scalar (dot) product.
   !<
   !< $$ {\rm D}= x_1 \cdot x_2 + y_1 \cdot y_2 + z_1 \cdot z_2 $$
   !< where \( x_i \), \( y_i \) and \( z_i \) \( i=1,2 \) are the components of the vectors.
   !<
   !<```fortran
   !< type(vector) :: pt(1:2)
   !< pt(1) = ex
   !< pt(2) = ey
   !< print "(F3.1)", pt(1).dot.pt(2)
   !<```
   !=> 0.0 <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   type(vector),  intent(in) :: rhs !< Right hand side.
   real(R_P)                 :: dot !< Dot product.

   dot = (lhs%x * rhs%x) + (lhs%y * rhs%y) + (lhs%z * rhs%z)
   endfunction dotproduct

   elemental function orthogonal(lhs, rhs) result(ortho)
   !< Compute the component of `lhs` orthogonal to `rhs`.
   !<
   !<```fortran
   !< type(vector) :: pt(0:2)
   !< pt(1) = 2 * ex + 3 * ey
   !< pt(2) = ex
   !< pt(0) = pt(1).ortho.pt(2)
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 0.0 3.0 0.0 <<<
   class(vector), intent(in) :: lhs   !< Left hand side.
   type(vector),  intent(in) :: rhs   !< Right hand side.
   type(vector)              :: ortho !< Component of of `lhs` orthogonal to `rhs`.

   ortho = lhs - (lhs.paral.rhs)
   endfunction orthogonal

   elemental function parallel(lhs, rhs) result(paral)
   !> Compute the component of `lhs` parallel to `rhs`.
   !<
   !<```fortran
   !< type(vector) :: pt(0:2)
   !< pt(1) = 2 * ex + 3 * ey
   !< pt(2) = ex
   !< pt(0) = pt(1).paral.pt(2)
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 2.0 0.0 0.0 <<<
   class(vector), intent(in) :: lhs   !< Left hand side.
   type(vector),  intent(in) :: rhs   !< Right hand side.
   type(vector)              :: paral !< Component of of `lhs` parallel to `rhs`.

   paral = (lhs.dot.rhs) * normalized(rhs) / normL2(rhs)
   endfunction parallel

   ! operator `=`
   pure subroutine assign_vector(lhs, rhs)
   !< Operator `=`
   !<
   !<```fortran
   !< type(vector) :: pt
   !< pt = 1 * ex + 2 * ey + 3 * ez
   !< print "(3(F3.1,1X))", abs(pt%x), abs(pt%y), abs(pt%z)
   !<```
   !=> 1.0 2.0 3.0 <<<
   class(vector), intent(inout) :: lhs !< Left hand side.
   type(vector), intent(in)     :: rhs !< Right hand side.

   lhs%x = rhs%x
   lhs%y = rhs%y
   lhs%z = rhs%z
   endsubroutine assign_vector

   elemental subroutine assign_R16P(lhs, rhs)
   !< Operator `= real(R16P)`.
   !<
   !<```fortran
   !< use penf, only : R16P
   !< type(vector) :: pt
   !< pt = 1._R16P
   !< print "(3(F3.1,1X))", abs(pt%x), abs(pt%y), abs(pt%z)
   !<```
   !=> 1.0 1.0 1.0 <<<
   class(vector), intent(inout) :: lhs !< Left hand side.
   real(R16P),    intent(in)    :: rhs !< Right hand side.

   lhs%x = real(rhs, R_P)
   lhs%y = real(rhs, R_P)
   lhs%z = real(rhs, R_P)
   endsubroutine assign_R16P

   elemental subroutine assign_R8P(lhs, rhs)
   !< Operator `= real(R8P)`.
   !<
   !<```fortran
   !< use penf, only : R8P
   !< type(vector) :: pt
   !< pt = 1._R8P
   !< print "(3(F3.1,1X))", abs(pt%x), abs(pt%y), abs(pt%z)
   !<```
   !=> 1.0 1.0 1.0 <<<
   class(vector), intent(inout) :: lhs !< Left hand side.
   real(R8P),     intent(in)    :: rhs !< Right hand side.

   lhs%x = real(rhs, R_P)
   lhs%y = real(rhs, R_P)
   lhs%z = real(rhs, R_P)
   endsubroutine assign_R8P

   elemental subroutine assign_R4P(lhs, rhs)
   !< Operator `= real(R4P)`.
   !<
   !<```fortran
   !< use penf, only : R4P
   !< type(vector) :: pt
   !< pt = 1._R4P
   !< print "(3(F3.1,1X))", abs(pt%x), abs(pt%y), abs(pt%z)
   !<```
   !=> 1.0 1.0 1.0 <<<
   class(vector), intent(inout) :: lhs !< Left hand side.
   real(R4P),     intent(in)    :: rhs !< Right hand side.

   lhs%x = real(rhs, R_P)
   lhs%y = real(rhs, R_P)
   lhs%z = real(rhs, R_P)
   endsubroutine assign_R4P

   elemental subroutine assign_I8P(lhs, rhs)
   !< Operator `= integer(I8P)`.
   !<
   !<```fortran
   !< use penf, only : I8P
   !< type(vector) :: pt
   !< pt = 1_I8P
   !< print "(3(F3.1,1X))", abs(pt%x), abs(pt%y), abs(pt%z)
   !<```
   !=> 1.0 1.0 1.0 <<<
   class(vector), intent(inout) :: lhs !< Left hand side.
   integer(I8P),  intent(in)    :: rhs !< Right hand side.

   lhs%x = real(rhs, R_P)
   lhs%y = real(rhs, R_P)
   lhs%z = real(rhs, R_P)
   endsubroutine assign_I8P

   elemental subroutine assign_I4P(lhs, rhs)
   !< Operator `= integer(I4P)`.
   !<
   !<```fortran
   !< use penf, only : I4P
   !< type(vector) :: pt
   !< pt = 1_I4P
   !< print "(3(F3.1,1X))", abs(pt%x), abs(pt%y), abs(pt%z)
   !<```
   !=> 1.0 1.0 1.0 <<<
   class(vector), intent(inout) :: lhs !< Left hand side.
   integer(I4P),  intent(in)    :: rhs !< Right hand side.

   lhs%x = real(rhs, R_P)
   lhs%y = real(rhs, R_P)
   lhs%z = real(rhs, R_P)
   endsubroutine assign_I4P

   elemental subroutine assign_I2P(lhs, rhs)
   !< Operator `= integer(I4P)`.
   !<
   !<```fortran
   !< use penf, only : I2P
   !< type(vector) :: pt
   !< pt = 1_I2P
   !< print "(3(F3.1,1X))", abs(pt%x), abs(pt%y), abs(pt%z)
   !<```
   !=> 1.0 1.0 1.0 <<<
   class(vector), intent(inout) :: lhs !< Left hand side.
   integer(I2P),  intent(in)    :: rhs !< Right hand side.

   lhs%x = real(rhs, R_P)
   lhs%y = real(rhs, R_P)
   lhs%z = real(rhs, R_P)
   endsubroutine assign_I2P

   elemental subroutine assign_I1P(lhs, rhs)
   !< Operator `= integer(I4P)`.
   !<
   !<```fortran
   !< use penf, only : I1P
   !< type(vector) :: pt
   !< pt = 1_I1P
   !< print "(3(F3.1,1X))", abs(pt%x), abs(pt%y), abs(pt%z)
   !<```
   !=> 1.0 1.0 1.0 <<<
   class(vector), intent(inout) :: lhs !< Left hand side.
   integer(I1P),  intent(in)    :: rhs !< Right hand side.

   lhs%x = real(rhs, R_P)
   lhs%y = real(rhs, R_P)
   lhs%z = real(rhs, R_P)
   endsubroutine assign_I1P

   ! operator `*`
   elemental function vector_mul_vector(lhs, rhs) result(opr)
   !< Operator `*`.
   !<
   !<```fortran
   !< type(vector) :: pt(0:2)
   !< pt(1) = 1 * ex + 2 * ey + 1 * ez
   !< pt(2) = pt(1) + 1
   !< pt(0) = pt(1) * pt(2)
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 2.0 6.0 2.0 <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   type(vector),  intent(in) :: rhs !< Right hand side.
   type(vector)              :: opr !< Operator result.

   opr%x = lhs%x * rhs%x
   opr%y = lhs%y * rhs%y
   opr%z = lhs%z * rhs%z
   endfunction vector_mul_vector

   elemental function R16P_mul_vector(lhs, rhs) result(opr)
   !< Operator `real(R16P) *`.
   !<
   !<```fortran
   !< use penf, only : R16P
   !< type(vector) :: pt(0:1)
   !< pt(1) = 1 * ex + 2 * ey + 1 * ez
   !< pt(0) = 2._R16P * pt(1)
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 2.0 4.0 2.0 <<<
   real(R16P),    intent(in) :: lhs !< Left hand side.
   class(vector), intent(in) :: rhs !< Right hand side.
   type(vector)              :: opr !< Operator result.

   opr%x = real(lhs, R_P) * rhs%x
   opr%y = real(lhs, R_P) * rhs%y
   opr%z = real(lhs, R_P) * rhs%z
   endfunction R16P_mul_vector

   elemental function vector_mul_R16P(lhs, rhs) result(opr)
   !< Operator `* real(R16P)`.
   !<
   !<```fortran
   !< use penf, only : R16P
   !< type(vector) :: pt(0:1)
   !< pt(1) = 1 * ex + 2 * ey + 1 * ez
   !< pt(0) = pt(1) * 2._R16P
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 2.0 4.0 2.0 <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   real(R16P),    intent(in) :: rhs !< Right hand side.
   type(vector)              :: opr !< Operator result.

   opr%x = lhs%x * real(rhs, R_P)
   opr%y = lhs%y * real(rhs, R_P)
   opr%z = lhs%z * real(rhs, R_P)
   endfunction vector_mul_R16P

   elemental function R8P_mul_vector(lhs, rhs) result(opr)
   !< Operator `real(R8P) *`.
   !<
   !<```fortran
   !< use penf, only : R8P
   !< type(vector) :: pt(0:1)
   !< pt(1) = 1 * ex + 2 * ey + 1 * ez
   !< pt(0) = 2._R8P * pt(1)
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 2.0 4.0 2.0 <<<
   real(R8P),     intent(in) :: lhs !< Left hand side.
   class(vector), intent(in) :: rhs !< Right hand side.
   type(vector)              :: opr !< Operator result.

   opr%x = real(lhs, R_P) * rhs%x
   opr%y = real(lhs, R_P) * rhs%y
   opr%z = real(lhs, R_P) * rhs%z
   endfunction R8P_mul_vector

   elemental function vector_mul_R8P(lhs, rhs) result(opr)
   !< Operator `* real(R8P)`.
   !<
   !<```fortran
   !< use penf, only : R8P
   !< type(vector) :: pt(0:1)
   !< pt(1) = 1 * ex + 2 * ey + 1 * ez
   !< pt(0) = pt(1) * 2._R8P
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 2.0 4.0 2.0 <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   real(R8P),     intent(in) :: rhs !< Right hand side.
   type(vector)              :: opr !< Operator result.

   opr%x = lhs%x * real(rhs, R_P)
   opr%y = lhs%y * real(rhs, R_P)
   opr%z = lhs%z * real(rhs, R_P)
   endfunction vector_mul_R8P

   elemental function R4P_mul_vector(lhs, rhs) result(opr)
   !< Operator `real(R4P) *`.
   !<
   !<```fortran
   !< use penf, only : R4P
   !< type(vector) :: pt(0:1)
   !< pt(1) = 1 * ex + 2 * ey + 1 * ez
   !< pt(0) = 2._R4P * pt(1)
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 2.0 4.0 2.0 <<<
   real(R4P),     intent(in) :: lhs !< Left hand side.
   class(vector), intent(in) :: rhs !< Right hand side.
   type(vector)              :: opr !< Operator result.

   opr%x = real(lhs, R_P) * rhs%x
   opr%y = real(lhs, R_P) * rhs%y
   opr%z = real(lhs, R_P) * rhs%z
   endfunction R4P_mul_vector

   elemental function vector_mul_R4P(lhs, rhs) result(opr)
   !< Operator `* real(R4P)`.
   !<
   !<```fortran
   !< use penf, only : R4P
   !< type(vector) :: pt(0:1)
   !< pt(1) = 1 * ex + 2 * ey + 1 * ez
   !< pt(0) = pt(1) * 2._R4P
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 2.0 4.0 2.0 <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   real(R4P),     intent(in) :: rhs !< Right hand side.
   type(vector)              :: opr !< Operator result.

   opr%x = lhs%x * real(rhs, R_P)
   opr%y = lhs%y * real(rhs, R_P)
   opr%z = lhs%z * real(rhs, R_P)
   endfunction vector_mul_R4P

   elemental function I8P_mul_vector(lhs, rhs) result(opr)
   !< Operator `integer(I8P) *`.
   !<
   !<```fortran
   !< use penf, only : I8P
   !< type(vector) :: pt(0:1)
   !< pt(1) = 1 * ex + 2 * ey + 1 * ez
   !< pt(0) = 2_I8P * pt(1)
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 2.0 4.0 2.0 <<<
   integer(I8P),  intent(in) :: lhs !< Left hand side.
   class(vector), intent(in) :: rhs !< Right hand side.
   type(vector)              :: opr !< Operator result.

   opr%x = real(lhs, R_P) * rhs%x
   opr%y = real(lhs, R_P) * rhs%y
   opr%z = real(lhs, R_P) * rhs%z
   endfunction I8P_mul_vector

   elemental function vector_mul_I8P(lhs, rhs) result(opr)
   !< Operator `* integer(I8P)`.
   !<
   !<```fortran
   !< use penf, only : I8P
   !< type(vector) :: pt(0:1)
   !< pt(1) = 1 * ex + 2 * ey + 1 * ez
   !< pt(0) = pt(1) * 2_I8P
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 2.0 4.0 2.0 <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   integer(I8P),  intent(in) :: rhs !< Right hand side.
   type(vector)              :: opr !< Operator result.

   opr%x = lhs%x * real(rhs, R_P)
   opr%y = lhs%y * real(rhs, R_P)
   opr%z = lhs%z * real(rhs, R_P)
   endfunction vector_mul_I8P

   elemental function I4P_mul_vector(lhs, rhs) result(opr)
   !< Operator `integer(I4P) *`.
   !<
   !<```fortran
   !< use penf, only : I4P
   !< type(vector) :: pt(0:1)
   !< pt(1) = 1 * ex + 2 * ey + 1 * ez
   !< pt(0) = 2_I4P * pt(1)
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 2.0 4.0 2.0 <<<
   integer(I4P),  intent(in) :: lhs !< Left hand side.
   class(vector), intent(in) :: rhs !< Right hand side.
   type(vector)              :: opr !< Operator result.

   opr%x = real(lhs, R_P) * rhs%x
   opr%y = real(lhs, R_P) * rhs%y
   opr%z = real(lhs, R_P) * rhs%z
   endfunction I4P_mul_vector

   elemental function vector_mul_I4P(lhs, rhs) result(opr)
   !< Operator `* integer(I4P)`.
   !<
   !<```fortran
   !< use penf, only : I4P
   !< type(vector) :: pt(0:1)
   !< pt(1) = 1 * ex + 2 * ey + 1 * ez
   !< pt(0) = pt(1) * 2_I4P
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 2.0 4.0 2.0 <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   integer(I4P),  intent(in) :: rhs !< Right hand side.
   type(vector)              :: opr !< Operator result.

   opr%x = lhs%x * real(rhs, R_P)
   opr%y = lhs%y * real(rhs, R_P)
   opr%z = lhs%z * real(rhs, R_P)
   endfunction vector_mul_I4P

   elemental function I2P_mul_vector(lhs, rhs) result(opr)
   !< Operator `integer(I2P) *`.
   !<
   !<```fortran
   !< use penf, only : I2P
   !< type(vector) :: pt(0:1)
   !< pt(1) = 1 * ex + 2 * ey + 1 * ez
   !< pt(0) = 2_I2P * pt(1)
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 2.0 4.0 2.0 <<<
   integer(I2P),  intent(in) :: lhs !< Left hand side.
   class(vector), intent(in) :: rhs !< Right hand side.
   type(vector)              :: opr !< Operator result.

   opr%x = real(lhs, R_P) * rhs%x
   opr%y = real(lhs, R_P) * rhs%y
   opr%z = real(lhs, R_P) * rhs%z
   endfunction I2P_mul_vector

   elemental function vector_mul_I2P(lhs, rhs) result(opr)
   !< Operator `* integer(I2P)`.
   !<
   !<```fortran
   !< use penf, only : I2P
   !< type(vector) :: pt(0:1)
   !< pt(1) = 1 * ex + 2 * ey + 1 * ez
   !< pt(0) = pt(1) * 2_I2P
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 2.0 4.0 2.0 <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   integer(I2P),  intent(in) :: rhs !< Right hand side.
   type(vector)              :: opr !< Operator result.

   opr%x = lhs%x * real(rhs, R_P)
   opr%y = lhs%y * real(rhs, R_P)
   opr%z = lhs%z * real(rhs, R_P)
   endfunction vector_mul_I2P

   elemental function I1P_mul_vector(lhs, rhs) result(opr)
   !< Operator `integer(I1P) *`.
   !<
   !<```fortran
   !< use penf, only : I1P
   !< type(vector) :: pt(0:1)
   !< pt(1) = 1 * ex + 2 * ey + 1 * ez
   !< pt(0) = 2_I1P * pt(1)
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 2.0 4.0 2.0 <<<
   integer(I1P),  intent(in) :: lhs !< Left hand side.
   class(vector), intent(in) :: rhs !< Right hand side.
   type(vector)              :: opr !< Operator result.

   opr%x = real(lhs, R_P) * rhs%x
   opr%y = real(lhs, R_P) * rhs%y
   opr%z = real(lhs, R_P) * rhs%z
   endfunction I1P_mul_vector

   elemental function vector_mul_I1P(lhs, rhs) result(opr)
   !< Operator `* integer(I1P)`.
   !<
   !<```fortran
   !< use penf, only : I1P
   !< type(vector) :: pt(0:1)
   !< pt(1) = 1 * ex + 2 * ey + 1 * ez
   !< pt(0) = pt(1) * 2_I1P
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 2.0 4.0 2.0 <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   integer(I1P),  intent(in) :: rhs !< Right hand side.
   type(vector)              :: opr !< Operator result.

   opr%x = lhs%x * real(rhs, R_P)
   opr%y = lhs%y * real(rhs, R_P)
   opr%z = lhs%z * real(rhs, R_P)
   endfunction vector_mul_I1P

   ! operator `/`
   elemental function vector_div_vector(lhs, rhs) result(opr)
   !< Operator `/`.
   !<
   !<```fortran
   !< type(vector) :: pt(0:2)
   !< pt(1) = 1 * ex + 1 * ey + 1 * ez
   !< pt(2) = pt(1) + 1
   !< pt(0) = pt(1) / pt(2)
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 0.5 0.5 0.5 <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   type(vector),  intent(in) :: rhs !< Right hand side.
   type(vector)              :: opr !< Operator result.

   opr%x = lhs%x / rhs%x
   opr%y = lhs%y / rhs%y
   opr%z = lhs%z / rhs%z
   endfunction vector_div_vector

   elemental function vector_div_R16P(lhs, rhs) result(opr)
   !< Operator `/ real(R16P)`.
   !<
   !<```fortran
   !< use penf, only : R16P
   !< type(vector) :: pt(0:1)
   !< pt(1) = 1 * ex + 2 * ey + 1 * ez
   !< pt(0) = pt(1) / 2._R16P
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 0.5 1.0 0.5 <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   real(R16P),    intent(in) :: rhs !< Right hand side.
   type(vector)              :: opr !< Operator result.

   opr%x = lhs%x / real(rhs, R_P)
   opr%y = lhs%y / real(rhs, R_P)
   opr%z = lhs%z / real(rhs, R_P)
   endfunction vector_div_R16P

   elemental function vector_div_R8P(lhs, rhs) result(opr)
   !< Operator `/ real(R8P)`.
   !<
   !<```fortran
   !< use penf, only : R8P
   !< type(vector) :: pt(0:1)
   !< pt(1) = 1 * ex + 2 * ey + 1 * ez
   !< pt(0) = pt(1) / 2._R8P
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 0.5 1.0 0.5 <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   real(R8P),     intent(in) :: rhs !< Right hand side.
   type(vector)              :: opr !< Operator result.

   opr%x = lhs%x / real(rhs, R_P)
   opr%y = lhs%y / real(rhs, R_P)
   opr%z = lhs%z / real(rhs, R_P)
   endfunction vector_div_R8P

   elemental function vector_div_R4P(lhs, rhs) result(opr)
   !< Operator `/ real(R4P)`.
   !<
   !<```fortran
   !< use penf, only : R4P
   !< type(vector) :: pt(0:1)
   !< pt(1) = 1 * ex + 2 * ey + 1 * ez
   !< pt(0) = pt(1) / 2._R4P
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 0.5 1.0 0.5 <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   real(R4P),     intent(in) :: rhs !< Right hand side.
   type(vector)              :: opr !< Operator result.

   opr%x = lhs%x / real(rhs, R_P)
   opr%y = lhs%y / real(rhs, R_P)
   opr%z = lhs%z / real(rhs, R_P)
   endfunction vector_div_R4P

   elemental function vector_div_I8P(lhs, rhs) result(opr)
   !< Operator `/ integer(I8P)`.
   !<
   !<```fortran
   !< use penf, only : I8P
   !< type(vector) :: pt(0:1)
   !< pt(1) = 1 * ex + 2 * ey + 1 * ez
   !< pt(0) = pt(1) / 2_I8P
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 0.5 1.0 0.5 <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   integer(I8P),  intent(in) :: rhs !< Right hand side.
   type(vector)              :: opr !< Operator result.

   opr%x = lhs%x / real(rhs, R_P)
   opr%y = lhs%y / real(rhs, R_P)
   opr%z = lhs%z / real(rhs, R_P)
   endfunction vector_div_I8P

   elemental function vector_div_I4P(lhs, rhs) result(opr)
   !< Operator `/ integer(I4P)`.
   !<
   !<```fortran
   !< use penf, only : I4P
   !< type(vector) :: pt(0:1)
   !< pt(1) = 1 * ex + 2 * ey + 1 * ez
   !< pt(0) = pt(1) / 2_I4P
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 0.5 1.0 0.5 <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   integer(I4P),  intent(in) :: rhs !< Right hand side.
   type(vector)              :: opr !< Operator result.

   opr%x = lhs%x / real(rhs, R_P)
   opr%y = lhs%y / real(rhs, R_P)
   opr%z = lhs%z / real(rhs, R_P)
   endfunction vector_div_I4P

   elemental function vector_div_I2P(lhs, rhs) result(opr)
   !< Operator `/ integer(I2P)`.
   !<
   !<```fortran
   !< use penf, only : I2P
   !< type(vector) :: pt(0:1)
   !< pt(1) = 1 * ex + 2 * ey + 1 * ez
   !< pt(0) = pt(1) / 2_I2P
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 0.5 1.0 0.5 <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   integer(I2P),  intent(in) :: rhs !< Right hand side.
   type(vector)              :: opr !< Operator result.

   opr%x = lhs%x / real(rhs, R_P)
   opr%y = lhs%y / real(rhs, R_P)
   opr%z = lhs%z / real(rhs, R_P)
   endfunction vector_div_I2P

   elemental function vector_div_I1P(lhs, rhs) result(opr)
   !< Operator `/ integer(I1P)`.
   !<
   !<```fortran
   !< use penf, only : I1P
   !< type(vector) :: pt(0:1)
   !< pt(1) = 1 * ex + 2 * ey + 1 * ez
   !< pt(0) = pt(1) / 2_I1P
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 0.5 1.0 0.5 <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   integer(I1P),  intent(in) :: rhs !< Right hand side.
   type(vector)              :: opr !< Operator result.

   opr%x = lhs%x / real(rhs, R_P)
   opr%y = lhs%y / real(rhs, R_P)
   opr%z = lhs%z / real(rhs, R_P)
   endfunction vector_div_I1P

   ! operator `+`
   elemental function positive(rhs) result(opr)
   !< Operator `+` unary.
   !<
   !<```fortran
   !< type(vector) :: pt(0:1)
   !< pt(1) = 1 * ex + 2 * ey + 1 * ez
   !< pt(0) = + pt(1)
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 1.0 2.0 1.0 <<<
   class(vector), intent(in) :: rhs !< Right hand side.
   type(vector)              :: opr !< Operator result.

   opr%x = + rhs%x
   opr%y = + rhs%y
   opr%z = + rhs%z
   endfunction positive

   elemental function vector_sum_vector(lhs, rhs) result(opr)
   !< Operator `+`.
   !<
   !<```fortran
   !< type(vector) :: pt(0:2)
   !< pt(1) = 1 * ex + 1 * ey + 1 * ez
   !< pt(2) = pt(1) + 1
   !< pt(0) = pt(1) + pt(2)
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 3.0 3.0 3.0 <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   type(vector),  intent(in) :: rhs !< Right hand side.
   type(vector)              :: opr !< Operator result.

   opr%x = lhs%x + rhs%x
   opr%y = lhs%y + rhs%y
   opr%z = lhs%z + rhs%z
   endfunction vector_sum_vector

   elemental function R16P_sum_vector(lhs, rhs) result(opr)
   !< Operator `real(R16P) +`.
   !<
   !<```fortran
   !< use penf, only : R16P
   !< type(vector) :: pt(0:1)
   !< pt(1) = 1 * ex + 2 * ey + 1 * ez
   !< pt(0) = 2._R16P + pt(1)
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 3.0 4.0 3.0 <<<
   real(R16P),    intent(in) :: lhs !< Left hand side.
   class(vector), intent(in) :: rhs !< Right hand side.
   type(vector)              :: opr !< Operator result.

   opr%x = real(lhs, R_P) + rhs%x
   opr%y = real(lhs, R_P) + rhs%y
   opr%z = real(lhs, R_P) + rhs%z
   endfunction R16P_sum_vector

   elemental function vector_sum_R16P(lhs, rhs) result(opr)
   !< Operator `+ real(R16P)`.
   !<
   !<```fortran
   !< use penf, only : R16P
   !< type(vector) :: pt(0:1)
   !< pt(1) = 1 * ex + 2 * ey + 1 * ez
   !< pt(0) = pt(1) + 2._R16P
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 3.0 4.0 3.0 <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   real(R16P),    intent(in) :: rhs !< Right hand side.
   type(vector)              :: opr !< Operator result.

   opr%x = lhs%x + real(rhs, R_P)
   opr%y = lhs%y + real(rhs, R_P)
   opr%z = lhs%z + real(rhs, R_P)
   endfunction vector_sum_R16P

   elemental function R8P_sum_vector(lhs, rhs) result(opr)
   !< Operator `real(R8P) +`.
   !<
   !<```fortran
   !< use penf, only : R8P
   !< type(vector) :: pt(0:1)
   !< pt(1) = 1 * ex + 2 * ey + 1 * ez
   !< pt(0) = 2._R8P + pt(1)
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 3.0 4.0 3.0 <<<
   real(R8P),     intent(in) :: lhs !< Left hand side.
   class(vector), intent(in) :: rhs !< Right hand side.
   type(vector)              :: opr !< Operator result.

   opr%x = real(lhs, R_P) + rhs%x
   opr%y = real(lhs, R_P) + rhs%y
   opr%z = real(lhs, R_P) + rhs%z
   endfunction R8P_sum_vector

   elemental function vector_sum_R8P(lhs, rhs) result(opr)
   !< Operator `+ real(R8P)`.
   !<
   !<```fortran
   !< use penf, only : R8P
   !< type(vector) :: pt(0:1)
   !< pt(1) = 1 * ex + 2 * ey + 1 * ez
   !< pt(0) = pt(1) + 2._R8P
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 3.0 4.0 3.0 <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   real(R8P),     intent(in) :: rhs !< Right hand side.
   type(vector)              :: opr !< Operator result.

   opr%x = lhs%x + real(rhs, R_P)
   opr%y = lhs%y + real(rhs, R_P)
   opr%z = lhs%z + real(rhs, R_P)
   endfunction vector_sum_R8P

   elemental function R4P_sum_vector(lhs, rhs) result(opr)
   !< Operator `real(R4P) +`.
   !<
   !<```fortran
   !< use penf, only : R4P
   !< type(vector) :: pt(0:1)
   !< pt(1) = 1 * ex + 2 * ey + 1 * ez
   !< pt(0) = 2._R4P + pt(1)
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 3.0 4.0 3.0 <<<
   real(R4P),     intent(in) :: lhs !< Left hand side.
   class(vector), intent(in) :: rhs !< Right hand side.
   type(vector)              :: opr !< Operator result.

   opr%x = real(lhs, R_P) + rhs%x
   opr%y = real(lhs, R_P) + rhs%y
   opr%z = real(lhs, R_P) + rhs%z
   endfunction R4P_sum_vector

   elemental function vector_sum_R4P(lhs, rhs) result(opr)
   !< Operator `+ real(R4P)`.
   !<
   !<```fortran
   !< use penf, only : R4P
   !< type(vector) :: pt(0:1)
   !< pt(1) = 1 * ex + 2 * ey + 1 * ez
   !< pt(0) = pt(1) + 2._R4P
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 3.0 4.0 3.0 <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   real(R4P),     intent(in) :: rhs !< Right hand side.
   type(vector)              :: opr !< Operator result.

   opr%x = lhs%x + real(rhs, R_P)
   opr%y = lhs%y + real(rhs, R_P)
   opr%z = lhs%z + real(rhs, R_P)
   endfunction vector_sum_R4P

   elemental function I8P_sum_vector(lhs, rhs) result(opr)
   !< Operator `integer(I8P) +`.
   !<
   !<```fortran
   !< use penf, only : I8P
   !< type(vector) :: pt(0:1)
   !< pt(1) = 1 * ex + 2 * ey + 1 * ez
   !< pt(0) = 2_I8P + pt(1)
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 3.0 4.0 3.0 <<<
   integer(I8P),  intent(in) :: lhs !< Left hand side.
   class(vector), intent(in) :: rhs !< Right hand side.
   type(vector)              :: opr !< Operator result.

   opr%x = real(lhs, R_P) + rhs%x
   opr%y = real(lhs, R_P) + rhs%y
   opr%z = real(lhs, R_P) + rhs%z
   endfunction I8P_sum_vector

   elemental function vector_sum_I8P(lhs, rhs) result(opr)
   !< Operator `+ integer(I8P)`.
   !<
   !<```fortran
   !< use penf, only : I8P
   !< type(vector) :: pt(0:1)
   !< pt(1) = 1 * ex + 2 * ey + 1 * ez
   !< pt(0) = pt(1) + 2_I8P
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 3.0 4.0 3.0 <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   integer(I8P),  intent(in) :: rhs !< Right hand side.
   type(vector)              :: opr !< Operator result.

   opr%x = lhs%x + real(rhs, R_P)
   opr%y = lhs%y + real(rhs, R_P)
   opr%z = lhs%z + real(rhs, R_P)
   endfunction vector_sum_I8P

   elemental function I4P_sum_vector(lhs, rhs) result(opr)
   !< Operator `integer(I4P) +`.
   !<
   !<```fortran
   !< use penf, only : I4P
   !< type(vector) :: pt(0:1)
   !< pt(1) = 1 * ex + 2 * ey + 1 * ez
   !< pt(0) = 2_I4P + pt(1)
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 3.0 4.0 3.0 <<<
   integer(I4P),  intent(in) :: lhs !< Left hand side.
   class(vector), intent(in) :: rhs !< Right hand side.
   type(vector)              :: opr !< Operator result.

   opr%x = real(lhs, R_P) + rhs%x
   opr%y = real(lhs, R_P) + rhs%y
   opr%z = real(lhs, R_P) + rhs%z
   endfunction I4P_sum_vector

   elemental function vector_sum_I4P(lhs, rhs) result(opr)
   !< Operator `+ integer(I4P)`.
   !<
   !<```fortran
   !< use penf, only : I4P
   !< type(vector) :: pt(0:1)
   !< pt(1) = 1 * ex + 2 * ey + 1 * ez
   !< pt(0) = pt(1) + 2_I4P
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 3.0 4.0 3.0 <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   integer(I4P),  intent(in) :: rhs !< Right hand side.
   type(vector)              :: opr !< Operator result.

   opr%x = lhs%x + real(rhs, R_P)
   opr%y = lhs%y + real(rhs, R_P)
   opr%z = lhs%z + real(rhs, R_P)
   endfunction vector_sum_I4P

   elemental function I2P_sum_vector(lhs, rhs) result(opr)
   !< Operator `integer(I2P) +`.
   !<
   !<```fortran
   !< use penf, only : I2P
   !< type(vector) :: pt(0:1)
   !< pt(1) = 1 * ex + 2 * ey + 1 * ez
   !< pt(0) = 2_I2P + pt(1)
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 3.0 4.0 3.0 <<<
   integer(I2P),  intent(in) :: lhs !< Left hand side.
   class(vector), intent(in) :: rhs !< Right hand side.
   type(vector)              :: opr !< Operator result.

   opr%x = real(lhs, R_P) + rhs%x
   opr%y = real(lhs, R_P) + rhs%y
   opr%z = real(lhs, R_P) + rhs%z
   endfunction I2P_sum_vector

   elemental function vector_sum_I2P(lhs, rhs) result(opr)
   !< Operator `+ integer(I2P)`.
   !<
   !<```fortran
   !< use penf, only : I2P
   !< type(vector) :: pt(0:1)
   !< pt(1) = 1 * ex + 2 * ey + 1 * ez
   !< pt(0) = pt(1) + 2_I2P
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 3.0 4.0 3.0 <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   integer(I2P),  intent(in) :: rhs !< Right hand side.
   type(vector)              :: opr !< Operator result.

   opr%x = lhs%x + real(rhs, R_P)
   opr%y = lhs%y + real(rhs, R_P)
   opr%z = lhs%z + real(rhs, R_P)
   endfunction vector_sum_I2P

   elemental function I1P_sum_vector(lhs, rhs) result(opr)
   !< Operator `integer(I1P) +`.
   !<
   !<```fortran
   !< use penf, only : I1P
   !< type(vector) :: pt(0:1)
   !< pt(1) = 1 * ex + 2 * ey + 1 * ez
   !< pt(0) = 2_I1P + pt(1)
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 3.0 4.0 3.0 <<<
   integer(I1P),  intent(in) :: lhs !< Left hand side.
   class(vector), intent(in) :: rhs !< Right hand side.
   type(vector)              :: opr !< Operator result.

   opr%x = real(lhs, R_P) + rhs%x
   opr%y = real(lhs, R_P) + rhs%y
   opr%z = real(lhs, R_P) + rhs%z
   endfunction I1P_sum_vector

   elemental function vector_sum_I1P(lhs, rhs) result(opr)
   !< Operator `+ integer(I1P)`.
   !<
   !<```fortran
   !< use penf, only : I1P
   !< type(vector) :: pt(0:1)
   !< pt(1) = 1 * ex + 2 * ey + 1 * ez
   !< pt(0) = pt(1) + 2_I1P
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 3.0 4.0 3.0 <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   integer(I1P),  intent(in) :: rhs !< Right hand side.
   type(vector)              :: opr !< Operator result.

   opr%x = lhs%x + real(rhs, R_P)
   opr%y = lhs%y + real(rhs, R_P)
   opr%z = lhs%z + real(rhs, R_P)
   endfunction vector_sum_I1P

   ! operator `-`
   elemental function negative(rhs) result(opr)
   !< Operator `-` unary.
   !<
   !<```fortran
   !< type(vector) :: pt(0:1)
   !< pt(1) = 1 * ex + 2 * ey + 1 * ez
   !< pt(0) = - pt(1)
   !< print "(3(F4.1,1X))", pt(0)%x, pt(0)%y, pt(0)%z
   !<```
   !=> -1.0 -2.0 -1.0 <<<
   class(vector), intent(in) :: rhs !< Right hand side.
   type(vector)              :: opr !< Operator result.

   opr%x = - rhs%x
   opr%y = - rhs%y
   opr%z = - rhs%z
   endfunction negative

   elemental function vector_sub_vector(lhs, rhs) result(opr)
   !< Operator `-`.
   !<
   !<```fortran
   !< type(vector) :: pt(0:2)
   !< pt(1) = 1 * ex + 1 * ey + 1 * ez
   !< pt(2) = pt(1) + 1
   !< pt(0) = pt(1) - pt(2)
   !< print "(3(F4.1,1X))", pt(0)%x, pt(0)%y, pt(0)%z
   !<```
   !=> -1.0 -1.0 -1.0 <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   type(vector),  intent(in) :: rhs !< Right hand side.
   type(vector)              :: opr !< Operator result.

   opr%x = lhs%x - rhs%x
   opr%y = lhs%y - rhs%y
   opr%z = lhs%z - rhs%z
   endfunction vector_sub_vector

   elemental function R16P_sub_vector(lhs, rhs) result(opr)
   !< Operator `real(R16P) -`.
   !<
   !<```fortran
   !< use penf, only : R16P
   !< type(vector) :: pt(0:1)
   !< pt(1) = 1 * ex + 2 * ey + 1 * ez
   !< pt(0) = 2._R16P - pt(1)
   !< print "(3(F3.1,1X))", pt(0)%x, pt(0)%y, pt(0)%z
   !<```
   !=> 1.0 0.0 1.0 <<<
   real(R16P),    intent(in) :: lhs !< Left hand side.
   class(vector), intent(in) :: rhs !< Right hand side.
   type(vector)              :: opr !< Operator result.

   opr%x = real(lhs, R_P) - rhs%x
   opr%y = real(lhs, R_P) - rhs%y
   opr%z = real(lhs, R_P) - rhs%z
   endfunction R16P_sub_vector

   elemental function vector_sub_R16P(lhs, rhs) result(opr)
   !< Operator `- real(R16P)`.
   !<
   !<```fortran
   !< use penf, only : R16P
   !< type(vector) :: pt(0:1)
   !< pt(1) = 1 * ex + 2 * ey + 1 * ez
   !< pt(0) = pt(1) - 2._R16P
   !< print "(3(F4.1,1X))", pt(0)%x, pt(0)%y, pt(0)%z
   !<```
   !=> -1.0  0.0 -1.0 <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   real(R16P),    intent(in) :: rhs !< Right hand side.
   type(vector)              :: opr !< Operator result.

   opr%x = lhs%x - real(rhs, R_P)
   opr%y = lhs%y - real(rhs, R_P)
   opr%z = lhs%z - real(rhs, R_P)
   endfunction vector_sub_R16P

   elemental function R8P_sub_vector(lhs, rhs) result(opr)
   !< Operator `real(R8P) -`.
   !<
   !<```fortran
   !< use penf, only : R8P
   !< type(vector) :: pt(0:1)
   !< pt(1) = 1 * ex + 2 * ey + 1 * ez
   !< pt(0) = 2._R8P - pt(1)
   !< print "(3(F3.1,1X))", pt(0)%x, pt(0)%y, pt(0)%z
   !<```
   !=> 1.0 0.0 1.0 <<<
   real(R8P),     intent(in) :: lhs !< Left hand side.
   class(vector), intent(in) :: rhs !< Right hand side.
   type(vector)              :: opr !< Operator result.

   opr%x = real(lhs, R_P) - rhs%x
   opr%y = real(lhs, R_P) - rhs%y
   opr%z = real(lhs, R_P) - rhs%z
   endfunction R8P_sub_vector

   elemental function vector_sub_R8P(lhs, rhs) result(opr)
   !< Operator `- real(R8P)`.
   !<
   !<```fortran
   !< use penf, only : R8P
   !< type(vector) :: pt(0:1)
   !< pt(1) = 1 * ex + 2 * ey + 1 * ez
   !< pt(0) = pt(1) - 2._R8P
   !< print "(3(F4.1,1X))", pt(0)%x, pt(0)%y, pt(0)%z
   !<```
   !=> -1.0  0.0 -1.0 <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   real(R8P),     intent(in) :: rhs !< Right hand side.
   type(vector)              :: opr !< Operator result.

   opr%x = lhs%x - real(rhs, R_P)
   opr%y = lhs%y - real(rhs, R_P)
   opr%z = lhs%z - real(rhs, R_P)
   endfunction vector_sub_R8P

   elemental function R4P_sub_vector(lhs, rhs) result(opr)
   !< Operator `real(R4P) -`.
   !<
   !<```fortran
   !< use penf, only : R4P
   !< type(vector) :: pt(0:1)
   !< pt(1) = 1 * ex + 2 * ey + 1 * ez
   !< pt(0) = 2._R4P - pt(1)
   !< print "(3(F3.1,1X))", pt(0)%x, pt(0)%y, pt(0)%z
   !<```
   !=> 1.0 0.0 1.0 <<<
   real(R4P),     intent(in) :: lhs !< Left hand side.
   class(vector), intent(in) :: rhs !< Right hand side.
   type(vector)              :: opr !< Operator result.

   opr%x = real(lhs, R_P) - rhs%x
   opr%y = real(lhs, R_P) - rhs%y
   opr%z = real(lhs, R_P) - rhs%z
   endfunction R4P_sub_vector

   elemental function vector_sub_R4P(lhs, rhs) result(opr)
   !< Operator `- real(R4P)`.
   !<
   !<```fortran
   !< use penf, only : R4P
   !< type(vector) :: pt(0:1)
   !< pt(1) = 1 * ex + 2 * ey + 1 * ez
   !< pt(0) = pt(1) - 2._R4P
   !< print "(3(F4.1,1X))", pt(0)%x, pt(0)%y, pt(0)%z
   !<```
   !=> -1.0  0.0 -1.0 <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   real(R4P),     intent(in) :: rhs !< Right hand side.
   type(vector)              :: opr !< Operator result.

   opr%x = lhs%x - real(rhs, R_P)
   opr%y = lhs%y - real(rhs, R_P)
   opr%z = lhs%z - real(rhs, R_P)
   endfunction vector_sub_R4P

   elemental function I8P_sub_vector(lhs, rhs) result(opr)
   !< Operator `integer(I8P) -`.
   !<
   !<```fortran
   !< use penf, only : I8P
   !< type(vector) :: pt(0:1)
   !< pt(1) = 1 * ex + 2 * ey + 1 * ez
   !< pt(0) = 2_I8P - pt(1)
   !< print "(3(F3.1,1X))", pt(0)%x, pt(0)%y, pt(0)%z
   !<```
   !=> 1.0 0.0 1.0 <<<
   integer(I8P),  intent(in) :: lhs !< Left hand side.
   class(vector), intent(in) :: rhs !< Right hand side.
   type(vector)              :: opr !< Operator result.

   opr%x = real(lhs, R_P) - rhs%x
   opr%y = real(lhs, R_P) - rhs%y
   opr%z = real(lhs, R_P) - rhs%z
   endfunction I8P_sub_vector

   elemental function vector_sub_I8P(lhs, rhs) result(opr)
   !< Operator `- integer(I8P)`.
   !<
   !<```fortran
   !< use penf, only : I8P
   !< type(vector) :: pt(0:1)
   !< pt(1) = 1 * ex + 2 * ey + 1 * ez
   !< pt(0) = pt(1) - 2_I8P
   !< print "(3(F4.1,1X))", pt(0)%x, pt(0)%y, pt(0)%z
   !<```
   !=> -1.0  0.0 -1.0 <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   integer(I8P),  intent(in) :: rhs !< Right hand side.
   type(vector)              :: opr !< Operator result.

   opr%x = lhs%x - real(rhs, R_P)
   opr%y = lhs%y - real(rhs, R_P)
   opr%z = lhs%z - real(rhs, R_P)
   endfunction vector_sub_I8P

   elemental function I4P_sub_vector(lhs, rhs) result(opr)
   !< Operator `integer(I4P) -`.
   !<
   !<```fortran
   !< use penf, only : I4P
   !< type(vector) :: pt(0:1)
   !< pt(1) = 1 * ex + 2 * ey + 1 * ez
   !< pt(0) = 2_I4P - pt(1)
   !< print "(3(F3.1,1X))", pt(0)%x, pt(0)%y, pt(0)%z
   !<```
   !=> 1.0 0.0 1.0 <<<
   integer(I4P),  intent(in) :: lhs !< Left hand side.
   class(vector), intent(in) :: rhs !< Right hand side.
   type(vector)              :: opr !< Operator result.

   opr%x = real(lhs, R_P) - rhs%x
   opr%y = real(lhs, R_P) - rhs%y
   opr%z = real(lhs, R_P) - rhs%z
   endfunction I4P_sub_vector

   elemental function vector_sub_I4P(lhs, rhs) result(opr)
   !< Operator `- integer(I4P)`.
   !<
   !<```fortran
   !< use penf, only : I4P
   !< type(vector) :: pt(0:1)
   !< pt(1) = 1 * ex + 2 * ey + 1 * ez
   !< pt(0) = pt(1) - 2_I4P
   !< print "(3(F4.1,1X))", pt(0)%x, pt(0)%y, pt(0)%z
   !<```
   !=> -1.0  0.0 -1.0 <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   integer(I4P),  intent(in) :: rhs !< Right hand side.
   type(vector)              :: opr !< Operator result.

   opr%x = lhs%x - real(rhs, R_P)
   opr%y = lhs%y - real(rhs, R_P)
   opr%z = lhs%z - real(rhs, R_P)
   endfunction vector_sub_I4P

   elemental function I2P_sub_vector(lhs, rhs) result(opr)
   !< Operator `integer(I2P) -`.
   !<
   !<```fortran
   !< use penf, only : I2P
   !< type(vector) :: pt(0:1)
   !< pt(1) = 1 * ex + 2 * ey + 1 * ez
   !< pt(0) = 2_I2P - pt(1)
   !< print "(3(F3.1,1X))", pt(0)%x, pt(0)%y, pt(0)%z
   !<```
   !=> 1.0 0.0 1.0 <<<
   integer(I2P),  intent(in) :: lhs !< Left hand side.
   class(vector), intent(in) :: rhs !< Right hand side.
   type(vector)              :: opr !< Operator result.

   opr%x = real(lhs, R_P) - rhs%x
   opr%y = real(lhs, R_P) - rhs%y
   opr%z = real(lhs, R_P) - rhs%z
   endfunction I2P_sub_vector

   elemental function vector_sub_I2P(lhs, rhs) result(opr)
   !< Operator `- integer(I2P)`.
   !<
   !<```fortran
   !< use penf, only : I2P
   !< type(vector) :: pt(0:1)
   !< pt(1) = 1 * ex + 2 * ey + 1 * ez
   !< pt(0) = pt(1) - 2_I2P
   !< print "(3(F4.1,1X))", pt(0)%x, pt(0)%y, pt(0)%z
   !<```
   !=> -1.0  0.0 -1.0 <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   integer(I2P),  intent(in) :: rhs !< Right hand side.
   type(vector)              :: opr !< Operator result.

   opr%x = lhs%x - real(rhs, R_P)
   opr%y = lhs%y - real(rhs, R_P)
   opr%z = lhs%z - real(rhs, R_P)
   endfunction vector_sub_I2P

   elemental function I1P_sub_vector(lhs, rhs) result(opr)
   !< Operator `integer(I1P) -`.
   !<
   !<```fortran
   !< use penf, only : I1P
   !< type(vector) :: pt(0:1)
   !< pt(1) = 1 * ex + 2 * ey + 1 * ez
   !< pt(0) = 2_I1P - pt(1)
   !< print "(3(F3.1,1X))", pt(0)%x, pt(0)%y, pt(0)%z
   !<```
   !=> 1.0 0.0 1.0 <<<
   integer(I1P),  intent(in) :: lhs !< Left hand side.
   class(vector), intent(in) :: rhs !< Right hand side.
   type(vector)              :: opr !< Operator result.

   opr%x = real(lhs, R_P) - rhs%x
   opr%y = real(lhs, R_P) - rhs%y
   opr%z = real(lhs, R_P) - rhs%z
   endfunction I1P_sub_vector

   elemental function vector_sub_I1P(lhs, rhs) result(opr)
   !< Operator `- integer(I1P)`.
   !<
   !<```fortran
   !< use penf, only : I1P
   !< type(vector) :: pt(0:1)
   !< pt(1) = 1 * ex + 2 * ey + 1 * ez
   !< pt(0) = pt(1) - 2_I1P
   !< print "(3(F4.1,1X))", pt(0)%x, pt(0)%y, pt(0)%z
   !<```
   !=> -1.0  0.0 -1.0 <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   integer(I1P),  intent(in) :: rhs !< Right hand side.
   type(vector)              :: opr !< Operator result.

   opr%x = lhs%x - real(rhs, R_P)
   opr%y = lhs%y - real(rhs, R_P)
   opr%z = lhs%z - real(rhs, R_P)
   endfunction vector_sub_I1P

   ! operator `/=`
   elemental function vector_not_eq_vector(lhs, rhs) result(opr)
   !< Operator `/=`.
   !<
   !< The comparison is done with respect normL2 and, secondary, with respect the directions.
   !<
   !<```fortran
   !< type(vector) :: pt(1:2)
   !< pt(1) = ex + ey + ez
   !< pt(2) = pt(1) + 1
   !< print "(L1)", pt(1) /= pt(2)
   !<```
   !=> T <<<
   !<
   !<```fortran
   !< type(vector) :: pt(1:2)
   !< pt(1) = ex + ey + ez
   !< pt(2) = ex + ey - ez
   !< print "(L1)", pt(1) /= pt(2)
   !<```
   !=> T <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   type(vector),  intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< The result of the comparison.
   type(vector)              :: nl  !< Normalizations of lhs.
   type(vector)              :: nr  !< Normalizations of rhs.

   opr = (normL2(lhs) /= normL2(rhs))
   if (.not.opr) then ! the normL2 are the same, checking the directions
     nl = normalized(lhs)
     nr = normalized(rhs)
     opr = ((nl%x /= nr%x) .or. (nl%y /= nr%y) .or. (nl%z /= nr%z))
   endif
   endfunction vector_not_eq_vector

   elemental function R16P_not_eq_vector(lhs, rhs) result(opr)
   !< Operator `real(R16P) /=`.
   !<
   !<```fortran
   !< use penf, only : R16P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", 1._R16P /= pt
   !<```
   !=> T <<<
   real(R16P),    intent(in) :: lhs !< Left hand side.
   class(vector), intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (real(lhs, R_P) /= normL2(rhs))
   endfunction R16P_not_eq_vector

   elemental function vector_not_eq_R16P(lhs, rhs) result(opr)
   !< Operator `/= real(R16P)`.
   !<
   !<```fortran
   !< use penf, only : R16P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", pt /= 1._R16P
   !<```
   !=> T <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   real(R16P),    intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (normL2(lhs) /= real(rhs, R_P))
   endfunction vector_not_eq_R16P

   elemental function R8P_not_eq_vector(lhs, rhs) result(opr)
   !< Operator `real(R8P) /=`.
   !<
   !<```fortran
   !< use penf, only : R8P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", 1._R8P /= pt
   !<```
   !=> T <<<
   real(R8P),     intent(in) :: lhs !< Left hand side.
   class(vector), intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (real(lhs, R_P) /= normL2(rhs))
   endfunction R8P_not_eq_vector

   elemental function vector_not_eq_R8P(lhs, rhs) result(opr)
   !< Operator `/= real(R8P)`.
   !<
   !<```fortran
   !< use penf, only : R8P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", pt /= 1._R8P
   !<```
   !=> T <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   real(R8P),     intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (normL2(lhs) /= real(rhs, R_P))
   endfunction vector_not_eq_R8P

   elemental function R4P_not_eq_vector(lhs, rhs) result(opr)
   !< Operator `real(R4P) /=`.
   !<
   !<```fortran
   !< use penf, only : R4P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", 1._R4P /= pt
   !<```
   !=> T <<<
   real(R4P),     intent(in) :: lhs !< Left hand side.
   class(vector), intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (real(lhs, R_P) /= normL2(rhs))
   endfunction R4P_not_eq_vector

   elemental function vector_not_eq_R4P(lhs, rhs) result(opr)
   !< Operator `/= real(R4P)`.
   !<
   !<```fortran
   !< use penf, only : R4P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", pt /= 1._R4P
   !<```
   !=> T <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   real(R4P),     intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (normL2(lhs) /= real(rhs, R_P))
   endfunction vector_not_eq_R4P

   elemental function I8P_not_eq_vector(lhs, rhs) result(opr)
   !< Operator `integer(I8P) /=`.
   !<
   !<```fortran
   !< use penf, only : I8P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", 1_I8P /= pt
   !<```
   !=> T <<<
   integer(I8P),  intent(in) :: lhs !< Left hand side.
   class(vector), intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (real(lhs, R_P) /= normL2(rhs))
   endfunction I8P_not_eq_vector

   elemental function vector_not_eq_I8P(lhs, rhs) result(opr)
   !< Operator `/= integer(I8P)`.
   !<
   !<```fortran
   !< use penf, only : I8P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", pt /= 1_I8P
   !<```
   !=> T <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   integer(I8P),  intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (normL2(lhs) /= real(rhs, R_P))
   endfunction vector_not_eq_I8P

   elemental function I4P_not_eq_vector(lhs, rhs) result(opr)
   !< Operator `integer(I4P) /=`.
   !<
   !<```fortran
   !< use penf, only : I4P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", 1_I4P /= pt
   !<```
   !=> T <<<
   integer(I4P),  intent(in) :: lhs !< Left hand side.
   class(vector), intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (real(lhs, R_P) /= normL2(rhs))
   endfunction I4P_not_eq_vector

   elemental function vector_not_eq_I4P(lhs, rhs) result(opr)
   !< Operator `/= integer(I4P)`.
   !<
   !<```fortran
   !< use penf, only : I4P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", pt /= 1_I4P
   !<```
   !=> T <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   integer(I4P),  intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (normL2(lhs) /= real(rhs, R_P))
   endfunction vector_not_eq_I4P

   elemental function I2P_not_eq_vector(lhs, rhs) result(opr)
   !< Operator `integer(I2P) /=`.
   !<
   !<```fortran
   !< use penf, only : I2P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", 1_I2P /= pt
   !<```
   !=> T <<<
   integer(I2P),  intent(in) :: lhs !< Left hand side.
   class(vector), intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (real(lhs, R_P) /= normL2(rhs))
   endfunction I2P_not_eq_vector

   elemental function vector_not_eq_I2P(lhs, rhs) result(opr)
   !< Operator `/= integer(I2P)`.
   !<
   !<```fortran
   !< use penf, only : I2P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", pt /= 1_I2P
   !<```
   !=> T <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   integer(I2P),  intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (normL2(lhs) /= real(rhs, R_P))
   endfunction vector_not_eq_I2P

   elemental function I1P_not_eq_vector(lhs, rhs) result(opr)
   !< Operator `integer(I1P) /=`.
   !<
   !<```fortran
   !< use penf, only : I1P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", 1_I1P /= pt
   !<```
   !=> T <<<
   integer(I1P),  intent(in) :: lhs !< Left hand side.
   class(vector), intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (real(lhs, R_P) /= normL2(rhs))
   endfunction I1P_not_eq_vector

   elemental function vector_not_eq_I1P(lhs, rhs) result(opr)
   !< Operator `/= integer(I1P)`.
   !<
   !<```fortran
   !< use penf, only : I1P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", pt /= 1_I1P
   !<```
   !=> T <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   integer(I1P),  intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (normL2(lhs) /= real(rhs, R_P))
   endfunction vector_not_eq_I1P

   ! operator `<`
   elemental function vector_low_vector(lhs, rhs) result(opr)
   !< Operator `<`.
   !<
   !<```fortran
   !< type(vector) :: pt(1:2)
   !< pt(1) = ex + ey + ez
   !< pt(2) = pt(1) + 1
   !< print "(L1)", pt(1) < pt(2)
   !<```
   !=> T <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   type(vector),  intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< The result of the comparison.

   opr = (normL2(lhs) < normL2(rhs))
   endfunction vector_low_vector

   elemental function R16P_low_vector(lhs, rhs) result(opr)
   !< Operator `real(R16P) <`.
   !<
   !<```fortran
   !< use penf, only : R16P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", 1._R16P < pt
   !<```
   !=> T <<<
   real(R16P),    intent(in) :: lhs !< Left hand side.
   class(vector), intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (real(lhs, R_P) < normL2(rhs))
   endfunction R16P_low_vector

   elemental function vector_low_R16P(lhs, rhs) result(opr)
   !< Operator `< real(R16P)`.
   !<
   !<```fortran
   !< use penf, only : R16P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", pt < 4._R16P
   !<```
   !=> T <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   real(R16P),    intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (normL2(lhs) < real(rhs, R_P))
   endfunction vector_low_R16P

   elemental function R8P_low_vector(lhs, rhs) result(opr)
   !< Operator `real(R8P) <`.
   !<
   !<```fortran
   !< use penf, only : R8P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", 1._R8P < pt
   !<```
   !=> T <<<
   real(R8P),     intent(in) :: lhs !< Left hand side.
   class(vector), intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (real(lhs, R_P) < normL2(rhs))
   endfunction R8P_low_vector

   elemental function vector_low_R8P(lhs, rhs) result(opr)
   !< Operator `< real(R8P)`.
   !<
   !<```fortran
   !< use penf, only : R8P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", pt < 4._R8P
   !<```
   !=> T <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   real(R8P),     intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (normL2(lhs) < real(rhs, R_P))
   endfunction vector_low_R8P

   elemental function R4P_low_vector(lhs, rhs) result(opr)
   !< Operator `real(R4P) <`.
   !<
   !<```fortran
   !< use penf, only : R4P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", 1._R4P < pt
   !<```
   !=> T <<<
   real(R4P),     intent(in) :: lhs !< Left hand side.
   class(vector), intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (real(lhs, R_P) < normL2(rhs))
   endfunction R4P_low_vector

   elemental function vector_low_R4P(lhs, rhs) result(opr)
   !< Operator `< real(R4P)`.
   !<
   !<```fortran
   !< use penf, only : R4P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", pt < 4._R4P
   !<```
   !=> T <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   real(R4P),     intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (normL2(lhs) < real(rhs, R_P))
   endfunction vector_low_R4P

   elemental function I8P_low_vector(lhs, rhs) result(opr)
   !< Operator `integer(I8P) <`.
   !<
   !<```fortran
   !< use penf, only : I8P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", 1_I8P < pt
   !<```
   !=> T <<<
   integer(I8P),  intent(in) :: lhs !< Left hand side.
   class(vector), intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (real(lhs, R_P) < normL2(rhs))
   endfunction I8P_low_vector

   elemental function vector_low_I8P(lhs, rhs) result(opr)
   !< Operator `< integer(I8P)`.
   !<
   !<```fortran
   !< use penf, only : I8P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", pt < 4_I8P
   !<```
   !=> T <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   integer(I8P),  intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (normL2(lhs) < real(rhs, R_P))
   endfunction vector_low_I8P

   elemental function I4P_low_vector(lhs, rhs) result(opr)
   !< Operator `integer(I4P) <`.
   !<
   !<```fortran
   !< use penf, only : I4P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", 1_I4P < pt
   !<```
   !=> T <<<
   integer(I4P),  intent(in) :: lhs !< Left hand side.
   class(vector), intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (real(lhs, R_P) < normL2(rhs))
   endfunction I4P_low_vector

   elemental function vector_low_I4P(lhs, rhs) result(opr)
   !< Operator `< integer(I4P)`.
   !<
   !<```fortran
   !< use penf, only : I4P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", pt < 4_I4P
   !<```
   !=> T <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   integer(I4P),  intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (normL2(lhs) < real(rhs, R_P))
   endfunction vector_low_I4P

   elemental function I2P_low_vector(lhs, rhs) result(opr)
   !< Operator `integer(I2P) <`.
   !<
   !<```fortran
   !< use penf, only : I2P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", 1_I2P < pt
   !<```
   !=> T <<<
   integer(I2P),  intent(in) :: lhs !< Left hand side.
   class(vector), intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (real(lhs, R_P) < normL2(rhs))
   endfunction I2P_low_vector

   elemental function vector_low_I2P(lhs, rhs) result(opr)
   !< Operator `< integer(I2P)`.
   !<
   !<```fortran
   !< use penf, only : I2P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", pt < 4_I2P
   !<```
   !=> T <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   integer(I2P),  intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (normL2(lhs) < real(rhs, R_P))
   endfunction vector_low_I2P

   elemental function I1P_low_vector(lhs, rhs) result(opr)
   !< Operator `integer(I1P) <`.
   !<
   !<```fortran
   !< use penf, only : I1P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", 1_I1P < pt
   !<```
   !=> T <<<
   integer(I1P),  intent(in) :: lhs !< Left hand side.
   class(vector), intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (real(lhs, R_P) < normL2(rhs))
   endfunction I1P_low_vector

   elemental function vector_low_I1P(lhs, rhs) result(opr)
   !< Operator `< integer(I1P)`.
   !<
   !<```fortran
   !< use penf, only : I1P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", pt < 4_I1P
   !<```
   !=> T <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   integer(I1P),  intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (normL2(lhs) < real(rhs, R_P))
   endfunction vector_low_I1P

   ! operator `<=`
   elemental function vector_low_eq_vector(lhs, rhs) result(opr)
   !< Operator `<=`.
   !<
   !<```fortran
   !< type(vector) :: pt(1:2)
   !< pt(1) = ex + ey + ez
   !< pt(2) = pt(1) + 1
   !< print "(L1)", pt(1) <= pt(2)
   !<```
   !=> T <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   type(vector),  intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< The result of the comparison.

   opr = (normL2(lhs) <= normL2(rhs))
   endfunction vector_low_eq_vector

   elemental function R16P_low_eq_vector(lhs, rhs) result(opr)
   !< Operator `real(R16P) <=`.
   !<
   !<```fortran
   !< use penf, only : R16P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", 1._R16P <= pt
   !<```
   !=> T <<<
   real(R16P),    intent(in) :: lhs !< Left hand side.
   class(vector), intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (real(lhs, R_P) <= normL2(rhs))
   endfunction R16P_low_eq_vector

   elemental function vector_low_eq_R16P(lhs, rhs) result(opr)
   !< Operator `<= real(R16P)`.
   !<
   !<```fortran
   !< use penf, only : R16P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", pt <= 4._R16P
   !<```
   !=> T <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   real(R16P),    intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (normL2(lhs) <= real(rhs, R_P))
   endfunction vector_low_eq_R16P

   elemental function R8P_low_eq_vector(lhs, rhs) result(opr)
   !< Operator `real(R8P) <=`.
   !<
   !<```fortran
   !< use penf, only : R8P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", 1._R8P <= pt
   !<```
   !=> T <<<
   real(R8P),     intent(in) :: lhs !< Left hand side.
   class(vector), intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (real(lhs, R_P) <= normL2(rhs))
   endfunction R8P_low_eq_vector

   elemental function vector_low_eq_R8P(lhs, rhs) result(opr)
   !< Operator `<= real(R8P)`.
   !<
   !<```fortran
   !< use penf, only : R8P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", pt <= 4._R8P
   !<```
   !=> T <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   real(R8P),     intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (normL2(lhs) <= real(rhs, R_P))
   endfunction vector_low_eq_R8P

   elemental function R4P_low_eq_vector(lhs, rhs) result(opr)
   !< Operator `real(R4P) <=`.
   !<
   !<```fortran
   !< use penf, only : R4P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", 1._R4P <= pt
   !<```
   !=> T <<<
   real(R4P),     intent(in) :: lhs !< Left hand side.
   class(vector), intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (real(lhs, R_P) <= normL2(rhs))
   endfunction R4P_low_eq_vector

   elemental function vector_low_eq_R4P(lhs, rhs) result(opr)
   !< Operator `<= real(R4P)`.
   !<
   !<```fortran
   !< use penf, only : R4P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", pt <= 4._R4P
   !<```
   !=> T <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   real(R4P),     intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (normL2(lhs) <= real(rhs, R_P))
   endfunction vector_low_eq_R4P

   elemental function I8P_low_eq_vector(lhs, rhs) result(opr)
   !< Operator `integer(I8P) <=`.
   !<
   !<```fortran
   !< use penf, only : I8P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", 1_I8P <= pt
   !<```
   !=> T <<<
   integer(I8P),  intent(in) :: lhs !< Left hand side.
   class(vector), intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (real(lhs, R_P) <= normL2(rhs))
   endfunction I8P_low_eq_vector

   elemental function vector_low_eq_I8P(lhs, rhs) result(opr)
   !< Operator `<= integer(I8P)`.
   !<
   !<```fortran
   !< use penf, only : I8P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", pt <= 4_I8P
   !<```
   !=> T <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   integer(I8P),  intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (normL2(lhs) <= real(rhs, R_P))
   endfunction vector_low_eq_I8P

   elemental function I4P_low_eq_vector(lhs, rhs) result(opr)
   !< Operator `integer(I4P) <=`.
   !<
   !<```fortran
   !< use penf, only : I4P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", 1_I4P <= pt
   !<```
   !=> T <<<
   integer(I4P),  intent(in) :: lhs !< Left hand side.
   class(vector), intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (real(lhs, R_P) <= normL2(rhs))
   endfunction I4P_low_eq_vector

   elemental function vector_low_eq_I4P(lhs, rhs) result(opr)
   !< Operator `<= integer(I4P)`.
   !<
   !<```fortran
   !< use penf, only : I4P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", pt <= 4_I4P
   !<```
   !=> T <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   integer(I4P),  intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (normL2(lhs) <= real(rhs, R_P))
   endfunction vector_low_eq_I4P

   elemental function I2P_low_eq_vector(lhs, rhs) result(opr)
   !< Operator `integer(I2P) <=`.
   !<
   !<```fortran
   !< use penf, only : I2P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", 1_I2P <= pt
   !<```
   !=> T <<<
   integer(I2P),  intent(in) :: lhs !< Left hand side.
   class(vector), intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (real(lhs, R_P) <= normL2(rhs))
   endfunction I2P_low_eq_vector

   elemental function vector_low_eq_I2P(lhs, rhs) result(opr)
   !< Operator `<= integer(I2P)`.
   !<
   !<```fortran
   !< use penf, only : I2P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", pt <= 4_I2P
   !<```
   !=> T <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   integer(I2P),  intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (normL2(lhs) <= real(rhs, R_P))
   endfunction vector_low_eq_I2P

   elemental function I1P_low_eq_vector(lhs, rhs) result(opr)
   !< Operator `integer(I1P) <=`.
   !<
   !<```fortran
   !< use penf, only : I1P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", 1_I1P <= pt
   !<```
   !=> T <<<
   integer(I1P),  intent(in) :: lhs !< Left hand side.
   class(vector), intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (real(lhs, R_P) <= normL2(rhs))
   endfunction I1P_low_eq_vector

   elemental function vector_low_eq_I1P(lhs, rhs) result(opr)
   !< Operator `<= integer(I1P)`.
   !<
   !<```fortran
   !< use penf, only : I1P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", pt <= 4_I1P
   !<```
   !=> T <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   integer(I1P),  intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (normL2(lhs) <= real(rhs, R_P))
   endfunction vector_low_eq_I1P

   ! operator `==`
   elemental function vector_eq_vector(lhs, rhs) result(opr)
   !< Operator `==`.
   !<
   !< The comparison is done with respect normL2 and, secondary, with respect the directions.
   !<
   !<```fortran
   !< type(vector) :: pt(1:2)
   !< pt(1) = ex + ey + ez
   !< pt(2) = ex + ey + ez
   !< print "(L1)", pt(1) == pt(2)
   !<```
   !=> T <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   type(vector),  intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< The result of the comparison.
   type(vector)              :: nl  !< Normalizations of lhs.
   type(vector)              :: nr  !< Normalizations of rhs.

   opr = (normL2(lhs) == normL2(rhs))
  if (opr) then ! the normL2 are the same, checking the directions
    nl = normalized(lhs)
    nr = normalized(rhs)
    opr = ((nl%x == nr%x) .and. (nl%y == nr%y) .and. (nl%z == nr%z))
  endif
   endfunction vector_eq_vector

   elemental function R16P_eq_vector(lhs, rhs) result(opr)
   !< Operator `real(R16P) ==`.
   !<
   !<```fortran
   !< use penf, only : R16P
   !< type(vector) :: pt
   !< pt = 4 * ex + 3 * ey
   !< print "(L1)", 5._R16P == pt
   !<```
   !=> T <<<
   real(R16P),    intent(in) :: lhs !< Left hand side.
   class(vector), intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (real(lhs, R_P) == normL2(rhs))
   endfunction R16P_eq_vector

   elemental function vector_eq_R16P(lhs, rhs) result(opr)
   !< Operator `== real(R16P)`.
   !<
   !<```fortran
   !< use penf, only : R16P
   !< type(vector) :: pt
   !< pt = 4 * ex + 3 * ey
   !< print "(L1)", pt == 5._R16P
   !<```
   !=> T <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   real(R16P),    intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (normL2(lhs) == real(rhs, R_P))
   endfunction vector_eq_R16P

   elemental function R8P_eq_vector(lhs, rhs) result(opr)
   !< Operator `real(R8P) ==`.
   !<
   !<```fortran
   !< use penf, only : R8P
   !< type(vector) :: pt
   !< pt = 4 * ex + 3 * ey
   !< print "(L1)", 5._R8P == pt
   !<```
   !=> T <<<
   real(R8P),     intent(in) :: lhs !< Left hand side.
   class(vector), intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (real(lhs, R_P) == normL2(rhs))
   endfunction R8P_eq_vector

   elemental function vector_eq_R8P(lhs, rhs) result(opr)
   !< Operator `== real(R8P)`.
   !<
   !<```fortran
   !< use penf, only : R8P
   !< type(vector) :: pt
   !< pt = 4 * ex + 3 * ey
   !< print "(L1)", pt == 5._R8P
   !<```
   !=> T <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   real(R8P),     intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (normL2(lhs) == real(rhs, R_P))
   endfunction vector_eq_R8P

   elemental function R4P_eq_vector(lhs, rhs) result(opr)
   !< Operator `real(R4P) ==`.
   !<
   !<```fortran
   !< use penf, only : R4P
   !< type(vector) :: pt
   !< pt = 4 * ex + 3 * ey
   !< print "(L1)", 5._R4P == pt
   !<```
   !=> T <<<
   real(R4P),     intent(in) :: lhs !< Left hand side.
   class(vector), intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (real(lhs, R_P) == normL2(rhs))
   endfunction R4P_eq_vector

   elemental function vector_eq_R4P(lhs, rhs) result(opr)
   !< Operator `== real(R4P)`.
   !<
   !<```fortran
   !< use penf, only : R4P
   !< type(vector) :: pt
   !< pt = 4 * ex + 3 * ey
   !< print "(L1)", pt == 5._R4P
   !<```
   !=> T <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   real(R4P),     intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (normL2(lhs) == real(rhs, R_P))
   endfunction vector_eq_R4P

   elemental function I8P_eq_vector(lhs, rhs) result(opr)
   !< Operator `integer(I8P) ==`.
   !<
   !<```fortran
   !< use penf, only : I8P
   !< type(vector) :: pt
   !< pt = 4 * ex + 3 * ey
   !< print "(L1)", 5_I8P == pt
   !<```
   !=> T <<<
   integer(I8P),  intent(in) :: lhs !< Left hand side.
   class(vector), intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (real(lhs, R_P) == normL2(rhs))
   endfunction I8P_eq_vector

   elemental function vector_eq_I8P(lhs, rhs) result(opr)
   !< Operator `== integer(I8P)`.
   !<
   !<```fortran
   !< use penf, only : I8P
   !< type(vector) :: pt
   !< pt = 4 * ex + 3 * ey
   !< print "(L1)", pt == 5_I8P
   !<```
   !=> T <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   integer(I8P),  intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (normL2(lhs) == real(rhs, R_P))
   endfunction vector_eq_I8P

   elemental function I4P_eq_vector(lhs, rhs) result(opr)
   !< Operator `integer(I4P) ==`.
   !<
   !<```fortran
   !< use penf, only : I4P
   !< type(vector) :: pt
   !< pt = 4 * ex + 3 * ey
   !< print "(L1)", 5_I4P == pt
   !<```
   !=> T <<<
   integer(I4P),  intent(in) :: lhs !< Left hand side.
   class(vector), intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (real(lhs, R_P) == normL2(rhs))
   endfunction I4P_eq_vector

   elemental function vector_eq_I4P(lhs, rhs) result(opr)
   !< Operator `== integer(I4P)`.
   !<
   !<```fortran
   !< use penf, only : I4P
   !< type(vector) :: pt
   !< pt = 4 * ex + 3 * ey
   !< print "(L1)", pt == 5_I4P
   !<```
   !=> T <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   integer(I4P),  intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (normL2(lhs) == real(rhs, R_P))
   endfunction vector_eq_I4P

   elemental function I2P_eq_vector(lhs, rhs) result(opr)
   !< Operator `integer(I2P) ==`.
   !<
   !<```fortran
   !< use penf, only : I2P
   !< type(vector) :: pt
   !< pt = 4 * ex + 3 * ey
   !< print "(L1)", 5_I2P == pt
   !<```
   !=> T <<<
   integer(I2P),  intent(in) :: lhs !< Left hand side.
   class(vector), intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (real(lhs, R_P) == normL2(rhs))
   endfunction I2P_eq_vector

   elemental function vector_eq_I2P(lhs, rhs) result(opr)
   !< Operator `== integer(I2P)`.
   !<
   !<```fortran
   !< use penf, only : I2P
   !< type(vector) :: pt
   !< pt = 4 * ex + 3 * ey
   !< print "(L1)", pt == 5_I2P
   !<```
   !=> T <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   integer(I2P),  intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (normL2(lhs) == real(rhs, R_P))
   endfunction vector_eq_I2P

   elemental function I1P_eq_vector(lhs, rhs) result(opr)
   !< Operator `integer(I1P) ==`.
   !<
   !<```fortran
   !< use penf, only : I1P
   !< type(vector) :: pt
   !< pt = 4 * ex + 3 * ey
   !< print "(L1)", 5_I1P == pt
   !<```
   !=> T <<<
   integer(I1P),  intent(in) :: lhs !< Left hand side.
   class(vector), intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (real(lhs, R_P) == normL2(rhs))
   endfunction I1P_eq_vector

   elemental function vector_eq_I1P(lhs, rhs) result(opr)
   !< Operator `== integer(I1P)`.
   !<
   !<```fortran
   !< use penf, only : I1P
   !< type(vector) :: pt
   !< pt = 4 * ex + 3 * ey
   !< print "(L1)", pt == 5_I1P
   !<```
   !=> T <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   integer(I1P),  intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (normL2(lhs) == real(rhs, R_P))
   endfunction vector_eq_I1P

   ! operator `>=`
   elemental function vector_great_eq_vector(lhs, rhs) result(opr)
   !< Operator `>=`.
   !<
   !<```fortran
   !< type(vector) :: pt(1:2)
   !< pt(1) = ex + ey + ez
   !< pt(2) = pt(1) + 1
   !< print "(L1)", pt(2) >= pt(1)
   !<```
   !=> T <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   type(vector),  intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< The result of the comparison.

   opr = (normL2(lhs) >= normL2(rhs))
   endfunction vector_great_eq_vector

   elemental function R16P_great_eq_vector(lhs, rhs) result(opr)
   !< Operator `real(R16P) >=`.
   !<
   !<```fortran
   !< use penf, only : R16P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", 4._R16P >= pt
   !<```
   !=> T <<<
   real(R16P),    intent(in) :: lhs !< Left hand side.
   class(vector), intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (real(lhs, R_P) >= normL2(rhs))
   endfunction R16P_great_eq_vector

   elemental function vector_great_eq_R16P(lhs, rhs) result(opr)
   !< Operator `>= real(R16P)`.
   !<
   !<```fortran
   !< use penf, only : R16P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", pt >= 1._R16P
   !<```
   !=> T <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   real(R16P),    intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (normL2(lhs) >= real(rhs, R_P))
   endfunction vector_great_eq_R16P

   elemental function R8P_great_eq_vector(lhs, rhs) result(opr)
   !< Operator `real(R8P) >=`.
   !<
   !<```fortran
   !< use penf, only : R8P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", 4._R8P >= pt
   !<```
   !=> T <<<
   real(R8P),     intent(in) :: lhs !< Left hand side.
   class(vector), intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (real(lhs, R_P) >= normL2(rhs))
   endfunction R8P_great_eq_vector

   elemental function vector_great_eq_R8P(lhs, rhs) result(opr)
   !< Operator `>= real(R8P)`.
   !<
   !<```fortran
   !< use penf, only : R8P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", pt >= 1._R8P
   !<```
   !=> T <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   real(R8P),     intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (normL2(lhs) >= real(rhs, R_P))
   endfunction vector_great_eq_R8P

   elemental function R4P_great_eq_vector(lhs, rhs) result(opr)
   !< Operator `real(R4P) >=`.
   !<
   !<```fortran
   !< use penf, only : R4P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", 4._R4P >= pt
   !<```
   !=> T <<<
   real(R4P),     intent(in) :: lhs !< Left hand side.
   class(vector), intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (real(lhs, R_P) >= normL2(rhs))
   endfunction R4P_great_eq_vector

   elemental function vector_great_eq_R4P(lhs, rhs) result(opr)
   !< Operator `>= real(R4P)`.
   !<
   !<```fortran
   !< use penf, only : R4P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", pt >= 1._R4P
   !<```
   !=> T <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   real(R4P),     intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (normL2(lhs) >= real(rhs, R_P))
   endfunction vector_great_eq_R4P

   elemental function I8P_great_eq_vector(lhs, rhs) result(opr)
   !< Operator `integer(I8P) >=`.
   !<
   !<```fortran
   !< use penf, only : I8P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", 4_I8P >= pt
   !<```
   !=> T <<<
   integer(I8P),  intent(in) :: lhs !< Left hand side.
   class(vector), intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (real(lhs, R_P) >= normL2(rhs))
   endfunction I8P_great_eq_vector

   elemental function vector_great_eq_I8P(lhs, rhs) result(opr)
   !< Operator `>= integer(I8P)`.
   !<
   !<```fortran
   !< use penf, only : I8P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", pt >= 1_I8P
   !<```
   !=> T <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   integer(I8P),  intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (normL2(lhs) >= real(rhs, R_P))
   endfunction vector_great_eq_I8P

   elemental function I4P_great_eq_vector(lhs, rhs) result(opr)
   !< Operator `integer(I4P) >=`.
   !<
   !<```fortran
   !< use penf, only : I4P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", 4_I4P >= pt
   !<```
   !=> T <<<
   integer(I4P),  intent(in) :: lhs !< Left hand side.
   class(vector), intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (real(lhs, R_P) >= normL2(rhs))
   endfunction I4P_great_eq_vector

   elemental function vector_great_eq_I4P(lhs, rhs) result(opr)
   !< Operator `>= integer(I4P)`.
   !<
   !<```fortran
   !< use penf, only : I4P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", pt >= 1_I4P
   !<```
   !=> T <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   integer(I4P),  intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (normL2(lhs) >= real(rhs, R_P))
   endfunction vector_great_eq_I4P

   elemental function I2P_great_eq_vector(lhs, rhs) result(opr)
   !< Operator `integer(I2P) >=`.
   !<
   !<```fortran
   !< use penf, only : I2P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", 4_I2P >= pt
   !<```
   !=> T <<<
   integer(I2P),  intent(in) :: lhs !< Left hand side.
   class(vector), intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (real(lhs, R_P) >= normL2(rhs))
   endfunction I2P_great_eq_vector

   elemental function vector_great_eq_I2P(lhs, rhs) result(opr)
   !< Operator `>= integer(I2P)`.
   !<
   !<```fortran
   !< use penf, only : I2P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", pt >= 1_I2P
   !<```
   !=> T <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   integer(I2P),  intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (normL2(lhs) >= real(rhs, R_P))
   endfunction vector_great_eq_I2P

   elemental function I1P_great_eq_vector(lhs, rhs) result(opr)
   !< Operator `integer(I1P) >=`.
   !<
   !<```fortran
   !< use penf, only : I1P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", 4_I1P >= pt
   !<```
   !=> T <<<
   integer(I1P),  intent(in) :: lhs !< Left hand side.
   class(vector), intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (real(lhs, R_P) >= normL2(rhs))
   endfunction I1P_great_eq_vector

   elemental function vector_great_eq_I1P(lhs, rhs) result(opr)
   !< Operator `>= integer(I1P)`.
   !<
   !<```fortran
   !< use penf, only : I1P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", pt >= 1_I1P
   !<```
   !=> T <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   integer(I1P),  intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (normL2(lhs) >= real(rhs, R_P))
   endfunction vector_great_eq_I1P

   ! operator `>`
   elemental function vector_great_vector(lhs, rhs) result(opr)
   !< Operator `>`.
   !<
   !<```fortran
   !< type(vector) :: pt(1:2)
   !< pt(1) = ex + ey + ez
   !< pt(2) = pt(1) + 1
   !< print "(L1)", pt(2) > pt(1)
   !<```
   !=> T <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   type(vector),  intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< The result of the comparison.

   opr = (normL2(lhs) > normL2(rhs))
   endfunction vector_great_vector

   elemental function R16P_great_vector(lhs, rhs) result(opr)
   !< Operator `real(R16P) >`.
   !<
   !<```fortran
   !< use penf, only : R16P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", 4._R16P > pt
   !<```
   !=> T <<<
   real(R16P),    intent(in) :: lhs !< Left hand side.
   class(vector), intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (real(lhs, R_P) > normL2(rhs))
   endfunction R16P_great_vector

   elemental function vector_great_R16P(lhs, rhs) result(opr)
   !< Operator `> real(R16P)`.
   !<
   !<```fortran
   !< use penf, only : R16P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", pt > 1._R16P
   !<```
   !=> T <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   real(R16P),    intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (normL2(lhs) > real(rhs, R_P))
   endfunction vector_great_R16P

   elemental function R8P_great_vector(lhs, rhs) result(opr)
   !< Operator `real(R8P) >`.
   !<
   !<```fortran
   !< use penf, only : R8P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", 4._R8P > pt
   !<```
   !=> T <<<
   real(R8P),     intent(in) :: lhs !< Left hand side.
   class(vector), intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (real(lhs, R_P) > normL2(rhs))
   endfunction R8P_great_vector

   elemental function vector_great_R8P(lhs, rhs) result(opr)
   !< Operator `> real(R8P)`.
   !<
   !<```fortran
   !< use penf, only : R8P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", pt > 1._R8P
   !<```
   !=> T <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   real(R8P),     intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (normL2(lhs) > real(rhs, R_P))
   endfunction vector_great_R8P

   elemental function R4P_great_vector(lhs, rhs) result(opr)
   !< Operator `real(R4P) >`.
   !<
   !<```fortran
   !< use penf, only : R4P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", 4._R4P > pt
   !<```
   !=> T <<<
   real(R4P),     intent(in) :: lhs !< Left hand side.
   class(vector), intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (real(lhs, R_P) > normL2(rhs))
   endfunction R4P_great_vector

   elemental function vector_great_R4P(lhs, rhs) result(opr)
   !< Operator `> real(R4P)`.
   !<
   !<```fortran
   !< use penf, only : R4P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", pt > 1._R4P
   !<```
   !=> T <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   real(R4P),     intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (normL2(lhs) > real(rhs, R_P))
   endfunction vector_great_R4P

   elemental function I8P_great_vector(lhs, rhs) result(opr)
   !< Operator `integer(I8P) >`.
   !<
   !<```fortran
   !< use penf, only : I8P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", 4_I8P > pt
   !<```
   !=> T <<<
   integer(I8P),  intent(in) :: lhs !< Left hand side.
   class(vector), intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (real(lhs, R_P) > normL2(rhs))
   endfunction I8P_great_vector

   elemental function vector_great_I8P(lhs, rhs) result(opr)
   !< Operator `> integer(I8P)`.
   !<
   !<```fortran
   !< use penf, only : I8P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", pt > 1_I8P
   !<```
   !=> T <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   integer(I8P),  intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (normL2(lhs) > real(rhs, R_P))
   endfunction vector_great_I8P

   elemental function I4P_great_vector(lhs, rhs) result(opr)
   !< Operator `integer(I4P) >`.
   !<
   !<```fortran
   !< use penf, only : I4P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", 4_I4P > pt
   !<```
   !=> T <<<
   integer(I4P),  intent(in) :: lhs !< Left hand side.
   class(vector), intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (real(lhs, R_P) > normL2(rhs))
   endfunction I4P_great_vector

   elemental function vector_great_I4P(lhs, rhs) result(opr)
   !< Operator `> integer(I4P)`.
   !<
   !<```fortran
   !< use penf, only : I4P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", pt > 1_I4P
   !<```
   !=> T <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   integer(I4P),  intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (normL2(lhs) > real(rhs, R_P))
   endfunction vector_great_I4P

   elemental function I2P_great_vector(lhs, rhs) result(opr)
   !< Operator `integer(I2P) >`.
   !<
   !<```fortran
   !< use penf, only : I2P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", 4_I2P > pt
   !<```
   !=> T <<<
   integer(I2P),  intent(in) :: lhs !< Left hand side.
   class(vector), intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (real(lhs, R_P) > normL2(rhs))
   endfunction I2P_great_vector

   elemental function vector_great_I2P(lhs, rhs) result(opr)
   !< Operator `> integer(I2P)`.
   !<
   !<```fortran
   !< use penf, only : I2P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", pt > 1_I2P
   !<```
   !=> T <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   integer(I2P),  intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (normL2(lhs) > real(rhs, R_P))
   endfunction vector_great_I2P

   elemental function I1P_great_vector(lhs, rhs) result(opr)
   !< Operator `integer(I1P) >`.
   !<
   !<```fortran
   !< use penf, only : I1P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", 4_I1P > pt
   !<```
   !=> T <<<
   integer(I1P),  intent(in) :: lhs !< Left hand side.
   class(vector), intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (real(lhs, R_P) > normL2(rhs))
   endfunction I1P_great_vector

   elemental function vector_great_I1P(lhs, rhs) result(opr)
   !< Operator `> integer(I1P)`.
   !<
   !<```fortran
   !< use penf, only : I1P
   !< type(vector) :: pt
   !< pt = ex + ey + ez
   !< print "(L1)", pt > 1_I1P
   !<```
   !=> T <<<
   class(vector), intent(in) :: lhs !< Left hand side.
   integer(I1P),  intent(in) :: rhs !< Right hand side.
   logical                   :: opr !< Operator result.

   opr = (normL2(lhs) > real(rhs, R_P))
   endfunction vector_great_I1P
endmodule vecfor
