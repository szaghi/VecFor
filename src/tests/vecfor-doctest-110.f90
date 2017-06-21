program volatile_doctest
use vecfor
 use penf, only : I1P
 type(vector) :: pt
 pt = ex + ey + ez
 print "(L1)", 1_I1P /= pt
endprogram volatile_doctest