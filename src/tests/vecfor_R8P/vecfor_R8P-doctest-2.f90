program volatile_doctest
use vecfor_R8P
 type(vector) :: pt(1:2)
 real(RPP) :: a

 pt(1) = ex
 pt(2) = ey
 a = angle(pt(1), pt(2))
 print "(F4.2)", a
endprogram volatile_doctest