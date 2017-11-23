program volatile_doctest
use vecfor
 type(vector) :: pt
 pt = ex + ey + ez
 print "(L1)", pt > 1_I8P
endprogram volatile_doctest