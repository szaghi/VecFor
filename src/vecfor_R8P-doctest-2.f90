program volatile_doctest
use vecfor_R8P
 type(vector_R8P) :: pt(1:2)
 pt(1) = ex_R8P
 pt(2) = ey_R8P
 print "(F3.1)", pt(1).dot.pt(2)
endprogram volatile_doctest