program volatile_doctest
use vecfor_R4P
 type(vector) :: pt
 pt = ex + ey + ez
 print "(L1)", 1._R16P <= pt
endprogram volatile_doctest