program quad_precision
!< Cookbook: true quadruple precision, with VecFor built with -DPENF_R16P.
use penf, only : R16P
use vecfor, only : ex_R16P, ey_R16P, vector_R16P
implicit none
type(vector_R16P) :: v

v = ex_R16P + ey_R16P
print '(A,I0)', 'digits of vector_R16P: ', precision(v%x)
print '(A,F38.34)', 'its length:  ', v%normL2()
print '(A,F38.34)', 'sqrt(2):     ', sqrt(2._R16P)
v = v / 3
call v%printf(prefix='(ex + ey) / 3 = ')
endprogram quad_precision
