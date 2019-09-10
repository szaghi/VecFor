program volatile_doctest
use vecfor_R4P
 type(vector_R4P) :: pt(0:2)
 real(R4P) :: d

 pt(0) = 5.3 * ez_R4P
 pt(1) = ex_R4P
 pt(2) = ey_R4P
 d = pt(0)%distance_to_line_R4P(pt1=pt(1), pt2=pt(2))
 print "(F3.1)", d
endprogram volatile_doctest