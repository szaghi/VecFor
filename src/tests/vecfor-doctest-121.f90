program volatile_doctest
use vecfor
 use penf, only : I8P
 type(vector) :: pt
 pt = ex + ey + ez
 print "(L1)", 1_I8P < pt
endprogram volatile_doctest