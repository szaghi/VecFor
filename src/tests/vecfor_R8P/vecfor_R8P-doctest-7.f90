program volatile_doctest
use vecfor_R8P
 type(vector_R8P) :: pt(1:2)
 real(R8P)        :: a

 pt(1) = ex_R8P
 pt(2) = ey_R8P
 a = angle_R8P(pt(1), pt(2))
 print "(F4.2)", a
endprogram volatile_doctest