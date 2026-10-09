a4  = ey_R4P  - ex_R4P                       ! each kind has its own versors
a8  = ey_R8P  - ex_R8P
a16 = ey_R16P - ex_R16P
print '(A,I3,A,ES10.2)', 'R4P : digits', precision(a4%x),  ', error of the length', &
                         abs(a4%normL2()  - l)
print '(A,I3,A,ES10.2)', 'R8P : digits', precision(a8%x),  ', error of the length', &
                         abs(a8%normL2()  - l)
print '(A,I3,A,ES10.2)', 'R16P: digits', precision(a16%x), ', error of the length', &
                         abs(a16%normL2() - l)
print '(A,I3)',          'vector: digits', precision(a%x)
