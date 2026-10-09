d = q%distance_vectorial_to_plane(pt1=p(2), pt2=p(3), pt3=p(4))
foot = q%projection_onto_plane(pt1=p(2), pt2=p(3), pt3=p(4))
print '(A,3F8.4)', 'from the face to q   ', d%x, d%y, d%z
print '(A,3F8.4)', 'foot of q            ', foot%x, foot%y, foot%z
print '(A,3F8.4)', 'foot + distance      ', foot%x + d%x, foot%y + d%y, foot%z + d%z
