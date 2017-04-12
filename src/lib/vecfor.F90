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
use penf, only : DR8P, FR8P, I1P, I2P, I4P, I8P, R_P, R4P, R8P, R16P, smallR_P, str

implicit none
private
public :: ex, ey, ez
public :: sq_norm
public :: normL2
public :: normalize
public :: face_normal3, face_normal4
public :: vector

type :: vector
  !< Vector class.
  real(R_P) :: x = 0._R_P !< Cartesian component in x direction.
  real(R_P) :: y = 0._R_P !< Cartesian component in y direction.
  real(R_P) :: z = 0._R_P !< Cartesian component in z direction.
  contains
    procedure :: init            => init_vector_self  ! Procedure for initializing vector components.
    procedure :: set             => set_vector_self   ! Procedure for setting vector components.
    procedure :: iolen           => iolen_vector_self ! Procedure for computing IO length.
    procedure :: load            => load_vector_self  ! Procedure for loading Vector data.
    procedure :: save            => save_vector_self  ! Procedure for saving Vector data.
    procedure :: print           => print_vector_self ! Procedure for printing vector components with a "pretty" format.
    procedure :: sq_norm         => sq_norm_self      ! Procedure for computing the square of the norm of a vector.
    procedure :: normL2          => normL2_self       ! Procedure for computing the norm L2 of a vector.
    procedure :: normalize       => normalize_self    ! Procedure for normalizing a vector.
    procedure :: normalized      => normalized_self   ! Procedure for obtaining a normalized copy of a vector.
    procedure :: face_normal4    => face_normal4_self ! Procedure for calculating the normal of the face defined by 4 points vector.
    procedure :: face_normal3    => face_normal3_self ! Procedure for calculating the normal of the face defined by 3 points vector.
    generic :: operator(.cross.) => crossproduct      ! Procedure for computing the cross product of 2 vectors.
    generic :: operator(.dot.)   => dotproduct        ! Procedure for computing the scalar (dot) product of 2 vectors.
    generic :: operator(.paral.) => parallel          ! Procedure for computing the component of vec1 parallel to vec2.
    generic :: operator(.ortho.) => orthogonal        ! Procedure for computign the component of vec1 orthogonal to vec2.
    procedure, pass(vec1), private :: crossproduct
    procedure, pass(vec1), private :: dotproduct
    procedure, pass(vec1), private :: parallel
    procedure, pass(vec1), private :: orthogonal
    ! operators overloading
    generic :: assignment(=) => assign_self,    &
#ifdef r16p
                                assign_ScalR16P,&
#endif
                                assign_ScalR8P,assign_ScalR4P,assign_ScalI8P,assign_ScalI4P,assign_ScalI2P,assign_ScalI1P
#ifdef r16p
    procedure, pass(self ), private :: assign_ScalR16P
#endif
    procedure, pass(self1), private :: assign_self
    procedure, pass(self ), private :: assign_ScalR8P
    procedure, pass(self ), private :: assign_ScalR4P
    procedure, pass(self ), private :: assign_ScalI8P
    procedure, pass(self ), private :: assign_ScalI4P
    procedure, pass(self ), private :: assign_ScalI2P
    procedure, pass(self ), private :: assign_ScalI1P
    generic                         :: operator(*) => self_mul_self,                                                               &
#ifdef r16p
                             ScalR16P_mul_self,self_mul_ScalR16P,                                                                  &
#endif
                             ScalR8P_mul_self,self_mul_ScalR8P,ScalR4P_mul_self,self_mul_ScalR4P,ScalI8P_mul_self,self_mul_ScalI8P,&
                             ScalI4P_mul_self,self_mul_ScalI4P,ScalI2P_mul_self,self_mul_ScalI2P,ScalI1P_mul_self,self_mul_ScalI1P
#ifdef r16p
    procedure, pass(self ), private :: ScalR16P_mul_self
    procedure, pass(self ), private :: self_mul_ScalR16P
#endif
    procedure, pass(self1), private :: self_mul_self
    procedure, pass(self ), private :: ScalR8P_mul_self
    procedure, pass(self ), private :: ScalR4P_mul_self
    procedure, pass(self ), private :: ScalI8P_mul_self
    procedure, pass(self ), private :: ScalI4P_mul_self
    procedure, pass(self ), private :: ScalI2P_mul_self
    procedure, pass(self ), private :: ScalI1P_mul_self
    procedure, pass(self ), private :: self_mul_ScalR8P
    procedure, pass(self ), private :: self_mul_ScalR4P
    procedure, pass(self ), private :: self_mul_ScalI8P
    procedure, pass(self ), private :: self_mul_ScalI4P
    procedure, pass(self ), private :: self_mul_ScalI2P
    procedure, pass(self ), private :: self_mul_ScalI1P
    generic :: operator(/) => self_div_self,    &
#ifdef r16p
                             self_div_ScalR16P,&
#endif
                             self_div_ScalR8P,self_div_ScalR4P,self_div_ScalI8P,self_div_ScalI4P,self_div_ScalI2P,self_div_ScalI1P
#ifdef r16p
    procedure, pass(self ), private :: self_div_ScalR16P
#endif
    procedure, pass(self1), private :: self_div_self
    procedure, pass(self ), private :: self_div_ScalR8P
    procedure, pass(self ), private :: self_div_ScalR4P
    procedure, pass(self ), private :: self_div_ScalI8P
    procedure, pass(self ), private :: self_div_ScalI4P
    procedure, pass(self ), private :: self_div_ScalI2P
    procedure, pass(self ), private :: self_div_ScalI1P
    generic :: operator(+) => positive_self,self_sum_self,                                                                         &
#ifdef r16p
                             ScalR16P_sum_self,self_sum_ScalR16P,                                                                  &
#endif
                             ScalR8P_sum_self,self_sum_ScalR8P,ScalR4P_sum_self,self_sum_ScalR4P,ScalI8P_sum_self,self_sum_ScalI8P,&
                             ScalI4P_sum_self,self_sum_ScalI4P,ScalI2P_sum_self,self_sum_ScalI2P,ScalI1P_sum_self,self_sum_ScalI1P
#ifdef r16p
    procedure, pass(self ), private :: ScalR16P_sum_self
    procedure, pass(self ), private :: self_sum_ScalR16P
#endif
    procedure, pass(self ), private :: positive_self
    procedure, pass(self1), private :: self_sum_self
    procedure, pass(self ), private :: ScalR8P_sum_self
    procedure, pass(self ), private :: ScalR4P_sum_self
    procedure, pass(self ), private :: ScalI8P_sum_self
    procedure, pass(self ), private :: ScalI4P_sum_self
    procedure, pass(self ), private :: ScalI2P_sum_self
    procedure, pass(self ), private :: ScalI1P_sum_self
    procedure, pass(self ), private :: self_sum_ScalR8P
    procedure, pass(self ), private :: self_sum_ScalR4P
    procedure, pass(self ), private :: self_sum_ScalI8P
    procedure, pass(self ), private :: self_sum_ScalI4P
    procedure, pass(self ), private :: self_sum_ScalI2P
    procedure, pass(self ), private :: self_sum_ScalI1P
    generic :: operator(-) => negative_self,self_sub_self,                                                                         &
#ifdef r16p
                             ScalR16P_sub_self,self_sub_ScalR16P,                                                                  &
#endif
                             ScalR8P_sub_self,self_sub_ScalR8P,ScalR4P_sub_self,self_sub_ScalR4P,ScalI8P_sub_self,self_sub_ScalI8P,&
                             ScalI4P_sub_self,self_sub_ScalI4P,ScalI2P_sub_self,self_sub_ScalI2P,ScalI1P_sub_self,self_sub_ScalI1P
#ifdef r16p
    procedure, pass(self ), private :: ScalR16P_sub_self
    procedure, pass(self ), private :: self_sub_ScalR16P
#endif
    procedure, pass(self ), private :: negative_self
    procedure, pass(self1), private :: self_sub_self
    procedure, pass(self ), private :: ScalR8P_sub_self
    procedure, pass(self ), private :: ScalR4P_sub_self
    procedure, pass(self ), private :: ScalI8P_sub_self
    procedure, pass(self ), private :: ScalI4P_sub_self
    procedure, pass(self ), private :: ScalI2P_sub_self
    procedure, pass(self ), private :: ScalI1P_sub_self
    procedure, pass(self ), private :: self_sub_ScalR8P
    procedure, pass(self ), private :: self_sub_ScalR4P
    procedure, pass(self ), private :: self_sub_ScalI8P
    procedure, pass(self ), private :: self_sub_ScalI4P
    procedure, pass(self ), private :: self_sub_ScalI2P
    procedure, pass(self ), private :: self_sub_ScalI1P
    generic :: operator(/=) => self_not_eq_self,                                                                              &
#ifdef r16p
                              R16P_not_eq_self,self_not_eq_R16P,                                                              &
#endif
                              R8P_not_eq_self,self_not_eq_R8P,R4P_not_eq_self,self_not_eq_R4P,I8P_not_eq_self,self_not_eq_I8P,&
                              I4P_not_eq_self,self_not_eq_I4P,I2P_not_eq_self,self_not_eq_I2P,I1P_not_eq_self,self_not_eq_I1P
    generic :: operator(<) => self_low_self,                                                               &
#ifdef r16p
                             R16P_low_self,self_low_R16P,                                                  &
#endif
                             R8P_low_self,self_low_R8P,R4P_low_self,self_low_R4P,I8P_low_self,self_low_I8P,&
                             I4P_low_self,self_low_I4P,I2P_low_self,self_low_I2P,I1P_low_self,self_low_I1P

    generic :: operator(<=) => self_low_eq_self,                                                                              &
#ifdef r16p
                              R16P_low_eq_self,self_low_eq_R16P,                                                              &
#endif
                              R8P_low_eq_self,self_low_eq_R8P,R4P_low_eq_self,self_low_eq_R4P,I8P_low_eq_self,self_low_eq_I8P,&
                              I4P_low_eq_self,self_low_eq_I4P,I2P_low_eq_self,self_low_eq_I2P,I1P_low_eq_self,self_low_eq_I1P
    generic :: operator(==) => self_eq_self,                                                          &
#ifdef r16p
                              R16P_eq_self,self_eq_R16P,                                              &
#endif
                              R8P_eq_self,self_eq_R8P,R4P_eq_self,self_eq_R4P,I8P_eq_self,self_eq_I8P,&
                              I4P_eq_self,self_eq_I4P,I2P_eq_self,self_eq_I2P,I1P_eq_self,self_eq_I1P
    generic:: operator(>=) => self_great_eq_self,                                                                       &
#ifdef r16p
                              R16P_great_eq_self,self_great_eq_R16P,                                                    &
#endif
                              R8P_great_eq_self,self_great_eq_R8P,R4P_great_eq_self,self_great_eq_R4P,I8P_great_eq_self,&
                              self_great_eq_I8P,I4P_great_eq_self,self_great_eq_I4P,I2P_great_eq_self,self_great_eq_I2P,&
                              I1P_great_eq_self,self_great_eq_I1P
    generic :: operator(>) => self_great_self,                                                                         &
#ifdef r16p
                             R16P_great_self,self_great_R16P,                                                          &
#endif
                             R8P_great_self,self_great_R8P,R4P_great_self,self_great_R4P,I8P_great_self,self_great_I8P,&
                             I4P_great_self,self_great_I4P,I2P_great_self,self_great_I2P,I1P_great_self,self_great_I1P
