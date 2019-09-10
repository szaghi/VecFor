program volatile_doctest
use vecfor_R4P
 type(vector_R4P) :: pt(1:2)
 real(R4P) :: a

 pt(1) = ex_R4P
 pt(2) = 2 * ex_R4P
 a = pt(1)%angle_R4P(pt(2))
 print "(F3.1)", a
endprogram volatile_doctest