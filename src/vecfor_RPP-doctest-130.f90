program volatile_doctest
use vecfor_RPP
 type(vector) :: pt(1:2)
 pt(1) = ex + ey + ez
 pt(2) = pt(1) + 1
 print "(L1)", pt(1) <= pt(2)
endprogram volatile_doctest