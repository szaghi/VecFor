call r(1)%load_from_file(unit=u, pos=4 * int(o%iolen(), int64) + 1, iostat=ios, iomsg=msg)
print '(A,I0,2A)', 'reading past the end: iostat = ', ios, ', ', trim(msg)
close(u)
