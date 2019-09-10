program volatile_doctest
use vecfor_R8P
 type(vector_R8P) :: pt
 pt = ex_R8P + ey_R8P
 print "(F4.2)", pt%normL2_R8P()
endprogram volatile_doctest