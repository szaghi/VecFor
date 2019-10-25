program volatile_doctest
use vecfor_R16P
 type(vector_R16P) :: pt
 pt = 4 * ex_R16P + 3 * ey_R16P
 print "(L1)", 5_I1P == pt
endprogram volatile_doctest