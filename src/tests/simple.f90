!< Simple regression test for VecFor library.
program simple
!< Simple regression test for VecFor library.
use vecfor
implicit none
type(vector) :: vector1 !< Vector dummy variable.
type(vector) :: vector2 !< Vector dummy variable.
type(vector) :: vector3 !< Vector dummy variable.
type(vector) :: vector4 !< Vector dummy variable.
type(vector) :: vector5 !< Vector dummy variable.

print "(A)", ' Assign vector1 = [1, 2, 3]'
vector1 = 1 * ex + 2 * ey + 3 * ez
print "(A)", ' Assign vector2 = [-1, -2, -3]'
vector2 = -1 * ex - 2 * ey - 3 * ez
print "(A)", ' Verify auxiliary methods'
print "(A,F5.1)", ' vector1%sq_norm() = ', vector1%sq_norm()
print "(A,F5.1)", ' sq_norm(vector1) = ', sq_norm(vector1)
print "(A,F5.1)", ' vector1%normL2() = ', vector1%normL2()
print "(A,F5.1)", ' normL2(vector1) = ', normL2(vector1)
print "(A)", ' normalized(vector1):'
vector3 = vector1%normalized()
call vector3%print
print "(A)", 'call vector1%normalize():'
vector3 = vector1
call vector3%normalize()
call vector3%print
print "(A)", ' Verify normalization fall-back for null vector'
vector3 = 0
call vector3%normalize()
print "(A)", 'call 0%normalize():'
call vector3%print
vector3 = 0
vector3 = vector3%normalized()
print "(A)", 'vector1 = 0%normalized():'
call vector3%print
print "(A)", ' Verify dot product'
print "(A,F5.1)", ' vector1.dot.ex = ', vector1.dot.ex
print "(A,F5.1)", ' vector1.dot.ey = ', vector1.dot.ey
print "(A,F5.1)", ' vector1.dot.ez = ', vector1.dot.ez
print "(A,F5.1)", ' vector1.dot.vector2 = ', vector1.dot.vector2
print "(A)", ' Verify cross product'
print "(A)", ' vector1.cross.vector2:'
vector3 = vector1.cross.vector2
call vector3%print
print "(A)", ' Verify special operators'
print "(A)", ' vector1.ortho.vector2:'
vector3 = vector1.ortho.vector2
call vector3%print
print "(A)", ' vector1.paral.vector2:'
vector3 = vector1.paral.vector2
call vector3%print
print "(A)", ' Verify * / + - operators'
print "(A)", ' vector1 * vector2:'
vector3 = vector1 * vector2
call vector3%print
print "(A)", ' vector1 / vector2:'
vector3 = vector1 / vector2
call vector3%print
print "(A)", ' vector1 + vector2:'
vector3 = vector1 + vector2
call vector3%print
print "(A)", ' vector1 - vector2:'
vector3 = vector1 - vector2
call vector3%print
print "(A)", ' Assign vector1 = [-1, 1, 0]'
vector1 = -ex + ey
print "(A)", ' Assign vector2 = [0, 1, 0]'
vector2 = ey
print "(A)", ' Assign vector3 = [0, -1, 0]'
vector3 = -ey
print "(A)", ' Assign vector4 = [-1, -1, 0]'
vector4 = -ex - ey
print "(A)", ' Face 1-2-3 normal (stand alone procedure):'
vector5 = face_normal3(pt1=vector1, pt2=vector2, pt3=vector3)
call vector5%print
print "(A)", ' Face 1-2-3 normal (stand alone procedure, normalized):'
vector5 = face_normal3(norm='y', pt1=vector1, pt2=vector2, pt3=vector3)
call vector5%print
print "(A)", ' Face 1-2-3 normal (type bound method):'
call vector5%face_normal3(pt1=vector1, pt2=vector2, pt3=vector3)
call vector5%print
print "(A)", ' Face 1-2-3 normal (type bound method, normalized):'
call vector5%face_normal3(norm='y', pt1=vector1, pt2=vector2, pt3=vector3)
call vector5%print
print "(A)", ' Face 1-2-3-4 normal (stand alone procedure): '
vector5 = face_normal4(pt1=vector1, pt2=vector2, pt3=vector3, pt4=vector4)
call vector5%print
print "(A)", ' Face 1-2-3-4 normal (stand alone procedure, normalized): '
vector5 = face_normal4(norm='y', pt1=vector1, pt2=vector2, pt3=vector3, pt4=vector4)
call vector5%print
print "(A)", ' Face 1-2-3-4 normal (type bound method):'
call vector5%face_normal4(pt1=vector1, pt2=vector2, pt3=vector3, pt4=vector4)
call vector5%print
print "(A)", ' Face 1-2-3-4 normal (type bound method, normalized):'
call vector5%face_normal4(norm='y', pt1=vector1, pt2=vector2, pt3=vector3, pt4=vector4)
call vector5%print
print "(A,I3)", ' IO length of vector1 = ', vector1%iolen()

stop
endprogram simple
