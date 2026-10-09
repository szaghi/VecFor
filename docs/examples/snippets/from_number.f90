program from_number
!< Cookbook: every component set to one number, of any integer or real kind.
use penf, only : I1P, I2P, I4P, I8P, R4P, R8P
use vecfor, only : vector
implicit none
type(vector) :: v

v = 2.5_R8P  ; call v%printf(prefix='real(R8P)    ')
v = 0.1_R4P  ; call v%printf(prefix='real(R4P)    ')
v = 7_I8P    ; call v%printf(prefix='integer(I8P) ')
v = -3_I4P   ; call v%printf(prefix='integer(I4P) ')
v = 4_I2P    ; call v%printf(prefix='integer(I2P) ')
v = 1_I1P    ; call v%printf(prefix='integer(I1P) ')
endprogram from_number
