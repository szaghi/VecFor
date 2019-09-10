program volatile_doctest
use vecfor_RPP
 type(vector) :: pt
 pt = ex + ey
 print "(F3.1)", pt%sq_norm()
endprogram volatile_doctest