program volatile_doctest
use vecfor_RPP
 type(vector) :: pt
 pt = 4 * ex + 3 * ey
 print "(L1)", 5._R4P == pt
endprogram volatile_doctest