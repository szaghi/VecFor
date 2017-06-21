program volatile_doctest
use vecfor
 use penf, only : I2P
 type(vector) :: pt
 pt = ex + ey + ez
 print "(L1)", 1_I2P < pt
endprogram volatile_doctest