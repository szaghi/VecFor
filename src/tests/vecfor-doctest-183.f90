program volatile_doctest
use vecfor
 type(vector) :: pt
 pt = ex + ey + ez
 print "(L1)", 4_I4P > pt
endprogram volatile_doctest