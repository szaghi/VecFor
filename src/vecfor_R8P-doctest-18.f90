program volatile_doctest
use vecfor_R8P
 use penf, only : byte_size
 type(vector_R8P) :: pt
 print*, pt%iolen()/byte_size(pt%x)
endprogram volatile_doctest