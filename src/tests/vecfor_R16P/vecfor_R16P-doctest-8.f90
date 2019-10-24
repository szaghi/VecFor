program volatile_doctest
use vecfor_R16P
 type(vector_R16P) :: pt(0:2)
 real(R16P)        :: d

 pt(0) = 5.3 * ez_R16P
 pt(1) = ex_R16P
 pt(2) = ey_R16P
 d = pt(0)%distance_to_line_R16P(pt1=pt(1), pt2=pt(2))
 print "(F3.1)", d
endprogram volatile_doctest