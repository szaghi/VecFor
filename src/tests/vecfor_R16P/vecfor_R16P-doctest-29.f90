program volatile_doctest
use vecfor_R16P
 type(vector) :: pt
 pt = ex + ey
 print "(F3.1)", pt%sq_norm()
endprogram volatile_doctest