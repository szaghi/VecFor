program volatile_doctest
use vecfor
 use penf, only : I2P
 type(vector) :: pt
 pt = 1_I2P
 print "(3(F3.1,1X))", abs(pt%x), abs(pt%y), abs(pt%z)
endprogram volatile_doctest