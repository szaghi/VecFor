program volatile_doctest
use vecfor_R8P
 type(vector_R8P) :: pt
 pt = ex_R8P + ey_R8P + ez_R8P
 print "(L1)", 1._R16P /= pt
endprogram volatile_doctest