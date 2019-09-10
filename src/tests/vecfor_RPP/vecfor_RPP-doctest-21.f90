program volatile_doctest
use vecfor_RPP
 type(vector) :: pt(0:2)

 pt(0) = 3 * ex
 pt(1) = 1 * ex
 pt(2) = 2 * ex
 print "(L1)", is_collinear(pt(0), pt1=pt(1), pt2=pt(2))
endprogram volatile_doctest