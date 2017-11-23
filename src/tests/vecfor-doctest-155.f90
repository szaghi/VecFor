program volatile_doctest
use vecfor
 type(vector) :: pt
 pt = 4 * ex + 3 * ey
 print "(L1)", 5_I2P == pt
endprogram volatile_doctest