program volatile_doctest
use vecfor
 type(vector) :: pt
 pt = ex + ey
 call pt%printf(prefix='[x, y, z] = ', sep=', ')
endprogram volatile_doctest