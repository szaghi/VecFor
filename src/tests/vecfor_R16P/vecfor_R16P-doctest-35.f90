program volatile_doctest
use vecfor_R16P
 type(vector_R16P) :: pt
 pt = ex_R16P + ey_R16P
 print "(F3.1)", sq_norm_R16P(pt)
endprogram volatile_doctest