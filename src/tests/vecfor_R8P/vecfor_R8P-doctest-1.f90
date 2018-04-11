program volatile_doctest
use vecfor_R8P
 type(vector) :: pt(1:2)
 real(RPP) :: a

 pt(1) = ex
 pt(2) = 2 * ex
 a = pt(1)%angle(pt(2))
 print "(F3.1)", a
endprogram volatile_doctest