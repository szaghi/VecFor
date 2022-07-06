program volatile_doctest
use vecfor_R4P
 type(vector_R4P) :: pt(0:3)

 pt(0) = -1 * ey_R4P
 pt(1) = 1 * ex_R4P
 pt(2) = 1 * ey_R4P
 pt(3) = -1 * ex_R4P
 print "(L1)", is_concyclic_R4P(pt(0), pt1=pt(1), pt2=pt(2), pt3=pt(3))
endprogram volatile_doctest