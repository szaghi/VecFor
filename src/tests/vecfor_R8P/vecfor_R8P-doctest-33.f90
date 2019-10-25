program volatile_doctest
use vecfor_R8P
 type(vector_R8P) :: pt
 pt = 1 * ex_R8P + 2 * ey_R8P + 3 * ez_R8P
 open(unit=10, form='unformatted', status='scratch')
 call pt%save_into_file(unit=10)
 rewind(unit=10)
 call pt%load_from_file(unit=10)
 close(unit=10)
 print "(3(F3.1,1X))", pt%x, pt%y, pt%z
endprogram volatile_doctest