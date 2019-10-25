program volatile_doctest
use vecfor_R8P
 type(vector_R8P) :: pt
 pt = ex_R8P + ey_R8P
 call pt%printf(prefix='[x, y, z] = ', sep=', ')
endprogram volatile_doctest