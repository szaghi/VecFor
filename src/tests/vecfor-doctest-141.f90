program volatile_doctest
use vecfor
 type(vector) :: pt
 pt = ex + ey + ez
 print "(L1)", pt <= 4_I2P
endprogram volatile_doctest