#ifdef r16p
    procedure, pass(self ), private :: R16P_not_eq_self
    procedure, pass(self ), private :: self_not_eq_R16P
    procedure, pass(self ), private :: R16P_low_self
    procedure, pass(self ), private :: self_low_R16P
    procedure, pass(self ), private :: R16P_low_eq_self
    procedure, pass(self ), private :: self_low_eq_R16P
    procedure, pass(self ), private :: R16P_eq_self
    procedure, pass(self ), private :: self_eq_R16P
    procedure, pass(self ), private :: R16P_great_eq_self
    procedure, pass(self ), private :: self_great_eq_R16P
    procedure, pass(self ), private :: R16P_great_self
    procedure, pass(self ), private :: self_great_R16P
#endif
    procedure, pass(self1), private :: self_not_eq_self
    procedure, pass(self ), private :: R8P_not_eq_self
    procedure, pass(self ), private :: R4P_not_eq_self
    procedure, pass(self ), private :: I8P_not_eq_self
    procedure, pass(self ), private :: I4P_not_eq_self
    procedure, pass(self ), private :: I2P_not_eq_self
    procedure, pass(self ), private :: I1P_not_eq_self
    procedure, pass(self ), private :: self_not_eq_R8P
    procedure, pass(self ), private :: self_not_eq_R4P
    procedure, pass(self ), private :: self_not_eq_I8P
    procedure, pass(self ), private :: self_not_eq_I4P
    procedure, pass(self ), private :: self_not_eq_I2P
    procedure, pass(self ), private :: self_not_eq_I1P
    procedure, pass(self1), private :: self_low_self
    procedure, pass(self ), private :: R8P_low_self
    procedure, pass(self ), private :: R4P_low_self
    procedure, pass(self ), private :: I8P_low_self
    procedure, pass(self ), private :: I4P_low_self
    procedure, pass(self ), private :: I2P_low_self
    procedure, pass(self ), private :: I1P_low_self
    procedure, pass(self ), private :: self_low_R8P
    procedure, pass(self ), private :: self_low_R4P
    procedure, pass(self ), private :: self_low_I8P
    procedure, pass(self ), private :: self_low_I4P
    procedure, pass(self ), private :: self_low_I2P
    procedure, pass(self ), private :: self_low_I1P
    procedure, pass(self1), private :: self_low_eq_self
    procedure, pass(self ), private :: R8P_low_eq_self
    procedure, pass(self ), private :: R4P_low_eq_self
    procedure, pass(self ), private :: I8P_low_eq_self
    procedure, pass(self ), private :: I4P_low_eq_self
    procedure, pass(self ), private :: I2P_low_eq_self
    procedure, pass(self ), private :: I1P_low_eq_self
    procedure, pass(self ), private :: self_low_eq_R8P
    procedure, pass(self ), private :: self_low_eq_R4P
    procedure, pass(self ), private :: self_low_eq_I8P
    procedure, pass(self ), private :: self_low_eq_I4P
    procedure, pass(self ), private :: self_low_eq_I2P
    procedure, pass(self ), private :: self_low_eq_I1P
    procedure, pass(self1), private :: self_eq_self
    procedure, pass(self ), private :: R8P_eq_self
    procedure, pass(self ), private :: R4P_eq_self
    procedure, pass(self ), private :: I8P_eq_self
    procedure, pass(self ), private :: I4P_eq_self
    procedure, pass(self ), private :: I2P_eq_self
    procedure, pass(self ), private :: I1P_eq_self
    procedure, pass(self ), private :: self_eq_R8P
    procedure, pass(self ), private :: self_eq_R4P
    procedure, pass(self ), private :: self_eq_I8P
    procedure, pass(self ), private :: self_eq_I4P
    procedure, pass(self ), private :: self_eq_I2P
    procedure, pass(self ), private :: self_eq_I1P
    procedure, pass(self1), private :: self_great_eq_self
    procedure, pass(self ), private :: R8P_great_eq_self
    procedure, pass(self ), private :: R4P_great_eq_self
    procedure, pass(self ), private :: I8P_great_eq_self
    procedure, pass(self ), private :: I4P_great_eq_self
    procedure, pass(self ), private :: I2P_great_eq_self
    procedure, pass(self ), private :: I1P_great_eq_self
    procedure, pass(self ), private :: self_great_eq_R8P
    procedure, pass(self ), private :: self_great_eq_R4P
    procedure, pass(self ), private :: self_great_eq_I8P
    procedure, pass(self ), private :: self_great_eq_I4P
    procedure, pass(self ), private :: self_great_eq_I2P
    procedure, pass(self ), private :: self_great_eq_I1P
    procedure, pass(self1), private :: self_great_self
    procedure, pass(self ), private :: R8P_great_self
    procedure, pass(self ), private :: R4P_great_self
    procedure, pass(self ), private :: I8P_great_self
    procedure, pass(self ), private :: I4P_great_self
    procedure, pass(self ), private :: I2P_great_self
    procedure, pass(self ), private :: I1P_great_self
    procedure, pass(self ), private :: self_great_R8P
    procedure, pass(self ), private :: self_great_R4P
    procedure, pass(self ), private :: self_great_I8P
    procedure, pass(self ), private :: self_great_I4P
    procedure, pass(self ), private :: self_great_I2P
    procedure, pass(self ), private :: self_great_I1P
endtype vector

type, public :: vector_ptr
  !< Pointer of Vector for creating array of pointers of Vector.
  type(vector), pointer:: p=>null()
endtype vector_ptr

type(vector), parameter :: ex = Vector(1._R_P, 0._R_P, 0._R_P) !< X direction versor.
type(vector), parameter :: ey = Vector(0._R_P, 1._R_P, 0._R_P) !< Y direction versor.
type(vector), parameter :: ez = Vector(0._R_P, 0._R_P, 1._R_P) !< Z direction versor.

