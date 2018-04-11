program volatile_doctest
use vecfor_R8P
 type(vector) :: pt(0:3)

 pt(0) = 5.3 * ez
 pt(1) = ex
 pt(2) = ey
 pt(3) = ex - ey
 pt(0) = pt(0)%distance_vectorial_to_plane(pt1=pt(1), pt2=pt(2), pt3=pt(3))
 print "(3(F3.1,1X))", pt(0)%x, pt(0)%y, pt(0)%z
endprogram volatile_doctest