program volatile_doctest
use vecfor
 use penf, only : I1P
 type(vector) :: pt
 pt = 4 * ex + 3 * ey
 print "(L1)", 5_I1P == pt
endprogram volatile_doctest