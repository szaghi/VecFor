program volatile_doctest
use vecfor_R8P
 type(vector_R8P) :: pt
 pt = ex_R8P + ey_R8P
 pt = pt%normalized()
 print "(3(F4.2,1X))", abs(pt%x), abs(pt%y), abs(pt%z)
endprogram volatile_doctest