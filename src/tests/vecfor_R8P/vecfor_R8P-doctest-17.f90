program volatile_doctest
use vecfor_R8P
 type(vector_R8P) :: pt(0:4)

 pt(1) = ex_R8P
 pt(2) = ey_R8P
 pt(3) = ex_R8P - ey_R8P
 pt(4) = ex_R8P + ey_R8P
 pt(0) = face_normal4_R8P(pt1=pt(1), pt2=pt(2), pt3=pt(3), pt4=pt(4), norm='y')
 print "(3(F3.1,1X))", abs(pt(0)%x), abs(pt(0)%y), abs(pt(0)%z)
endprogram volatile_doctest