n = face_normal3(pt1=p(2), pt2=p(3), pt3=p(4), norm='y')
call n%printf(prefix='unit normal of face 4 = ')
n = face_normal3(pt1=p(2), pt2=p(4), pt3=p(3), norm='y')
call n%printf(prefix='p3 and p4 swapped     = ')
