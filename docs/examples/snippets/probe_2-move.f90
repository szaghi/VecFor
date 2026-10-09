s = p + (2 * ex - 0.5_R8P * ez)       ! every vertex at once: + works on arrays of vectors
call s(4)%printf(prefix='moved p4     = ')
