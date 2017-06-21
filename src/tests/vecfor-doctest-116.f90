program volatile_doctest
use vecfor
 use penf, only : R8P
 type(vector) :: pt
 pt = ex + ey + ez
 print "(L1)", pt < 4._R8P
endprogram volatile_doctest