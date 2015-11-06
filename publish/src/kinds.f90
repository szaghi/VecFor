!< Kinds regression test for VecFor library.
program kinds
!< Kinds regression test for VecFor library.
!<
!< Try to test the algebra of mixed vector/numbers for all supported kinds.
use vecfor
implicit none
#ifdef r16p
integer,       parameter :: R16P     = selected_real_kind(33,4931) !< 33  digits, range \([10^{-4931}, 10^{+4931} - 1]\); 128 bits.
#else
integer,       parameter :: R16P     = selected_real_kind(15,307)  !< Defined as R8P; 64 bits.
#endif
integer,       parameter :: R8P      = selected_real_kind(15,307)  !< 15  digits, range \([10^{-307} , 10^{+307}  - 1]\); 64 bits.
integer,       parameter :: R4P      = selected_real_kind(6,37)    !< 6   digits, range \([10^{-37}  , 10^{+37}   - 1]\); 32 bits.
integer,       parameter :: I8P      = selected_int_kind(18)       !< Range \([-2^{63},+2^{63} - 1]\), 19 digits plus sign; 64 bits.
integer,       parameter :: I4P      = selected_int_kind(9)        !< Range \([-2^{31},+2^{31} - 1]\), 10 digits plus sign; 32 bits.
integer,       parameter :: I2P      = selected_int_kind(4)        !< Range \([-2^{15},+2^{15} - 1]\), 5  digits plus sign; 16 bits.
integer,       parameter :: I1P      = selected_int_kind(2)        !< Range \([-2^{7} ,+2^{7}  - 1]\), 3  digits plus sign; 8  bits.
type(vector)             :: vector1                                !< Vector dummy variable.
type(vector)             :: vector2                                !< Vector dummy variable.
type(vector)             :: vector3                                !< Vector dummy variable.

