program volatile_doctest
use vecfor_R4P
 type(vector_R4P) :: pt(0:3)
 real(R4P)        :: d

 pt(0) = 5.3 * ez_R4P
 pt(1) = ex_R4P
 pt(2) = ey_R4P
 pt(3) = ex_R4P - ey_R4P
 d = distance_to_plane_R4P(pt(0), pt1=pt(1), pt2=pt(2), pt3=pt(3))
 print "(F3.1)", d
endprogram volatile_doctest