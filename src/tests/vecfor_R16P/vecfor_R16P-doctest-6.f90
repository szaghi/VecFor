program volatile_doctest
use vecfor_R16P
 type(vector_R16P) :: pt(1:2)
 real(R16P)        :: a

 pt(1) = ex_R16P
 pt(2) = 2 * ex_R16P
 a = pt(1)%angle_R16P(pt(2))
 print "(F3.1)", a
endprogram volatile_doctest