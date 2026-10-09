normal = face_normal3(pt1=p(face(1,:)), pt2=p(face(2,:)), pt3=p(face(3,:)), norm='y')   ! four faces, one call
print '(A,4F8.4)', 'x of the normals ', normal%x
print '(A,4F8.4)', 'their lengths    ', normL2(normal)
