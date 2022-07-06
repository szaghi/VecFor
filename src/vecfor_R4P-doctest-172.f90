program volatile_doctest
use vecfor_R4P
 type(vector_R4P) :: pt
 pt = ex_R4P + ey_R4P + ez_R4P
 print "(L1)", pt >= 1_I2P
endprogram volatile_doctest