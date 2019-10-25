program volatile_doctest
use vecfor_R16P
 type(vector_R16P) :: pt
 pt = ex_R16P + ey_R16P + ez_R16P
 print "(L1)", pt > 1._R16P
endprogram volatile_doctest