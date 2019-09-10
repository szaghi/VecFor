program volatile_doctest
use vecfor_R8P
 type(vector_R8P) :: pt(1:2)
 real(R8P) :: a

 pt(1) = ex_R8P
 pt(2) = 2 * ex_R8P
 a = pt(1)%angle_R8P(pt(2))
 print "(F3.1)", a
endprogram volatile_doctest