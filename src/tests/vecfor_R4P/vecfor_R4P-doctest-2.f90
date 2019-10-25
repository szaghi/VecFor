program volatile_doctest
use vecfor_R4P
 type(vector_R4P) :: pt(1:2)
 pt(1) = ex_R4P
 pt(2) = ey_R4P
 print "(F3.1)", pt(1).dot.pt(2)
endprogram volatile_doctest