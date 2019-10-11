program volatile_doctest
use vecfor_R16P
 type(vector_R16P) :: pt(0:3)
 real(R16P)        :: d

 pt(0) = 5.3 * ez_R16P
 pt(1) = ex_R16P
 pt(2) = ey_R16P
 pt(3) = ex_R16P - ey_R16P
 d = distance_to_plane_R16P(pt(0), pt1=pt(1), pt2=pt(2), pt3=pt(3))
 print "(F3.1)", d
endprogram volatile_doctest