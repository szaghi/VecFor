program volatile_doctest
use vecfor_R16P
 type(vector_R16P) :: pt(0:2)

 pt(0) = 3 * ex_R16P
 pt(1) = 1 * ex_R16P
 pt(2) = 2 * ex_R16P
 print "(L1)", pt(0)%is_collinear_R16P(pt1=pt(1), pt2=pt(2))
endprogram volatile_doctest