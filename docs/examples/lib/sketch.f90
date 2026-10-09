module sketch
!< The drawings of the documentation: points in space seen from a direction, written as data files for foresight.
!<
!< A view projects a point onto the plane of the screen with two dot products, its abscissa along `right` and its ordinate
!< along `up`: the figures are computed by VecFor itself. Each layer of a drawing is a data file in the layout read by
!< the foresight style that draws it. The view keeps the extent of all it wrote, and `frame` writes the ranges that show
!< it whole, at the same scale on both axes, for the foresight script of the figure.
use penf, only : R8P
use vecfor, only : ex, ey, ez, normalized, vector
implicit none
private
public :: view_object

type :: view_object
  !< A direction of view: the screen axes, unit vectors orthogonal to the direction of view and to each other.
  type(vector)           :: right                !< Screen abscissa.
  type(vector)           :: up                   !< Screen ordinate.
  real(R8P)              :: lo(2) = huge(1._R8P) !< Lower left corner of what was written.
  real(R8P)              :: hi(2) = -huge(1._R8P)!< Upper right corner of what was written.
  real(R8P), allocatable :: text_end(:,:)        !< Abscissa and length (characters) of each label.
  contains
    procedure, pass(self) :: look      !< Set the view from azimuth and elevation.
    procedure, pass(self) :: look_from !< Set the view from the direction towards the viewer.
    procedure, pass(self) :: axes      !< Write the Cartesian axes and their labels.
    procedure, pass(self) :: arrow     !< Write an arrow: `x y dx dy` (style `vectors`).
    procedure, pass(self) :: segment   !< Write a segment: two points and a blank line (style `lines`).
    procedure, pass(self) :: polygon   !< Write a closed polygon: its points, the first again, a blank line.
    procedure, pass(self) :: label     !< Write a label: `x y "text"` (style `labels`).
    procedure, pass(self) :: point     !< Write a point: `x y` (style `points`).
    procedure, pass(self) :: frame     !< Write the ranges that show the whole drawing.
    procedure, pass(self) :: grow      !< Extend the extent to a point of the screen.
endtype view_object

