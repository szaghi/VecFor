program volatile_doctest
use vecfor
 use penf, only : R4P
 type(vector) :: pt
 pt = ex + ey + ez
 print "(L1)", 4._R4P > pt
endprogram volatile_doctest