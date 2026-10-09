edge = p(4) - p(2)                    ! from p2 to p4
call edge%printf(prefix='edge p2->p4  = ')
edge = -edge                          ! the opposite edge
call edge%printf(prefix='edge p4->p2  = ')
