program unit_vector
!< Cookbook: a unit vector, as a new vector or in place; the zero vector.
use vecfor, only : ex, ey, ez, normalized, vector
implicit none
type(vector) :: a, u, z

a = 2 * ex + 3 * ey + 6 * ez
u = a%normalized()   ; call u%printf(prefix='a%normalized()  = ')
u = normalized(a)    ; call u%printf(prefix='normalized(a)   = ')
call a%printf(prefix='a, unchanged    = ')
call a%normalize     ; call a%printf(prefix='after normalize = ')
call z%normalize     ; call z%printf(prefix='zero, normalized = ')
endprogram unit_vector
