implicit none
private
public :: vector_RPP
public :: ex_RPP
public :: ey_RPP
public :: ez_RPP
public :: angle_RPP
public :: distance_to_line_RPP
public :: distance_to_plane_RPP
public :: distance_vectorial_to_plane_RPP
public :: face_normal3_RPP
public :: face_normal4_RPP
public :: iolen_RPP
public :: is_collinear_RPP
public :: is_concyclic_RPP
public :: mirror_matrix_RPP
public :: normalized_RPP
public :: normL2_RPP
public :: projection_onto_plane_RPP
public :: rotation_matrix_RPP
public :: sq_norm_RPP
public :: I1P, I2P, I4P, I8P, R4P, R8P, R16P, str

type :: vector_RPP
  !< Vector class.
  real(RPP) :: x = 0._RPP !< Cartesian component in x direction.
  real(RPP) :: y = 0._RPP !< Cartesian component in y direction.
  real(RPP) :: z = 0._RPP !< Cartesian component in z direction.
  contains
     ! public new operators
     generic :: operator(.cross.)  => crossproduct  !< Cross product operator.
     generic :: operator(.dot.)    => dotproduct    !< Scalar (dot) product operator.
     generic :: operator(.matrix.) => matrixproduct !< Matrix product operator.
     generic :: operator(.paral.)  => parallel      !< Component of `lhs` parallel to `rhs` operator.
     generic :: operator(.ortho.)  => orthogonal    !< Component of `lhs` orthogonal to `rhs` operator.
     procedure, pass(lhs) :: crossproduct           !< Compute the cross product.
     procedure, pass(lhs) :: dotproduct             !< Compute the scalar (dot) product.
     procedure, pass(rhs) :: matrixproduct          !< Compute the matrix product.
     procedure, pass(lhs) :: orthogonal             !< Compute the component of `lhs` orthogonal to `rhs`.
     procedure, pass(lhs) :: parallel               !< Compute the component of `lhs` parallel to `rhs`.
     ! public methods
     procedure, pass(self) :: angle => angle_RPP                                             !< Return the angle (rad) between two 
                                                                                             !< vectors.
     procedure, pass(self) :: distance_to_line => distance_to_line_RPP                       !< Return the distance (scalar) to 
                                                                                             !< line.
     procedure, pass(self) :: distance_to_plane => distance_to_plane_RPP                     !< Return the distance (signed, scalar) 
                                                                                             !< to plane.
     procedure, pass(self) :: distance_vectorial_to_plane => distance_vectorial_to_plane_RPP !< Return the distance (vectorial) to 
                                                                                             !< plane.
     procedure, nopass     :: face_normal3 => face_normal3_RPP                               !< Return the normal of the face.
     procedure, nopass     :: face_normal4 => face_normal4_RPP                               !< Return the normal of the face.
     procedure, pass(self) :: iolen => iolen_RPP                                             !< Compute IO length.
     procedure, pass(self) :: is_collinear => is_collinear_RPP                               !< Return true if the point is col- 
                                                                                             !< linear with other two given points.
     procedure, pass(self) :: is_concyclic => is_concyclic_RPP                               !< Return true if the point is concy-
                                                                                             !< clic with other three given pts.
     procedure, pass(self) :: load_from_file                                                 !< Load vector from file.
     generic               :: mirror => mirror_by_normal, &                                  
                                        mirror_by_matrix                                     !< Mirror vector.
     procedure, pass(self) :: normalize                                                      !< Normalize a vector.
     procedure, pass(self) :: normalized => normalized_RPP                                   !< Return a normalized copy of vector.
     procedure, pass(self) :: normL2 => normL2_RPP                                           !< Return the norm L2 of vector.
     procedure, pass(self) :: printf                                                         !< Print vector components with a 
                                                                                             !< "pretty" format.
     procedure, pass(self) :: projection_onto_plane => projection_onto_plane_RPP             !< Calculate the projection of point 
                                                                                             !< onto plane defined by 3 points.
     generic               :: rotate => rotate_by_axis_angle, &                              
                                        rotate_by_matrix                                     !< Rotate vector.
     procedure, pass(self) :: save_into_file                                                 !< Save vector into file.
     procedure, pass(self) :: sq_norm => sq_norm_RPP                                         !< Return the square of the norm.
     ! operators overloading
     generic :: assignment(=) => assign_vector, &
#ifdef _R16P
                                 assign_R16P,   &
#endif
                                 assign_R8P,    &
                                 assign_R4P,    &
                                 assign_I8P,    &
                                 assign_I4P,    &
                                 assign_I2P,    &
                                 assign_I1P !< Overloading `=`.
     generic :: operator(*) => vector_mul_vector,                &
#ifdef _R16P
                               R16P_mul_vector, vector_mul_R16P, &
#endif
                               R8P_mul_vector, vector_mul_R8P,   &
                               R4P_mul_vector, vector_mul_R4P,   &
                               I8P_mul_vector, vector_mul_I8P,   &
                               I4P_mul_vector, vector_mul_I4P,   &
                               I2P_mul_vector, vector_mul_I2P,   &
                               I1P_mul_vector, vector_mul_I1P !< Overloading `*`.
     generic :: operator(/) => vector_div_vector, &
#ifdef _R16P
                               vector_div_R16P,   &
#endif
                               vector_div_R8P,    &
                               vector_div_R4P,    &
                               vector_div_I8P,    &
                               vector_div_I4P,    &
                               vector_div_I2P,    &
                               vector_div_I1P !< Overloading `/`.
     generic :: operator(+) => positive, vector_sum_vector,      &
#ifdef _R16P
                               R16P_sum_vector, vector_sum_R16P, &
#endif
                               R8P_sum_vector, vector_sum_R8P,   &
                               R4P_sum_vector, vector_sum_R4P,   &
                               I8P_sum_vector, vector_sum_I8P,   &
                               I4P_sum_vector, vector_sum_I4P,   &
                               I2P_sum_vector, vector_sum_I2P,   &
                               I1P_sum_vector, vector_sum_I1P !< Overloading `+`.
     generic :: operator(-) => negative, vector_sub_vector,      &
#ifdef _R16P
                               R16P_sub_vector, vector_sub_R16P, &
#endif
                               R8P_sub_vector, vector_sub_R8P,   &
                               R4P_sub_vector, vector_sub_R4P,   &
                               I8P_sub_vector, vector_sub_I8P,   &
                               I4P_sub_vector, vector_sub_I4P,   &
                               I2P_sub_vector, vector_sub_I2P,   &
                               I1P_sub_vector, vector_sub_I1P !< Overloading `-`.
     generic :: operator(/=) => vector_not_eq_vector,                   &
#ifdef _R16P
                                R16P_not_eq_vector, vector_not_eq_R16P, &
#endif
                                R8P_not_eq_vector, vector_not_eq_R8P,   &
                                R4P_not_eq_vector, vector_not_eq_R4P,   &
                                I8P_not_eq_vector, vector_not_eq_I8P,   &
                                I4P_not_eq_vector, vector_not_eq_I4P,   &
                                I2P_not_eq_vector, vector_not_eq_I2P,   &
                                I1P_not_eq_vector, vector_not_eq_I1P !< Overloading `/=`.
     generic :: operator(<) => vector_low_vector,                &
#ifdef _R16P
                               R16P_low_vector, vector_low_R16P, &
#endif
                               R8P_low_vector, vector_low_R8P,   &
                               R4P_low_vector, vector_low_R4P,   &
                               I8P_low_vector, vector_low_I8P,   &
                               I4P_low_vector, vector_low_I4P,   &
                               I2P_low_vector, vector_low_I2P,   &
                               I1P_low_vector, vector_low_I1P !< Overloading `<`.
     generic :: operator(<=) => vector_low_eq_vector,                   &
#ifdef _R16P
                                R16P_low_eq_vector, vector_low_eq_R16P, &
#endif
                                R8P_low_eq_vector, vector_low_eq_R8P,   &
                                R4P_low_eq_vector, vector_low_eq_R4P,   &
                                I8P_low_eq_vector, vector_low_eq_I8P,   &
                                I4P_low_eq_vector, vector_low_eq_I4P,   &
                                I2P_low_eq_vector, vector_low_eq_I2P,   &
                                I1P_low_eq_vector, vector_low_eq_I1P !< Overloading `<=`.
     generic :: operator(==) => vector_eq_vector,               &
#ifdef _R16P
                                R16P_eq_vector, vector_eq_R16P, &
#endif
                                R8P_eq_vector, vector_eq_R8P,   &
                                R4P_eq_vector, vector_eq_R4P,   &
                                I8P_eq_vector, vector_eq_I8P,   &
                                I4P_eq_vector, vector_eq_I4P,   &
                                I2P_eq_vector, vector_eq_I2P,   &
                                I1P_eq_vector, vector_eq_I1P !< Overloading `==`.
     generic :: operator(>=) => vector_great_eq_vector,                     &
#ifdef _R16P
                                R16P_great_eq_vector, vector_great_eq_R16P, &
#endif
                                R8P_great_eq_vector, vector_great_eq_R8P,   &
                                R4P_great_eq_vector, vector_great_eq_R4P,   &
                                I8P_great_eq_vector, vector_great_eq_I8P,   &
                                I4P_great_eq_vector, vector_great_eq_I4P,   &
                                I2P_great_eq_vector, vector_great_eq_I2P,   &
                                I1P_great_eq_vector, vector_great_eq_I1P !< Overloading `>=`.
     generic :: operator(>) => vector_great_vector,                  &
#ifdef _R16P
                               R16P_great_vector, vector_great_R16P, &
#endif
                               R8P_great_vector, vector_great_R8P,   &
                               R4P_great_vector, vector_great_R4P,   &
                               I8P_great_vector, vector_great_I8P,   &
                               I4P_great_vector, vector_great_I4P,   &
                               I2P_great_vector, vector_great_I2P,   &
                               I1P_great_vector, vector_great_I1P !< Overloading `>`.
     ! private methods
     procedure, pass(self), private :: mirror_by_normal     !< Mirror vector given normal of mirroring plane.
     procedure, pass(self), private :: mirror_by_matrix     !< Mirror vector given matrix.
     procedure, pass(self), private :: rotate_by_axis_angle !< Rotate vector given axis and angle.
     procedure, pass(self), private :: rotate_by_matrix     !< Rotate vector given matrix.
     ! operators
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
endtype vector_RPP

type(vector_RPP), parameter :: ex_RPP = vector_RPP(1._RPP, 0._RPP, 0._RPP) !< X direction versor.
type(vector_RPP), parameter :: ey_RPP = vector_RPP(0._RPP, 1._RPP, 0._RPP) !< Y direction versor.
type(vector_RPP), parameter :: ez_RPP = vector_RPP(0._RPP, 0._RPP, 1._RPP) !< Z direction versor.

