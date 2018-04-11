program volatile_doctest
use vecfor_R4P
 type(vector) :: pt
 pt = ex + ey + ez
 print "(L1)", 1_I2P <= pt
endprogram volatile_doctest