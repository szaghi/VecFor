program volatile_doctest
use vecfor_R16P
 type(vector_R16P) :: pt(1:2)
 pt(1) = ex_R16P
 pt(2) = ey_R16P
 print "(F3.1)", pt(1).dot.pt(2)
endprogram volatile_doctest