contains
  elemental function sq_norm(vec) result(sq)
  !< Compute the square of the norm of a vector.
  !<
  !< The square norm if defined as \( N = x^2  + y^2  + z^2 \).
  type(vector), intent(in) :: vec !< Vector.
  real(R_P)                :: sq  !< Square of the Norm.

  sq = (vec%x * vec%x) + (vec%y * vec%y) + (vec%z * vec%z)
  endfunction sq_norm

  elemental function normL2(vec) result(norm)
  !< Compute the norm L2 of a vector.
  !<
  !< The norm L2 if defined as \( N = \sqrt {x^2  + y^2  + z^2 } \).
  type(vector), intent(in) :: vec  !< Vector.
  real(R_P)                :: norm !< Norm L2.

  norm = sqrt((vec%x*vec%x) + (vec%y*vec%y) + (vec%z*vec%z))
  endfunction normL2

  elemental function normalize(vec) result(norm)
  !< Normalize a vector.
  !<
  !< The normalization is made by means of norm L2. If the norm L2 of the vector is less than the parameter smallR_P the
  !< normalization value is set to normL2(vec)+smallR_P.
  type(vector), intent(in) :: vec  !< Vector to be normalized.
  type(vector)             :: norm !< Vector normalized.
  real(R_P)                :: nm   !< Norm L2 of vector.

  nm = normL2(vec)
  if (nm < smallR_P) then
    nm = nm + smallR_P
  endif
  norm%x = vec%x / nm
  norm%y = vec%y / nm
  norm%z = vec%z / nm
  endfunction normalize

  elemental function face_normal4(pt1, pt2, pt3, pt4, norm) result(fnormal)
  !< Calculate the normal of the face defined by 4 points vector pt1, pt2, pt3 and pt4.
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
  type(vector), intent(in)           :: pt1     !< First face point.
  type(vector), intent(in)           :: pt2     !< Second face point.
  type(vector), intent(in)           :: pt3     !< Third face point.
  type(vector), intent(in)           :: pt4     !< Fourth face point.
  character(1), intent(in), optional :: norm    !< If 'norm' is passed as argument the normal is normalized.
  type(vector)                       :: fnormal !< Face normal.
  type(vector)                       :: d13     !< Face 1-3 diagonal.
  type(vector)                       :: d24     !< Face 2-4 diagonal.

  d13 = pt3 - pt1
  d24 = pt4 - pt2
  if (present(norm)) then
    fnormal = normalize(d13.cross.d24)
  else
    fnormal = 0.5_R_P * (d13.cross.d24)
  endif
  endfunction face_normal4

  elemental function face_normal3(pt1, pt2, pt3, norm) result(fnormal)
  !< Calculate the normal of the face defined by the 3 points vector pt1, pt2 and pt3.
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
  !< The normal is normalized if the variable 'norm' is passed (with any value).
  type(vector), intent(in)           :: pt1     !< First face point.
  type(vector), intent(in)           :: pt2     !< Second face point.
  type(vector), intent(in)           :: pt3     !< Third face point.
  character(1), intent(in), optional :: norm    !< If 'norm' is passed as argument the normal is normalized.
  type(vector)                       :: fnormal !< Face normal.
  type(vector)                       :: s12     !< Face 1-2 diagonals.
  type(vector)                       :: s13     !< Face 1-3 diagonals.

  s12 = pt2 - pt1
  s13 = pt3 - pt1
  if (present(norm)) then
    fnormal = normalize(s12.cross.s13)
  else
    fnormal = 0.5_R_P * (s12.cross.s13)
  endif
  endfunction face_normal3

  elemental subroutine init_vector_self(vec)
  !< Initialize components of Vector variable.
  class(vector), intent(inout) :: vec !< Vector.

  vec%x = 0._R_P
  vec%y = 0._R_P
  vec%z = 0._R_P
  endsubroutine init_vector_self

  elemental subroutine set_vector_self(vec, x, y, z)
  !< Set components of Vector variable.
  class(vector), intent(inout)        :: vec !< Vector.
  real(R_P),     intent(in), optional :: x   !< Cartesian component in x direction.
  real(R_P),     intent(in), optional :: y   !< Cartesian component in y direction.
  real(R_P),     intent(in), optional :: z   !< Cartesian component in z direction.

  if (present(x)) vec%x = x
  if (present(y)) vec%y = y
  if (present(z)) vec%z = z
  endsubroutine set_vector_self

  function iolen_vector_self(vec) result(iolen)
  !< Compute IO length.
  class(vector), intent(in) :: vec   !< Vector.
  integer(I4P)              :: iolen !< IO length.

  inquire(iolength=iolen) vec%x, vec%y, vec%z
  endfunction iolen_vector_self

  subroutine load_vector_self(vec, unit, pos, iostat, iomsg)
  !< Load Vector data.
  class(vector), intent(inout)         :: vec     !< Vector data.
  integer(I4P),  intent(in)            :: unit    !< Logic unit.
  integer(I8P),  intent(in),  optional :: pos     !< Position specifier.
  integer(I4P),  intent(out), optional :: iostat  !< IO error.
  character(*),  intent(out), optional :: iomsg   !< IO error message.
  integer(I4P)                         :: iostatd !< IO error.
  character(500)                       :: iomsgd  !< Temporary variable for IO error message.

  if (present(pos)) then
    read(unit=unit, pos=pos, iostat=iostatd, iomsg=iomsgd)vec%x, vec%y, vec%z
  else
    read(unit=unit,          iostat=iostatd, iomsg=iomsgd)vec%x, vec%y, vec%z
  endif
  if (present(iostat)) iostat = iostatd
  if (present(iomsg))  iomsg  = trim(adjustl(iomsgd))
  endsubroutine load_vector_self

  subroutine save_vector_self(vec, unit, pos, iostat, iomsg)
  !< Save Vector data.
  class(vector), intent(in)            :: vec     !< Vector data.
  integer(I4P),  intent(in)            :: unit    !< Logic unit.
  integer(I8P),  intent(in),  optional :: pos     !< Position specifier.
  integer(I4P),  intent(out), optional :: iostat  !< IO error.
  character(*),  intent(out), optional :: iomsg   !< IO error message.
  integer(I4P)                         :: iostatd !< IO error.
  character(500)                       :: iomsgd  !< Temporary variable for IO error message.

  if (present(pos)) then
    write(unit=unit, pos=pos, iostat=iostatd, iomsg=iomsgd)vec%x, vec%y, vec%z
  else
    write(unit=unit,          iostat=iostatd, iomsg=iomsgd)vec%x, vec%y, vec%z
  endif
  if (present(iostat)) iostat = iostatd
  if (present(iomsg))  iomsg  = trim(adjustl(iomsgd))
  endsubroutine save_vector_self

  subroutine print_vector_self(vec, unit, pref, iostat, iomsg)
  !< Print in a pretty ascii format the components of type Vector.
  class(vector), intent(in)            :: vec     !< Vector.
  integer(I4P),  intent(in),  optional :: unit    !< Logic unit.
  character(*),  intent(in),  optional :: pref    !< Prefixing string for outputs.
  integer(I4P),  intent(out), optional :: iostat  !< IO error.
  character(*),  intent(out), optional :: iomsg   !< IO error message.
  character(len=:), allocatable        :: prefd   !< Prefixing string.
  integer(I4P)                         :: unitd   !< Logic unit.
  integer(I4P)                         :: iostatd !< IO error.
  character(500)                       :: iomsgd  !< Temporary variable for IO error message.

  unitd = stdout ; if (present(unit)) unitd = unit
  prefd = '' ; if (present(pref)) prefd = pref
  write(unitd, '(A)', iostat=iostatd, iomsg=iomsgd)pref//' Component x '//str(n=vec%x)
  write(unitd, '(A)', iostat=iostatd, iomsg=iomsgd)pref//' Component y '//str(n=vec%y)
  write(unitd, '(A)', iostat=iostatd, iomsg=iomsgd)pref//' Component z '//str(n=vec%z)
  if (present(iostat)) iostat = iostatd
  if (present(iomsg))  iomsg  = trim(adjustl(iomsgd))
  endsubroutine print_vector_self

  elemental subroutine normalize_self(vec)
  !< Normalize a vector.
  !<
  !< The normalization is made by means of norm L2. If the norm L2 of the vector is less than the parameter smallR_P the
  !< normalization value is set to normL2(vec)+smallR_P.
  class(vector), intent(inout) :: vec !< Vector to be normalized.
  real(R_P)                    :: nm  !< Norm L2 of vector.

  nm = normL2(vec)
  if (nm < smallR_P) then
    nm = nm + smallR_P
  endif
  vec%x = vec%x / nm
  vec%y = vec%y / nm
  vec%z = vec%z / nm
  endsubroutine normalize_self

  elemental function normalized_self(vec) result(norm)
  !< Get a normalized copy of a vector.
  !<
  !< The normalization is made by means of norm L2. If the norm L2 of the vector is less than the parameter smallR_P the
  !< normalization value is set to normL2(vec)+smallR_P.
  class(vector), intent(in) :: vec  !< Vector to be normalized.
  type(vector)              :: norm !< Normalized copy.
  real(R_P)                 :: nm   !< Norm L2 of vector.

  nm = normL2(vec)
  if (nm < smallR_P) then
    nm = nm + smallR_P
  endif
  norm%x = vec%x / nm
  norm%y = vec%y / nm
  norm%z = vec%z / nm
  endfunction normalized_self

  elemental function sq_norm_self(vec) result(sq)
  !< Compute the square of the norm of a vector.
  !<
  !< The square norm if defined as \( N = x^2  + y^2  + z^2 \).
  class(vector), intent(in) :: vec !< Vector.
  real(R_P)                 :: sq  !< Square of the Norm.

  sq = (vec%x * vec%x) + (vec%y * vec%y) + (vec%z * vec%z)
  endfunction sq_norm_self

  elemental function normL2_self(vec) result(norm)
  !< Compute the norm L2 of a vector.
  !<
  !< The norm L2 if defined as \( N = \sqrt {x^2  + y^2  + z^2 } \).
  class(vector), intent(in) :: vec  !< Vector.
  real(R_P)                 :: norm !< Norm L2.

  norm = sqrt((vec%x * vec%x) + (vec%y * vec%y) + (vec%z * vec%z))
  endfunction normL2_self

  elemental subroutine face_normal4_self(fnormal, pt1, pt2, pt3, pt4, norm)
  !< Calculate the normal of the face defined by 4 points vector pt1, pt2, pt3 and pt4.
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
  class(vector), intent(inout)        :: fnormal !< Face normal.
  type(vector),  intent(in)           :: pt1     !< First face point.
  type(vector),  intent(in)           :: pt2     !< Second face point.
  type(vector),  intent(in)           :: pt3     !< Third face point.
  type(vector),  intent(in)           :: pt4     !< Fourth face point.
  character(1),  intent(in), optional :: norm    !< If 'norm' is passed as argument the normal is normalized.
  type(vector)                        :: d13     !< Face 1-3 diagonals.
  type(vector)                        :: d24     !< Face 2-4 diagonals.

  d13 = pt3 - pt1
  d24 = pt4 - pt2
  if (present(norm)) then
    fnormal = normalize(d13.cross.d24)
  else
    fnormal = 0.5_R_P * (d13.cross.d24)
  endif
  endsubroutine face_normal4_self

  elemental subroutine face_normal3_self(fnormal, pt1, pt2, pt3, norm)
  !< Calculate the normal of the face defined by the 3 points vector pt1, pt2 and pt3.
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
  class(vector), intent(inout)        :: fnormal !< Face normal.
  type(vector),  intent(in)           :: pt1     !< First face point.
  type(vector),  intent(in)           :: pt2     !< Second face point.
  type(vector),  intent(in)           :: pt3     !< Third face point.
  character(1),  intent(in), optional :: norm    !< If 'norm' is passed as argument the normal is normalized.
  type(vector)                        :: s12     !< Face 1-2 diagonals.
  type(vector)                        :: s13     !< Face 1-3 diagonals.

  s12 = pt2 - pt1
  s13 = pt3 - pt1
  if (present(norm)) then
    fnormal = normalize(s12.cross.s13)
  else
    fnormal = 0.5_R_P * (s12.cross.s13)
  endif
  endsubroutine face_normal3_self

  elemental function crossproduct(vec1, vec2) result(cross)
  !< Compute the cross product of 2 vectors.
  !<
  !< $$ \vec V=\left({y_1 z_2 - z_1 y_2}\right)\vec i +
  !<           \left({z_1 x_2 - x_1 z_2}\right)\vec j +
  !<           \left({x_1 y_2 - y_1 x_2}\right)\vec k $$
  !< where \( x_i \), \( y_i \) and \( z_i \) \( i=1,2 \) are the components of the vectors.
  class(vector), intent(in) :: vec1  !< First vector.
  type(vector),  intent(in) :: vec2  !< Second vector.
  type(vector)              :: cross !< Cross product vector.

  cross%x = (vec1%y * vec2%z) - (vec1%z * vec2%y)
  cross%y = (vec1%z * vec2%x) - (vec1%x * vec2%z)
  cross%z = (vec1%x * vec2%y) - (vec1%y * vec2%x)
  endfunction crossproduct

  elemental function dotproduct(vec1, vec2) result(dot)
  !< Compute the scalar (dot) product of 2 vectors.
  !<
  !< $$ {\rm D}= x_1 \cdot x_2 + y_1 \cdot y_2 + z_1 \cdot z_2 $$
  !< where \( x_i \), \( y_i \) and \( z_i \) \( i=1,2 \) are the components of the vectors.
  class(vector), intent(in) :: vec1 !< First vector.
  type(vector),  intent(in) :: vec2 !< Second vector.
  real(R_P)                 :: dot  !< Dot product.

  dot = (vec1%x * vec2%x) + (vec1%y * vec2%y) + (vec1%z * vec2%z)
  endfunction dotproduct

  elemental function parallel(vec1, vec2) result(paral)
  !> Compute the component of vec1 parallel to vec2.
  class(vector), intent(in) :: vec1  !< First vector.
  type(vector),  intent(in) :: vec2  !< Second vector.
  type(vector)              :: paral !< Component of of vec1 parallel to vec2.

  paral = (vec1.dot.vec2) * normalize(vec2)/normL2(vec2)
  endfunction parallel

  elemental function orthogonal(vec1, vec2) result(ortho)
  !< Compute the component of vec1 orthogonal to vec2.
  class(vector), intent(in) :: vec1  !< First vector.
  type(vector),  intent(in) :: vec2  !< Second vector.
  type(vector)              :: ortho !< Component of of vec1 orthogonal to vec2.

  ortho = vec1 - (vec1.paral.vec2)
  endfunction orthogonal

  ! Operators overloading.
  ! Operator (=)
  pure subroutine assign_self(self1, self2)
  !< Assignment between two selfs.
  class(vector), intent(inout) :: self1 !< Left hand side.
  class(vector), intent(in)    :: self2 !< Right hand side.

  self1%x = self2%x
  self1%y = self2%y
  self1%z = self2%z
  endsubroutine assign_self

  elemental subroutine assign_ScalR16P(self, scal)
  !< Assignment between a scalar (real R16P) and self.
  class(vector), intent(inout) :: self !< Left hand side.
  real(R16P),    intent(in)    :: scal !< Right hand side.

  self%x = real(scal, R_P)
  self%y = real(scal, R_P)
  self%z = real(scal, R_P)
  endsubroutine assign_ScalR16P

  elemental subroutine assign_ScalR8P(self, scal)
  !< Assignment between a scalar (real R8P) and self.
  class(vector), intent(inout) :: self !< Left hand side.
  real(R8P),     intent(in)    :: scal !< Right hand side.

  self%x = real(scal, R_P)
  self%y = real(scal, R_P)
  self%z = real(scal, R_P)
  endsubroutine assign_ScalR8P

  elemental subroutine assign_ScalR4P(self, scal)
  !< Assignment between a scalar (real R4P) and self.
  class(vector), intent(inout) :: self !< Left hand side.
  real(R4P),     intent(in)    :: scal !< Right hand side.

  self%x = real(scal, R_P)
  self%y = real(scal, R_P)
  self%z = real(scal, R_P)
  endsubroutine assign_ScalR4P

  elemental subroutine assign_ScalI8P(self, scal)
  !< Assignment between a scalar (integer I8P) and self.
  class(vector), intent(inout) :: self !< Left hand side.
  integer(I8P),  intent(in)    :: scal !< Right hand side.

  self%x = real(scal, R_P)
  self%y = real(scal, R_P)
  self%z = real(scal, R_P)
  endsubroutine assign_ScalI8P

  elemental subroutine assign_ScalI4P(self, scal)
  !< Assignment between a scalar (integer I4P) and self.
  class(vector), intent(inout) :: self !< Left hand side.
  integer(I4P),  intent(in)    :: scal !< Right hand side.

  self%x = real(scal, R_P)
  self%y = real(scal, R_P)
  self%z = real(scal, R_P)
  endsubroutine assign_ScalI4P

  elemental subroutine assign_ScalI2P(self, scal)
  !< Assignment between a scalar (integer I2P) and self.
  class(vector), intent(inout) :: self !< Left hand side.
  integer(I2P),  intent(in)    :: scal !< Right hand side.

  self%x = real(scal, R_P)
  self%y = real(scal, R_P)
  self%z = real(scal, R_P)
  endsubroutine assign_ScalI2P

  elemental subroutine assign_ScalI1P(self, scal)
  !< Assignment between a scalar (integer I1P) and self.
  class(vector), intent(inout) :: self !< Left hand side.
  integer(I1P),  intent(in)    :: scal !< Right hand side.

  self%x = real(scal, R_P)
  self%y = real(scal, R_P)
  self%z = real(scal, R_P)
  endsubroutine assign_ScalI1P

  ! Operator (*)
  elemental function self_mul_self(self1, self2) result(mul)
  !< Multiply (by components) two selfs.
  class(vector), intent(in) :: self1 !< Left hand side.
  type(vector),  intent(in) :: self2 !< Right hand side.
  type(vector)              :: mul   !< Operator result.

  mul%x = self1%x * self2%x
  mul%y = self1%y * self2%y
  mul%z = self1%z * self2%z
  endfunction self_mul_self

  elemental function ScalR16P_mul_self(scal, self) result(mul)
  !< Multiply scalar (real R16P) for self.
  real(R16P),    intent(in) :: scal !< Left hand side.
  class(vector), intent(in) :: self !< Right hand side.
  type(vector)              :: mul  !< Operator result.

  mul%x = real(scal, R_P) * self%x
  mul%y = real(scal, R_P) * self%y
  mul%z = real(scal, R_P) * self%z
  endfunction ScalR16P_mul_self

  elemental function self_mul_ScalR16P(self, scal) result(mul)
  !< Multiply self for scalar (real R16P).
  class(vector), intent(in) :: self !< Left hand side.
  real(R16P),    intent(in) :: scal !< Right hand side.
  type(vector)              :: mul  !< Operator result.

  mul%x = real(scal, R_P) * self%x
  mul%y = real(scal, R_P) * self%y
  mul%z = real(scal, R_P) * self%z
  endfunction self_mul_ScalR16P

  elemental function ScalR8P_mul_self(scal, self) result(mul)
  !< Multiply scalar (real R8P) for self.
  real(R8P),     intent(in) :: scal !< Left hand side.
  class(vector), intent(in) :: self !< Right hand side.
  type(vector)              :: mul  !< Operator result.

  mul%x = real(scal, R_P) * self%x
  mul%y = real(scal, R_P) * self%y
  mul%z = real(scal, R_P) * self%z
  endfunction ScalR8P_mul_self

  elemental function self_mul_ScalR8P(self, scal) result(mul)
  !< Multiply self for scalar (real R8P).
  class(vector), intent(in) :: self !< Left hand side.
  real(R8P),     intent(in) :: scal !< Right hand side.
  type(vector)              :: mul  !< Operator result.

  mul%x = real(scal, R_P) * self%x
  mul%y = real(scal, R_P) * self%y
  mul%z = real(scal, R_P) * self%z
  endfunction self_mul_ScalR8P

  elemental function ScalR4P_mul_self(scal, self) result(mul)
  !< Multiply scalar (real R4P) for self.
  real(R4P),     intent(in) :: scal !< Left hand side.
  class(vector), intent(in) :: self !< Right hand side.
  type(vector)              :: mul  !< Operator result.

  mul%x = real(scal, R_P) * self%x
  mul%y = real(scal, R_P) * self%y
  mul%z = real(scal, R_P) * self%z
  endfunction ScalR4P_mul_self

  elemental function self_mul_ScalR4P(self, scal) result(mul)
  !< Multiply self for scalar (real R4P).
  class(vector), intent(in) :: self !< Left hand side.
  real(R4P),     intent(in) :: scal !< Right hand side.
  type(vector)              :: mul  !< Operator result.

  mul%x = real(scal, R_P) * self%x
  mul%y = real(scal, R_P) * self%y
  mul%z = real(scal, R_P) * self%z
  endfunction self_mul_ScalR4P

  elemental function ScalI8P_mul_self(scal, self) result(mul)
  !< Multiply scalar (integer I8P) for self.
  integer(I8P),  intent(in) :: scal !< Left hand side.
  class(vector), intent(in) :: self !< Right hand side.
  type(vector)              :: mul  !< Operator result.

  mul%x = real(scal, R_P) * self%x
  mul%y = real(scal, R_P) * self%y
  mul%z = real(scal, R_P) * self%z
  endfunction ScalI8P_mul_self

  elemental function self_mul_ScalI8P(self, scal) result(mul)
  !< Multiply self for scalar (integer I8P).
  class(vector), intent(in) :: self !< Left hand side.
  integer(I8P),  intent(in) :: scal !< Right hand side.
  type(vector)              :: mul  !< Operator result.

  mul%x = real(scal, R_P) * self%x
  mul%y = real(scal, R_P) * self%y
  mul%z = real(scal, R_P) * self%z
  endfunction self_mul_ScalI8P

  elemental function ScalI4P_mul_self(scal, self) result(mul)
  !< Multiply scalar (integer I4P) for self.
  integer(I4P),  intent(in) :: scal !< Left hand side.
  class(vector), intent(in) :: self !< Right hand side.
  type(vector)              :: mul  !< Operator result.

  mul%x = real(scal, R_P) * self%x
  mul%y = real(scal, R_P) * self%y
  mul%z = real(scal, R_P) * self%z
  endfunction ScalI4P_mul_self

  elemental function self_mul_ScalI4P(self, scal) result(mul)
  !< Multiply self for scalar (integer I4P).
  class(vector), intent(in) :: self !< Left hand side.
  integer(I4P),  intent(in) :: scal !< Right hand side.
  type(vector)              :: mul  !< Operator result.

  mul%x = real(scal, R_P) * self%x
  mul%y = real(scal, R_P) * self%y
  mul%z = real(scal, R_P) * self%z
  endfunction self_mul_ScalI4P

  elemental function ScalI2P_mul_self(scal, self) result(mul)
  !< Multiply scalar (integer I2P) for self.
  integer(I2P),  intent(in) :: scal !< Left hand side.
  class(vector), intent(in) :: self !< Right hand side.
  type(vector)              :: mul  !< Operator result.

  mul%x = real(scal, R_P) * self%x
  mul%y = real(scal, R_P) * self%y
  mul%z = real(scal, R_P) * self%z
  endfunction ScalI2P_mul_self

  elemental function self_mul_ScalI2P(self, scal) result(mul)
  !< Multiply self for scalar (integer I2P).
  class(vector), intent(in) :: self !< Left hand side.
  integer(I2P),  intent(in) :: scal !< Right hand side.
  type(vector)              :: mul  !< Operator result.

  mul%x = real(scal, R_P) * self%x
  mul%y = real(scal, R_P) * self%y
  mul%z = real(scal, R_P) * self%z
  endfunction self_mul_ScalI2P

  elemental function ScalI1P_mul_self(scal, self) result(mul)
  !< Multiply scalar (integer I1P) for self.
  integer(I1P),  intent(in) :: scal !< Left hand side.
  class(vector), intent(in) :: self !< Right hand side.
  type(vector)              :: mul  !< Operator result.

  mul%x = real(scal, R_P) * self%x
  mul%y = real(scal, R_P) * self%y
  mul%z = real(scal, R_P) * self%z
  endfunction ScalI1P_mul_self

  elemental function self_mul_ScalI1P(self, scal) result(mul)
  !< Multiply self for scalar (integer I1P).
  class(vector), intent(in) :: self !< Left hand side.
  integer(I1P),  intent(in) :: scal !< Right hand side.
  type(vector)              :: mul  !< Operator result.

  mul%x = real(scal, R_P) * self%x
  mul%y = real(scal, R_P) * self%y
  mul%z = real(scal, R_P) * self%z
  endfunction self_mul_ScalI1P

  ! Operator (/)
  elemental function self_div_self(self1, self2) result(div)
  !< Divide self for self.
  class(vector), intent(in) :: self1 !< Left hand side.
  type(vector),  intent(in) :: self2 !< Right hand side.
  type(vector)              :: div   !< Operator result.

  div%x = self1%x / self2%x
  div%y = self1%y / self2%y
  div%z = self1%z / self2%z
  endfunction self_div_self

  elemental function self_div_ScalR16P(self, scal) result(div)
  !< Divide self for scalar (real R16P).
  class(vector), intent(in) :: self !< Left hand side.
  real(R16P),    intent(in) :: scal !< Right hand side.
  type(vector)              :: div  !< Operator result.

  div%x = self%x / real(scal, R_P)
  div%y = self%y / real(scal, R_P)
  div%z = self%z / real(scal, R_P)
  endfunction self_div_ScalR16P

  elemental function self_div_ScalR8P(self, scal) result(div)
  !< Divide self for scalar (real R8P).
  class(vector), intent(in) :: self !< Left hand side.
  real(R8P),     intent(in) :: scal !< Right hand side.
  type(vector)              :: div  !< Operator result.

  div%x = self%x / real(scal, R_P)
  div%y = self%y / real(scal, R_P)
  div%z = self%z / real(scal, R_P)
  endfunction self_div_ScalR8P

  elemental function self_div_ScalR4P(self, scal) result(div)
  !< Divide self for scalar (real R4P).
  class(vector), intent(in) :: self !< Left hand side.
  real(R4P),     intent(in) :: scal !< Right hand side.
  type(vector)              :: div  !< Operator result.

  div%x = self%x / real(scal, R_P)
  div%y = self%y / real(scal, R_P)
  div%z = self%z / real(scal, R_P)
  endfunction self_div_ScalR4P

  elemental function self_div_ScalI8P(self, scal) result(div)
  !< Divide self for scalar (integer I8P).
  class(vector), intent(in) :: self !< Left hand side.
  integer(I8P),  intent(in) :: scal !< Right hand side.
  type(vector)              :: div  !< Operator result.

  div%x = self%x / real(scal, R_P)
  div%y = self%y / real(scal, R_P)
  div%z = self%z / real(scal, R_P)
  endfunction self_div_ScalI8P

  elemental function self_div_ScalI4P(self, scal) result(div)
  !< Divide self for scalar (integer I4P).
  class(vector), intent(in) :: self !< Left hand side.
  integer(I4P),  intent(in) :: scal !< Right hand side.
  type(vector)              :: div  !< Operator result.

  div%x = self%x / real(scal, R_P)
  div%y = self%y / real(scal, R_P)
  div%z = self%z / real(scal, R_P)
  endfunction self_div_ScalI4P

  elemental function self_div_ScalI2P(self, scal) result(div)
  !< Divide self for scalar (integer I2P).
  class(vector), intent(in) :: self !< Left hand side.
  integer(I2P),  intent(in) :: scal !< Right hand side.
  type(vector)              :: div  !< Operator result.

  div%x = self%x / real(scal, R_P)
  div%y = self%y / real(scal, R_P)
  div%z = self%z / real(scal, R_P)
  endfunction self_div_ScalI2P

  elemental function self_div_ScalI1P(self, scal) result(div)
  !< Divide self for scalar (integer I1P).
  class(vector), intent(in) :: self !< Left hand side.
  integer(I1P),  intent(in) :: scal !< Right hand side.
  type(vector)              :: div  !< Operator result.

  div%x = self%x / real(scal, R_P)
  div%y = self%y / real(scal, R_P)
  div%z = self%z / real(scal, R_P)
  endfunction self_div_ScalI1P

  ! Operator (+)
  elemental function positive_self(self) result(pos)
  !< Applay unary + to a self.
  class(vector), intent(in) :: self !< Unary object.
  type(vector)              :: pos  !< Operator result.
  pos%x = + self%x
  pos%y = + self%y
  pos%z = + self%z
  endfunction positive_self

  elemental function self_sum_self(self1, self2) result(summ)
  !< Sum self and self.
  class(vector), intent(in) :: self1 !< Left hand side.
  type(vector),  intent(in) :: self2 !< Right hand side.
  type(vector)              :: summ  !< Operator result.

  summ%x = self1%x + self2%x
  summ%y = self1%y + self2%y
  summ%z = self1%z + self2%z
  endfunction self_sum_self

  elemental function ScalR16P_sum_self(scal, self) result(summ)
  !< Sum scalar (real R16P) and self.
  real(R16P),    intent(in) :: scal !< Left hand side.
  class(vector), intent(in) :: self !< Right hand side.
  type(vector)              :: summ !< Operator result.

  summ%x = real(scal, R_P) + self%x
  summ%y = real(scal, R_P) + self%y
  summ%z = real(scal, R_P) + self%z
  endfunction ScalR16P_sum_self

  elemental function self_sum_ScalR16P(self, scal) result(summ)
  !< Sum self and scalar (real R16P).
  class(vector), intent(in) :: self !< Left hand side.
  real(R16P),    intent(in) :: scal !< Right hand side.
  type(vector)              :: summ !< Operator result.

  summ%x = real(scal, R_P) + self%x
  summ%y = real(scal, R_P) + self%y
  summ%z = real(scal, R_P) + self%z
  endfunction self_sum_ScalR16P

  elemental function ScalR8P_sum_self(scal, self) result(summ)
  !< Sum scalar (real R8P) and self.
  real(R8P),     intent(in) :: scal !< Left hand side.
  class(vector), intent(in) :: self !< Right hand side.
  type(vector)              :: summ !< Operator result.

  summ%x = real(scal, R_P) + self%x
  summ%y = real(scal, R_P) + self%y
  summ%z = real(scal, R_P) + self%z
  endfunction ScalR8P_sum_self

  elemental function self_sum_ScalR8P(self, scal) result(summ)
  !< Sum self and scalar (real R8P).
  class(vector), intent(in) :: self !< Left hand side.
  real(R8P),     intent(in) :: scal !< Right hand side.
  type(vector)              :: summ !< Operator result.

  summ%x = real(scal, R_P) + self%x
  summ%y = real(scal, R_P) + self%y
  summ%z = real(scal, R_P) + self%z
  endfunction self_sum_ScalR8P

  elemental function ScalR4P_sum_self(scal, self) result(summ)
  !< Sum scalar (real R4P) and self.
  real(R4P),     intent(in) :: scal !< Left hand side.
  class(vector), intent(in) :: self !< Right hand side.
  type(vector)              :: summ !< Operator result.

  summ%x = real(scal, R_P) + self%x
  summ%y = real(scal, R_P) + self%y
  summ%z = real(scal, R_P) + self%z
  endfunction ScalR4P_sum_self

  elemental function self_sum_ScalR4P(self, scal) result(summ)
  !< Sum self and scalar (real R4P).
  class(vector), intent(in) :: self !< Left hand side.
  real(R4P),     intent(in) :: scal !< Right hand side.
  type(vector)              :: summ !< Operator result.

  summ%x = real(scal, R_P) + self%x
  summ%y = real(scal, R_P) + self%y
  summ%z = real(scal, R_P) + self%z
  endfunction self_sum_ScalR4P

  elemental function ScalI8P_sum_self(scal, self) result(summ)
  !< Sum scalar (integer I8P) and self.
  integer(I8P),  intent(in) :: scal !< Left hand side.
  class(vector), intent(in) :: self !< Right hand side.
  type(vector)              :: summ !< Operator result.

  summ%x = real(scal, R_P) + self%x
  summ%y = real(scal, R_P) + self%y
  summ%z = real(scal, R_P) + self%z
  endfunction ScalI8P_sum_self

  elemental function self_sum_ScalI8P(self, scal) result(summ)
  !< Sum self and scalar (integer I8P).
  class(vector), intent(in) :: self !< Left hand side.
  integer(I8P),  intent(in) :: scal !< Right hand side.
  type(vector)              :: summ !< Operator result.

  summ%x = real(scal, R_P) + self%x
  summ%y = real(scal, R_P) + self%y
  summ%z = real(scal, R_P) + self%z
  endfunction self_sum_ScalI8P

  elemental function ScalI4P_sum_self(scal, self) result(summ)
  !< Sum scalar (integer I4P) and self.
  integer(I4P),  intent(in) :: scal !< Left hand side.
  class(vector), intent(in) :: self !< Right hand side.
  type(vector)              :: summ !< Operator result.

  summ%x = real(scal, R_P) + self%x
  summ%y = real(scal, R_P) + self%y
  summ%z = real(scal, R_P) + self%z
  endfunction ScalI4P_sum_self

  elemental function self_sum_ScalI4P(self, scal) result(summ)
  !< Sum self and scalar (integer I4P).
  class(vector), intent(in) :: self !< Left hand side.
  integer(I4P),  intent(in) :: scal !< Right hand side.
  type(vector)              :: summ !< Operator result.

  summ%x = real(scal, R_P) + self%x
  summ%y = real(scal, R_P) + self%y
  summ%z = real(scal, R_P) + self%z
  endfunction self_sum_ScalI4P

  elemental function ScalI2P_sum_self(scal, self) result(summ)
  !< Sum scalar (integer I2P) and self.
  integer(I2P),  intent(in) :: scal !< Left hand side.
  class(vector), intent(in) :: self !< Right hand side.
  type(vector)              :: summ !< Operator result.

  summ%x = real(scal, R_P) + self%x
  summ%y = real(scal, R_P) + self%y
  summ%z = real(scal, R_P) + self%z
  endfunction ScalI2P_sum_self

  elemental function self_sum_ScalI2P(self, scal) result(summ)
  !< Sum self and scalar (integer I2P).
  class(vector), intent(in) :: self !< Left hand side.
  integer(I2P),  intent(in) :: scal !< Right hand side.
  type(vector)              :: summ !< Operator result.

  summ%x = real(scal, R_P) + self%x
  summ%y = real(scal, R_P) + self%y
  summ%z = real(scal, R_P) + self%z
  endfunction self_sum_ScalI2P

  elemental function ScalI1P_sum_self(scal, self) result(summ)
  !< Sum scalar (integer I1P) and self.
  integer(I1P),  intent(in) :: scal !< Left hand side.
  class(vector), intent(in) :: self !< Right hand side.
  type(vector)              :: summ !< Operator result.

  summ%x = real(scal, R_P) + self%x
  summ%y = real(scal, R_P) + self%y
  summ%z = real(scal, R_P) + self%z
  endfunction ScalI1P_sum_self

  elemental function self_sum_ScalI1P(self, scal) result(summ)
  !< Sum self and scalar (integer I1P).
  class(vector), intent(in) :: self !< Left hand side.
  integer(I1P),  intent(in) :: scal !< Right hand side.
  type(vector)              :: summ !< Operator result.

  summ%x = real(scal, R_P) + self%x
  summ%y = real(scal, R_P) + self%y
  summ%z = real(scal, R_P) + self%z
  endfunction self_sum_ScalI1P

  ! Operator (-)
  elemental function negative_self(self) result(neg)
  !< Applay unary - to a self.
  class(vector), intent(in) :: self !< Unary object.
  type(vector)              :: neg  !< Operator result.

  neg%x = - self%x
  neg%y = - self%y
  neg%z = - self%z
  endfunction negative_self

  elemental function self_sub_self(self1, self2) result(sub)
  !< Subtract self and self.
  class(vector), intent(in) :: self1 !< Left hand side.
  type(vector),  intent(in) :: self2 !< Right hand side.
  type(vector)              :: sub   !< Operator result.

  sub%x = self1%x - self2%x
  sub%y = self1%y - self2%y
  sub%z = self1%z - self2%z
  endfunction self_sub_self

  elemental function ScalR16P_sub_self(scal, self) result(sub)
  !< Subtract scalar (real R16P) and self.
  real(R16P),    intent(in) :: scal !< Left hand side.
  class(vector), intent(in) :: self !< Right hand side.
  type(vector)              :: sub  !< Operator result.

  sub%x = real(scal, R_P) - self%x
  sub%y = real(scal, R_P) - self%y
  sub%z = real(scal, R_P) - self%z
  endfunction ScalR16P_sub_self

  elemental function self_sub_ScalR16P(self, scal) result(sub)
  !< Subtract self and scalar (real R16P).
  class(vector), intent(in) :: self !< Left hand side.
  real(R16P),    intent(in) :: scal !< Right hand side.
  type(vector)              :: sub  !< Operator result.

  sub%x = self%x - real(scal, R_P)
  sub%y = self%y - real(scal, R_P)
  sub%z = self%z - real(scal, R_P)
  endfunction self_sub_ScalR16P

  elemental function ScalR8P_sub_self(scal, self) result(sub)
  !< Subtract scalar (real R8P) and self.
  real(R8P),     intent(in) :: scal !< Left hand side.
  class(vector), intent(in) :: self !< Right hand side.
  type(vector)              :: sub  !< Operator result.

  sub%x = real(scal, R_P) - self%x
  sub%y = real(scal, R_P) - self%y
  sub%z = real(scal, R_P) - self%z
  endfunction ScalR8P_sub_self

  elemental function self_sub_ScalR8P(self, scal) result(sub)
  !< Subtract self and scalar (real R8P).
  class(vector), intent(in) :: self !< Left hand side.
  real(R8P),     intent(in) :: scal !< Right hand side.
  type(vector)              :: sub  !< Operator result.

  sub%x = self%x - real(scal, R_P)
  sub%y = self%y - real(scal, R_P)
  sub%z = self%z - real(scal, R_P)
  endfunction self_sub_ScalR8P

  elemental function ScalR4P_sub_self(scal, self) result(sub)
  !< Subtract scalar (real R4P) and self.
  real(R4P),     intent(in) :: scal !< Left hand side.
  class(vector), intent(in) :: self !< Right hand side.
  type(vector)              :: sub  !< Operator result.

  sub%x = real(scal, R_P) - self%x
  sub%y = real(scal, R_P) - self%y
  sub%z = real(scal, R_P) - self%z
  endfunction ScalR4P_sub_self

  elemental function self_sub_ScalR4P(self, scal) result(sub)
  !< Subtract self and scalar (real R4P).
  class(vector), intent(in) :: self !< Left hand side.
  real(R4P),     intent(in) :: scal !< Right hand side.
  type(vector)              :: sub  !< Operator result.

  sub%x = self%x - real(scal, R_P)
  sub%y = self%y - real(scal, R_P)
  sub%z = self%z - real(scal, R_P)
  endfunction self_sub_ScalR4P

  elemental function ScalI8P_sub_self(scal, self) result(sub)
  !< Subtract scalar (integer I8P) and self.
  integer(I8P),  intent(in) :: scal !< Left hand side.
  class(vector), intent(in) :: self !< Right hand side.
  type(vector)              :: sub  !< Operator result.

  sub%x = real(scal, R_P) - self%x
  sub%y = real(scal, R_P) - self%y
  sub%z = real(scal, R_P) - self%z
  endfunction ScalI8P_sub_self

  elemental function self_sub_ScalI8P(self, scal) result(sub)
  !< Subtract self and scalar (integer I8P).
  class(vector), intent(in) :: self !< Left hand side.
  integer(I8P),  intent(in) :: scal !< Right hand side.
  type(vector)              :: sub  !< Operator result.

  sub%x = self%x - real(scal, R_P)
  sub%y = self%y - real(scal, R_P)
  sub%z = self%z - real(scal, R_P)
  endfunction self_sub_ScalI8P

  elemental function ScalI4P_sub_self(scal, self) result(sub)
  !< Subtract scalar (integer I4P) and self.
  integer(I4P),  intent(in) :: scal !< Left hand side.
  class(vector), intent(in) :: self !< Right hand side.
  type(vector)              :: sub  !< Operator result.

  sub%x = real(scal, R_P) - self%x
  sub%y = real(scal, R_P) - self%y
  sub%z = real(scal, R_P) - self%z
  endfunction ScalI4P_sub_self

  elemental function self_sub_ScalI4P(self, scal) result(sub)
  !< Subtract self and scalar (integer I4P).
  class(vector), intent(in) :: self !< Left hand side.
  integer(I4P),  intent(in) :: scal !< Right hand side.
  type(vector)              :: sub  !< Operator result.

  sub%x = self%x - real(scal, R_P)
  sub%y = self%y - real(scal, R_P)
  sub%z = self%z - real(scal, R_P)
  endfunction self_sub_ScalI4P

  elemental function ScalI2P_sub_self(scal, self) result(sub)
  !< Subtract scalar (integer I2P) and self.
  integer(I2P),  intent(in) :: scal !< Left hand side.
  class(vector), intent(in) :: self !< Right hand side.
  type(vector)              :: sub  !< Operator result.

  sub%x = real(scal, R_P) - self%x
  sub%y = real(scal, R_P) - self%y
  sub%z = real(scal, R_P) - self%z
  endfunction ScalI2P_sub_self

  elemental function self_sub_ScalI2P(self, scal) result(sub)
  !< Subtract self and scalar (integer I2P).
  class(vector), intent(in) :: self !< Left hand side.
  integer(I2P),  intent(in) :: scal !< Right hand side.
  type(vector)              :: sub  !< Operator result.

  sub%x = self%x - real(scal, R_P)
  sub%y = self%y - real(scal, R_P)
  sub%z = self%z - real(scal, R_P)
  endfunction self_sub_ScalI2P

  elemental function ScalI1P_sub_self(scal, self) result(sub)
  !< Subtract scalar (integer I1P) and self.
  integer(I1P),  intent(in) :: scal !< Left hand side.
  class(vector), intent(in) :: self !< Right hand side.
  type(vector)              :: sub  !< Operator result.

  sub%x = real(scal, R_P) - self%x
  sub%y = real(scal, R_P) - self%y
  sub%z = real(scal, R_P) - self%z
  endfunction ScalI1P_sub_self

  elemental function self_sub_ScalI1P(self, scal) result(sub)
  !< Subtract self and scalar (integer I1P).
  class(vector), intent(in) :: self !< Left hand side.
  integer(I1P),  intent(in) :: scal !< Right hand side.
  type(vector)              :: sub  !< Operator result.

  sub%x = self%x - real(scal, R_P)
  sub%y = self%y - real(scal, R_P)
  sub%z = self%z - real(scal, R_P)
  endfunction self_sub_ScalI1P

  ! Conditional operators
  ! Oprator /=
  elemental function self_not_eq_self(self1, self2) result(compare)
  !< Return .true. if the normL2 of the self1 is /= with respect the normL2 of self2 or if the directions of self1
  !< and self2 are different, .false. otherwise.
  class(vector), intent(in) :: self1   !< First selftor.
  type(vector),  intent(in) :: self2   !< Second selftor.
  logical                   :: compare !< The result of the comparison.
  type(vector)              :: n1      !< Normalizations of self1.
  type(vector)              :: n2      !< Normalizations of self2.

  compare = (normL2(self1)/=normL2(self2))
  if (.not.compare) then ! the normL2 are the same, checking the directions
    n1 = normalize(self1)
    n2 = normalize(self2)
    compare = ((n1%x/=n2%x).OR.(n1%y/=n2%y).OR.(n1%z/=n2%z))
  endif
  endfunction self_not_eq_self

  elemental function R16P_not_eq_self(scal, self) result(compare)
  !< Return .true. if the normL2 of the self is /= with respect the value of scalar scal, .false. otherwise.
  real(R16P),    intent(in) :: scal    !< Left hand side.
  class(vector), intent(in) :: self    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (real(scal, R_P)/=normL2(self))
  endfunction R16P_not_eq_self

  elemental function self_not_eq_R16P(self, scal) result(compare)
  !< Return .true. if the normL2 of the self is /= with respect the value of scalar scal, .false. otherwise.
  class(vector), intent(in) :: self    !< Left hand side.
  real(R16P),    intent(in) :: scal    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (real(scal, R_P)/=normL2(self))
  endfunction self_not_eq_R16P

  elemental function R8P_not_eq_self(scal, self) result(compare)
  !< Return .true. if the normL2 of the self is /= with respect the value of scalar scal, .false. otherwise.
  real(R8P),     intent(in) :: scal    !< Left hand side.
  class(vector), intent(in) :: self    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (real(scal, R_P)/=normL2(self))
  endfunction R8P_not_eq_self

  elemental function self_not_eq_R8P(self, scal) result(compare)
  !< Return .true. if the normL2 of the self is /= with respect the value of scalar scal, .false. otherwise.
  class(vector), intent(in) :: self    !< Left hand side.
  real(R8P),     intent(in) :: scal    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (real(scal, R_P)/=normL2(self))
  endfunction self_not_eq_R8P

  elemental function R4P_not_eq_self(scal, self) result(compare)
  !< Return .true. if the normL2 of the self is /= with respect the value of scalar scal, .false. otherwise.
  real(R4P),     intent(in) :: scal    !< Left hand side.
  class(vector), intent(in) :: self    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (real(scal, R_P)/=normL2(self))
  endfunction R4P_not_eq_self

  elemental function self_not_eq_R4P(self, scal) result(compare)
  !< Return .true. if the normL2 of the self is /= with respect the value of scalar scal, .false. otherwise.
  class(vector), intent(in) :: self    !< Left hand side.
  real(R4P),     intent(in) :: scal    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (real(scal, R_P)/=normL2(self))
  endfunction self_not_eq_R4P

  elemental function I8P_not_eq_self(scal, self) result(compare)
  !< Return .true. if the normL2 of the self is /= with respect the value of scalar scal, .false. otherwise.
  integer(I8P),  intent(in) :: scal    !< Left hand side.
  class(vector), intent(in) :: self    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (real(scal, R_P)/=normL2(self))
  endfunction I8P_not_eq_self

  elemental function self_not_eq_I8P(self, scal) result(compare)
  !< Return .true. if the normL2 of the self is /= with respect the value of scalar scal, .false. otherwise.
  class(vector), intent(in) :: self    !< Left hand side.
  integer(I8P),  intent(in) :: scal    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (real(scal, R_P)/=normL2(self))
  endfunction self_not_eq_I8P

  elemental function I4P_not_eq_self(scal, self) result(compare)
  !< Return .true. if the normL2 of the self is /= with respect the value of scalar scal, .false. otherwise.
  integer(I4P),  intent(in) :: scal    !< Left hand side.
  class(vector), intent(in) :: self    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (real(scal, R_P)/=normL2(self))
  endfunction I4P_not_eq_self

  elemental function self_not_eq_I4P(self, scal) result(compare)
  !< Return .true. if the normL2 of the self is /= with respect the value of scalar scal, .false. otherwise.
  class(vector), intent(in) :: self    !< Left hand side.
  integer(I4P),  intent(in) :: scal    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (real(scal, R_P)/=normL2(self))
  endfunction self_not_eq_I4P

  elemental function I2P_not_eq_self(scal, self) result(compare)
  !< Return .true. if the normL2 of the self is /= with respect the value of scalar scal, .false. otherwise.
  integer(I2P),  intent(in) :: scal    !< Left hand side.
  class(vector), intent(in) :: self    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (real(scal, R_P)/=normL2(self))
  endfunction I2P_not_eq_self

  elemental function self_not_eq_I2P(self, scal) result(compare)
  !< Return .true. if the normL2 of the self is /= with respect the value of scalar scal, .false. otherwise.
  class(vector), intent(in) :: self    !< Left hand side.
  integer(I2P),  intent(in) :: scal    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (real(scal, R_P)/=normL2(self))
  endfunction self_not_eq_I2P

  elemental function I1P_not_eq_self(scal, self) result(compare)
  !< Return .true. if the normL2 of the self is /= with respect the value of scalar scal, .false. otherwise.
  integer(I1P),  intent(in) :: scal    !< Left hand side.
  class(vector), intent(in) :: self    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (real(scal, R_P)/=normL2(self))
  endfunction I1P_not_eq_self

  elemental function self_not_eq_I1P(self, scal) result(compare)
  !< Return .true. if the normL2 of the self is /= with respect the value of scalar scal, .false. otherwise.
  class(vector), intent(in) :: self    !< Left hand side.
  integer(I1P),  intent(in) :: scal    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (real(scal, R_P)/=normL2(self))
  endfunction self_not_eq_I1P

  ! Oprator <
  elemental function self_low_self(self1, self2) result(compare)
  !< Return .true. if the normL2 of the self1 is < with respect the normL2 of self2, .false. otherwise.
  class(vector), intent(in) :: self1   !< Left hand side.
  type(vector),  intent(in) :: self2   !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (normL2(self1)<normL2(self2))
  endfunction self_low_self

  elemental function R16P_low_self(scal, self) result(compare)
  !< Return .true. if the normL2 of the self1 is < with respect the  value of scalar scal, .false. otherwise.
  real(R16P),    intent(in) :: scal    !< Left hand side.
  class(vector), intent(in) :: self    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (real(scal, R_P)<normL2(self))
  endfunction R16P_low_self

  elemental function self_low_R16P(self, scal) result(compare)
  !< Return .true. if the normL2 of the self1 is < with respect the  value of scalar scal, .false. otherwise.
  class(vector), intent(in) :: self    !< Left hand side.
  real(R16P),    intent(in) :: scal    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (normL2(self)<real(scal, R_P))
  endfunction self_low_R16P

  elemental function R8P_low_self(scal, self) result(compare)
  !< Return .true. if the normL2 of the self1 is < with respect the  value of scalar scal, .false. otherwise.
  real(R8P),     intent(in) :: scal    !< Left hand side.
  class(vector), intent(in) :: self    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (real(scal, R_P)<normL2(self))
  endfunction R8P_low_self

  elemental function self_low_R8P(self, scal) result(compare)
  !< Return .true. if the normL2 of the self1 is < with respect the  value of scalar scal, .false. otherwise.
  class(vector), intent(in) :: self    !< Left hand side.
  real(R8P),     intent(in) :: scal    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (normL2(self)<real(scal, R_P))
  endfunction self_low_R8P

  elemental function R4P_low_self(scal, self) result(compare)
  !< Return .true. if the normL2 of the self1 is < with respect the  value of scalar scal, .false. otherwise.
  real(R4P),     intent(in) :: scal    !< Left hand side.
  class(vector), intent(in) :: self    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (real(scal, R_P)<normL2(self))
  endfunction R4P_low_self

  elemental function self_low_R4P(self, scal) result(compare)
  !< Return .true. if the normL2 of the self1 is < with respect the  value of scalar scal, .false. otherwise.
  class(vector), intent(in) :: self    !< Left hand side.
  real(R4P),     intent(in) :: scal    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (normL2(self)<real(scal, R_P))
  endfunction self_low_R4P

  elemental function I8P_low_self(scal, self) result(compare)
  !< Return .true. if the normL2 of the self1 is < with respect the  value of scalar scal, .false. otherwise.
  integer(I8P),  intent(in) :: scal    !< Left hand side.
  class(vector), intent(in) :: self    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (real(scal, R_P)<normL2(self))
  endfunction I8P_low_self

  elemental function self_low_I8P(self, scal) result(compare)
  !< Return .true. if the normL2 of the self1 is < with respect the  value of scalar scal, .false. otherwise.
  class(vector), intent(in) :: self    !< Left hand side.
  integer(I8P),  intent(in) :: scal    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (normL2(self)<real(scal, R_P))
  endfunction self_low_I8P

  elemental function I4P_low_self(scal, self) result(compare)
  !< Return .true. if the normL2 of the self1 is < with respect the  value of scalar scal, .false. otherwise.
  integer(I4P),  intent(in) :: scal    !< Left hand side.
  class(vector), intent(in) :: self    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (real(scal, R_P)<normL2(self))
  endfunction I4P_low_self

  elemental function self_low_I4P(self, scal) result(compare)
  !< Return .true. if the normL2 of the self1 is < with respect the  value of scalar scal, .false. otherwise.
  class(vector), intent(in) :: self    !< Left hand side.
  integer(I4P),  intent(in) :: scal    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (normL2(self)<real(scal, R_P))
  endfunction self_low_I4P

  elemental function I2P_low_self(scal, self) result(compare)
  !< Return .true. if the normL2 of the self1 is < with respect the  value of scalar scal, .false. otherwise.
  integer(I2P),  intent(in) :: scal    !< Left hand side.
  class(vector), intent(in) :: self    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (real(scal, R_P)<normL2(self))
  endfunction I2P_low_self

  elemental function self_low_I2P(self, scal) result(compare)
  !< Return .true. if the normL2 of the self1 is < with respect the  value of scalar scal, .false. otherwise.
  class(vector), intent(in) :: self    !< Left hand side.
  integer(I2P),  intent(in) :: scal    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (normL2(self)<real(scal, R_P))
  endfunction self_low_I2P

  elemental function I1P_low_self(scal, self) result(compare)
  !< Return .true. if the normL2 of the self1 is < with respect the  value of scalar scal, .false. otherwise.
  integer(I1P),  intent(in) :: scal    !< Left hand side.
  class(vector), intent(in) :: self    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (real(scal, R_P)<normL2(self))
  endfunction I1P_low_self

  elemental function self_low_I1P(self, scal) result(compare)
  !< Return .true. if the normL2 of the self1 is < with respect the  value of scalar scal, .false. otherwise.
  class(vector), intent(in) :: self    !< Left hand side.
  integer(I1P),  intent(in) :: scal    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (normL2(self)<real(scal, R_P))
  endfunction self_low_I1P

  ! Oprator <=
  elemental function self_low_eq_self(self1, self2) result(compare)
  !< Return .true. if the normL2 of the self1 is <= with respect the normL2 of self2, .false. otherwise.
  class(vector), intent(in) :: self1   !< Left hand side.
  type(vector),  intent(in) :: self2   !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (normL2(self1)<=normL2(self2))
  endfunction self_low_eq_self

  elemental function R16P_low_eq_self(scal, self) result(compare)
  !< Return .true. if the normL2 of the self1 is <= with respect the  value of scalar scal, .false. otherwise.
  real(R16P),    intent(in) :: scal    !< Left hand side.
  class(vector), intent(in) :: self    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (real(scal, R_P)<=normL2(self))
  endfunction R16P_low_eq_self

  elemental function self_low_eq_R16P(self, scal) result(compare)
  !< Return .true. if the normL2 of the self1 is <= with respect the  value of scalar scal, .false. otherwise.
  class(vector), intent(in) :: self    !< Left hand side.
  real(R16P),    intent(in) :: scal    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (normL2(self)<=real(scal, R_P))
  endfunction self_low_eq_R16P

  elemental function R8P_low_eq_self(scal, self) result(compare)
  !< Return .true. if the normL2 of the self1 is <= with respect the  value of scalar scal, .false. otherwise.
  real(R8P),     intent(in) :: scal    !< Left hand side.
  class(vector), intent(in) :: self    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (real(scal, R_P)<=normL2(self))
  endfunction R8P_low_eq_self

  elemental function self_low_eq_R8P(self, scal) result(compare)
  !< Return .true. if the normL2 of the self1 is <= with respect the  value of scalar scal, .false. otherwise.
  class(vector), intent(in) :: self    !< Left hand side.
  real(R8P),     intent(in) :: scal    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (normL2(self)<=real(scal, R_P))
  endfunction self_low_eq_R8P

  elemental function R4P_low_eq_self(scal, self) result(compare)
  !< Return .true. if the normL2 of the self1 is <= with respect the  value of scalar scal, .false. otherwise.
  real(R4P),     intent(in) :: scal    !< Left hand side.
  class(vector), intent(in) :: self    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (real(scal, R_P)<=normL2(self))
  endfunction R4P_low_eq_self

  elemental function self_low_eq_R4P(self, scal) result(compare)
  !< Return .true. if the normL2 of the self1 is <= with respect the  value of scalar scal, .false. otherwise.
  class(vector), intent(in) :: self    !< Left hand side.
  real(R4P),     intent(in) :: scal    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (normL2(self)<=real(scal, R_P))
  endfunction self_low_eq_R4P

  elemental function I8P_low_eq_self(scal, self) result(compare)
  !< Return .true. if the normL2 of the self1 is <= with respect the  value of scalar scal, .false. otherwise.
  integer(I8P),  intent(in) :: scal    !< Left hand side.
  class(vector), intent(in) :: self    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (real(scal, R_P)<=normL2(self))
  endfunction I8P_low_eq_self

  elemental function self_low_eq_I8P(self, scal) result(compare)
  !< Return .true. if the normL2 of the self1 is <= with respect the  value of scalar scal, .false. otherwise.
  class(vector), intent(in) :: self    !< Left hand side.
  integer(I8P),  intent(in) :: scal    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (normL2(self)<=real(scal, R_P))
  endfunction self_low_eq_I8P

  elemental function I4P_low_eq_self(scal, self) result(compare)
  !< Return .true. if the normL2 of the self1 is <= with respect the  value of scalar scal, .false. otherwise.
  integer(I4P),  intent(in) :: scal    !< Left hand side.
  class(vector), intent(in) :: self    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (real(scal, R_P)<=normL2(self))
  endfunction I4P_low_eq_self

  elemental function self_low_eq_I4P(self, scal) result(compare)
  !< Return .true. if the normL2 of the self1 is <= with respect the  value of scalar scal, .false. otherwise.
  class(vector), intent(in) :: self    !< Left hand side.
  integer(I4P),  intent(in) :: scal    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (normL2(self)<=real(scal, R_P))
  endfunction self_low_eq_I4P

  elemental function I2P_low_eq_self(scal, self) result(compare)
  !< Return .true. if the normL2 of the self1 is <= with respect the  value of scalar scal, .false. otherwise.
  integer(I2P),  intent(in) :: scal    !< Left hand side.
  class(vector), intent(in) :: self    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (real(scal, R_P)<=normL2(self))
  endfunction I2P_low_eq_self

  elemental function self_low_eq_I2P(self, scal) result(compare)
  !< Return .true. if the normL2 of the self1 is <= with respect the  value of scalar scal, .false. otherwise.
  class(vector), intent(in) :: self    !< Left hand side.
  integer(I2P),  intent(in) :: scal    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (normL2(self)<=real(scal, R_P))
  endfunction self_low_eq_I2P

  elemental function I1P_low_eq_self(scal, self) result(compare)
  !< Return .true. if the normL2 of the self1 is <= with respect the  value of scalar scal, .false. otherwise.
  integer(I1P),  intent(in) :: scal    !< Left hand side.
  class(vector), intent(in) :: self    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (real(scal, R_P)<=normL2(self))
  endfunction I1P_low_eq_self

  elemental function self_low_eq_I1P(self, scal) result(compare)
  !< Return .true. if the normL2 of the self1 is <= with respect the  value of scalar scal, .false. otherwise.
  class(vector), intent(in) :: self    !< Left hand side.
  integer(I1P),  intent(in) :: scal    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (normL2(self)<=real(scal, R_P))
  endfunction self_low_eq_I1P

  ! Oprator ==
  elemental function self_eq_self(self1, self2) result(compare)
  !> Return .true. if the normL2 of the self1 is = with respect the normL2 of self2 and the directions of
  !> self1 and self2 are the same, .false. otherwise.
  class(vector), intent(in) :: self1   !< Left hand side.
  type(vector),  intent(in) :: self2   !< Right hand side.
  logical                   :: compare !< Operator result.
  type(vector)              :: n1      !< Normalizations of self1.
  type(vector)              :: n2      !< Normalizations of self2.

  compare = (normL2(self1)==normL2(self2))
  if (compare) then ! the normL2 are the same, checking the directions
    n1 = normalize(self1)
    n2 = normalize(self2)
    compare = ((n1%x==n2%x).AND.(n1%y==n2%y).AND.(n1%z==n2%z))
  endif
  endfunction self_eq_self

  elemental function R16P_eq_self(scal, self) result(compare)
  !< Return .true. if the normL2 of the self is = with respect the value of scalar scal, .false. otherwise.
  real(R16P),    intent(in) :: scal    !< Left hand side.
  class(vector), intent(in) :: self    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (normL2(self)==real(scal, R_P))
  endfunction R16P_eq_self

  elemental function self_eq_R16P(self, scal) result(compare)
  !< Return .true. if the normL2 of the self is = with respect the value of scalar scal, .false. otherwise.
  class(vector), intent(in) :: self    !< Left hand side.
  real(R16P),    intent(in) :: scal    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (normL2(self)==real(scal, R_P))
  endfunction self_eq_R16P

  elemental function R8P_eq_self(scal, self) result(compare)
  !< Return .true. if the normL2 of the self is = with respect the value of scalar scal, .false. otherwise.
  real(R8P),     intent(in) :: scal    !< Left hand side.
  class(vector), intent(in) :: self    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (normL2(self)==real(scal, R_P))
  endfunction R8P_eq_self

  elemental function self_eq_R8P(self, scal) result(compare)
  !< Return .true. if the normL2 of the self is = with respect the value of scalar scal, .false. otherwise.
  class(vector), intent(in) :: self    !< Left hand side.
  real(R8P),     intent(in) :: scal    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (normL2(self)==real(scal, R_P))
  endfunction self_eq_R8P

  elemental function R4P_eq_self(scal, self) result(compare)
  !< Return .true. if the normL2 of the self is = with respect the value of scalar scal, .false. otherwise.
  real(R4P),     intent(in) :: scal    !< Left hand side.
  class(vector), intent(in) :: self    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (normL2(self)==real(scal, R_P))
  endfunction R4P_eq_self

  elemental function self_eq_R4P(self, scal) result(compare)
  !< Return .true. if the normL2 of the self is = with respect the value of scalar scal, .false. otherwise.
  class(vector), intent(in) :: self    !< Left hand side.
  real(R4P),     intent(in) :: scal    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (normL2(self)==real(scal, R_P))
  endfunction self_eq_R4P

  elemental function I8P_eq_self(scal, self) result(compare)
  !< Return .true. if the normL2 of the self is = with respect the value of scalar scal, .false. otherwise.
  integer(I8P),  intent(in) :: scal    !< Left hand side.
  class(vector), intent(in) :: self    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (normL2(self)==real(scal, R_P))
  endfunction I8P_eq_self

  elemental function self_eq_I8P(self, scal) result(compare)
  !< Return .true. if the normL2 of the self is = with respect the value of scalar scal, .false. otherwise.
  class(vector), intent(in) :: self    !< Left hand side.
  integer(I8P),  intent(in) :: scal    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (normL2(self)==real(scal, R_P))
  endfunction self_eq_I8P

  elemental function I4P_eq_self(scal, self) result(compare)
  !< @brief Procedure returns .true. if the normL2 of the self is = with respect the value of scalar scal, .false. otherwise.
  integer(I4P),  intent(in) :: scal    !< Left hand side.
  class(vector), intent(in) :: self    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (normL2(self)==real(scal, R_P))
  endfunction I4P_eq_self

  elemental function self_eq_I4P(self, scal) result(compare)
  !< Return .true. if the normL2 of the self is = with respect the value of scalar scal, .false. otherwise.
  class(vector), intent(in) :: self    !< Left hand side.
  integer(I4P),  intent(in) :: scal    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (normL2(self)==real(scal, R_P))
  endfunction self_eq_I4P

  elemental function I2P_eq_self(scal, self) result(compare)
  !< Return .true. if the normL2 of the self is = with respect the value of scalar scal, .false. otherwise.
  integer(I2P),  intent(in) :: scal    !< Left hand side.
  class(vector), intent(in) :: self    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (normL2(self)==real(scal, R_P))
  endfunction I2P_eq_self

  elemental function self_eq_I2P(self, scal) result(compare)
  !< Return .true. if the normL2 of the self is = with respect the value of scalar scal, .false. otherwise.
  class(vector), intent(in) :: self    !< Left hand side.
  integer(I2P),  intent(in) :: scal    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (normL2(self)==real(scal, R_P))
  endfunction self_eq_I2P

  elemental function I1P_eq_self(scal, self) result(compare)
  !< Return .true. if the normL2 of the self is = with respect the value of scalar scal, .false. otherwise.
  integer(I1P),  intent(in) :: scal    !< Left hand side.
  class(vector), intent(in) :: self    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (normL2(self)==real(scal, R_P))
  endfunction I1P_eq_self

  elemental function self_eq_I1P(self, scal) result(compare)
  !< Return .true. if the normL2 of the self is = with respect the value of scalar scal, .false. otherwise.
  class(vector), intent(in) :: self    !< Left hand side.
  integer(I1P),  intent(in) :: scal    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (normL2(self)==real(scal, R_P))
  endfunction self_eq_I1P

  ! Oprator >=
  elemental function self_great_eq_self(self1, self2) result(compare)
  !< Return .true. if the normL2 of the self1 is >= with respect the normL2 of self2, .false. otherwise.
  class(vector), intent(in) :: self1   !< Left hand side.
  type(vector),  intent(in) :: self2   !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (normL2(self1)>=normL2(self2))
  endfunction self_great_eq_self

  elemental function R16P_great_eq_self(scal, self) result(compare)
  !< Return .true. if the normL2 of the self1 is >= with respect the  value of scalar scal, .false. otherwise.
  real(R16P),    intent(in) :: scal    !< Left hand side.
  class(vector), intent(in) :: self    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (real(scal, R_P)>=normL2(self))
  endfunction R16P_great_eq_self

  elemental function self_great_eq_R16P(self, scal) result(compare)
  !< Return .true. if the normL2 of the self1 is >= with respect the  value of scalar scal, .false. otherwise.
  class(vector), intent(in) :: self    !< Left hand side.
  real(R16P),    intent(in) :: scal    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (normL2(self)>=real(scal, R_P))
  endfunction self_great_eq_R16P

  elemental function R8P_great_eq_self(scal, self) result(compare)
  !< Return .true. if the normL2 of the self1 is >= with respect the  value of scalar scal, .false. otherwise.
  real(R8P),     intent(in) :: scal    !< Left hand side.
  class(vector), intent(in) :: self    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (real(scal, R_P)>=normL2(self))
  endfunction R8P_great_eq_self

  elemental function self_great_eq_R8P(self, scal) result(compare)
  !< Return .true. if the normL2 of the self1 is >= with respect the  value of scalar scal, .false. otherwise.
  class(vector), intent(in) :: self    !< Left hand side.
  real(R8P),     intent(in) :: scal    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (normL2(self)>=real(scal, R_P))
  endfunction self_great_eq_R8P

  elemental function R4P_great_eq_self(scal, self) result(compare)
  !< Return .true. if the normL2 of the self1 is >= with respect the  value of scalar scal, .false. otherwise.
  real(R4P),     intent(in) :: scal    !< Left hand side.
  class(vector), intent(in) :: self    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (real(scal, R_P)>=normL2(self))
  endfunction R4P_great_eq_self

  elemental function self_great_eq_R4P(self, scal) result(compare)
  !< Return .true. if the normL2 of the self1 is >= with respect the  value of scalar scal, .false. otherwise.
  class(vector), intent(in) :: self    !< Left hand side.
  real(R4P),     intent(in) :: scal    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (normL2(self)>=real(scal, R_P))
  endfunction self_great_eq_R4P

  elemental function I8P_great_eq_self(scal, self) result(compare)
  !< Return .true. if the normL2 of the self1 is >= with respect the  value of scalar scal, .false. otherwise.
  integer(I8P),  intent(in) :: scal    !< Left hand side.
  class(vector), intent(in) :: self    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (real(scal, R_P)>=normL2(self))
  endfunction I8P_great_eq_self

  elemental function self_great_eq_I8P(self, scal) result(compare)
  !< Return .true. if the normL2 of the self1 is >= with respect the  value of scalar scal, .false. otherwise.
  class(vector), intent(in) :: self    !< Left hand side.
  integer(I8P),  intent(in) :: scal    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (normL2(self)>=real(scal, R_P))
  endfunction self_great_eq_I8P

  elemental function I4P_great_eq_self(scal, self) result(compare)
  !< Return .true. if the normL2 of the self1 is >= with respect the  value of scalar scal, .false. otherwise.
  integer(I4P),  intent(in) :: scal    !< Left hand side.
  class(vector), intent(in) :: self    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (real(scal, R_P)>=normL2(self))
  endfunction I4P_great_eq_self

  elemental function self_great_eq_I4P(self, scal) result(compare)
  !< Return .true. if the normL2 of the self1 is >= with respect the  value of scalar scal, .false. otherwise.
  class(vector), intent(in) :: self    !< Left hand side.
  integer(I4P),  intent(in) :: scal    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (normL2(self)>=real(scal, R_P))
  endfunction self_great_eq_I4P

  elemental function I2P_great_eq_self(scal, self) result(compare)
  !< Return .true. if the normL2 of the self1 is >= with respect the  value of scalar scal, .false. otherwise.
  integer(I2P),  intent(in) :: scal    !< Left hand side.
  class(vector), intent(in) :: self    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (real(scal, R_P)>=normL2(self))
  endfunction I2P_great_eq_self

  elemental function self_great_eq_I2P(self, scal) result(compare)
  !< Return .true. if the normL2 of the self1 is >= with respect the  value of scalar scal, .false. otherwise.
  class(vector), intent(in) :: self    !< Left hand side.
  integer(I2P),  intent(in) :: scal    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (normL2(self)>=real(scal, R_P))
  endfunction self_great_eq_I2P

  elemental function I1P_great_eq_self(scal, self) result(compare)
  !< Return .true. if the normL2 of the self1 is >= with respect the  value of scalar scal, .false. otherwise.
  integer(I1P),  intent(in) :: scal    !< Left hand side.
  class(vector), intent(in) :: self    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (real(scal, R_P)>=normL2(self))
  endfunction I1P_great_eq_self

  elemental function self_great_eq_I1P(self, scal) result(compare)
  !< Return .true. if the normL2 of the self1 is >= with respect the  value of scalar scal, .false. otherwise.
  class(vector), intent(in) :: self    !< Left hand side.
  integer(I1P),  intent(in) :: scal    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (normL2(self)>=real(scal, R_P))
  endfunction self_great_eq_I1P

  ! Oprator >
  elemental function self_great_self(self1, self2) result(compare)
  !< Return .true. if the normL2 of the self1 is > with respect the normL2 of self2, .false. otherwise.
  class(vector), intent(in) :: self1   !< Left hand side.
  type(vector),  intent(in) :: self2   !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (normL2(self1)>normL2(self2))
  endfunction self_great_self

  elemental function R16P_great_self(scal, self) result(compare)
  !< Return .true. if the normL2 of the self1 is > with respect the  value of scalar scal, .false. otherwise.
  real(R16P),    intent(in) :: scal    !< Left hand side.
  class(vector), intent(in) :: self    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (real(scal, R_P)>normL2(self))
  endfunction R16P_great_self

  elemental function self_great_R16P(self, scal) result(compare)
  !< Return .true. if the normL2 of the self1 is > with respect the  value of scalar scal, .false. otherwise.
  class(vector), intent(in) :: self    !< Left hand side.
  real(R16P),    intent(in) :: scal    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (normL2(self)>real(scal, R_P))
  endfunction self_great_R16P

  elemental function R8P_great_self(scal, self) result(compare)
  !< Return .true. if the normL2 of the self1 is > with respect the  value of scalar scal, .false. otherwise.
  real(R8P),     intent(in) :: scal    !< Left hand side.
  class(vector), intent(in) :: self    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (real(scal, R_P)>normL2(self))
  endfunction R8P_great_self

  elemental function self_great_R8P(self, scal) result(compare)
  !< Return .true. if the normL2 of the self1 is > with respect the  value of scalar scal, .false. otherwise.
  class(vector), intent(in) :: self    !< Left hand side.
  real(R8P),     intent(in) :: scal    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (normL2(self)>real(scal, R_P))
  endfunction self_great_R8P

  elemental function R4P_great_self(scal, self) result(compare)
  !< Return .true. if the normL2 of the self1 is > with respect the  value of scalar scal, .false. otherwise.
  real(R4P),     intent(in) :: scal    !< Left hand side.
  class(vector), intent(in) :: self    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (real(scal, R_P)>normL2(self))
  endfunction R4P_great_self

  elemental function self_great_R4P(self, scal) result(compare)
  !< Return .true. if the normL2 of the self1 is > with respect the  value of scalar scal, .false. otherwise.
  class(vector), intent(in) :: self    !< Left hand side.
  real(R4P),     intent(in) :: scal    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (normL2(self)>real(scal, R_P))
  endfunction self_great_R4P

  elemental function I8P_great_self(scal, self) result(compare)
  !< Return .true. if the normL2 of the self1 is > with respect the  value of scalar scal, .false. otherwise.
  integer(I8P),  intent(in) :: scal    !< Left hand side.
  class(vector), intent(in) :: self    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (real(scal, R_P)>normL2(self))
  endfunction I8P_great_self

  elemental function self_great_I8P(self, scal) result(compare)
  !< Return .true. if the normL2 of the self1 is > with respect the  value of scalar scal, .false. otherwise.
  class(vector), intent(in) :: self    !< Left hand side.
  integer(I8P),  intent(in) :: scal    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (normL2(self)>real(scal, R_P))
  endfunction self_great_I8P

  elemental function I4P_great_self(scal, self) result(compare)
  !< Return .true. if the normL2 of the self1 is > with respect the  value of scalar scal, .false. otherwise.
  integer(I4P),  intent(in) :: scal    !< Left hand side.
  class(vector), intent(in) :: self    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (real(scal, R_P)>normL2(self))
  endfunction I4P_great_self

  elemental function self_great_I4P(self, scal) result(compare)
  !< Return .true. if the normL2 of the self1 is > with respect the  value of scalar scal, .false. otherwise.
  class(vector), intent(in) :: self    !< Left hand side.
  integer(I4P),  intent(in) :: scal    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (normL2(self)>real(scal, R_P))
  endfunction self_great_I4P

  elemental function I2P_great_self(scal, self) result(compare)
  !< Return .true. if the normL2 of the self1 is > with respect the  value of scalar scal, .false. otherwise.
  integer(I2P),  intent(in) :: scal    !< Left hand side.
  class(vector), intent(in) :: self    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (real(scal, R_P)>normL2(self))
  endfunction I2P_great_self

  elemental function self_great_I2P(self, scal) result(compare)
  !< Return .true. if the normL2 of the self1 is > with respect the  value of scalar scal, .false. otherwise.
  class(vector), intent(in) :: self    !< Left hand side.
  integer(I2P),  intent(in) :: scal    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (normL2(self)>real(scal, R_P))
  endfunction self_great_I2P

  elemental function I1P_great_self(scal, self) result(compare)
  !< Return .true. if the normL2 of the self1 is > with respect the  value of scalar scal, .false. otherwise.
  integer(I1P),  intent(in) :: scal    !< Left hand side.
  class(vector), intent(in) :: self    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (real(scal, R_P)>normL2(self))
  endfunction I1P_great_self

  elemental function self_great_I1P(self, scal) result(compare)
  !< Return .true. if the normL2 of the self1 is > with respect the  value of scalar scal, .false. otherwise.
  class(vector), intent(in) :: self    !< Left hand side.
  integer(I1P),  intent(in) :: scal    !< Right hand side.
  logical                   :: compare !< Operator result.

  compare = (normL2(self)>real(scal, R_P))
  endfunction self_great_I1P
endmodule vecfor
