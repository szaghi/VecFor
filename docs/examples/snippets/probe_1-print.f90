call p(1)%printf(prefix='p1 = ')
call p(2)%printf(prefix='p2 = ')
call p(3)%printf(prefix='p3 = ')
call p(4)%printf(prefix='p4 = ')
call q%printf(prefix='q  = ')
print '(A,F4.2)', 'the x of q is ', q%x