call vector1%set(x=-1._R8P, y=-1._R8P, z=-1._R8P)
call vector1%init()
print "(A)", ' Assign vector1 = [1, 2, 3]'
vector1 = 1 * ex + 2 * ey + 3 * ez
print "(A)", ' Assign vector2 = [1, 1, 1] testing assignments by scalar'
vector2 = 1._R16P
vector2 = 1._R8P
vector2 = 1._R4P
vector2 = 1_I8P
vector2 = 1_I4P
vector2 = 1_I2P
vector2 = 1_I1P
print "(A)", ' Verify * operator, multiply by 1 defined in any supported number formats'
vector1 = 1._R16P * vector1
vector1 = 1._R8P * vector1
vector1 = 1._R4P * vector1
vector1 = 1_I8P * vector1
vector1 = 1_I4P * vector1
vector1 = 1_I2P * vector1
vector1 = 1_I1P * vector1
vector1 = vector1 * 1._R16P
vector1 = vector1 * 1._R8P
vector1 = vector1 * 1._R4P
vector1 = vector1 * 1_I8P
vector1 = vector1 * 1_I4P
vector1 = vector1 * 1_I2P
vector1 = vector1 * 1_I1P
call vector1%print
print "(A)", ' Verify * operator between vectors, vector1 * vector2'
vector1 = vector1 * vector2
call vector1%print
print "(A)", ' Verify / operator, diveded by 1 defined in any supported number formats'
vector1 = vector1 / 1._R16P
vector1 = vector1 / 1._R8P
vector1 = vector1 / 1._R4P
vector1 = vector1 / 1_I8P
vector1 = vector1 / 1_I4P
vector1 = vector1 / 1_I2P
vector1 = vector1 / 1_I1P
call vector1%print
print "(A)", ' Verify / operator between vectors, vector1 / vector2'
vector1 = vector1 / vector2
call vector1%print
print "(A)", ' Verify + operator, add 1 (14 times) defined in any supported number formats'
vector1 = 1._R16P + vector1
vector1 = 1._R8P + vector1
vector1 = 1._R4P + vector1
vector1 = 1_I8P + vector1
vector1 = 1_I4P + vector1
vector1 = 1_I2P + vector1
vector1 = 1_I1P + vector1
vector1 = + vector1
vector1 = vector1 + 1._R16P
vector1 = vector1 + 1._R8P
vector1 = vector1 + 1._R4P
vector1 = vector1 + 1_I8P
vector1 = vector1 + 1_I4P
vector1 = vector1 + 1_I2P
vector1 = vector1 + 1_I1P
call vector1%print
print "(A)", ' Verify + operator between vectors, vector1 + vector2'
vector1 = vector1 + vector2
call vector1%print
print "(A)", ' Verify - operator, subtract 1 (14 times) defined in any supported number formats'
vector1 = 1._R16P - vector1
vector1 =-1._R8P - vector1
vector1 = 1._R4P - vector1
vector1 =-1_I8P - vector1
vector1 = 1_I4P - vector1
vector1 =-1_I2P - vector1
vector1 = 1_I1P - vector1
vector1 = - vector1
vector1 = vector1 - 1._R16P
vector1 = vector1 - 1._R8P
vector1 = vector1 - 1._R4P
vector1 = vector1 - 1_I8P
vector1 = vector1 - 1_I4P
vector1 = vector1 - 1_I2P
vector1 = vector1 - 1_I1P
call vector1%print
print "(A)", ' Verify - operator between vectors, vector1 - vector2'
vector1 = vector1 - vector2
call vector1%print
print "(A)", ' Verify save/load methods'
open(unit=2, form='UNFORMATTED', status='SCRATCH')
call vector1%save(unit=2)
rewind(unit=2)
call vector3%load(unit=2)
close(unit=2)
call vector3%print
vector3 = 0
print "(A)", ' Verify save/load methods with stream-accessed file'
open(unit=2, form='UNFORMATTED', status='SCRATCH', access='STREAM')
call vector1%save(unit=2, pos=1_I8P)
rewind(unit=2)
call vector3%load(unit=2, pos=1_I8P)
close(unit=2)
call vector3%print
print "(A)", ' Verify < operator, compare with 1 (and vector2) defined in any supported number formats'
print "(A,L1)", 'vector1<1._R16P => ', (vector1<1._R16P)
print "(A,L1)", 'vector1<1._R8P  => ', (vector1<1._R8P )
print "(A,L1)", 'vector1<1._R4P  => ', (vector1<1._R4P )
print "(A,L1)", 'vector1<1_I8P   => ', (vector1<1_I8P  )
print "(A,L1)", 'vector1<1_I4P   => ', (vector1<1_I4P  )
print "(A,L1)", 'vector1<1_I2P   => ', (vector1<1_I2P  )
print "(A,L1)", 'vector1<1_I1P   => ', (vector1<1_I1P  )
print "(A,L1)", '1._R16P<vector1 => ', (1._R16P<vector1)
print "(A,L1)", '1._R8P <vector1 => ', (1._R8P <vector1)
print "(A,L1)", '1._R4P <vector1 => ', (1._R4P <vector1)
print "(A,L1)", '1_I8P  <vector1 => ', (1_I8P  <vector1)
print "(A,L1)", '1_I4P  <vector1 => ', (1_I4P  <vector1)
print "(A,L1)", '1_I2P  <vector1 => ', (1_I2P  <vector1)
print "(A,L1)", '1_I1P  <vector1 => ', (1_I1P  <vector1)
print "(A,L1)", 'vector1<vector2 => ', (vector1<vector2)
print "(A)", ' Verify <= operator, compare with 1 (and vector2) defined in any supported number formats'
print "(A,L1)", 'vector1<=1._R16P => ', (vector1<=1._R16P)
print "(A,L1)", 'vector1<=1._R8P  => ', (vector1<=1._R8P )
print "(A,L1)", 'vector1<=1._R4P  => ', (vector1<=1._R4P )
print "(A,L1)", 'vector1<=1_I8P   => ', (vector1<=1_I8P  )
print "(A,L1)", 'vector1<=1_I4P   => ', (vector1<=1_I4P  )
print "(A,L1)", 'vector1<=1_I2P   => ', (vector1<=1_I2P  )
print "(A,L1)", 'vector1<=1_I1P   => ', (vector1<=1_I1P  )
print "(A,L1)", '1._R16P<=vector1 => ', (1._R16P<=vector1)
print "(A,L1)", '1._R8P <=vector1 => ', (1._R8P <=vector1)
print "(A,L1)", '1._R4P <=vector1 => ', (1._R4P <=vector1)
print "(A,L1)", '1_I8P  <=vector1 => ', (1_I8P  <=vector1)
print "(A,L1)", '1_I4P  <=vector1 => ', (1_I4P  <=vector1)
print "(A,L1)", '1_I2P  <=vector1 => ', (1_I2P  <=vector1)
print "(A,L1)", '1_I1P  <=vector1 => ', (1_I1P  <=vector1)
print "(A,L1)", 'vector1<=vector2 => ', (vector1<=vector2)
print "(A)", ' Verify == operator, compare with 1 (and vector2) defined in any supported number formats'
print "(A,L1)", 'vector1==1._R16P => ', (vector1==1._R16P)
print "(A,L1)", 'vector1==1._R8P  => ', (vector1==1._R8P )
print "(A,L1)", 'vector1==1._R4P  => ', (vector1==1._R4P )
print "(A,L1)", 'vector1==1_I8P   => ', (vector1==1_I8P  )
print "(A,L1)", 'vector1==1_I4P   => ', (vector1==1_I4P  )
print "(A,L1)", 'vector1==1_I2P   => ', (vector1==1_I2P  )
print "(A,L1)", 'vector1==1_I1P   => ', (vector1==1_I1P  )
print "(A,L1)", '1._R16P==vector1 => ', (1._R16P==vector1)
print "(A,L1)", '1._R8P ==vector1 => ', (1._R8P ==vector1)
print "(A,L1)", '1._R4P ==vector1 => ', (1._R4P ==vector1)
print "(A,L1)", '1_I8P  ==vector1 => ', (1_I8P  ==vector1)
print "(A,L1)", '1_I4P  ==vector1 => ', (1_I4P  ==vector1)
print "(A,L1)", '1_I2P  ==vector1 => ', (1_I2P  ==vector1)
print "(A,L1)", '1_I1P  ==vector1 => ', (1_I1P  ==vector1)
print "(A,L1)", 'vector1==vector2 => ', (vector1==vector2)
print "(A,L1)", 'vector1==-vector1 => ', (vector1==-vector1)
print "(A)", ' Verify /= operator, compare with 1 (and vector2) defined in any supported number formats'
print "(A,L1)", 'vector1/=1._R16P => ', (vector1/=1._R16P)
print "(A,L1)", 'vector1/=1._R8P  => ', (vector1/=1._R8P )
print "(A,L1)", 'vector1/=1._R4P  => ', (vector1/=1._R4P )
print "(A,L1)", 'vector1/=1_I8P   => ', (vector1/=1_I8P  )
print "(A,L1)", 'vector1/=1_I4P   => ', (vector1/=1_I4P  )
print "(A,L1)", 'vector1/=1_I2P   => ', (vector1/=1_I2P  )
print "(A,L1)", 'vector1/=1_I1P   => ', (vector1/=1_I1P  )
print "(A,L1)", '1._R16P/=vector1 => ', (1._R16P/=vector1)
print "(A,L1)", '1._R8P /=vector1 => ', (1._R8P /=vector1)
print "(A,L1)", '1._R4P /=vector1 => ', (1._R4P /=vector1)
print "(A,L1)", '1_I8P  /=vector1 => ', (1_I8P  /=vector1)
print "(A,L1)", '1_I4P  /=vector1 => ', (1_I4P  /=vector1)
print "(A,L1)", '1_I2P  /=vector1 => ', (1_I2P  /=vector1)
print "(A,L1)", '1_I1P  /=vector1 => ', (1_I1P  /=vector1)
print "(A,L1)", 'vector1/=vector2 => ', (vector1/=vector2)
print "(A,L1)", 'vector1/=-vector1 => ', (vector1/=-vector1)
print "(A)", ' Verify >= operator, compare with 1 (and vector2) defined in any supported number formats'
print "(A,L1)", 'vector1>=1._R16P => ', (vector1>=1._R16P)
print "(A,L1)", 'vector1>=1._R8P  => ', (vector1>=1._R8P )
print "(A,L1)", 'vector1>=1._R4P  => ', (vector1>=1._R4P )
print "(A,L1)", 'vector1>=1_I8P   => ', (vector1>=1_I8P  )
print "(A,L1)", 'vector1>=1_I4P   => ', (vector1>=1_I4P  )
print "(A,L1)", 'vector1>=1_I2P   => ', (vector1>=1_I2P  )
print "(A,L1)", 'vector1>=1_I1P   => ', (vector1>=1_I1P  )
print "(A,L1)", '1._R16P>=vector1 => ', (1._R16P>=vector1)
print "(A,L1)", '1._R8P >=vector1 => ', (1._R8P >=vector1)
print "(A,L1)", '1._R4P >=vector1 => ', (1._R4P >=vector1)
print "(A,L1)", '1_I8P  >=vector1 => ', (1_I8P  >=vector1)
print "(A,L1)", '1_I4P  >=vector1 => ', (1_I4P  >=vector1)
print "(A,L1)", '1_I2P  >=vector1 => ', (1_I2P  >=vector1)
print "(A,L1)", '1_I1P  >=vector1 => ', (1_I1P  >=vector1)
print "(A,L1)", 'vector1>=vector2 => ', (vector1>=vector2)
print "(A)", ' Verify > operator, compare with 1 (and vector2) defined in any supported number formats'
print "(A,L1)", 'vector1>1._R16P => ', (vector1>1._R16P)
print "(A,L1)", 'vector1>1._R8P  => ', (vector1>1._R8P )
print "(A,L1)", 'vector1>1._R4P  => ', (vector1>1._R4P )
print "(A,L1)", 'vector1>1_I8P   => ', (vector1>1_I8P  )
print "(A,L1)", 'vector1>1_I4P   => ', (vector1>1_I4P  )
print "(A,L1)", 'vector1>1_I2P   => ', (vector1>1_I2P  )
print "(A,L1)", 'vector1>1_I1P   => ', (vector1>1_I1P  )
print "(A,L1)", '1._R16P>vector1 => ', (1._R16P>vector1)
print "(A,L1)", '1._R8P >vector1 => ', (1._R8P >vector1)
print "(A,L1)", '1._R4P >vector1 => ', (1._R4P >vector1)
print "(A,L1)", '1_I8P  >vector1 => ', (1_I8P  >vector1)
print "(A,L1)", '1_I4P  >vector1 => ', (1_I4P  >vector1)
print "(A,L1)", '1_I2P  >vector1 => ', (1_I2P  >vector1)
print "(A,L1)", '1_I1P  >vector1 => ', (1_I1P  >vector1)
print "(A,L1)", 'vector1>vector2 => ', (vector1>vector2)

stop
endprogram kinds
