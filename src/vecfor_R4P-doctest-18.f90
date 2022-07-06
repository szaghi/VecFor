program volatile_doctest
use vecfor_R4P
 use penf, only : byte_size
 type(vector_R4P) :: pt
 print*, pt%iolen()/byte_size(pt%x)
endprogram volatile_doctest