program volatile_doctest
use vecfor_R4P
 type(vector_R4P) :: pt
 pt = ex_R4P + ey_R4P + ez_R4P
 print "(L1)", 4._R8P > pt
endprogram volatile_doctest