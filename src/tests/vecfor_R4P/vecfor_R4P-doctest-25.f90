program volatile_doctest
use vecfor_R4P
 type(vector_R4P) :: pt
 pt = ex_R4P + ey_R4P
 call pt%normalize
 print "(3(F4.2,1X))", abs(pt%x), abs(pt%y), abs(pt%z)
endprogram volatile_doctest