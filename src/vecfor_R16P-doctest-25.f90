program volatile_doctest
use vecfor_R16P
 type(vector_R16P) :: pt
 pt = ex_R16P + ey_R16P
 call pt%normalize
 print "(3(F4.2,1X))", abs(pt%x), abs(pt%y), abs(pt%z)
endprogram volatile_doctest