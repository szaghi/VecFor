program volatile_doctest
use vecfor_RPP
 type(vector) :: pt
 pt = 1_I8P
 print "(3(F3.1,1X))", abs(pt%x), abs(pt%y), abs(pt%z)
endprogram volatile_doctest