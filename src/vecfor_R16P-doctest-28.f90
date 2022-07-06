program volatile_doctest
use vecfor_R16P
 type(vector_R16P) :: pt
 pt = ex_R16P + ey_R16P
 print "(F4.2)", pt%normL2()
endprogram volatile_doctest