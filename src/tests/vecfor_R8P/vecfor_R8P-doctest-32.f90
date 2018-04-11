program volatile_doctest
use vecfor_R8P
 type(vector) :: pt(1:2)
 pt(1) = ex
 pt(2) = ey
 print "(F3.1)", pt(1).dot.pt(2)
endprogram volatile_doctest