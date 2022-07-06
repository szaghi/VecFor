program volatile_doctest
use vecfor_R4P
 type(vector_R4P) :: pt
 pt = 4 * ex_R4P + 3 * ey_R4P
 print "(L1)", 5_I1P == pt
endprogram volatile_doctest