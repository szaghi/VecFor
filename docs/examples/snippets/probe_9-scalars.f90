a4 = a4 * 0.1_R8P                            ! a scalar of another kind is converted to the kind of the vector
print '(A,ES16.8)', 'x of a4 * 0.1    ', a4%x
print '(A,ES16.8)', 'length, function ', normL2_R4P(a4)
