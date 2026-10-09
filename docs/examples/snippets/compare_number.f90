program compare_number
!< Cookbook: comparing the length of a vector with a number.
use penf, only : I4P, R4P, R8P
use vecfor, only : ex, ey, vector
implicit none
type(vector) :: v

v = 3 * ex + 4 * ey                      ! its length is 5
print '(A,L1)', 'v == 5        ', v == 5
print '(A,L1)', 'v <  5.5_R8P  ', v < 5.5_R8P
print '(A,L1)', '4_I4P < v     ', 4_I4P < v
print '(A,L1)', 'v >= 6._R4P   ', v >= 6._R4P
endprogram compare_number
