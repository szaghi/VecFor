do f = 1, 4
   dist(f) = q%distance_to_plane(pt1=p(face(1,f)), pt2=p(face(2,f)), pt3=p(face(3,f)))
enddo
print '(A,4F8.4)', 'q to the faces       ', dist
print '(A,L1)',    'q is inside:         ', all(dist <= 0._R8P)
do f = 1, 4
   dist(f) = c%distance_to_plane(pt1=p(face(1,f)), pt2=p(face(2,f)), pt3=p(face(3,f)))
enddo
print '(A,4F8.4)', 'centroid to the faces', dist
print '(A,L1)',    'centroid is inside:  ', all(dist <= 0._R8P)
