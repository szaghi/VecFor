program volatile_doctest
use vecfor_R4P
 type(vector_R4P) :: pt(0:3)

 pt(1) = ex_R4P
 pt(2) = ey_R4P
 pt(3) = ex_R4P - ey_R4P
 pt(0) = face_normal3_R4P(pt1=pt(1), pt2=pt(2), pt3=pt(3), norm='y')
 print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
endprogram volatile_doctest