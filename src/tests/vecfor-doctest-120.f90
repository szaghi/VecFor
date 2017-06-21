program volatile_doctest
use vecfor
 use penf, only : I8P
 type(vector) :: pt
 pt = ex + ey + ez
 print "(L1)", pt < 4_I8P
endprogram volatile_doctest