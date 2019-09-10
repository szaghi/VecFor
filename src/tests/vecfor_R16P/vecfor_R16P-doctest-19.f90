program volatile_doctest
use vecfor_R16P
 use penf, only : byte_size
 type(vector_R16P) :: pt
 print*, iolen_R16P(pt)/byte_size(pt%x)
endprogram volatile_doctest