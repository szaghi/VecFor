program volatile_doctest
use vecfor_R4P
 type(vector_R4P) :: pt
 pt = ex_R4P + ey_R4P
 print "(F3.1)", sq_norm_R4P(pt)
endprogram volatile_doctest