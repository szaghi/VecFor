program volatile_doctest
use vecfor_R8P
 type(vector_R8P) :: pt
 pt = 4 * ex_R8P + 3 * ey_R8P
 print "(L1)", 5_I8P == pt
endprogram volatile_doctest