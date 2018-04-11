program volatile_doctest
use vecfor_R8P
 type(vector) :: pt(0:3)

 pt(0) = -1 * ey
 pt(1) = 1 * ex
 pt(2) = 1 * ey
 pt(3) = -1 * ex
 print "(L1)", is_concyclic(pt(0), pt1=pt(1), pt2=pt(2), pt3=pt(3))
endprogram volatile_doctest