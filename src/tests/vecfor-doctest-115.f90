program volatile_doctest
use vecfor
 use penf, only : R16P
 type(vector) :: pt
 pt = ex + ey + ez
 print "(L1)", 1._R16P < pt
endprogram volatile_doctest