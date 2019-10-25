program volatile_doctest
use vecfor_R4P
 type(vector_R4P) :: pt
 pt = ex_R4P + ey_R4P
 call pt%printf(prefix='[x, y, z] = ', sep=', ')
endprogram volatile_doctest