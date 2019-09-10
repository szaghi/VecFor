program volatile_doctest
use vecfor_RPP
 type(vector) :: pt(0:3)
 real(RPP) :: d

 pt(0) = 5.3 * ez
 pt(1) = ex
 pt(2) = ey
 pt(3) = ex - ey
 d = pt(0)%distance_to_plane(pt1=pt(1), pt2=pt(2), pt3=pt(3))
 print "(F3.1)", d
endprogram volatile_doctest