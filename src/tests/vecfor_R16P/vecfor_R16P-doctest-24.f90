program volatile_doctest
use vecfor_R16P
 type(vector_R16P) :: pt
 pt = 1 * ex_R16P + 2 * ey_R16P + 3 * ez_R16P
 open(unit=10, form='unformatted', status='scratch')
 call pt%save_into_file(unit=10)
 rewind(unit=10)
 call pt%load_from_file(unit=10)
 close(unit=10)
 print "(3(F3.1,1X))", pt%x, pt%y, pt%z
endprogram volatile_doctest