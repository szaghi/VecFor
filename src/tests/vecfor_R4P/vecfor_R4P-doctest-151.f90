program volatile_doctest
use vecfor_R4P
 type(vector) :: pt
 pt = 4 * ex + 3 * ey
 print "(L1)", 5_I8P == pt
endprogram volatile_doctest