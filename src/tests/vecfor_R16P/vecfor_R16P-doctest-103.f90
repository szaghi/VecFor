program volatile_doctest
use vecfor_R16P
 type(vector_R16P) :: pt
 pt = ex_R16P + ey_R16P + ez_R16P
 print "(L1)", 1._R8P /= pt
endprogram volatile_doctest