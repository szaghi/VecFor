allocate(g(n**3))
do k = 1, n
   do j = 1, n
      do i = 1, n
         g(i + n * (j - 1) + n**2 * (k - 1)) = ((i - 0.5_R8P) * ex + (j - 0.5_R8P) * ey + (k - 0.5_R8P) * ez) / n
      enddo
   enddo
enddo
