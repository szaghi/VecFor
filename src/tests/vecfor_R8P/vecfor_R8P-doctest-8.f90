program volatile_doctest
use vecfor_R8P
 type(vector_R8P) :: pt(0:2)
 real(R8P) :: d

 pt(0) = 5.3 * ez_R8P
 pt(1) = ex_R8P
 pt(2) = ey_R8P
 d = pt(0)%distance_to_line_R8P(pt1=pt(1), pt2=pt(2))
 print "(F3.1)", d
endprogram volatile_doctest