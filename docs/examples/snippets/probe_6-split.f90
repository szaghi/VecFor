vn = v .paral. n
vt = v .ortho. n
call vn%printf(prefix='normal component     = ')
call vt%printf(prefix='tangential component = ')
print '(A,ES9.1)', 'vn . vt                ', vn .dot. vt
