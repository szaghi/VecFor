program volatile_doctest
use vecfor_R4P
 type(vector_R4P) :: pt
 pt = 1 * ex_R4P + 2 * ey_R4P + 3 * ez_R4P
 open(unit=10, form='unformatted', status='scratch')
 call pt%save_into_file(unit=10)
 rewind(unit=10)
 call pt%load_from_file(unit=10)
 close(unit=10)
 print "(3(F3.1,1X))", pt%x, pt%y, pt%z
endprogram volatile_doctest