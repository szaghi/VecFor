program volatile_doctest
use vecfor
 type(vector) :: pt(0:3)

 pt(1) = ex
 pt(2) = ey
 pt(3) = ex - ey
 pt(0) = pt(1)%face_normal3(pt1=pt(1), pt2=pt(2), pt3=pt(3), norm='y')
 print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
endprogram volatile_doctest