u = a%normalized()                    ! a unit vector along a; a is unchanged
call u%printf(prefix='direction of p2->p3 = ')
print '(A,F8.4)', 'its length            ', u%normL2()
call a%normalize                      ! a itself becomes a unit vector
call a%printf(prefix='a, normalized       = ')
a = p(3) - p(2)
