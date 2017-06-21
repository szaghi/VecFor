program volatile_doctest
use vecfor
 use penf, only : I4P
 type(vector) :: pt
 pt = ex + ey + ez
 print "(L1)", 1_I4P < pt
endprogram volatile_doctest