contains
   subroutine look(self, azimuth, elevation)
   !< Set the view: the viewer is far away in the direction of azimuth (from x towards y) and elevation (from the xy
   !< plane towards z), both in degrees. The z axis is drawn upwards.
   class(view_object), intent(inout) :: self      !< The view.
   real(R8P),          intent(in)    :: azimuth   !< Azimuth [deg].
   real(R8P),          intent(in)    :: elevation !< Elevation [deg].
   real(R8P)                         :: a, e      !< Azimuth and elevation [rad].

   a = azimuth * acos(-1._R8P) / 180._R8P
   e = elevation * acos(-1._R8P) / 180._R8P
   call self%look_from(cos(e) * cos(a) * ex + cos(e) * sin(a) * ey + sin(e) * ez)
   endsubroutine look

   subroutine look_from(self, eye)
   !< Set the view: the viewer is far away in the direction `eye`; z is drawn upwards, unless `eye` is along z.
   class(view_object), intent(inout) :: self !< The view.
   type(vector),       intent(in)    :: eye  !< Direction towards the viewer.

   if (normL2_xy(eye) > 1.e-6_R8P * eye%normL2()) then
      self%right = normalized(ez .cross. eye)
   else
      self%right = ex
   endif
   self%up = normalized(eye .cross. self%right)
   contains
      pure function normL2_xy(v) result(n)
      !< The length of the projection of v onto the xy plane.
      type(vector), intent(in) :: v !< The vector.
      real(R8P)                :: n !< The length.

      n = sqrt(v%x**2 + v%y**2)
      endfunction normL2_xy
   endsubroutine look_from

   subroutine axes(self, name, length)
   !< Write the axes x, y, z from the origin, `length` long, into `name.axes.dat` and their labels into
   !< `name.axlabels.dat`.
   class(view_object), intent(inout) :: self   !< The view.
   character(*),       intent(in)    :: name   !< Name of the figure.
   real(R8P),          intent(in)    :: length !< Length of the axes.
   type(vector)                      :: o      !< The origin.
   integer                           :: u      !< Data file.

   open(newunit=u, file=name//'.axes.dat')
   call self%arrow(u, o, length * ex)
   call self%arrow(u, o, length * ey)
   call self%arrow(u, o, length * ez)
   close(u)
   open(newunit=u, file=name//'.axlabels.dat')
   call self%label(u, (length + 0.1_R8P) * ex, 'x')
   call self%label(u, (length + 0.1_R8P) * ey, 'y')
   call self%label(u, (length + 0.1_R8P) * ez, 'z')
   close(u)
   endsubroutine axes

   subroutine arrow(self, unit, tail, head)
   !< Write an arrow from `tail` to `head`.
   class(view_object), intent(inout) :: self !< The view.
   integer,            intent(in)    :: unit !< Data file.
   type(vector),       intent(in)    :: tail !< Tail of the arrow.
   type(vector),       intent(in)    :: head !< Head of the arrow.

   call self%grow(tail)
   call self%grow(head)
   write(unit, '(4(ES16.8,1X))') tail .dot. self%right, tail .dot. self%up, &
                                 (head - tail) .dot. self%right, (head - tail) .dot. self%up
   endsubroutine arrow

   subroutine segment(self, unit, a, b)
   !< Write the segment from `a` to `b`.
   class(view_object), intent(inout) :: self !< The view.
   integer,            intent(in)    :: unit !< Data file.
   type(vector),       intent(in)    :: a    !< First end.
   type(vector),       intent(in)    :: b    !< Second end.

   call self%point(unit, a)
   call self%point(unit, b)
   write(unit, '(A)') ''
   endsubroutine segment

   subroutine polygon(self, unit, vertices)
   !< Write the closed polygon through `vertices`.
   class(view_object), intent(inout) :: self        !< The view.
   integer,            intent(in)    :: unit        !< Data file.
   type(vector),       intent(in)    :: vertices(:) !< Vertices, in order.
   integer                           :: i           !< Counter.

   do i = 1, size(vertices)
      call self%point(unit, vertices(i))
   enddo
   call self%point(unit, vertices(1))
   write(unit, '(A)') ''
   endsubroutine polygon

   subroutine label(self, unit, at, text)
   !< Write the label `text` at `at`.
   class(view_object), intent(inout) :: self !< The view.
   integer,            intent(in)    :: unit !< Data file.
   type(vector),       intent(in)    :: at   !< Position.
   character(*),       intent(in)    :: text !< Text.

   call self%grow(at)
   if (.not.allocated(self%text_end)) allocate(self%text_end(2,0))
   self%text_end = reshape([self%text_end, [at .dot. self%right, real(len(text), R8P)]], &
                           [2, size(self%text_end, dim=2) + 1])
   write(unit, '(2(ES16.8,1X),A)') at .dot. self%right, at .dot. self%up, '"'//text//'"'
   endsubroutine label

   subroutine point(self, unit, at)
   !< Write the point `at`.
   class(view_object), intent(inout) :: self !< The view.
   integer,            intent(in)    :: unit !< Data file.
   type(vector),       intent(in)    :: at   !< Position.

   call self%grow(at)
   write(unit, '(2(ES16.8,1X))') at .dot. self%right, at .dot. self%up
   endsubroutine point

   subroutine grow(self, at)
   !< Extend the extent of the drawing to the point `at`.
   class(view_object), intent(inout) :: self !< The view.
   type(vector),       intent(in)    :: at   !< Position.
   real(R8P)                         :: s(2) !< Its screen coordinates.

   s = [at .dot. self%right, at .dot. self%up]
   self%lo = min(self%lo, s)
   self%hi = max(self%hi, s)
   endsubroutine grow

   subroutine frame(self, name)
   !< Write `name.frame.gp`: the ranges that show the whole drawing with a margin, and the size ratio that keeps the same
   !< scale on both axes. The labels are written left of their point, about 80 characters in the width of the plot.
   class(view_object), intent(inout) :: self    !< The view.
   character(*),       intent(in)    :: name    !< Name of the figure.
   real(R8P)                         :: lo(2)   !< Lower left corner of the plot.
   real(R8P)                         :: hi(2)   !< Upper right corner of the plot.
   real(R8P)                         :: margin  !< Margin around the drawing.
   integer                           :: i, u    !< Counter, file.

   lo = self%lo
   hi = self%hi
   if (allocated(self%text_end)) then
      do i = 1, size(self%text_end, dim=2)
         hi(1) = max(hi(1), self%text_end(1,i) + (self%text_end(2,i) + 2) * (self%hi(1) - self%lo(1)) / 70)
      enddo
   endif
   margin = 0.06_R8P * maxval(hi - lo)
   lo = lo - margin
   hi = hi + margin
   open(newunit=u, file=name//'.frame.gp')
   write(u, '(A,F0.4,A,F0.4,A)') 'set xrange [', lo(1), ':', hi(1), ']'
   write(u, '(A,F0.4,A,F0.4,A)') 'set yrange [', lo(2), ':', hi(2), ']'
   write(u, '(A,F0.4)')          'set size ratio ', (hi(2) - lo(2)) / (hi(1) - lo(1))
   close(u)
   endsubroutine frame
endmodule sketch
