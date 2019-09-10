program volatile_doctest
use vecfor_R8P
 type(vector_R8P) :: pt
 pt = ex_R8P + ey_R8P
 print "(F3.1)", sq_norm_R8P(pt)
endprogram volatile_doctest