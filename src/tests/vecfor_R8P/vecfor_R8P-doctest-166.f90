program volatile_doctest
use vecfor_R8P
 type(vector_R8P) :: pt
 pt = ex_R8P + ey_R8P + ez_R8P
 print "(L1)", pt >= 1._R4P
endprogram volatile_doctest