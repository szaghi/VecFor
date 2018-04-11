program volatile_doctest
use vecfor_R8P
 type(vector) :: pt(0:3)

 pt(0) = 1 * ex + 2 * ey + 5.3 * ez
 pt(1) = ex
 pt(2) = ey
 pt(3) = ex - ey
 pt(0) = projection_onto_plane(pt(0), pt1=pt(1), pt2=pt(2), pt3=pt(3))
 print "(3(F3.1,1X))", pt(0)%x, pt(0)%y, pt(0)%z
endprogram volatile_doctest