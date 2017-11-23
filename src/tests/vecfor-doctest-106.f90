program volatile_doctest
use vecfor
 type(vector) :: pt
 pt = ex + ey + ez
 print "(L1)", 1_I8P /= pt
endprogram volatile_doctest