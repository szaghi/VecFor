program volatile_doctest
use vecfor_R16P
 type(vector_R16P) :: pt(1:2)
 real(R16P)        :: a

 pt(1) = ex_R16P
 pt(2) = ey_R16P
 a = angle_R16P(pt(1), pt(2))
 print "(F4.2)", a
endprogram volatile_doctest