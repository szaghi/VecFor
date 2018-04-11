program volatile_doctest
use vecfor_R8P
 type(vector) :: pt
 pt = ex + ey + ez
 print "(L1)", 1._R8P /= pt
endprogram volatile_doctest