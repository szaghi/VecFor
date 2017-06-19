!< Kinds regression test for VecFor library.
program kinds
!< Kinds regression test for VecFor library.
!<
!< Try to test the algebra of mixed vector/numbers for all supported kinds.
use penf
use vecfor

implicit none

type(vector) :: vector1 !< Vector dummy variable.
type(vector) :: vector2 !< Vector dummy variable.
type(vector) :: vector3 !< Vector dummy variable.

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
call vector1%printf
print "(A)", ' Verify * operator between vectors, vector1 * vector2'
vector1 = vector1 * vector2
call vector1%printf
print "(A)", ' Verify / operator, diveded by 1 defined in any supported number formats'
vector1 = vector1 / 1._R16P
vector1 = vector1 / 1._R8P
vector1 = vector1 / 1._R4P
vector1 = vector1 / 1_I8P
vector1 = vector1 / 1_I4P
vector1 = vector1 / 1_I2P
vector1 = vector1 / 1_I1P
call vector1%printf
print "(A)", ' Verify / operator between vectors, vector1 / vector2'
vector1 = vector1 / vector2
call vector1%printf
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
call vector1%printf
print "(A)", ' Verify + operator between vectors, vector1 + vector2'
vector1 = vector1 + vector2
call vector1%printf
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
call vector1%printf
print "(A)", ' Verify - operator between vectors, vector1 - vector2'
vector1 = vector1 - vector2
call vector1%printf
print "(A)", ' Verify save/load methods'
open(unit=2, form='UNFORMATTED', status='SCRATCH')
call vector1%save_into_file(unit=2)
rewind(unit=2)
call vector3%load_from_file(unit=2)
close(unit=2)
call vector3%printf
vector3 = 0
print "(A)", ' Verify save/load methods with stream-accessed file'
open(unit=2, form='UNFORMATTED', status='SCRATCH', access='STREAM')
call vector1%save_into_file(unit=2, pos=1_I8P)
rewind(unit=2)
call vector3%load_from_file(unit=2, pos=1_I8P)
close(unit=2)
call vector3%printf
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
