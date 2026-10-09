a = 2 * (p(2) + p(3) + p(4)) / 3 - p(2)        ! opposite to p2, on the circle through p2, p3, p4
print '(A,L1)', 'a, p4, p2, p3 on a circle: ', a%is_concyclic(pt1=p(4), pt2=p(2), pt3=p(3))
print '(A,L1)', 'a, p2, p4, p3 on a circle: ', a%is_concyclic(pt1=p(2), pt2=p(4), pt3=p(3))
