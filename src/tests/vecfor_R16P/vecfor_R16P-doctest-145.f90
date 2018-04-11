program volatile_doctest
use vecfor_R16P
 type(vector) :: pt
 pt = 4 * ex + 3 * ey
 print "(L1)", 5._R16P == pt
endprogram volatile_doctest