program volatile_doctest
use vecfor_R4P
 type(vector_R4P) :: pt(1:2)
 pt(1) = ex_R4P + ey_R4P + ez_R4P
 pt(2) = pt(1) + 1
 print "(L1)", pt(2) >= pt(1)
endprogram volatile_doctest