program volatile_doctest
use vecfor
 use penf, only : byte_size
 type(vector) :: pt
 print*, pt%iolen()/byte_size(pt%x)
endprogram volatile_doctest