contains
   ! public methods
   ! non TBP
   pure function rotation_matrix_RPP(axis, angle) result(matrix)
   !< Return the rotation matrix given axis and angle of ratation.
   !<
   !< Angle must be in radiants.
   type(vector_RPP), intent(in) :: axis        !< Axis of ratation.
   real(RPP),        intent(in) :: angle       !< Angle of ratation.
   type(vector_RPP)             :: axis_       !< Axis of ratation, normalized.
   real(RPP)                    :: matrix(3,3) !< Rotation matrix.
   real(RPP)                    :: c           !< `cos(angle)`.
   real(RPP)                    :: s           !< `sin(angle)`.
   real(RPP)                    :: one_c       !< `1-cos(angle)`.

   axis_ = normalized_RPP(axis)
   c = cos(angle)
   s = sin(angle)
   one_c = 1._RPP - cos(angle)
   matrix(1,1) = c + axis_%x * axis_%x * one_c    
   matrix(2,1) =     axis_%y * axis_%x * one_c + axis_%z * s
   matrix(3,1) =     axis_%z * axis_%x * one_c - axis_%y * s
   matrix(1,2) =     axis_%x * axis_%y * one_c - axis_%z * s
   matrix(2,2) = c + axis_%y * axis_%y * one_c    
   matrix(3,2) =     axis_%z * axis_%y * one_c + axis_%x * s
   matrix(1,3) =     axis_%x * axis_%z * one_c + axis_%y * s  
   matrix(2,3) =     axis_%y * axis_%z * one_c - axis_%x * s  
   matrix(3,3) = c + axis_%z * axis_%z * one_c      
   endfunction rotation_matrix_RPP

   pure function mirror_matrix_RPP(normal) result(matrix)
   !< Return the mirror matrix (Householder's matrix) given normal of the mirroring plane.
   type(vector_RPP), intent(in) :: normal      !< Normal of mirroring plane.
   real(RPP)                    :: matrix(3,3) !< Rotation matrix.
   type(vector_RPP)             :: normal_     !< Normal of mirroring plane, local variable.

   normal_ = normalized_RPP(normal)
   matrix(1,1) = 1._RPP - 2._RPP * normal_%x * normal_%x
   matrix(2,1) =                   normal_%y * normal_%x
   matrix(3,1) =                   normal_%z * normal_%x
   matrix(1,2) =                   normal_%x * normal_%y
   matrix(2,2) = 1._RPP - 2._RPP * normal_%y * normal_%y
   matrix(3,2) =                   normal_%z * normal_%y
   matrix(1,3) =                   normal_%x * normal_%z  
   matrix(2,3) =                   normal_%y * normal_%z  
   matrix(3,3) = 1._RPP - 2._RPP * normal_%z * normal_%z  
   endfunction mirror_matrix_RPP

   ! new operators
   /* elemental function crossproduct_RPP(lhs, rhs) result(cross) */
   /* !< Compute the cross product. */
   /* class(vector_RPP), intent(in) :: lhs   !< Left hand side. */
   /* type(vector_RPP),  intent(in) :: rhs   !< Right hand side. */
   /* type(vector_RPP)              :: cross !< Cross product vector. */

   /* cross = lhs%crossproduct(rhs=rhs) */
   /* endfunction crossproduct_RPP */

   /* elemental function dotproduct_RPP(lhs, rhs) result(dot) */
   /* !< Compute the scalar (dot) product. */
   /* class(vector_RPP), intent(in) :: lhs !< Left hand side. */
   /* type(vector_RPP),  intent(in) :: rhs !< Right hand side. */
   /* real(RPP)                     :: dot !< Dot product. */

   /* dot = lhs%dotproduct(rhs=rhs) */
   /* endfunction dotproduct_RPP */

   elemental function crossproduct(lhs, rhs) result(cross)
   !< Compute the cross product.
   !<
   !< $$ \vec V=\left({y_1 z_2 - z_1 y_2}\right)\vec i +
   !<           \left({z_1 x_2 - x_1 z_2}\right)\vec j +
   !<           \left({x_1 y_2 - y_1 x_2}\right)\vec k $$
   !< where \( x_i \), \( y_i \) and \( z_i \) \( i=1,2 \) are the components of the vectors.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:2)
   !< pt(1) = 2 * ex_RPP
   !< pt(2) = ex_RPP
   !< pt(0) = pt(1).cross.pt(2)
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 0.0 0.0 0.0 <<<
   class(vector_RPP), intent(in) :: lhs   !< Left hand side.
   type(vector_RPP),  intent(in) :: rhs   !< Right hand side.
   type(vector_RPP)              :: cross !< Cross product vector.

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
   !< type(vector_RPP) :: pt(1:2)
   !< pt(1) = ex_RPP
   !< pt(2) = ey_RPP
   !< print "(F3.1)", pt(1).dot.pt(2)
   !<```
   !=> 0.0 <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   type(vector_RPP),  intent(in) :: rhs !< Right hand side.
   real(RPP)                     :: dot !< Dot product.

   dot = (lhs%x * rhs%x) + (lhs%y * rhs%y) + (lhs%z * rhs%z)
   endfunction dotproduct

   pure function matrixproduct(lhs, rhs) result(opr)
   !< Compute the matrix product.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(2)
   !< real(RPP)        :: I(3,3)
   !< pt(1) = 2 * ex_RPP
   !< I = 0._RPP
   !< I(1,1) = 1._RPP
   !< I(2,2) = 1._RPP
   !< I(3,3) = 1._RPP
   !< pt(2) = I.matrix.pt(1)
   !< print "(3(F3.1,1X))", abs(pt(2)%x), abs(pt(2)%y), abs(pt(2)%z)
   !<```
   !=> 2.0 0.0 0.0 <<<
   real(RPP),         intent(in) :: lhs(3,3) !< Left hand side.
   class(vector_RPP), intent(in) :: rhs      !< Right hand side.
   type(vector_RPP)              :: opr      !< Operator result.
   real(RPP)                     :: v(1:3)   !< Vector coordinatex array.

   v = [rhs%x, rhs%y, rhs%z]
   v = matmul(lhs, v)
   opr%x = v(1)
   opr%y = v(2)
   opr%z = v(3)
   endfunction matrixproduct

   elemental function orthogonal(lhs, rhs) result(ortho)
   !< Compute the component of `lhs` orthogonal to `rhs`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:2)
   !< pt(1) = 2 * ex_RPP + 3 * ey_RPP
   !< pt(2) = ex_RPP
   !< pt(0) = pt(1).ortho.pt(2)
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 0.0 3.0 0.0 <<<
   class(vector_RPP), intent(in) :: lhs   !< Left hand side.
   type(vector_RPP),  intent(in) :: rhs   !< Right hand side.
   type(vector_RPP)              :: ortho !< Component of of `lhs` orthogonal to `rhs`.

   ortho = lhs - (lhs.paral.rhs)
   endfunction orthogonal

   elemental function parallel(lhs, rhs) result(paral)
   !> Compute the component of `lhs` parallel to `rhs`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:2)
   !< pt(1) = 2 * ex_RPP + 3 * ey_RPP
   !< pt(2) = ex_RPP
   !< pt(0) = pt(1).paral.pt(2)
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 2.0 0.0 0.0 <<<
   class(vector_RPP), intent(in) :: lhs   !< Left hand side.
   type(vector_RPP),  intent(in) :: rhs   !< Right hand side.
   type(vector_RPP)              :: paral !< Component of of `lhs` parallel to `rhs`.

   paral = (lhs.dot.rhs) * normalized_RPP(rhs) / normL2_RPP(rhs)
   endfunction parallel

   ! methods
   elemental function angle_RPP(self, other) result(angle_)
   !< Calculate the angle (rad) between two vectors.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(1:2)
   !< real(RPP)        :: a
   !<
   !< pt(1) = ex_RPP
   !< pt(2) = 2 * ex_RPP
   !< a = pt(1)%angle(pt(2))
   !< print "(F3.1)", a
   !<```
   !=> 0.0 <<<
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(1:2)
   !< real(RPP)        :: a
   !<
   !< pt(1) = ex_RPP
   !< pt(2) = ey_RPP
   !< a = angle_RPP(pt(1), pt(2))
   !< print "(F4.2)", a
   !<```
   !=> 1.57 <<<
   class(vector_RPP), intent(in) :: self      !< The first vector.
   type(vector_RPP),  intent(in) :: other     !< Other vector.
   real(RPP)                     :: angle_    !< Angle between vectors, in radians.
   real(RPP)                     :: angle_cos !< Angle computed by means of cos.
   real(RPP)                     :: angle_sin !< Angle computed by means of sin.
   type(vector_RPP)              :: versor(2) !< Input vectors normalized.

   versor = [self%normalized(), other%normalized()]
   angle_cos = versor(1).dot.versor(2)
   angle_sin = normL2_RPP(versor(1).cross.versor(2))
   angle_ = atan2(angle_sin, angle_cos)
   endfunction angle_RPP

   elemental function distance_to_line_RPP(self, pt1, pt2) result(distance)
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
   !< type(vector_RPP) :: pt(0:2)
   !< real(RPP)        :: d
   !<
   !< pt(0) = 5.3 * ez_RPP
   !< pt(1) = ex_RPP
   !< pt(2) = ey_RPP
   !< d = pt(0)%distance_to_line(pt1=pt(1), pt2=pt(2))
   !< print "(F3.1)", d
   !<```
   !=> 5.3 <<<
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:2)
   !< real(RPP)        :: d
   !<
   !< pt(0) = 5.3 * ez_RPP
   !< pt(1) = ex_RPP
   !< pt(2) = ey_RPP
   !< d = distance_to_line_RPP(pt(0), pt1=pt(1), pt2=pt(2))
   !< print "(F3.1)", d
   !<```
   !=> 5.3 <<<
   class(vector_RPP), intent(in) :: self     !< The point from which computing the distance.
   type(vector_RPP),  intent(in) :: pt1      !< First line point.
   type(vector_RPP),  intent(in) :: pt2      !< Second line point.
   real(RPP)                     :: distance !< Face normal.

   distance = normL2_RPP((self - pt1).cross.(self - pt2)) / normL2_RPP(pt2 - pt1)
   endfunction distance_to_line_RPP

   elemental function distance_to_plane_RPP(self, pt1, pt2, pt3) result(distance)
   !< Calculate the distance (signed, scalar) to plane defined by the 3 points.
   !<
   !< The convention for the points numeration is the following:
   !<```
   !< 3.----.2
   !<   \   |
   !<    \ *---------> . self
   !<     \ |
   !<      \|
   !<       .1
   !<```
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:3)
   !< real(RPP)        :: d
   !<
   !< pt(0) = 5.3 * ez_RPP
   !< pt(1) = ex_RPP
   !< pt(2) = ey_RPP
   !< pt(3) = ex_RPP - ey_RPP
   !< d = pt(0)%distance_to_plane(pt1=pt(1), pt2=pt(2), pt3=pt(3))
   !< print "(F3.1)", d
   !<```
   !=> 5.3 <<<
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:3)
   !< real(RPP)        :: d
   !<
   !< pt(0) = 5.3 * ez_RPP
   !< pt(1) = ex_RPP
   !< pt(2) = ey_RPP
   !< pt(3) = ex_RPP - ey_RPP
   !< d = distance_to_plane_RPP(pt(0), pt1=pt(1), pt2=pt(2), pt3=pt(3))
   !< print "(F3.1)", d
   !<```
   !=> 5.3 <<<
   class(vector_RPP), intent(in) :: self     !< The point from which computing the distance.
   type(vector_RPP),  intent(in) :: pt1      !< First plane point.
   type(vector_RPP),  intent(in) :: pt2      !< Second plane point.
   type(vector_RPP),  intent(in) :: pt3      !< Third plane point.
   real(RPP)                     :: distance !< Face normal.
   type(vector_RPP)              :: normal   !< Normal (versor) of plane.

   normal = face_normal3_RPP(pt1=pt1, pt2=pt2, pt3=pt3, norm='y')
   distance = normal.dot.(self - pt1)
   endfunction distance_to_plane_RPP

   elemental function distance_vectorial_to_plane_RPP(self, pt1, pt2, pt3) result(distance)
   !< Calculate the distance (vectorial) to plane defined by the 3 points.
   !<
   !< The convention for the points numeration is the following:
   !<```
   !< 3.----.2
   !<   \   |
   !<    \ *---------> . self
   !<     \ |
   !<      \|
   !<       .1
   !<```
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:3)
   !<
   !< pt(0) = 5.3 * ez_RPP
   !< pt(1) = ex_RPP
   !< pt(2) = ey_RPP
   !< pt(3) = ex_RPP - ey_RPP
   !< pt(0) = pt(0)%distance_vectorial_to_plane(pt1=pt(1), pt2=pt(2), pt3=pt(3))
   !< print "(3(F3.1,1X))", pt(0)%x, pt(0)%y, pt(0)%z
   !<```
   !=> 0.0 0.0 5.3 <<<
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:3)
   !<
   !< pt(0) = 5.3 * ez_RPP
   !< pt(1) = ex_RPP
   !< pt(2) = ey_RPP
   !< pt(3) = ex_RPP - ey_RPP
   !< pt(0) = distance_vectorial_to_plane_RPP(pt(0), pt1=pt(1), pt2=pt(2), pt3=pt(3))
   !< print "(3(F3.1,1X))", pt(0)%x, pt(0)%y, pt(0)%z
   !<```
   !=> 0.0 0.0 5.3 <<<
   class(vector_RPP), intent(in) :: self     !< The point from which computing the distance.
   type(vector_RPP),  intent(in) :: pt1      !< First plane point.
   type(vector_RPP),  intent(in) :: pt2      !< Second plane point.
   type(vector_RPP),  intent(in) :: pt3      !< Third plane point.
   type(vector_RPP)              :: distance !< Face normal.
   type(vector_RPP)              :: normal   !< Normal (versor) of plane.

   normal = face_normal3_RPP(pt1=pt1, pt2=pt2, pt3=pt3, norm='y')
   distance = normal * (normal.dot.(self - pt1))
   endfunction distance_vectorial_to_plane_RPP

   elemental function face_normal3_RPP(pt1, pt2, pt3, norm) result(normal)
   !< Calculate the normal of the face defined by the 3 points.
   !<
   !< The convention for the points numeration is the following:
   !<```
   !< 3.----.2
   !<   \   |
   !<    \  |
   !<     \ |
   !<      \|
   !<       .1
   !<```
   !< The normal is calculated by the cross product of the side s12 for the side s13: s12 x s13.
   !< The normal is normalized if the variable *norm* is passed (with any value).
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:3)
   !<
   !< pt(1) = ex_RPP
   !< pt(2) = ey_RPP
   !< pt(3) = ex_RPP - ey_RPP
   !< pt(0) = pt(1)%face_normal3(pt1=pt(1), pt2=pt(2), pt3=pt(3), norm='y')
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 0.0 0.0 1.0 <<<
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:3)
   !<
   !< pt(1) = ex_RPP
   !< pt(2) = ey_RPP
   !< pt(3) = ex_RPP - ey_RPP
   !< pt(0) = face_normal3_RPP(pt1=pt(1), pt2=pt(2), pt3=pt(3), norm='y')
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 0.0 0.0 1.0 <<<
   type(vector_RPP),  intent(in)           :: pt1    !< First face point.
   type(vector_RPP),  intent(in)           :: pt2    !< Second face point.
   type(vector_RPP),  intent(in)           :: pt3    !< Third face point.
   character(1),      intent(in), optional :: norm   !< If 'norm' is passed as argument the normal is normalized.
   type(vector_RPP)                        :: normal !< Face normal.
   type(vector_RPP)                        :: s12    !< Face 1-2 diagonals.
   type(vector_RPP)                        :: s13    !< Face 1-3 diagonals.

   s12 = pt2 - pt1
   s13 = pt3 - pt1
   if (present(norm)) then
     normal = normalized_RPP(s12.cross.s13)
   else
     normal = 0.5_RPP * (s12.cross.s13)
   endif
   endfunction face_normal3_RPP

   elemental function face_normal4_RPP(pt1, pt2, pt3, pt4, norm) result(normal)
   !< Calculate the normal of the face defined by 4 points.
   !<
   !< The convention for the points numeration is the following:
   !<```
   !< 3.----------.2
   !<  |          |
   !<  |          |
   !<  |          |
   !<  |          |
   !< 4.----------.1
   !<```
   !< The normal is calculated by the cross product of the diagonal d13 for the diagonal d24: d13 x d24.
   !< The normal is normalized if the variable *norm* is passed (with any value).
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:4)
   !<
   !< pt(1) = ex_RPP
   !< pt(2) = ey_RPP
   !< pt(3) = ex_RPP - ey_RPP
   !< pt(4) = ex_RPP + ey_RPP
   !< pt(0) = pt(1)%face_normal4(pt1=pt(1), pt2=pt(2), pt3=pt(3), pt4=pt(4), norm='y')
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 0.0 0.0 1.0 <<<
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:4)
   !<
   !< pt(1) = ex_RPP
   !< pt(2) = ey_RPP
   !< pt(3) = ex_RPP - ey_RPP
   !< pt(4) = ex_RPP + ey_RPP
   !< pt(0) = face_normal4_RPP(pt1=pt(1), pt2=pt(2), pt3=pt(3), pt4=pt(4), norm='y')
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 0.0 0.0 1.0 <<<
   type(vector_RPP),  intent(in)           :: pt1    !< First face point.
   type(vector_RPP),  intent(in)           :: pt2    !< Second face point.
   type(vector_RPP),  intent(in)           :: pt3    !< Third face point.
   type(vector_RPP),  intent(in)           :: pt4    !< Fourth face point.
   character(1),      intent(in), optional :: norm   !< If 'norm' is passed as argument the normal is normalized.
   type(vector_RPP)                        :: normal !< Face normal.
   type(vector_RPP)                        :: d13    !< Face 1-3 diagonals.
   type(vector_RPP)                        :: d24    !< Face 2-4 diagonals.

   d13 = pt3 - pt1
   d24 = pt4 - pt2
   if (present(norm)) then
     normal = normalized_RPP(d13.cross.d24)
   else
     normal = 0.5_RPP * (d13.cross.d24)
   endif
   endfunction face_normal4_RPP

   function iolen_RPP(self) result(iolen_)
   !< Compute IO length.
   !<
   !<```fortran
   !< use penf, only : byte_size
   !< type(vector_RPP) :: pt
   !< print*, pt%iolen()/byte_size(pt%x)
   !<```
   !=> 3 <<<
   !<
   !<```fortran
   !< use penf, only : byte_size
   !< type(vector_RPP) :: pt
   !< print*, iolen_RPP(pt)/byte_size(pt%x)
   !<```
   !=> 3 <<<
   class(vector_RPP), intent(in) :: self   !< Vector.
   integer(I4P)                  :: iolen_ !< IO length.

   inquire(iolength=iolen_) self%x, self%y, self%z
   endfunction iolen_RPP

   elemental function is_collinear_RPP(self, pt1, pt2, tolerance) result(is_collinear_)
   !< Return true if the point is collinear with other two given points.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:2)
   !<
   !< pt(0) = 3 * ex_RPP
   !< pt(1) = 1 * ex_RPP
   !< pt(2) = 2 * ex_RPP
   !< print "(L1)", pt(0)%is_collinear(pt1=pt(1), pt2=pt(2))
   !<```
   !=> T <<<
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:2)
   !<
   !< pt(0) = 3 * ex_RPP
   !< pt(1) = 1 * ex_RPP
   !< pt(2) = 2 * ex_RPP
   !< print "(L1)", is_collinear_RPP(pt(0), pt1=pt(1), pt2=pt(2))
   !<```
   !=> T <<<
   class(vector_RPP), intent(in)           :: self          !< Vector.
   type(vector_RPP),  intent(in)           :: pt1           !< First line point.
   type(vector_RPP),  intent(in)           :: pt2           !< Second line point.
   real(RPP),         intent(in), optional :: tolerance     !< Tolerance for collinearity check.
   logical                                 :: is_collinear_ !< Inquire result.
   real(RPP)                               :: tolerance_    !< Tolerance for collinearity check, local variable.

   tolerance_ = 0._RPP ; if (present(tolerance)) tolerance_ = tolerance
   is_collinear_ = self%distance_to_line(pt1=pt1, pt2=pt2) <= ZeroRPP + tolerance_
   endfunction is_collinear_RPP

   elemental function is_concyclic_RPP(self, pt1, pt2, pt3, tolerance) result(is_concyclic_)
   !< Return true if the point is concyclic with other three given points.
   !<
   !< Based on Ptolemy's Theorem.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:3)
   !<
   !< pt(0) = -1 * ey_RPP
   !< pt(1) =  1 * ex_RPP
   !< pt(2) =  1 * ey_RPP
   !< pt(3) = -1 * ex_RPP
   !< print "(L1)", pt(0)%is_concyclic(pt1=pt(1), pt2=pt(2), pt3=pt(3))
   !<```
   !=> T <<<
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:3)
   !<
   !< pt(0) = -1 * ey_RPP
   !< pt(1) =  1 * ex_RPP
   !< pt(2) =  1 * ey_RPP
   !< pt(3) = -1 * ex_RPP
   !< print "(L1)", is_concyclic_RPP(pt(0), pt1=pt(1), pt2=pt(2), pt3=pt(3))
   !<```
   !=> T <<<
   class(vector_RPP), intent(in)           :: self          !< Vector.
   type(vector_RPP),  intent(in)           :: pt1           !< First arc point.
   type(vector_RPP),  intent(in)           :: pt2           !< Second arc point.
   type(vector_RPP),  intent(in)           :: pt3           !< Third arc point.
   real(RPP),         intent(in), optional :: tolerance     !< Tolerance for concyclicity check.
   logical                                 :: is_concyclic_ !< Inquire result.
   real(RPP)                               :: tolerance_    !< Tolerance for concyclicity check, local variable.
   real(RPP)                               :: a, b, c       !< Temporary storage to avoid bad conditioned math (lost of precision).

   a = sq_norm_RPP(self - pt1) * sq_norm_RPP(pt2 - pt3)
   b = sq_norm_RPP(pt1 - pt2) * sq_norm_RPP(pt3 - self)
   c = sq_norm_RPP(self - pt2) * sq_norm_RPP(pt1 - pt3)
   tolerance_ = 0._RPP ; if (present(tolerance)) tolerance_ = tolerance
   is_concyclic_ = sqrt(a) + sqrt(b) - sqrt(c) <= smallRPP + tolerance_
   endfunction is_concyclic_RPP

   subroutine load_from_file(self, unit, fmt, pos, iostat, iomsg)
   !< Load vector from file.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = 1 * ex_RPP + 2 * ey_RPP + 3 * ez_RPP
   !< open(unit=10, form='unformatted', status='scratch')
   !< call pt%save_into_file(unit=10)
   !< rewind(unit=10)
   !< call pt%load_from_file(unit=10)
   !< close(unit=10)
   !< print "(3(F3.1,1X))", pt%x, pt%y, pt%z
   !<```
   !=> 1.0 2.0 3.0 <<<
   class(vector_RPP), intent(inout)         :: self    !< Vector.
   integer(I4P),      intent(in)            :: unit    !< Logic unit.
   character(*),      intent(in),  optional :: fmt     !< IO format.
   integer(I8P),      intent(in),  optional :: pos     !< Position specifier.
   integer(I4P),      intent(out), optional :: iostat  !< IO error.
   character(*),      intent(out), optional :: iomsg   !< IO error message.
   integer(I4P)                             :: iostat_ !< IO error, local variable.
   character(len=:), allocatable            :: iomsg_  !< IO error message, local variable.

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
   !< The normalization is made by means of norm L2. If the norm L2 of the vector is less than the parameter smallRPP the
   !< normalization value is set to `normL2 + smallRPP`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP
   !< call pt%normalize
   !< print "(3(F4.2,1X))", abs(pt%x), abs(pt%y), abs(pt%z)
   !<```
   !=> 0.71 0.71 0.00 <<<
   class(vector_RPP), intent(inout) :: self !< Vector.
   real(RPP)                        :: nm   !< Norm L2 of vector.

   nm = normL2_RPP(self)
   if (nm < smallRPP) then
     nm = nm + smallRPP
   endif
   self%x = self%x / nm
   self%y = self%y / nm
   self%z = self%z / nm
   endsubroutine normalize

   elemental function normalized_RPP(self) result(norm)
   !< Return a normalized copy of vector.
   !<
   !< The normalization is made by means of norm L2. If the norm L2 of the vector is less than the parameter smallRPP the
   !< normalization value is set to normL2(vec)+smallRPP.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP
   !< pt = pt%normalized()
   !< print "(3(F4.2,1X))", abs(pt%x), abs(pt%y), abs(pt%z)
   !<```
   !=> 0.71 0.71 0.00 <<<
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP
   !< pt = normalized_RPP(pt)
   !< print "(3(F4.2,1X))", abs(pt%x), abs(pt%y), abs(pt%z)
   !<```
   !=> 0.71 0.71 0.00 <<<
   class(vector_RPP), intent(in) :: self !< Vector.
   type(vector_RPP)              :: norm !< Normalized copy.

   norm = self
   call norm%normalize
   endfunction normalized_RPP

   elemental function normL2_RPP(self) result(norm)
   !< Return the norm L2 of vector.
   !<
   !< The norm L2 if defined as \( N = \sqrt {x^2  + y^2  + z^2 } \).
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP
   !< print "(F4.2)", pt%normL2()
   !<```
   !=> 1.41 <<<
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP
   !< print "(F4.2)", normL2_RPP(pt)
   !<```
   !=> 1.41 <<<
   class(vector_RPP), intent(in) :: self !< Vector.
   real(RPP)                     :: norm !< Norm L2.

   norm = sqrt(self%sq_norm())
   endfunction normL2_RPP

   subroutine printf(self, unit, prefix, sep, suffix, iostat, iomsg)
   !< Print in a pretty ascii format the components of type Vector.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP
   !< call pt%printf(prefix='[x, y, z] = ', sep=', ')
   !<```
   !=> [x, y, z] = +0.1E+1, +0.1E+1, 0.0E+0 <<<
   class(vector_RPP), intent(in)            :: self    !< Vector.
   integer(I4P),      intent(in),  optional :: unit    !< Logic unit.
   character(*),      intent(in),  optional :: prefix  !< Prefix string.
   character(*),      intent(in),  optional :: sep     !< Components separator.
   character(*),      intent(in),  optional :: suffix  !< Suffix string.
   integer(I4P),      intent(out), optional :: iostat  !< IO error.
   character(*),      intent(out), optional :: iomsg   !< IO error message.
   character(len=:), allocatable            :: prefix_ !< Prefix string, local variable.
   character(len=:), allocatable            :: sep_    !< Components separator, local variable.
   character(len=:), allocatable            :: suffix_ !< Suffix string, local variable.
   integer(I4P)                             :: unit_   !< Logic unit.
   integer(I4P)                             :: iostat_ !< IO error, local variable.
   character(len=:), allocatable            :: iomsg_  !< IO error message, local variable.

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

   elemental function projection_onto_plane_RPP(self, pt1, pt2, pt3) result(projection)
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
   !< type(vector_RPP) :: pt(0:3)
   !<
   !< pt(0) = 1 * ex_RPP + 2 * ey_RPP + 5.3 * ez_RPP
   !< pt(1) = ex_RPP
   !< pt(2) = ey_RPP
   !< pt(3) = ex_RPP - ey_RPP
   !< pt(0) = pt(0)%projection_onto_plane(pt1=pt(1), pt2=pt(2), pt3=pt(3))
   !< print "(3(F3.1,1X))", pt(0)%x, pt(0)%y, pt(0)%z
   !<```
   !=> 1.0 2.0 0.0 <<<
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:3)
   !<
   !< pt(0) = 1 * ex_RPP + 2 * ey_RPP + 5.3 * ez_RPP
   !< pt(1) = ex_RPP
   !< pt(2) = ey_RPP
   !< pt(3) = ex_RPP - ey_RPP
   !< pt(0) = projection_onto_plane_RPP(pt(0), pt1=pt(1), pt2=pt(2), pt3=pt(3))
   !< print "(3(F3.1,1X))", pt(0)%x, pt(0)%y, pt(0)%z
   !<```
   !=> 1.0 2.0 0.0 <<<
   class(vector_RPP), intent(in) :: self       !< The point from which computing the distance.
   type(vector_RPP),  intent(in) :: pt1        !< First plane point.
   type(vector_RPP),  intent(in) :: pt2        !< Second plane point.
   type(vector_RPP),  intent(in) :: pt3        !< Third plane point.
   type(vector_RPP)              :: projection !< Point projection.
   type(vector_RPP)              :: distance   !< Vectorial distance.

   distance = self%distance_vectorial_to_plane(pt1=pt1, pt2=pt2, pt3=pt3)
   projection = self - distance
   endfunction projection_onto_plane_RPP

   subroutine save_into_file(self, unit, fmt, pos, iostat, iomsg)
   !< Save vector into file.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = 1 * ex_RPP + 2 * ey_RPP + 3 * ez_RPP
   !< open(unit=10, form='unformatted', status='scratch')
   !< call pt%save_into_file(unit=10)
   !< rewind(unit=10)
   !< call pt%load_from_file(unit=10)
   !< close(unit=10)
   !< print "(3(F3.1,1X))", pt%x, pt%y, pt%z
   !<```
   !=> 1.0 2.0 3.0 <<<
   class(vector_RPP), intent(in)            :: self    !< Vector data.
   integer(I4P),      intent(in)            :: unit    !< Logic unit.
   character(*),      intent(in),  optional :: fmt     !< IO format.
   integer(I8P),      intent(in),  optional :: pos     !< Position specifier.
   integer(I4P),      intent(out), optional :: iostat  !< IO error.
   character(*),      intent(out), optional :: iomsg   !< IO error message.
   integer(I4P)                             :: iostat_ !< IO error, local variable.
   character(len=:), allocatable            :: iomsg_  !< IO error message, local variable.

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

   elemental function sq_norm_RPP(self) result(sq)
   !< Return the square of the norm of vector.
   !<
   !< The square norm if defined as \( N = x^2  + y^2  + z^2 \).
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP
   !< print "(F3.1)", pt%sq_norm()
   !<```
   !=> 2.0 <<<
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP
   !< print "(F3.1)", sq_norm_RPP(pt)
   !<```
   !=> 2.0 <<<
   class(vector_RPP), intent(in) :: self !< Vector.
   real(RPP)                     :: sq   !< Square of the Norm.

   sq = (self%x * self%x) + (self%y * self%y) + (self%z * self%z)
   endfunction sq_norm_RPP

   ! private methods
   pure subroutine mirror_by_normal(self, normal)
   !< Mirror vector given normal of mirroring plane.
   class(vector_RPP), intent(inout) :: self   !< Vector.
   type(vector_RPP),  intent(in)    :: normal !< Normal of mirroring plane.

   self = self%matrixproduct(mirror_matrix_RPP(normal=normal))
   endsubroutine mirror_by_normal

   pure subroutine mirror_by_matrix(self, matrix)
   !< Mirror vector given matrix (of mirroring).
   class(vector_RPP), intent(inout) :: self        !< Vector.
   real(RPP),         intent(in)    :: matrix(3,3) !< Mirroring matrix.

   self = self%matrixproduct(matrix)
   endsubroutine mirror_by_matrix

   pure subroutine rotate_by_axis_angle(self, axis, angle)
   !< Rotate vector given axis and angle.
   !<
   !< Angle must be in radiants.
   class(vector_RPP), intent(inout) :: self  !< Vector.
   type(vector_RPP),  intent(in)    :: axis  !< Axis of rotation.
   real(RPP),         intent(in)    :: angle !< Angle of rotation.

   self = self%matrixproduct(rotation_matrix_RPP(axis=axis, angle=angle))
   endsubroutine rotate_by_axis_angle

   pure subroutine rotate_by_matrix(self, matrix)
   !< Rotate vector given matrix (of ratation).
   class(vector_RPP), intent(inout) :: self        !< Vector.
   real(RPP),         intent(in)    :: matrix(3,3) !< Rotation matrix.

   self = self%matrixproduct(matrix)
   endsubroutine rotate_by_matrix

   ! operator `=`
   pure subroutine assign_vector(lhs, rhs)
   !< Operator `=`
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = 1 * ex_RPP + 2 * ey_RPP + 3 * ez_RPP
   !< print "(3(F3.1,1X))", abs(pt%x), abs(pt%y), abs(pt%z)
   !<```
   !=> 1.0 2.0 3.0 <<<
   class(vector_RPP), intent(inout) :: lhs !< Left hand side.
   type(vector_RPP), intent(in)     :: rhs !< Right hand side.

   lhs%x = rhs%x
   lhs%y = rhs%y
   lhs%z = rhs%z
   endsubroutine assign_vector

   elemental subroutine assign_R16P(lhs, rhs)
   !< Operator `= real(R16P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = 1._R16P
   !< print "(3(F3.1,1X))", abs(pt%x), abs(pt%y), abs(pt%z)
   !<```
   !=> 1.0 1.0 1.0 <<<
   class(vector_RPP), intent(inout) :: lhs !< Left hand side.
   real(R16P),        intent(in)    :: rhs !< Right hand side.

   lhs%x = real(rhs, RPP)
   lhs%y = real(rhs, RPP)
   lhs%z = real(rhs, RPP)
   endsubroutine assign_R16P

   elemental subroutine assign_R8P(lhs, rhs)
   !< Operator `= real(R8P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = 1._R8P
   !< print "(3(F3.1,1X))", abs(pt%x), abs(pt%y), abs(pt%z)
   !<```
   !=> 1.0 1.0 1.0 <<<
   class(vector_RPP), intent(inout) :: lhs !< Left hand side.
   real(R8P),         intent(in)    :: rhs !< Right hand side.

   lhs%x = real(rhs, RPP)
   lhs%y = real(rhs, RPP)
   lhs%z = real(rhs, RPP)
   endsubroutine assign_R8P

   elemental subroutine assign_R4P(lhs, rhs)
   !< Operator `= real(R4P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = 1._R4P
   !< print "(3(F3.1,1X))", abs(pt%x), abs(pt%y), abs(pt%z)
   !<```
   !=> 1.0 1.0 1.0 <<<
   class(vector_RPP), intent(inout) :: lhs !< Left hand side.
   real(R4P),         intent(in)    :: rhs !< Right hand side.

   lhs%x = real(rhs, RPP)
   lhs%y = real(rhs, RPP)
   lhs%z = real(rhs, RPP)
   endsubroutine assign_R4P

   elemental subroutine assign_I8P(lhs, rhs)
   !< Operator `= integer(I8P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = 1_I8P
   !< print "(3(F3.1,1X))", abs(pt%x), abs(pt%y), abs(pt%z)
   !<```
   !=> 1.0 1.0 1.0 <<<
   class(vector_RPP), intent(inout) :: lhs !< Left hand side.
   integer(I8P),      intent(in)    :: rhs !< Right hand side.

   lhs%x = real(rhs, RPP)
   lhs%y = real(rhs, RPP)
   lhs%z = real(rhs, RPP)
   endsubroutine assign_I8P

   elemental subroutine assign_I4P(lhs, rhs)
   !< Operator `= integer(I4P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = 1_I4P
   !< print "(3(F3.1,1X))", abs(pt%x), abs(pt%y), abs(pt%z)
   !<```
   !=> 1.0 1.0 1.0 <<<
   class(vector_RPP), intent(inout) :: lhs !< Left hand side.
   integer(I4P),      intent(in)    :: rhs !< Right hand side.

   lhs%x = real(rhs, RPP)
   lhs%y = real(rhs, RPP)
   lhs%z = real(rhs, RPP)
   endsubroutine assign_I4P

   elemental subroutine assign_I2P(lhs, rhs)
   !< Operator `= integer(I4P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = 1_I2P
   !< print "(3(F3.1,1X))", abs(pt%x), abs(pt%y), abs(pt%z)
   !<```
   !=> 1.0 1.0 1.0 <<<
   class(vector_RPP), intent(inout) :: lhs !< Left hand side.
   integer(I2P),      intent(in)    :: rhs !< Right hand side.

   lhs%x = real(rhs, RPP)
   lhs%y = real(rhs, RPP)
   lhs%z = real(rhs, RPP)
   endsubroutine assign_I2P

   elemental subroutine assign_I1P(lhs, rhs)
   !< Operator `= integer(I4P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = 1_I1P
   !< print "(3(F3.1,1X))", abs(pt%x), abs(pt%y), abs(pt%z)
   !<```
   !=> 1.0 1.0 1.0 <<<
   class(vector_RPP), intent(inout) :: lhs !< Left hand side.
   integer(I1P),      intent(in)    :: rhs !< Right hand side.

   lhs%x = real(rhs, RPP)
   lhs%y = real(rhs, RPP)
   lhs%z = real(rhs, RPP)
   endsubroutine assign_I1P

   ! operator `*`
   elemental function vector_mul_vector(lhs, rhs) result(opr)
   !< Operator `*`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:2)
   !< pt(1) = 1 * ex_RPP + 2 * ey_RPP + 1 * ez_RPP
   !< pt(2) = pt(1) + 1
   !< pt(0) = pt(1) * pt(2)
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 2.0 6.0 2.0 <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   type(vector_RPP),  intent(in) :: rhs !< Right hand side.
   type(vector_RPP)              :: opr !< Operator result.

   opr%x = lhs%x * rhs%x
   opr%y = lhs%y * rhs%y
   opr%z = lhs%z * rhs%z
   endfunction vector_mul_vector

   elemental function R16P_mul_vector(lhs, rhs) result(opr)
   !< Operator `real(R16P) *`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:1)
   !< pt(1) = 1 * ex_RPP + 2 * ey_RPP + 1 * ez_RPP
   !< pt(0) = 2._R16P * pt(1)
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 2.0 4.0 2.0 <<<
   real(R16P),        intent(in) :: lhs !< Left hand side.
   class(vector_RPP), intent(in) :: rhs !< Right hand side.
   type(vector_RPP)              :: opr !< Operator result.

   opr%x = real(lhs, RPP) * rhs%x
   opr%y = real(lhs, RPP) * rhs%y
   opr%z = real(lhs, RPP) * rhs%z
   endfunction R16P_mul_vector

   elemental function vector_mul_R16P(lhs, rhs) result(opr)
   !< Operator `* real(R16P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:1)
   !< pt(1) = 1 * ex_RPP + 2 * ey_RPP + 1 * ez_RPP
   !< pt(0) = pt(1) * 2._R16P
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 2.0 4.0 2.0 <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   real(R16P),        intent(in) :: rhs !< Right hand side.
   type(vector_RPP)              :: opr !< Operator result.

   opr%x = lhs%x * real(rhs, RPP)
   opr%y = lhs%y * real(rhs, RPP)
   opr%z = lhs%z * real(rhs, RPP)
   endfunction vector_mul_R16P

   elemental function R8P_mul_vector(lhs, rhs) result(opr)
   !< Operator `real(R8P) *`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:1)
   !< pt(1) = 1 * ex_RPP + 2 * ey_RPP + 1 * ez_RPP
   !< pt(0) = 2._R8P * pt(1)
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 2.0 4.0 2.0 <<<
   real(R8P),         intent(in) :: lhs !< Left hand side.
   class(vector_RPP), intent(in) :: rhs !< Right hand side.
   type(vector_RPP)              :: opr !< Operator result.

   opr%x = real(lhs, RPP) * rhs%x
   opr%y = real(lhs, RPP) * rhs%y
   opr%z = real(lhs, RPP) * rhs%z
   endfunction R8P_mul_vector

   elemental function vector_mul_R8P(lhs, rhs) result(opr)
   !< Operator `* real(R8P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:1)
   !< pt(1) = 1 * ex_RPP + 2 * ey_RPP + 1 * ez_RPP
   !< pt(0) = pt(1) * 2._R8P
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 2.0 4.0 2.0 <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   real(R8P),         intent(in) :: rhs !< Right hand side.
   type(vector_RPP)              :: opr !< Operator result.

   opr%x = lhs%x * real(rhs, RPP)
   opr%y = lhs%y * real(rhs, RPP)
   opr%z = lhs%z * real(rhs, RPP)
   endfunction vector_mul_R8P

   elemental function R4P_mul_vector(lhs, rhs) result(opr)
   !< Operator `real(R4P) *`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:1)
   !< pt(1) = 1 * ex_RPP + 2 * ey_RPP + 1 * ez_RPP
   !< pt(0) = 2._R4P * pt(1)
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 2.0 4.0 2.0 <<<
   real(R4P),         intent(in) :: lhs !< Left hand side.
   class(vector_RPP), intent(in) :: rhs !< Right hand side.
   type(vector_RPP)              :: opr !< Operator result.

   opr%x = real(lhs, RPP) * rhs%x
   opr%y = real(lhs, RPP) * rhs%y
   opr%z = real(lhs, RPP) * rhs%z
   endfunction R4P_mul_vector

   elemental function vector_mul_R4P(lhs, rhs) result(opr)
   !< Operator `* real(R4P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:1)
   !< pt(1) = 1 * ex_RPP + 2 * ey_RPP + 1 * ez_RPP
   !< pt(0) = pt(1) * 2._R4P
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 2.0 4.0 2.0 <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   real(R4P),         intent(in) :: rhs !< Right hand side.
   type(vector_RPP)              :: opr !< Operator result.

   opr%x = lhs%x * real(rhs, RPP)
   opr%y = lhs%y * real(rhs, RPP)
   opr%z = lhs%z * real(rhs, RPP)
   endfunction vector_mul_R4P

   elemental function I8P_mul_vector(lhs, rhs) result(opr)
   !< Operator `integer(I8P) *`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:1)
   !< pt(1) = 1 * ex_RPP + 2 * ey_RPP + 1 * ez_RPP
   !< pt(0) = 2_I8P * pt(1)
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 2.0 4.0 2.0 <<<
   integer(I8P),      intent(in) :: lhs !< Left hand side.
   class(vector_RPP), intent(in) :: rhs !< Right hand side.
   type(vector_RPP)              :: opr !< Operator result.

   opr%x = real(lhs, RPP) * rhs%x
   opr%y = real(lhs, RPP) * rhs%y
   opr%z = real(lhs, RPP) * rhs%z
   endfunction I8P_mul_vector

   elemental function vector_mul_I8P(lhs, rhs) result(opr)
   !< Operator `* integer(I8P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:1)
   !< pt(1) = 1 * ex_RPP + 2 * ey_RPP + 1 * ez_RPP
   !< pt(0) = pt(1) * 2_I8P
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 2.0 4.0 2.0 <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   integer(I8P),      intent(in) :: rhs !< Right hand side.
   type(vector_RPP)              :: opr !< Operator result.

   opr%x = lhs%x * real(rhs, RPP)
   opr%y = lhs%y * real(rhs, RPP)
   opr%z = lhs%z * real(rhs, RPP)
   endfunction vector_mul_I8P

   elemental function I4P_mul_vector(lhs, rhs) result(opr)
   !< Operator `integer(I4P) *`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:1)
   !< pt(1) = 1 * ex_RPP + 2 * ey_RPP + 1 * ez_RPP
   !< pt(0) = 2_I4P * pt(1)
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 2.0 4.0 2.0 <<<
   integer(I4P),      intent(in) :: lhs !< Left hand side.
   class(vector_RPP), intent(in) :: rhs !< Right hand side.
   type(vector_RPP)              :: opr !< Operator result.

   opr%x = real(lhs, RPP) * rhs%x
   opr%y = real(lhs, RPP) * rhs%y
   opr%z = real(lhs, RPP) * rhs%z
   endfunction I4P_mul_vector

   elemental function vector_mul_I4P(lhs, rhs) result(opr)
   !< Operator `* integer(I4P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:1)
   !< pt(1) = 1 * ex_RPP + 2 * ey_RPP + 1 * ez_RPP
   !< pt(0) = pt(1) * 2_I4P
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 2.0 4.0 2.0 <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   integer(I4P),      intent(in) :: rhs !< Right hand side.
   type(vector_RPP)              :: opr !< Operator result.

   opr%x = lhs%x * real(rhs, RPP)
   opr%y = lhs%y * real(rhs, RPP)
   opr%z = lhs%z * real(rhs, RPP)
   endfunction vector_mul_I4P

   elemental function I2P_mul_vector(lhs, rhs) result(opr)
   !< Operator `integer(I2P) *`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:1)
   !< pt(1) = 1 * ex_RPP + 2 * ey_RPP + 1 * ez_RPP
   !< pt(0) = 2_I2P * pt(1)
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 2.0 4.0 2.0 <<<
   integer(I2P),      intent(in) :: lhs !< Left hand side.
   class(vector_RPP), intent(in) :: rhs !< Right hand side.
   type(vector_RPP)              :: opr !< Operator result.

   opr%x = real(lhs, RPP) * rhs%x
   opr%y = real(lhs, RPP) * rhs%y
   opr%z = real(lhs, RPP) * rhs%z
   endfunction I2P_mul_vector

   elemental function vector_mul_I2P(lhs, rhs) result(opr)
   !< Operator `* integer(I2P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:1)
   !< pt(1) = 1 * ex_RPP + 2 * ey_RPP + 1 * ez_RPP
   !< pt(0) = pt(1) * 2_I2P
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 2.0 4.0 2.0 <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   integer(I2P),      intent(in) :: rhs !< Right hand side.
   type(vector_RPP)              :: opr !< Operator result.

   opr%x = lhs%x * real(rhs, RPP)
   opr%y = lhs%y * real(rhs, RPP)
   opr%z = lhs%z * real(rhs, RPP)
   endfunction vector_mul_I2P

   elemental function I1P_mul_vector(lhs, rhs) result(opr)
   !< Operator `integer(I1P) *`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:1)
   !< pt(1) = 1 * ex_RPP + 2 * ey_RPP + 1 * ez_RPP
   !< pt(0) = 2_I1P * pt(1)
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 2.0 4.0 2.0 <<<
   integer(I1P),      intent(in) :: lhs !< Left hand side.
   class(vector_RPP), intent(in) :: rhs !< Right hand side.
   type(vector_RPP)              :: opr !< Operator result.

   opr%x = real(lhs, RPP) * rhs%x
   opr%y = real(lhs, RPP) * rhs%y
   opr%z = real(lhs, RPP) * rhs%z
   endfunction I1P_mul_vector

   elemental function vector_mul_I1P(lhs, rhs) result(opr)
   !< Operator `* integer(I1P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:1)
   !< pt(1) = 1 * ex_RPP + 2 * ey_RPP + 1 * ez_RPP
   !< pt(0) = pt(1) * 2_I1P
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 2.0 4.0 2.0 <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   integer(I1P),      intent(in) :: rhs !< Right hand side.
   type(vector_RPP)              :: opr !< Operator result.

   opr%x = lhs%x * real(rhs, RPP)
   opr%y = lhs%y * real(rhs, RPP)
   opr%z = lhs%z * real(rhs, RPP)
   endfunction vector_mul_I1P

   ! operator `/`
   elemental function vector_div_vector(lhs, rhs) result(opr)
   !< Operator `/`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:2)
   !< pt(1) = 1 * ex_RPP + 1 * ey_RPP + 1 * ez_RPP
   !< pt(2) = pt(1) + 1
   !< pt(0) = pt(1) / pt(2)
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 0.5 0.5 0.5 <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   type(vector_RPP),  intent(in) :: rhs !< Right hand side.
   type(vector_RPP)              :: opr !< Operator result.

   opr%x = lhs%x / rhs%x
   opr%y = lhs%y / rhs%y
   opr%z = lhs%z / rhs%z
   endfunction vector_div_vector

   elemental function vector_div_R16P(lhs, rhs) result(opr)
   !< Operator `/ real(R16P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:1)
   !< pt(1) = 1 * ex_RPP + 2 * ey_RPP + 1 * ez_RPP
   !< pt(0) = pt(1) / 2._R16P
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 0.5 1.0 0.5 <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   real(R16P),        intent(in) :: rhs !< Right hand side.
   type(vector_RPP)              :: opr !< Operator result.

   opr%x = lhs%x / real(rhs, RPP)
   opr%y = lhs%y / real(rhs, RPP)
   opr%z = lhs%z / real(rhs, RPP)
   endfunction vector_div_R16P

   elemental function vector_div_R8P(lhs, rhs) result(opr)
   !< Operator `/ real(R8P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:1)
   !< pt(1) = 1 * ex_RPP + 2 * ey_RPP + 1 * ez_RPP
   !< pt(0) = pt(1) / 2._R8P
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 0.5 1.0 0.5 <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   real(R8P),         intent(in) :: rhs !< Right hand side.
   type(vector_RPP)              :: opr !< Operator result.

   opr%x = lhs%x / real(rhs, RPP)
   opr%y = lhs%y / real(rhs, RPP)
   opr%z = lhs%z / real(rhs, RPP)
   endfunction vector_div_R8P

   elemental function vector_div_R4P(lhs, rhs) result(opr)
   !< Operator `/ real(R4P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:1)
   !< pt(1) = 1 * ex_RPP + 2 * ey_RPP + 1 * ez_RPP
   !< pt(0) = pt(1) / 2._R4P
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 0.5 1.0 0.5 <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   real(R4P),         intent(in) :: rhs !< Right hand side.
   type(vector_RPP)              :: opr !< Operator result.

   opr%x = lhs%x / real(rhs, RPP)
   opr%y = lhs%y / real(rhs, RPP)
   opr%z = lhs%z / real(rhs, RPP)
   endfunction vector_div_R4P

   elemental function vector_div_I8P(lhs, rhs) result(opr)
   !< Operator `/ integer(I8P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:1)
   !< pt(1) = 1 * ex_RPP + 2 * ey_RPP + 1 * ez_RPP
   !< pt(0) = pt(1) / 2_I8P
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 0.5 1.0 0.5 <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   integer(I8P),      intent(in) :: rhs !< Right hand side.
   type(vector_RPP)              :: opr !< Operator result.

   opr%x = lhs%x / real(rhs, RPP)
   opr%y = lhs%y / real(rhs, RPP)
   opr%z = lhs%z / real(rhs, RPP)
   endfunction vector_div_I8P

   elemental function vector_div_I4P(lhs, rhs) result(opr)
   !< Operator `/ integer(I4P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:1)
   !< pt(1) = 1 * ex_RPP + 2 * ey_RPP + 1 * ez_RPP
   !< pt(0) = pt(1) / 2_I4P
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 0.5 1.0 0.5 <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   integer(I4P),      intent(in) :: rhs !< Right hand side.
   type(vector_RPP)              :: opr !< Operator result.

   opr%x = lhs%x / real(rhs, RPP)
   opr%y = lhs%y / real(rhs, RPP)
   opr%z = lhs%z / real(rhs, RPP)
   endfunction vector_div_I4P

   elemental function vector_div_I2P(lhs, rhs) result(opr)
   !< Operator `/ integer(I2P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:1)
   !< pt(1) = 1 * ex_RPP + 2 * ey_RPP + 1 * ez_RPP
   !< pt(0) = pt(1) / 2_I2P
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 0.5 1.0 0.5 <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   integer(I2P),      intent(in) :: rhs !< Right hand side.
   type(vector_RPP)              :: opr !< Operator result.

   opr%x = lhs%x / real(rhs, RPP)
   opr%y = lhs%y / real(rhs, RPP)
   opr%z = lhs%z / real(rhs, RPP)
   endfunction vector_div_I2P

   elemental function vector_div_I1P(lhs, rhs) result(opr)
   !< Operator `/ integer(I1P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:1)
   !< pt(1) = 1 * ex_RPP + 2 * ey_RPP + 1 * ez_RPP
   !< pt(0) = pt(1) / 2_I1P
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 0.5 1.0 0.5 <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   integer(I1P),      intent(in) :: rhs !< Right hand side.
   type(vector_RPP)              :: opr !< Operator result.

   opr%x = lhs%x / real(rhs, RPP)
   opr%y = lhs%y / real(rhs, RPP)
   opr%z = lhs%z / real(rhs, RPP)
   endfunction vector_div_I1P

   ! operator `+`
   elemental function positive(rhs) result(opr)
   !< Operator `+` unary.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:1)
   !< pt(1) = 1 * ex_RPP + 2 * ey_RPP + 1 * ez_RPP
   !< pt(0) = + pt(1)
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 1.0 2.0 1.0 <<<
   class(vector_RPP), intent(in) :: rhs !< Right hand side.
   type(vector_RPP)              :: opr !< Operator result.

   opr%x = + rhs%x
   opr%y = + rhs%y
   opr%z = + rhs%z
   endfunction positive

   elemental function vector_sum_vector(lhs, rhs) result(opr)
   !< Operator `+`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:2)
   !< pt(1) = 1 * ex_RPP + 1 * ey_RPP + 1 * ez_RPP
   !< pt(2) = pt(1) + 1
   !< pt(0) = pt(1) + pt(2)
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 3.0 3.0 3.0 <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   type(vector_RPP),  intent(in) :: rhs !< Right hand side.
   type(vector_RPP)              :: opr !< Operator result.

   opr%x = lhs%x + rhs%x
   opr%y = lhs%y + rhs%y
   opr%z = lhs%z + rhs%z
   endfunction vector_sum_vector

   elemental function R16P_sum_vector(lhs, rhs) result(opr)
   !< Operator `real(R16P) +`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:1)
   !< pt(1) = 1 * ex_RPP + 2 * ey_RPP + 1 * ez_RPP
   !< pt(0) = 2._R16P + pt(1)
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 3.0 4.0 3.0 <<<
   real(R16P),        intent(in) :: lhs !< Left hand side.
   class(vector_RPP), intent(in) :: rhs !< Right hand side.
   type(vector_RPP)              :: opr !< Operator result.

   opr%x = real(lhs, RPP) + rhs%x
   opr%y = real(lhs, RPP) + rhs%y
   opr%z = real(lhs, RPP) + rhs%z
   endfunction R16P_sum_vector

   elemental function vector_sum_R16P(lhs, rhs) result(opr)
   !< Operator `+ real(R16P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:1)
   !< pt(1) = 1 * ex_RPP + 2 * ey_RPP + 1 * ez_RPP
   !< pt(0) = pt(1) + 2._R16P
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 3.0 4.0 3.0 <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   real(R16P),        intent(in) :: rhs !< Right hand side.
   type(vector_RPP)              :: opr !< Operator result.

   opr%x = lhs%x + real(rhs, RPP)
   opr%y = lhs%y + real(rhs, RPP)
   opr%z = lhs%z + real(rhs, RPP)
   endfunction vector_sum_R16P

   elemental function R8P_sum_vector(lhs, rhs) result(opr)
   !< Operator `real(R8P) +`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:1)
   !< pt(1) = 1 * ex_RPP + 2 * ey_RPP + 1 * ez_RPP
   !< pt(0) = 2._R8P + pt(1)
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 3.0 4.0 3.0 <<<
   real(R8P),         intent(in) :: lhs !< Left hand side.
   class(vector_RPP), intent(in) :: rhs !< Right hand side.
   type(vector_RPP)              :: opr !< Operator result.

   opr%x = real(lhs, RPP) + rhs%x
   opr%y = real(lhs, RPP) + rhs%y
   opr%z = real(lhs, RPP) + rhs%z
   endfunction R8P_sum_vector

   elemental function vector_sum_R8P(lhs, rhs) result(opr)
   !< Operator `+ real(R8P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:1)
   !< pt(1) = 1 * ex_RPP + 2 * ey_RPP + 1 * ez_RPP
   !< pt(0) = pt(1) + 2._R8P
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 3.0 4.0 3.0 <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   real(R8P),         intent(in) :: rhs !< Right hand side.
   type(vector_RPP)              :: opr !< Operator result.

   opr%x = lhs%x + real(rhs, RPP)
   opr%y = lhs%y + real(rhs, RPP)
   opr%z = lhs%z + real(rhs, RPP)
   endfunction vector_sum_R8P

   elemental function R4P_sum_vector(lhs, rhs) result(opr)
   !< Operator `real(R4P) +`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:1)
   !< pt(1) = 1 * ex_RPP + 2 * ey_RPP + 1 * ez_RPP
   !< pt(0) = 2._R4P + pt(1)
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 3.0 4.0 3.0 <<<
   real(R4P),         intent(in) :: lhs !< Left hand side.
   class(vector_RPP), intent(in) :: rhs !< Right hand side.
   type(vector_RPP)              :: opr !< Operator result.

   opr%x = real(lhs, RPP) + rhs%x
   opr%y = real(lhs, RPP) + rhs%y
   opr%z = real(lhs, RPP) + rhs%z
   endfunction R4P_sum_vector

   elemental function vector_sum_R4P(lhs, rhs) result(opr)
   !< Operator `+ real(R4P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:1)
   !< pt(1) = 1 * ex_RPP + 2 * ey_RPP + 1 * ez_RPP
   !< pt(0) = pt(1) + 2._R4P
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 3.0 4.0 3.0 <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   real(R4P),         intent(in) :: rhs !< Right hand side.
   type(vector_RPP)              :: opr !< Operator result.

   opr%x = lhs%x + real(rhs, RPP)
   opr%y = lhs%y + real(rhs, RPP)
   opr%z = lhs%z + real(rhs, RPP)
   endfunction vector_sum_R4P

   elemental function I8P_sum_vector(lhs, rhs) result(opr)
   !< Operator `integer(I8P) +`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:1)
   !< pt(1) = 1 * ex_RPP + 2 * ey_RPP + 1 * ez_RPP
   !< pt(0) = 2_I8P + pt(1)
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 3.0 4.0 3.0 <<<
   integer(I8P),      intent(in) :: lhs !< Left hand side.
   class(vector_RPP), intent(in) :: rhs !< Right hand side.
   type(vector_RPP)              :: opr !< Operator result.

   opr%x = real(lhs, RPP) + rhs%x
   opr%y = real(lhs, RPP) + rhs%y
   opr%z = real(lhs, RPP) + rhs%z
   endfunction I8P_sum_vector

   elemental function vector_sum_I8P(lhs, rhs) result(opr)
   !< Operator `+ integer(I8P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:1)
   !< pt(1) = 1 * ex_RPP + 2 * ey_RPP + 1 * ez_RPP
   !< pt(0) = pt(1) + 2_I8P
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 3.0 4.0 3.0 <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   integer(I8P),      intent(in) :: rhs !< Right hand side.
   type(vector_RPP)              :: opr !< Operator result.

   opr%x = lhs%x + real(rhs, RPP)
   opr%y = lhs%y + real(rhs, RPP)
   opr%z = lhs%z + real(rhs, RPP)
   endfunction vector_sum_I8P

   elemental function I4P_sum_vector(lhs, rhs) result(opr)
   !< Operator `integer(I4P) +`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:1)
   !< pt(1) = 1 * ex_RPP + 2 * ey_RPP + 1 * ez_RPP
   !< pt(0) = 2_I4P + pt(1)
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 3.0 4.0 3.0 <<<
   integer(I4P),      intent(in) :: lhs !< Left hand side.
   class(vector_RPP), intent(in) :: rhs !< Right hand side.
   type(vector_RPP)              :: opr !< Operator result.

   opr%x = real(lhs, RPP) + rhs%x
   opr%y = real(lhs, RPP) + rhs%y
   opr%z = real(lhs, RPP) + rhs%z
   endfunction I4P_sum_vector

   elemental function vector_sum_I4P(lhs, rhs) result(opr)
   !< Operator `+ integer(I4P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:1)
   !< pt(1) = 1 * ex_RPP + 2 * ey_RPP + 1 * ez_RPP
   !< pt(0) = pt(1) + 2_I4P
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 3.0 4.0 3.0 <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   integer(I4P),      intent(in) :: rhs !< Right hand side.
   type(vector_RPP)              :: opr !< Operator result.

   opr%x = lhs%x + real(rhs, RPP)
   opr%y = lhs%y + real(rhs, RPP)
   opr%z = lhs%z + real(rhs, RPP)
   endfunction vector_sum_I4P

   elemental function I2P_sum_vector(lhs, rhs) result(opr)
   !< Operator `integer(I2P) +`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:1)
   !< pt(1) = 1 * ex_RPP + 2 * ey_RPP + 1 * ez_RPP
   !< pt(0) = 2_I2P + pt(1)
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 3.0 4.0 3.0 <<<
   integer(I2P),      intent(in) :: lhs !< Left hand side.
   class(vector_RPP), intent(in) :: rhs !< Right hand side.
   type(vector_RPP)              :: opr !< Operator result.

   opr%x = real(lhs, RPP) + rhs%x
   opr%y = real(lhs, RPP) + rhs%y
   opr%z = real(lhs, RPP) + rhs%z
   endfunction I2P_sum_vector

   elemental function vector_sum_I2P(lhs, rhs) result(opr)
   !< Operator `+ integer(I2P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:1)
   !< pt(1) = 1 * ex_RPP + 2 * ey_RPP + 1 * ez_RPP
   !< pt(0) = pt(1) + 2_I2P
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 3.0 4.0 3.0 <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   integer(I2P),      intent(in) :: rhs !< Right hand side.
   type(vector_RPP)              :: opr !< Operator result.

   opr%x = lhs%x + real(rhs, RPP)
   opr%y = lhs%y + real(rhs, RPP)
   opr%z = lhs%z + real(rhs, RPP)
   endfunction vector_sum_I2P

   elemental function I1P_sum_vector(lhs, rhs) result(opr)
   !< Operator `integer(I1P) +`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:1)
   !< pt(1) = 1 * ex_RPP + 2 * ey_RPP + 1 * ez_RPP
   !< pt(0) = 2_I1P + pt(1)
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 3.0 4.0 3.0 <<<
   integer(I1P),      intent(in) :: lhs !< Left hand side.
   class(vector_RPP), intent(in) :: rhs !< Right hand side.
   type(vector_RPP)              :: opr !< Operator result.

   opr%x = real(lhs, RPP) + rhs%x
   opr%y = real(lhs, RPP) + rhs%y
   opr%z = real(lhs, RPP) + rhs%z
   endfunction I1P_sum_vector

   elemental function vector_sum_I1P(lhs, rhs) result(opr)
   !< Operator `+ integer(I1P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:1)
   !< pt(1) = 1 * ex_RPP + 2 * ey_RPP + 1 * ez_RPP
   !< pt(0) = pt(1) + 2_I1P
   !< print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
   !<```
   !=> 3.0 4.0 3.0 <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   integer(I1P),      intent(in) :: rhs !< Right hand side.
   type(vector_RPP)              :: opr !< Operator result.

   opr%x = lhs%x + real(rhs, RPP)
   opr%y = lhs%y + real(rhs, RPP)
   opr%z = lhs%z + real(rhs, RPP)
   endfunction vector_sum_I1P

   ! operator `-`
   elemental function negative(rhs) result(opr)
   !< Operator `-` unary.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:1)
   !< pt(1) = 1 * ex_RPP + 2 * ey_RPP + 1 * ez_RPP
   !< pt(0) = - pt(1)
   !< print "(3(F4.1,1X))", pt(0)%x, pt(0)%y, pt(0)%z
   !<```
   !=> -1.0 -2.0 -1.0 <<<
   class(vector_RPP), intent(in) :: rhs !< Right hand side.
   type(vector_RPP)              :: opr !< Operator result.

   opr%x = - rhs%x
   opr%y = - rhs%y
   opr%z = - rhs%z
   endfunction negative

   elemental function vector_sub_vector(lhs, rhs) result(opr)
   !< Operator `-`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:2)
   !< pt(1) = 1 * ex_RPP + 1 * ey_RPP + 1 * ez_RPP
   !< pt(2) = pt(1) + 1
   !< pt(0) = pt(1) - pt(2)
   !< print "(3(F4.1,1X))", pt(0)%x, pt(0)%y, pt(0)%z
   !<```
   !=> -1.0 -1.0 -1.0 <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   type(vector_RPP),  intent(in) :: rhs !< Right hand side.
   type(vector_RPP)              :: opr !< Operator result.

   opr%x = lhs%x - rhs%x
   opr%y = lhs%y - rhs%y
   opr%z = lhs%z - rhs%z
   endfunction vector_sub_vector

   elemental function R16P_sub_vector(lhs, rhs) result(opr)
   !< Operator `real(R16P) -`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:1)
   !< pt(1) = 1 * ex_RPP + 2 * ey_RPP + 1 * ez_RPP
   !< pt(0) = 2._R16P - pt(1)
   !< print "(3(F3.1,1X))", pt(0)%x, pt(0)%y, pt(0)%z
   !<```
   !=> 1.0 0.0 1.0 <<<
   real(R16P),        intent(in) :: lhs !< Left hand side.
   class(vector_RPP), intent(in) :: rhs !< Right hand side.
   type(vector_RPP)              :: opr !< Operator result.

   opr%x = real(lhs, RPP) - rhs%x
   opr%y = real(lhs, RPP) - rhs%y
   opr%z = real(lhs, RPP) - rhs%z
   endfunction R16P_sub_vector

   elemental function vector_sub_R16P(lhs, rhs) result(opr)
   !< Operator `- real(R16P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:1)
   !< pt(1) = 1 * ex_RPP + 2 * ey_RPP + 1 * ez_RPP
   !< pt(0) = pt(1) - 3._R16P
   !< print "(3(F4.1,1X))", pt(0)%x, pt(0)%y, pt(0)%z
   !<```
   !=> -2.0 -1.0 -2.0 <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   real(R16P),        intent(in) :: rhs !< Right hand side.
   type(vector_RPP)              :: opr !< Operator result.

   opr%x = lhs%x - real(rhs, RPP)
   opr%y = lhs%y - real(rhs, RPP)
   opr%z = lhs%z - real(rhs, RPP)
   endfunction vector_sub_R16P

   elemental function R8P_sub_vector(lhs, rhs) result(opr)
   !< Operator `real(R8P) -`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:1)
   !< pt(1) = 1 * ex_RPP + 2 * ey_RPP + 1 * ez_RPP
   !< pt(0) = 2._R8P - pt(1)
   !< print "(3(F3.1,1X))", pt(0)%x, pt(0)%y, pt(0)%z
   !<```
   !=> 1.0 0.0 1.0 <<<
   real(R8P),         intent(in) :: lhs !< Left hand side.
   class(vector_RPP), intent(in) :: rhs !< Right hand side.
   type(vector_RPP)              :: opr !< Operator result.

   opr%x = real(lhs, RPP) - rhs%x
   opr%y = real(lhs, RPP) - rhs%y
   opr%z = real(lhs, RPP) - rhs%z
   endfunction R8P_sub_vector

   elemental function vector_sub_R8P(lhs, rhs) result(opr)
   !< Operator `- real(R8P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:1)
   !< character(4) :: res(3)
   !< pt(1) = 1 * ex_RPP + 2 * ey_RPP + 1 * ez_RPP
   !< pt(0) = pt(1) - 2._R8P
   !< res(1) = trim(adjustl(str('(F4.1)',pt(0)%x)))
   !< res(2) = trim(adjustl(str('(F4.1)',pt(0)%y)))
   !< res(3) = trim(adjustl(str('(F4.1)',pt(0)%z)))
   !< print "(A4,1X,A3,1X,A4)", res(1), res(2), res(3)
   !<```
   !=> -1.0 0.0 -1.0 <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   real(R8P),         intent(in) :: rhs !< Right hand side.
   type(vector_RPP)              :: opr !< Operator result.

   opr%x = lhs%x - real(rhs, RPP)
   opr%y = lhs%y - real(rhs, RPP)
   opr%z = lhs%z - real(rhs, RPP)
   endfunction vector_sub_R8P

   elemental function R4P_sub_vector(lhs, rhs) result(opr)
   !< Operator `real(R4P) -`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:1)
   !< pt(1) = 1 * ex_RPP + 2 * ey_RPP + 1 * ez_RPP
   !< pt(0) = 2._R4P - pt(1)
   !< print "(3(F3.1,1X))", pt(0)%x, pt(0)%y, pt(0)%z
   !<```
   !=> 1.0 0.0 1.0 <<<
   real(R4P),         intent(in) :: lhs !< Left hand side.
   class(vector_RPP), intent(in) :: rhs !< Right hand side.
   type(vector_RPP)              :: opr !< Operator result.

   opr%x = real(lhs, RPP) - rhs%x
   opr%y = real(lhs, RPP) - rhs%y
   opr%z = real(lhs, RPP) - rhs%z
   endfunction R4P_sub_vector

   elemental function vector_sub_R4P(lhs, rhs) result(opr)
   !< Operator `- real(R4P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:1)
   !< pt(1) = 1 * ex_RPP + 2 * ey_RPP + 1 * ez_RPP
   !< pt(0) = pt(1) - 3._R4P
   !< print "(3(F4.1,1X))", pt(0)%x, pt(0)%y, pt(0)%z
   !<```
   !=> -2.0 -1.0 -2.0 <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   real(R4P),         intent(in) :: rhs !< Right hand side.
   type(vector_RPP)              :: opr !< Operator result.

   opr%x = lhs%x - real(rhs, RPP)
   opr%y = lhs%y - real(rhs, RPP)
   opr%z = lhs%z - real(rhs, RPP)
   endfunction vector_sub_R4P

   elemental function I8P_sub_vector(lhs, rhs) result(opr)
   !< Operator `integer(I8P) -`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:1)
   !< pt(1) = 1 * ex_RPP + 2 * ey_RPP + 1 * ez_RPP
   !< pt(0) = 2_I8P - pt(1)
   !< print "(3(F3.1,1X))", pt(0)%x, pt(0)%y, pt(0)%z
   !<```
   !=> 1.0 0.0 1.0 <<<
   integer(I8P),      intent(in) :: lhs !< Left hand side.
   class(vector_RPP), intent(in) :: rhs !< Right hand side.
   type(vector_RPP)              :: opr !< Operator result.

   opr%x = real(lhs, RPP) - rhs%x
   opr%y = real(lhs, RPP) - rhs%y
   opr%z = real(lhs, RPP) - rhs%z
   endfunction I8P_sub_vector

   elemental function vector_sub_I8P(lhs, rhs) result(opr)
   !< Operator `- integer(I8P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:1)
   !< character(4) :: res(3)
   !< pt(1) = 1 * ex_RPP + 2 * ey_RPP + 1 * ez_RPP
   !< pt(0) = pt(1) - 2_I8P
   !< res(1) = trim(adjustl(str('(F4.1)',pt(0)%x)))
   !< res(2) = trim(adjustl(str('(F4.1)',pt(0)%y)))
   !< res(3) = trim(adjustl(str('(F4.1)',pt(0)%z)))
   !< print "(A4,1X,A3,1X,A4)", res(1), res(2), res(3)
   !<```
   !=> -1.0 0.0 -1.0 <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   integer(I8P),      intent(in) :: rhs !< Right hand side.
   type(vector_RPP)              :: opr !< Operator result.

   opr%x = lhs%x - real(rhs, RPP)
   opr%y = lhs%y - real(rhs, RPP)
   opr%z = lhs%z - real(rhs, RPP)
   endfunction vector_sub_I8P

   elemental function I4P_sub_vector(lhs, rhs) result(opr)
   !< Operator `integer(I4P) -`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:1)
   !< pt(1) = 1 * ex_RPP + 2 * ey_RPP + 1 * ez_RPP
   !< pt(0) = 2_I4P - pt(1)
   !< print "(3(F3.1,1X))", pt(0)%x, pt(0)%y, pt(0)%z
   !<```
   !=> 1.0 0.0 1.0 <<<
   integer(I4P),      intent(in) :: lhs !< Left hand side.
   class(vector_RPP), intent(in) :: rhs !< Right hand side.
   type(vector_RPP)              :: opr !< Operator result.

   opr%x = real(lhs, RPP) - rhs%x
   opr%y = real(lhs, RPP) - rhs%y
   opr%z = real(lhs, RPP) - rhs%z
   endfunction I4P_sub_vector

   elemental function vector_sub_I4P(lhs, rhs) result(opr)
   !< Operator `- integer(I4P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:1)
   !< pt(1) = 1 * ex_RPP + 2 * ey_RPP + 1 * ez_RPP
   !< pt(0) = pt(1) - 3_I4P
   !< print "(3(F4.1,1X))", pt(0)%x, pt(0)%y, pt(0)%z
   !<```
   !=> -2.0 -1.0 -2.0 <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   integer(I4P),      intent(in) :: rhs !< Right hand side.
   type(vector_RPP)              :: opr !< Operator result.

   opr%x = lhs%x - real(rhs, RPP)
   opr%y = lhs%y - real(rhs, RPP)
   opr%z = lhs%z - real(rhs, RPP)
   endfunction vector_sub_I4P

   elemental function I2P_sub_vector(lhs, rhs) result(opr)
   !< Operator `integer(I2P) -`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:1)
   !< pt(1) = 1 * ex_RPP + 2 * ey_RPP + 1 * ez_RPP
   !< pt(0) = 2_I2P - pt(1)
   !< print "(3(F3.1,1X))", pt(0)%x, pt(0)%y, pt(0)%z
   !<```
   !=> 1.0 0.0 1.0 <<<
   integer(I2P),      intent(in) :: lhs !< Left hand side.
   class(vector_RPP), intent(in) :: rhs !< Right hand side.
   type(vector_RPP)              :: opr !< Operator result.

   opr%x = real(lhs, RPP) - rhs%x
   opr%y = real(lhs, RPP) - rhs%y
   opr%z = real(lhs, RPP) - rhs%z
   endfunction I2P_sub_vector

   elemental function vector_sub_I2P(lhs, rhs) result(opr)
   !< Operator `- integer(I2P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:1)
   !< pt(1) = 1 * ex_RPP + 2 * ey_RPP + 1 * ez_RPP
   !< pt(0) = pt(1) - 3_I2P
   !< print "(3(F4.1,1X))", pt(0)%x, pt(0)%y, pt(0)%z
   !<```
   !=> -2.0 -1.0 -2.0 <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   integer(I2P),      intent(in) :: rhs !< Right hand side.
   type(vector_RPP)              :: opr !< Operator result.

   opr%x = lhs%x - real(rhs, RPP)
   opr%y = lhs%y - real(rhs, RPP)
   opr%z = lhs%z - real(rhs, RPP)
   endfunction vector_sub_I2P

   elemental function I1P_sub_vector(lhs, rhs) result(opr)
   !< Operator `integer(I1P) -`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:1)
   !< pt(1) = 1 * ex_RPP + 2 * ey_RPP + 1 * ez_RPP
   !< pt(0) = 2_I1P - pt(1)
   !< print "(3(F3.1,1X))", pt(0)%x, pt(0)%y, pt(0)%z
   !<```
   !=> 1.0 0.0 1.0 <<<
   integer(I1P),      intent(in) :: lhs !< Left hand side.
   class(vector_RPP), intent(in) :: rhs !< Right hand side.
   type(vector_RPP)              :: opr !< Operator result.

   opr%x = real(lhs, RPP) - rhs%x
   opr%y = real(lhs, RPP) - rhs%y
   opr%z = real(lhs, RPP) - rhs%z
   endfunction I1P_sub_vector

   elemental function vector_sub_I1P(lhs, rhs) result(opr)
   !< Operator `- integer(I1P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(0:1)
   !< pt(1) = 1 * ex_RPP + 2 * ey_RPP + 1 * ez_RPP
   !< pt(0) = pt(1) - 3_I1P
   !< print "(3(F4.1,1X))", pt(0)%x, pt(0)%y, pt(0)%z
   !<```
   !=> -2.0 -1.0 -2.0 <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   integer(I1P),      intent(in) :: rhs !< Right hand side.
   type(vector_RPP)              :: opr !< Operator result.

   opr%x = lhs%x - real(rhs, RPP)
   opr%y = lhs%y - real(rhs, RPP)
   opr%z = lhs%z - real(rhs, RPP)
   endfunction vector_sub_I1P

   ! operator `/=`
   elemental function vector_not_eq_vector(lhs, rhs) result(opr)
   !< Operator `/=`.
   !<
   !< The comparison is done with respect normL2 and, secondary, with respect the directions.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(1:2)
   !< pt(1) = ex_RPP + ey_RPP + ez_RPP
   !< pt(2) = pt(1) + 1
   !< print "(L1)", pt(1) /= pt(2)
   !<```
   !=> T <<<
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(1:2)
   !< pt(1) = ex_RPP + ey_RPP + ez_RPP
   !< pt(2) = ex_RPP + ey_RPP - ez_RPP
   !< print "(L1)", pt(1) /= pt(2)
   !<```
   !=> T <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   type(vector_RPP),  intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< The result of the comparison.
   type(vector_RPP)              :: nl  !< Normalizations of lhs.
   type(vector_RPP)              :: nr  !< Normalizations of rhs.

   opr = (normL2_RPP(lhs) /= normL2_RPP(rhs))
   if (.not.opr) then ! the normL2 are the same, checking the directions
     nl = normalized_RPP(lhs)
     nr = normalized_RPP(rhs)
     opr = ((nl%x /= nr%x) .or. (nl%y /= nr%y) .or. (nl%z /= nr%z))
   endif
   endfunction vector_not_eq_vector

   elemental function R16P_not_eq_vector(lhs, rhs) result(opr)
   !< Operator `real(R16P) /=`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", 1._R16P /= pt
   !<```
   !=> T <<<
   real(R16P),        intent(in) :: lhs !< Left hand side.
   class(vector_RPP), intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (real(lhs, RPP) /= normL2_RPP(rhs))
   endfunction R16P_not_eq_vector

   elemental function vector_not_eq_R16P(lhs, rhs) result(opr)
   !< Operator `/= real(R16P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", pt /= 1._R16P
   !<```
   !=> T <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   real(R16P),        intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (normL2_RPP(lhs) /= real(rhs, RPP))
   endfunction vector_not_eq_R16P

   elemental function R8P_not_eq_vector(lhs, rhs) result(opr)
   !< Operator `real(R8P) /=`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", 1._R8P /= pt
   !<```
   !=> T <<<
   real(R8P),         intent(in) :: lhs !< Left hand side.
   class(vector_RPP), intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (real(lhs, RPP) /= normL2_RPP(rhs))
   endfunction R8P_not_eq_vector

   elemental function vector_not_eq_R8P(lhs, rhs) result(opr)
   !< Operator `/= real(R8P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", pt /= 1._R8P
   !<```
   !=> T <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   real(R8P),         intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (normL2_RPP(lhs) /= real(rhs, RPP))
   endfunction vector_not_eq_R8P

   elemental function R4P_not_eq_vector(lhs, rhs) result(opr)
   !< Operator `real(R4P) /=`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", 1._R4P /= pt
   !<```
   !=> T <<<
   real(R4P),         intent(in) :: lhs !< Left hand side.
   class(vector_RPP), intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (real(lhs, RPP) /= normL2_RPP(rhs))
   endfunction R4P_not_eq_vector

   elemental function vector_not_eq_R4P(lhs, rhs) result(opr)
   !< Operator `/= real(R4P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", pt /= 1._R4P
   !<```
   !=> T <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   real(R4P),         intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (normL2_RPP(lhs) /= real(rhs, RPP))
   endfunction vector_not_eq_R4P

   elemental function I8P_not_eq_vector(lhs, rhs) result(opr)
   !< Operator `integer(I8P) /=`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", 1_I8P /= pt
   !<```
   !=> T <<<
   integer(I8P),      intent(in) :: lhs !< Left hand side.
   class(vector_RPP), intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (real(lhs, RPP) /= normL2_RPP(rhs))
   endfunction I8P_not_eq_vector

   elemental function vector_not_eq_I8P(lhs, rhs) result(opr)
   !< Operator `/= integer(I8P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", pt /= 1_I8P
   !<```
   !=> T <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   integer(I8P),      intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (normL2_RPP(lhs) /= real(rhs, RPP))
   endfunction vector_not_eq_I8P

   elemental function I4P_not_eq_vector(lhs, rhs) result(opr)
   !< Operator `integer(I4P) /=`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", 1_I4P /= pt
   !<```
   !=> T <<<
   integer(I4P),      intent(in) :: lhs !< Left hand side.
   class(vector_RPP), intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (real(lhs, RPP) /= normL2_RPP(rhs))
   endfunction I4P_not_eq_vector

   elemental function vector_not_eq_I4P(lhs, rhs) result(opr)
   !< Operator `/= integer(I4P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", pt /= 1_I4P
   !<```
   !=> T <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   integer(I4P),      intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (normL2_RPP(lhs) /= real(rhs, RPP))
   endfunction vector_not_eq_I4P

   elemental function I2P_not_eq_vector(lhs, rhs) result(opr)
   !< Operator `integer(I2P) /=`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", 1_I2P /= pt
   !<```
   !=> T <<<
   integer(I2P),      intent(in) :: lhs !< Left hand side.
   class(vector_RPP), intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (real(lhs, RPP) /= normL2_RPP(rhs))
   endfunction I2P_not_eq_vector

   elemental function vector_not_eq_I2P(lhs, rhs) result(opr)
   !< Operator `/= integer(I2P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", pt /= 1_I2P
   !<```
   !=> T <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   integer(I2P),      intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (normL2_RPP(lhs) /= real(rhs, RPP))
   endfunction vector_not_eq_I2P

   elemental function I1P_not_eq_vector(lhs, rhs) result(opr)
   !< Operator `integer(I1P) /=`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", 1_I1P /= pt
   !<```
   !=> T <<<
   integer(I1P),      intent(in) :: lhs !< Left hand side.
   class(vector_RPP), intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (real(lhs, RPP) /= normL2_RPP(rhs))
   endfunction I1P_not_eq_vector

   elemental function vector_not_eq_I1P(lhs, rhs) result(opr)
   !< Operator `/= integer(I1P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", pt /= 1_I1P
   !<```
   !=> T <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   integer(I1P),      intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (normL2_RPP(lhs) /= real(rhs, RPP))
   endfunction vector_not_eq_I1P

   ! operator `<`
   elemental function vector_low_vector(lhs, rhs) result(opr)
   !< Operator `<`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(1:2)
   !< pt(1) = ex_RPP + ey_RPP + ez_RPP
   !< pt(2) = pt(1) + 1
   !< print "(L1)", pt(1) < pt(2)
   !<```
   !=> T <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   type(vector_RPP),  intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< The result of the comparison.

   opr = (normL2_RPP(lhs) < normL2_RPP(rhs))
   endfunction vector_low_vector

   elemental function R16P_low_vector(lhs, rhs) result(opr)
   !< Operator `real(R16P) <`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", 1._R16P < pt
   !<```
   !=> T <<<
   real(R16P),        intent(in) :: lhs !< Left hand side.
   class(vector_RPP), intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (real(lhs, RPP) < normL2_RPP(rhs))
   endfunction R16P_low_vector

   elemental function vector_low_R16P(lhs, rhs) result(opr)
   !< Operator `< real(R16P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", pt < 4._R16P
   !<```
   !=> T <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   real(R16P),        intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (normL2_RPP(lhs) < real(rhs, RPP))
   endfunction vector_low_R16P

   elemental function R8P_low_vector(lhs, rhs) result(opr)
   !< Operator `real(R8P) <`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", 1._R8P < pt
   !<```
   !=> T <<<
   real(R8P),         intent(in) :: lhs !< Left hand side.
   class(vector_RPP), intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (real(lhs, RPP) < normL2_RPP(rhs))
   endfunction R8P_low_vector

   elemental function vector_low_R8P(lhs, rhs) result(opr)
   !< Operator `< real(R8P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", pt < 4._R8P
   !<```
   !=> T <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   real(R8P),         intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (normL2_RPP(lhs) < real(rhs, RPP))
   endfunction vector_low_R8P

   elemental function R4P_low_vector(lhs, rhs) result(opr)
   !< Operator `real(R4P) <`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", 1._R4P < pt
   !<```
   !=> T <<<
   real(R4P),         intent(in) :: lhs !< Left hand side.
   class(vector_RPP), intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (real(lhs, RPP) < normL2_RPP(rhs))
   endfunction R4P_low_vector

   elemental function vector_low_R4P(lhs, rhs) result(opr)
   !< Operator `< real(R4P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", pt < 4._R4P
   !<```
   !=> T <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   real(R4P),         intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (normL2_RPP(lhs) < real(rhs, RPP))
   endfunction vector_low_R4P

   elemental function I8P_low_vector(lhs, rhs) result(opr)
   !< Operator `integer(I8P) <`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", 1_I8P < pt
   !<```
   !=> T <<<
   integer(I8P),      intent(in) :: lhs !< Left hand side.
   class(vector_RPP), intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (real(lhs, RPP) < normL2_RPP(rhs))
   endfunction I8P_low_vector

   elemental function vector_low_I8P(lhs, rhs) result(opr)
   !< Operator `< integer(I8P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", pt < 4_I8P
   !<```
   !=> T <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   integer(I8P),      intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (normL2_RPP(lhs) < real(rhs, RPP))
   endfunction vector_low_I8P

   elemental function I4P_low_vector(lhs, rhs) result(opr)
   !< Operator `integer(I4P) <`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", 1_I4P < pt
   !<```
   !=> T <<<
   integer(I4P),      intent(in) :: lhs !< Left hand side.
   class(vector_RPP), intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (real(lhs, RPP) < normL2_RPP(rhs))
   endfunction I4P_low_vector

   elemental function vector_low_I4P(lhs, rhs) result(opr)
   !< Operator `< integer(I4P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", pt < 4_I4P
   !<```
   !=> T <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   integer(I4P),      intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (normL2_RPP(lhs) < real(rhs, RPP))
   endfunction vector_low_I4P

   elemental function I2P_low_vector(lhs, rhs) result(opr)
   !< Operator `integer(I2P) <`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", 1_I2P < pt
   !<```
   !=> T <<<
   integer(I2P),      intent(in) :: lhs !< Left hand side.
   class(vector_RPP), intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (real(lhs, RPP) < normL2_RPP(rhs))
   endfunction I2P_low_vector

   elemental function vector_low_I2P(lhs, rhs) result(opr)
   !< Operator `< integer(I2P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", pt < 4_I2P
   !<```
   !=> T <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   integer(I2P),      intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (normL2_RPP(lhs) < real(rhs, RPP))
   endfunction vector_low_I2P

   elemental function I1P_low_vector(lhs, rhs) result(opr)
   !< Operator `integer(I1P) <`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", 1_I1P < pt
   !<```
   !=> T <<<
   integer(I1P),      intent(in) :: lhs !< Left hand side.
   class(vector_RPP), intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (real(lhs, RPP) < normL2_RPP(rhs))
   endfunction I1P_low_vector

   elemental function vector_low_I1P(lhs, rhs) result(opr)
   !< Operator `< integer(I1P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", pt < 4_I1P
   !<```
   !=> T <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   integer(I1P),      intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (normL2_RPP(lhs) < real(rhs, RPP))
   endfunction vector_low_I1P

   ! operator `<=`
   elemental function vector_low_eq_vector(lhs, rhs) result(opr)
   !< Operator `<=`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(1:2)
   !< pt(1) = ex_RPP + ey_RPP + ez_RPP
   !< pt(2) = pt(1) + 1
   !< print "(L1)", pt(1) <= pt(2)
   !<```
   !=> T <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   type(vector_RPP),  intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< The result of the comparison.

   opr = (normL2_RPP(lhs) <= normL2_RPP(rhs))
   endfunction vector_low_eq_vector

   elemental function R16P_low_eq_vector(lhs, rhs) result(opr)
   !< Operator `real(R16P) <=`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", 1._R16P <= pt
   !<```
   !=> T <<<
   real(R16P),        intent(in) :: lhs !< Left hand side.
   class(vector_RPP), intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (real(lhs, RPP) <= normL2_RPP(rhs))
   endfunction R16P_low_eq_vector

   elemental function vector_low_eq_R16P(lhs, rhs) result(opr)
   !< Operator `<= real(R16P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", pt <= 4._R16P
   !<```
   !=> T <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   real(R16P),        intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (normL2_RPP(lhs) <= real(rhs, RPP))
   endfunction vector_low_eq_R16P

   elemental function R8P_low_eq_vector(lhs, rhs) result(opr)
   !< Operator `real(R8P) <=`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", 1._R8P <= pt
   !<```
   !=> T <<<
   real(R8P),         intent(in) :: lhs !< Left hand side.
   class(vector_RPP), intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (real(lhs, RPP) <= normL2_RPP(rhs))
   endfunction R8P_low_eq_vector

   elemental function vector_low_eq_R8P(lhs, rhs) result(opr)
   !< Operator `<= real(R8P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", pt <= 4._R8P
   !<```
   !=> T <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   real(R8P),         intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (normL2_RPP(lhs) <= real(rhs, RPP))
   endfunction vector_low_eq_R8P

   elemental function R4P_low_eq_vector(lhs, rhs) result(opr)
   !< Operator `real(R4P) <=`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", 1._R4P <= pt
   !<```
   !=> T <<<
   real(R4P),         intent(in) :: lhs !< Left hand side.
   class(vector_RPP), intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (real(lhs, RPP) <= normL2_RPP(rhs))
   endfunction R4P_low_eq_vector

   elemental function vector_low_eq_R4P(lhs, rhs) result(opr)
   !< Operator `<= real(R4P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", pt <= 4._R4P
   !<```
   !=> T <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   real(R4P),         intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (normL2_RPP(lhs) <= real(rhs, RPP))
   endfunction vector_low_eq_R4P

   elemental function I8P_low_eq_vector(lhs, rhs) result(opr)
   !< Operator `integer(I8P) <=`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", 1_I8P <= pt
   !<```
   !=> T <<<
   integer(I8P),      intent(in) :: lhs !< Left hand side.
   class(vector_RPP), intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (real(lhs, RPP) <= normL2_RPP(rhs))
   endfunction I8P_low_eq_vector

   elemental function vector_low_eq_I8P(lhs, rhs) result(opr)
   !< Operator `<= integer(I8P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", pt <= 4_I8P
   !<```
   !=> T <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   integer(I8P),      intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (normL2_RPP(lhs) <= real(rhs, RPP))
   endfunction vector_low_eq_I8P

   elemental function I4P_low_eq_vector(lhs, rhs) result(opr)
   !< Operator `integer(I4P) <=`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", 1_I4P <= pt
   !<```
   !=> T <<<
   integer(I4P),      intent(in) :: lhs !< Left hand side.
   class(vector_RPP), intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (real(lhs, RPP) <= normL2_RPP(rhs))
   endfunction I4P_low_eq_vector

   elemental function vector_low_eq_I4P(lhs, rhs) result(opr)
   !< Operator `<= integer(I4P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", pt <= 4_I4P
   !<```
   !=> T <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   integer(I4P),      intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (normL2_RPP(lhs) <= real(rhs, RPP))
   endfunction vector_low_eq_I4P

   elemental function I2P_low_eq_vector(lhs, rhs) result(opr)
   !< Operator `integer(I2P) <=`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", 1_I2P <= pt
   !<```
   !=> T <<<
   integer(I2P),      intent(in) :: lhs !< Left hand side.
   class(vector_RPP), intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (real(lhs, RPP) <= normL2_RPP(rhs))
   endfunction I2P_low_eq_vector

   elemental function vector_low_eq_I2P(lhs, rhs) result(opr)
   !< Operator `<= integer(I2P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", pt <= 4_I2P
   !<```
   !=> T <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   integer(I2P),      intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (normL2_RPP(lhs) <= real(rhs, RPP))
   endfunction vector_low_eq_I2P

   elemental function I1P_low_eq_vector(lhs, rhs) result(opr)
   !< Operator `integer(I1P) <=`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", 1_I1P <= pt
   !<```
   !=> T <<<
   integer(I1P),      intent(in) :: lhs !< Left hand side.
   class(vector_RPP), intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (real(lhs, RPP) <= normL2_RPP(rhs))
   endfunction I1P_low_eq_vector

   elemental function vector_low_eq_I1P(lhs, rhs) result(opr)
   !< Operator `<= integer(I1P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", pt <= 4_I1P
   !<```
   !=> T <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   integer(I1P),      intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (normL2_RPP(lhs) <= real(rhs, RPP))
   endfunction vector_low_eq_I1P

   ! operator `==`
   elemental function vector_eq_vector(lhs, rhs) result(opr)
   !< Operator `==`.
   !<
   !< The comparison is done with respect normL2 and, secondary, with respect the directions.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(1:2)
   !< pt(1) = ex_RPP + ey_RPP + ez_RPP
   !< pt(2) = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", pt(1) == pt(2)
   !<```
   !=> T <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   type(vector_RPP),  intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< The result of the comparison.
   type(vector_RPP)              :: nl  !< Normalizations of lhs.
   type(vector_RPP)              :: nr  !< Normalizations of rhs.

   opr = (normL2_RPP(lhs) == normL2_RPP(rhs))
  if (opr) then ! the normL2 are the same, checking the directions
    nl = normalized_RPP(lhs)
    nr = normalized_RPP(rhs)
    opr = ((nl%x == nr%x) .and. (nl%y == nr%y) .and. (nl%z == nr%z))
  endif
   endfunction vector_eq_vector

   elemental function R16P_eq_vector(lhs, rhs) result(opr)
   !< Operator `real(R16P) ==`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = 4 * ex_RPP + 3 * ey_RPP
   !< print "(L1)", 5._R16P == pt
   !<```
   !=> T <<<
   real(R16P),        intent(in) :: lhs !< Left hand side.
   class(vector_RPP), intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (real(lhs, RPP) == normL2_RPP(rhs))
   endfunction R16P_eq_vector

   elemental function vector_eq_R16P(lhs, rhs) result(opr)
   !< Operator `== real(R16P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = 4 * ex_RPP + 3 * ey_RPP
   !< print "(L1)", pt == 5._R16P
   !<```
   !=> T <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   real(R16P),        intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (normL2_RPP(lhs) == real(rhs, RPP))
   endfunction vector_eq_R16P

   elemental function R8P_eq_vector(lhs, rhs) result(opr)
   !< Operator `real(R8P) ==`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = 4 * ex_RPP + 3 * ey_RPP
   !< print "(L1)", 5._R8P == pt
   !<```
   !=> T <<<
   real(R8P),         intent(in) :: lhs !< Left hand side.
   class(vector_RPP), intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (real(lhs, RPP) == normL2_RPP(rhs))
   endfunction R8P_eq_vector

   elemental function vector_eq_R8P(lhs, rhs) result(opr)
   !< Operator `== real(R8P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = 4 * ex_RPP + 3 * ey_RPP
   !< print "(L1)", pt == 5._R8P
   !<```
   !=> T <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   real(R8P),         intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (normL2_RPP(lhs) == real(rhs, RPP))
   endfunction vector_eq_R8P

   elemental function R4P_eq_vector(lhs, rhs) result(opr)
   !< Operator `real(R4P) ==`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = 4 * ex_RPP + 3 * ey_RPP
   !< print "(L1)", 5._R4P == pt
   !<```
   !=> T <<<
   real(R4P),         intent(in) :: lhs !< Left hand side.
   class(vector_RPP), intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (real(lhs, RPP) == normL2_RPP(rhs))
   endfunction R4P_eq_vector

   elemental function vector_eq_R4P(lhs, rhs) result(opr)
   !< Operator `== real(R4P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = 4 * ex_RPP + 3 * ey_RPP
   !< print "(L1)", pt == 5._R4P
   !<```
   !=> T <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   real(R4P),         intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (normL2_RPP(lhs) == real(rhs, RPP))
   endfunction vector_eq_R4P

   elemental function I8P_eq_vector(lhs, rhs) result(opr)
   !< Operator `integer(I8P) ==`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = 4 * ex_RPP + 3 * ey_RPP
   !< print "(L1)", 5_I8P == pt
   !<```
   !=> T <<<
   integer(I8P),      intent(in) :: lhs !< Left hand side.
   class(vector_RPP), intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (real(lhs, RPP) == normL2_RPP(rhs))
   endfunction I8P_eq_vector

   elemental function vector_eq_I8P(lhs, rhs) result(opr)
   !< Operator `== integer(I8P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = 4 * ex_RPP + 3 * ey_RPP
   !< print "(L1)", pt == 5_I8P
   !<```
   !=> T <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   integer(I8P),      intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (normL2_RPP(lhs) == real(rhs, RPP))
   endfunction vector_eq_I8P

   elemental function I4P_eq_vector(lhs, rhs) result(opr)
   !< Operator `integer(I4P) ==`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = 4 * ex_RPP + 3 * ey_RPP
   !< print "(L1)", 5_I4P == pt
   !<```
   !=> T <<<
   integer(I4P),      intent(in) :: lhs !< Left hand side.
   class(vector_RPP), intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (real(lhs, RPP) == normL2_RPP(rhs))
   endfunction I4P_eq_vector

   elemental function vector_eq_I4P(lhs, rhs) result(opr)
   !< Operator `== integer(I4P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = 4 * ex_RPP + 3 * ey_RPP
   !< print "(L1)", pt == 5_I4P
   !<```
   !=> T <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   integer(I4P),      intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (normL2_RPP(lhs) == real(rhs, RPP))
   endfunction vector_eq_I4P

   elemental function I2P_eq_vector(lhs, rhs) result(opr)
   !< Operator `integer(I2P) ==`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = 4 * ex_RPP + 3 * ey_RPP
   !< print "(L1)", 5_I2P == pt
   !<```
   !=> T <<<
   integer(I2P),      intent(in) :: lhs !< Left hand side.
   class(vector_RPP), intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (real(lhs, RPP) == normL2_RPP(rhs))
   endfunction I2P_eq_vector

   elemental function vector_eq_I2P(lhs, rhs) result(opr)
   !< Operator `== integer(I2P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = 4 * ex_RPP + 3 * ey_RPP
   !< print "(L1)", pt == 5_I2P
   !<```
   !=> T <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   integer(I2P),      intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (normL2_RPP(lhs) == real(rhs, RPP))
   endfunction vector_eq_I2P

   elemental function I1P_eq_vector(lhs, rhs) result(opr)
   !< Operator `integer(I1P) ==`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = 4 * ex_RPP + 3 * ey_RPP
   !< print "(L1)", 5_I1P == pt
   !<```
   !=> T <<<
   integer(I1P),      intent(in) :: lhs !< Left hand side.
   class(vector_RPP), intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (real(lhs, RPP) == normL2_RPP(rhs))
   endfunction I1P_eq_vector

   elemental function vector_eq_I1P(lhs, rhs) result(opr)
   !< Operator `== integer(I1P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = 4 * ex_RPP + 3 * ey_RPP
   !< print "(L1)", pt == 5_I1P
   !<```
   !=> T <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   integer(I1P),      intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (normL2_RPP(lhs) == real(rhs, RPP))
   endfunction vector_eq_I1P

   ! operator `>=`
   elemental function vector_great_eq_vector(lhs, rhs) result(opr)
   !< Operator `>=`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(1:2)
   !< pt(1) = ex_RPP + ey_RPP + ez_RPP
   !< pt(2) = pt(1) + 1
   !< print "(L1)", pt(2) >= pt(1)
   !<```
   !=> T <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   type(vector_RPP),  intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< The result of the comparison.

   opr = (normL2_RPP(lhs) >= normL2_RPP(rhs))
   endfunction vector_great_eq_vector

   elemental function R16P_great_eq_vector(lhs, rhs) result(opr)
   !< Operator `real(R16P) >=`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", 4._R16P >= pt
   !<```
   !=> T <<<
   real(R16P),        intent(in) :: lhs !< Left hand side.
   class(vector_RPP), intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (real(lhs, RPP) >= normL2_RPP(rhs))
   endfunction R16P_great_eq_vector

   elemental function vector_great_eq_R16P(lhs, rhs) result(opr)
   !< Operator `>= real(R16P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", pt >= 1._R16P
   !<```
   !=> T <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   real(R16P),        intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (normL2_RPP(lhs) >= real(rhs, RPP))
   endfunction vector_great_eq_R16P

   elemental function R8P_great_eq_vector(lhs, rhs) result(opr)
   !< Operator `real(R8P) >=`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", 4._R8P >= pt
   !<```
   !=> T <<<
   real(R8P),         intent(in) :: lhs !< Left hand side.
   class(vector_RPP), intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (real(lhs, RPP) >= normL2_RPP(rhs))
   endfunction R8P_great_eq_vector

   elemental function vector_great_eq_R8P(lhs, rhs) result(opr)
   !< Operator `>= real(R8P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", pt >= 1._R8P
   !<```
   !=> T <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   real(R8P),         intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (normL2_RPP(lhs) >= real(rhs, RPP))
   endfunction vector_great_eq_R8P

   elemental function R4P_great_eq_vector(lhs, rhs) result(opr)
   !< Operator `real(R4P) >=`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", 4._R4P >= pt
   !<```
   !=> T <<<
   real(R4P),         intent(in) :: lhs !< Left hand side.
   class(vector_RPP), intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (real(lhs, RPP) >= normL2_RPP(rhs))
   endfunction R4P_great_eq_vector

   elemental function vector_great_eq_R4P(lhs, rhs) result(opr)
   !< Operator `>= real(R4P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", pt >= 1._R4P
   !<```
   !=> T <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   real(R4P),         intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (normL2_RPP(lhs) >= real(rhs, RPP))
   endfunction vector_great_eq_R4P

   elemental function I8P_great_eq_vector(lhs, rhs) result(opr)
   !< Operator `integer(I8P) >=`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", 4_I8P >= pt
   !<```
   !=> T <<<
   integer(I8P),      intent(in) :: lhs !< Left hand side.
   class(vector_RPP), intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (real(lhs, RPP) >= normL2_RPP(rhs))
   endfunction I8P_great_eq_vector

   elemental function vector_great_eq_I8P(lhs, rhs) result(opr)
   !< Operator `>= integer(I8P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", pt >= 1_I8P
   !<```
   !=> T <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   integer(I8P),      intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (normL2_RPP(lhs) >= real(rhs, RPP))
   endfunction vector_great_eq_I8P

   elemental function I4P_great_eq_vector(lhs, rhs) result(opr)
   !< Operator `integer(I4P) >=`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", 4_I4P >= pt
   !<```
   !=> T <<<
   integer(I4P),      intent(in) :: lhs !< Left hand side.
   class(vector_RPP), intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (real(lhs, RPP) >= normL2_RPP(rhs))
   endfunction I4P_great_eq_vector

   elemental function vector_great_eq_I4P(lhs, rhs) result(opr)
   !< Operator `>= integer(I4P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", pt >= 1_I4P
   !<```
   !=> T <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   integer(I4P),      intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (normL2_RPP(lhs) >= real(rhs, RPP))
   endfunction vector_great_eq_I4P

   elemental function I2P_great_eq_vector(lhs, rhs) result(opr)
   !< Operator `integer(I2P) >=`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", 4_I2P >= pt
   !<```
   !=> T <<<
   integer(I2P),      intent(in) :: lhs !< Left hand side.
   class(vector_RPP), intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (real(lhs, RPP) >= normL2_RPP(rhs))
   endfunction I2P_great_eq_vector

   elemental function vector_great_eq_I2P(lhs, rhs) result(opr)
   !< Operator `>= integer(I2P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", pt >= 1_I2P
   !<```
   !=> T <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   integer(I2P),      intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (normL2_RPP(lhs) >= real(rhs, RPP))
   endfunction vector_great_eq_I2P

   elemental function I1P_great_eq_vector(lhs, rhs) result(opr)
   !< Operator `integer(I1P) >=`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", 4_I1P >= pt
   !<```
   !=> T <<<
   integer(I1P),      intent(in) :: lhs !< Left hand side.
   class(vector_RPP), intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (real(lhs, RPP) >= normL2_RPP(rhs))
   endfunction I1P_great_eq_vector

   elemental function vector_great_eq_I1P(lhs, rhs) result(opr)
   !< Operator `>= integer(I1P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", pt >= 1_I1P
   !<```
   !=> T <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   integer(I1P),      intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (normL2_RPP(lhs) >= real(rhs, RPP))
   endfunction vector_great_eq_I1P

   ! operator `>`
   elemental function vector_great_vector(lhs, rhs) result(opr)
   !< Operator `>`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt(1:2)
   !< pt(1) = ex_RPP + ey_RPP + ez_RPP
   !< pt(2) = pt(1) + 1
   !< print "(L1)", pt(2) > pt(1)
   !<```
   !=> T <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   type(vector_RPP),  intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< The result of the comparison.

   opr = (normL2_RPP(lhs) > normL2_RPP(rhs))
   endfunction vector_great_vector

   elemental function R16P_great_vector(lhs, rhs) result(opr)
   !< Operator `real(R16P) >`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", 4._R16P > pt
   !<```
   !=> T <<<
   real(R16P),        intent(in) :: lhs !< Left hand side.
   class(vector_RPP), intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (real(lhs, RPP) > normL2_RPP(rhs))
   endfunction R16P_great_vector

   elemental function vector_great_R16P(lhs, rhs) result(opr)
   !< Operator `> real(R16P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", pt > 1._R16P
   !<```
   !=> T <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   real(R16P),        intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (normL2_RPP(lhs) > real(rhs, RPP))
   endfunction vector_great_R16P

   elemental function R8P_great_vector(lhs, rhs) result(opr)
   !< Operator `real(R8P) >`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", 4._R8P > pt
   !<```
   !=> T <<<
   real(R8P),         intent(in) :: lhs !< Left hand side.
   class(vector_RPP), intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (real(lhs, RPP) > normL2_RPP(rhs))
   endfunction R8P_great_vector

   elemental function vector_great_R8P(lhs, rhs) result(opr)
   !< Operator `> real(R8P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", pt > 1._R8P
   !<```
   !=> T <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   real(R8P),         intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (normL2_RPP(lhs) > real(rhs, RPP))
   endfunction vector_great_R8P

   elemental function R4P_great_vector(lhs, rhs) result(opr)
   !< Operator `real(R4P) >`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", 4._R4P > pt
   !<```
   !=> T <<<
   real(R4P),         intent(in) :: lhs !< Left hand side.
   class(vector_RPP), intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (real(lhs, RPP) > normL2_RPP(rhs))
   endfunction R4P_great_vector

   elemental function vector_great_R4P(lhs, rhs) result(opr)
   !< Operator `> real(R4P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", pt > 1._R4P
   !<```
   !=> T <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   real(R4P),         intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (normL2_RPP(lhs) > real(rhs, RPP))
   endfunction vector_great_R4P

   elemental function I8P_great_vector(lhs, rhs) result(opr)
   !< Operator `integer(I8P) >`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", 4_I8P > pt
   !<```
   !=> T <<<
   integer(I8P),      intent(in) :: lhs !< Left hand side.
   class(vector_RPP), intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (real(lhs, RPP) > normL2_RPP(rhs))
   endfunction I8P_great_vector

   elemental function vector_great_I8P(lhs, rhs) result(opr)
   !< Operator `> integer(I8P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", pt > 1_I8P
   !<```
   !=> T <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   integer(I8P),      intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (normL2_RPP(lhs) > real(rhs, RPP))
   endfunction vector_great_I8P

   elemental function I4P_great_vector(lhs, rhs) result(opr)
   !< Operator `integer(I4P) >`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", 4_I4P > pt
   !<```
   !=> T <<<
   integer(I4P),      intent(in) :: lhs !< Left hand side.
   class(vector_RPP), intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (real(lhs, RPP) > normL2_RPP(rhs))
   endfunction I4P_great_vector

   elemental function vector_great_I4P(lhs, rhs) result(opr)
   !< Operator `> integer(I4P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", pt > 1_I4P
   !<```
   !=> T <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   integer(I4P),      intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (normL2_RPP(lhs) > real(rhs, RPP))
   endfunction vector_great_I4P

   elemental function I2P_great_vector(lhs, rhs) result(opr)
   !< Operator `integer(I2P) >`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", 4_I2P > pt
   !<```
   !=> T <<<
   integer(I2P),      intent(in) :: lhs !< Left hand side.
   class(vector_RPP), intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (real(lhs, RPP) > normL2_RPP(rhs))
   endfunction I2P_great_vector

   elemental function vector_great_I2P(lhs, rhs) result(opr)
   !< Operator `> integer(I2P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", pt > 1_I2P
   !<```
   !=> T <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   integer(I2P),      intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (normL2_RPP(lhs) > real(rhs, RPP))
   endfunction vector_great_I2P

   elemental function I1P_great_vector(lhs, rhs) result(opr)
   !< Operator `integer(I1P) >`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", 4_I1P > pt
   !<```
   !=> T <<<
   integer(I1P),      intent(in) :: lhs !< Left hand side.
   class(vector_RPP), intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (real(lhs, RPP) > normL2_RPP(rhs))
   endfunction I1P_great_vector

   elemental function vector_great_I1P(lhs, rhs) result(opr)
   !< Operator `> integer(I1P)`.
   !<
   !<```fortran
   !< type(vector_RPP) :: pt
   !< pt = ex_RPP + ey_RPP + ez_RPP
   !< print "(L1)", pt > 1_I1P
   !<```
   !=> T <<<
   class(vector_RPP), intent(in) :: lhs !< Left hand side.
   integer(I1P),      intent(in) :: rhs !< Right hand side.
   logical                       :: opr !< Operator result.

   opr = (normL2_RPP(lhs) > real(rhs, RPP))
   endfunction vector_great_I1P
