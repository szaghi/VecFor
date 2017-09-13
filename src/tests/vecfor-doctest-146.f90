program volatile_doctest
use vecfor
 use penf, only : R16P
 type(vector) :: pt
 pt = 4 * ex + 3 * ey
 print "(L1)", pt == 5._R16P
endprogram volatile_doctest