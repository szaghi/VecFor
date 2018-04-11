program volatile_doctest
use vecfor_R16P
 type(vector) :: pt
 pt = ex + ey + ez
 print "(L1)", 4_I2P > pt
endprogram volatile_doctest