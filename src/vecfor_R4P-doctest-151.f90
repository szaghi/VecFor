program volatile_doctest
use vecfor_R4P
 type(vector_R4P) :: pt
 pt = 4 * ex_R4P + 3 * ey_R4P
 print "(L1)", pt == 5._R4P
endprogram volatile_doctest