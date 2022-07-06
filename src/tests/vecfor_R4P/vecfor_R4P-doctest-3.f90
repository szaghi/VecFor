program volatile_doctest
use vecfor_R4P
 type(vector_R4P) :: pt(2)
 real(R4P) :: I(3,3)
 pt(1) = 2 * ex_R4P
 I = 0._RPP
 I(1,1) = 1._RPP
 I(2,2) = 1._RPP
 I(3,3) = 1._RPP
 pt(2) = I.matrix.pt(1)
 print "(3(F3.1,1X))", abs(pt(2)%x), abs(pt(2)%y), abs(pt(2)%z)
endprogram volatile_doctest