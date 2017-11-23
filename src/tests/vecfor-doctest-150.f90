program volatile_doctest
use vecfor
 type(vector) :: pt
 pt = 4 * ex + 3 * ey
 print "(L1)", pt == 5._R4P
endprogram volatile_doctest