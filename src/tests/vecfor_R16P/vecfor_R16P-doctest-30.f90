program volatile_doctest
use vecfor_R16P
 type(vector_R16P) :: pt
 pt = ex_R16P + ey_R16P
 call pt%printf(prefix='[x, y, z] = ', sep=', ')
endprogram volatile_doctest