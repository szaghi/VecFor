program volatile_doctest
use vecfor_R16P
 use penf, only : byte_size
 type(vector_R16P) :: pt
 print*, pt%iolen()/byte_size(pt%x)
endprogram volatile_doctest