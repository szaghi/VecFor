program volatile_doctest
use vecfor
 use penf, only : R4P
 type(vector) :: pt
 pt = ex + ey + ez
 print "(L1)", pt /= 1._R4P
endprogram volatile_doctest