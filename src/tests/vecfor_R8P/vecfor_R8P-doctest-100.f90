program volatile_doctest
use vecfor_R8P
 type(vector_R8P) :: pt(1:2)
 pt(1) = ex_R8P + ey_R8P + ez_R8P
 pt(2) = ex_R8P + ey_R8P - ez_R8P
 print "(L1)", pt(1) /= pt(2)
endprogram volatile_doctest