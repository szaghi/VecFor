program volatile_doctest
use vecfor_R8P
 type(vector_R8P) :: pt(0:2)

 pt(0) = 3 * ex_R8P
 pt(1) = 1 * ex_R8P
 pt(2) = 2 * ex_R8P
 print "(L1)", is_collinear_R8P(pt(0), pt1=pt(1), pt2=pt(2))
endprogram volatile_doctest