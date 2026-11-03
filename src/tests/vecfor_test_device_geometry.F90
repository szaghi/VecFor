!< Device-readiness test for VecFor's geometric `_dev` API: norms, projections, distances, face normals,
!< predicates, in-place transforms and the angle.
!<
!< Each entry point is called inside an `!$acc parallel loop` and, after it, on the host. Two checks per entry:
!< the `_dev` form run on the host must reproduce the host procedure bit-exact (same arithmetic, open-coded: this
!< catches transcription errors), and the device result must agree with the host procedure, bit-exact unless a
!< tolerance is stated and justified next to the check. Under `_OPENACC` every iteration must also have run on the
!< device (nvfortran runs a loop with an indirect call on the host, results unchanged).
!<
!< Built by `tests-nvf-acc` (device) and by every other test mode and fpm (serial, the directives inert).
program vecfor_test_device_geometry
use penf, only : R8P, I4P
#ifdef _OPENACC
use openacc, only : acc_on_device, acc_device_not_host
#endif
use vecfor, only : vector_R8P,                          &
                   angle_R8P,                           &
                   angle_R8P_dev,                       &
                   assign_vector_R8P_dev,               &
                   crossproduct_accurate_R8P,           &
                   crossproduct_accurate_R8P_dev,       &
                   distance_to_line_R8P,                &
                   distance_to_line_R8P_dev,            &
                   distance_to_plane_R8P,               &
                   distance_to_plane_R8P_dev,           &
                   distance_vectorial_to_plane_R8P,     &
                   distance_vectorial_to_plane_R8P_dev, &
                   dotproduct_accurate_R8P,             &
                   dotproduct_accurate_R8P_dev,         &
                   face_normal3_R8P,                    &
                   face_normal3_R8P_dev,                &
                   face_normal4_R8P,                    &
                   face_normal4_R8P_dev,                &
                   is_collinear_R8P,                    &
                   is_collinear_R8P_dev,                &
                   is_concyclic_R8P,                    &
                   is_concyclic_R8P_dev,                &
                   mirror_by_matrix_R8P_dev,            &
                   mirror_by_normal_R8P_dev,            &
                   mirror_matrix_R8P,                   &
                   normalize_R8P_dev,                   &
                   normalized_checked_R8P,              &
                   normalized_checked_R8P_dev,          &
                   normalized_R8P,                      &
                   normalized_R8P_dev,                  &
                   normL2_R8P,                          &
                   normL2_R8P_dev,                      &
                   orthogonal_R8P_dev,                  &
                   parallel_R8P_dev,                    &
                   projection_onto_plane_R8P,           &
                   projection_onto_plane_R8P_dev,       &
                   rotate_by_axis_angle_R8P_dev,        &
                   rotate_by_matrix_R8P_dev,            &
                   rotation_matrix_R8P,                 &
                   sq_norm_R8P,                         &
                   sq_norm_R8P_dev
implicit none

integer(I4P), parameter :: n = 256              !< Loop length.
type(vector_R8P)        :: p0(n)                !< Points (p0(1) is the zero vector).
type(vector_R8P)        :: p1(n), p2(n), p3(n)  !< More points.
type(vector_R8P)        :: t1                   !< Loop-private scratch.
logical                 :: on_device(n)         !< Where each iteration of the device loop ran.
logical                 :: all_passed           !< Overall result.
integer(I4P)            :: i                    !< Counter.
! normL2, sq_norm, normalized, normalize
real(R8P)               :: nrm_dev(n), nrm_ref(n), nrm_hst(n)
real(R8P)               :: sq_dev(n), sq_ref(n), sq_hst(n)
type(vector_R8P)        :: nzd_dev(n), nzd_ref(n), nzd_hst(n)
type(vector_R8P)        :: nze_dev(n), nze_ref(n), nze_hst(n)

! parallel, orthogonal
type(vector_R8P)        :: par_dev(n), par_ref(n), par_hst(n)
type(vector_R8P)        :: ort_dev(n), ort_ref(n), ort_hst(n)
real(R8P)               :: ort_bnd(3,n)

! distance_to_line
real(R8P)               :: dtl_dev(n), dtl_ref(n), dtl_hst(n)
real(R8P)               :: dtl_bnd(n)

! face_normal3, face_normal4, with and without norm
type(vector_R8P)        :: f3n_dev(n), f3n_ref(n), f3n_hst(n), f3a_dev(n), f3a_ref(n), f3a_hst(n)
type(vector_R8P)        :: f4n_dev(n), f4n_ref(n), f4n_hst(n), f4a_dev(n), f4a_ref(n), f4a_hst(n)
real(R8P)               :: f3_bnd(3,n), f3n_bnd(3,n), f4_bnd(3,n), f4n_bnd(3,n), cnd

! distance_to_plane, distance_vectorial_to_plane, projection_onto_plane
real(R8P)               :: dtp_dev(n), dtp_ref(n), dtp_hst(n)
type(vector_R8P)        :: dvp_dev(n), dvp_ref(n), dvp_hst(n), prj_dev(n), prj_ref(n), prj_hst(n)
real(R8P)               :: dtp_bnd(n), dvp_bnd(3,n), prj_bnd(3,n)

! is_collinear, is_concyclic, with and without tolerance (q: on the line p1-p2 for odd i; c0..c3: on a circle,
! c3 moved off it for even i)
type(vector_R8P)        :: q(n), c0(n), c1(n), c2(n), c3(n)
real(R8P)               :: rad, ctr(3)
logical                 :: col_dev(n), col_ref(n), col_hst(n), colt_dev(n), colt_ref(n), colt_hst(n)
logical                 :: ccl_dev(n), ccl_ref(n), ccl_hst(n), cclt_dev(n), cclt_ref(n), cclt_hst(n)

! in-place rotate and mirror (by axis/angle, by normal, by matrix)
real(R8P)               :: ang(n), rotm(3,3,n), mirm(3,3,n), m(3,3)
type(vector_R8P)        :: rax_dev(n), rax_ref(n), rax_hst(n), rmx_dev(n), rmx_ref(n), rmx_hst(n)
type(vector_R8P)        :: mnr_dev(n), mnr_ref(n), mnr_hst(n), mmx_dev(n), mmx_ref(n), mmx_hst(n)
real(R8P)               :: trf_bnd(3,n), trm_bnd(3,n)

! angle (p0(1) is the zero vector: atan2(0, 0))
real(R8P)               :: agl_dev(n), agl_ref(n), agl_hst(n), agl_bnd(n)

! normalized_checked, default threshold and min_norm = 50 (about half of the data below it)
type(vector_R8P)        :: nck_dev(n), nck_ref(n), nck_hst(n), nc5_dev(n), nc5_ref(n), nc5_hst(n)
logical                 :: okk_dev(n), okk_ref(n), okk_hst(n), ok5_dev(n), ok5_ref(n), ok5_hst(n)

! accurate cross and dot: explicit fma (no contraction choice), so device and host agree bit-exact
type(vector_R8P)        :: cxa_dev(n), cxa_ref(n), cxa_hst(n)
real(R8P)               :: dta_dev(n), dta_ref(n), dta_hst(n)

all_passed = .true.
on_device = .false.
do i = 1, n
   p0(i) = vector_R8P(x=0.37_R8P * real(i - 1, R8P), y=1._R8P - 0.011_R8P * real(i - 1, R8P), &
                      z=-0.29_R8P * real(i - 1, R8P))
   if (i == 1) p0(i) = vector_R8P(x=0._R8P, y=0._R8P, z=0._R8P)
   p1(i) = vector_R8P(x=1._R8P / real(i, R8P), y=0.7_R8P * real(i, R8P), z=2._R8P - 0.003_R8P * real(i, R8P))
   p2(i) = vector_R8P(x=-1.5_R8P + 0.02_R8P * real(i, R8P), y=0.3_R8P, z=real(mod(i, 7), R8P) - 2.5_R8P)
   p3(i) = vector_R8P(x=0.9_R8P, y=-0.4_R8P * real(mod(i, 5), R8P), z=1._R8P + 1._R8P / real(i + 1, R8P))
   q(i) = p1(i) + (0.25_R8P + 0.01_R8P * real(i, R8P)) * (p2(i) - p1(i))
   if (mod(i, 2) == 0) q(i) = q(i) + p3(i)
   rad = 0.5_R8P + 0.01_R8P * real(i, R8P)
   ctr = [0.1_R8P * real(i, R8P), -1._R8P, 0.3_R8P]
   c0(i) = vector_R8P(x=ctr(1) + rad * cos(0.1_R8P), y=ctr(2) + rad * sin(0.1_R8P), z=ctr(3))
   c1(i) = vector_R8P(x=ctr(1) + rad * cos(1.7_R8P), y=ctr(2) + rad * sin(1.7_R8P), z=ctr(3))
   c2(i) = vector_R8P(x=ctr(1) + rad * cos(3.9_R8P), y=ctr(2) + rad * sin(3.9_R8P), z=ctr(3))
   c3(i) = vector_R8P(x=ctr(1) + rad * cos(5.2_R8P), y=ctr(2) + rad * sin(5.2_R8P), z=ctr(3))
   if (mod(i, 2) == 0) c3(i)%x = c3(i)%x + 0.3_R8P
   ang(i) = 0.0125_R8P * real(i, R8P)
   rotm(:,:,i) = rotation_matrix_R8P(p1(i), ang(i))
   mirm(:,:,i) = mirror_matrix_R8P(p2(i))
enddo

!$acc parallel loop copyin(p0, p1, p2, p3, q, c0, c1, c2, c3, ang, rotm, mirm) private(t1, m) &
!$acc copyout(on_device, nrm_dev, sq_dev, nzd_dev, nze_dev, par_dev, ort_dev, dtl_dev, f3n_dev, f3a_dev, &
!$acc         f4n_dev, f4a_dev, dtp_dev, dvp_dev, prj_dev, col_dev, colt_dev, ccl_dev, cclt_dev, rax_dev, &
!$acc         rmx_dev, mnr_dev, mmx_dev, agl_dev, nck_dev, nc5_dev, okk_dev, ok5_dev, cxa_dev, dta_dev)
do i = 1, n
   nrm_dev(i) = normL2_R8P_dev(p0(i))
   sq_dev(i) = sq_norm_R8P_dev(p0(i))
   call normalized_R8P_dev(p0(i), nzd_dev(i))
   call assign_vector_R8P_dev(t1, p0(i))
   call normalize_R8P_dev(t1)
   call assign_vector_R8P_dev(nze_dev(i), t1)
   call parallel_R8P_dev(p1(i), p2(i), par_dev(i))
   call orthogonal_R8P_dev(p1(i), p2(i), ort_dev(i))
   dtl_dev(i) = distance_to_line_R8P_dev(p0(i), p1(i), p2(i))
   call face_normal3_R8P_dev(p1(i), p2(i), p3(i), f3n_dev(i), norm='y')
   call face_normal3_R8P_dev(p1(i), p2(i), p3(i), f3a_dev(i))
   call face_normal4_R8P_dev(p0(i), p1(i), p2(i), p3(i), f4n_dev(i), norm='y')
   call face_normal4_R8P_dev(p0(i), p1(i), p2(i), p3(i), f4a_dev(i))
   dtp_dev(i) = distance_to_plane_R8P_dev(p0(i), p1(i), p2(i), p3(i))
   call distance_vectorial_to_plane_R8P_dev(p0(i), p1(i), p2(i), p3(i), dvp_dev(i))
   call projection_onto_plane_R8P_dev(p0(i), p1(i), p2(i), p3(i), prj_dev(i))
   col_dev(i) = is_collinear_R8P_dev(q(i), p1(i), p2(i))
   colt_dev(i) = is_collinear_R8P_dev(q(i), p1(i), p2(i), tolerance=1e-9_R8P)
   ccl_dev(i) = is_concyclic_R8P_dev(c0(i), c1(i), c2(i), c3(i))
   cclt_dev(i) = is_concyclic_R8P_dev(c0(i), c1(i), c2(i), c3(i), tolerance=1e-9_R8P)
   call assign_vector_R8P_dev(t1, p0(i))
   call rotate_by_axis_angle_R8P_dev(t1, p1(i), ang(i))
   call assign_vector_R8P_dev(rax_dev(i), t1)
   call assign_vector_R8P_dev(t1, p0(i))
   m = rotm(:,:,i)
   call rotate_by_matrix_R8P_dev(t1, m)
   call assign_vector_R8P_dev(rmx_dev(i), t1)
   call assign_vector_R8P_dev(t1, p0(i))
   call mirror_by_normal_R8P_dev(t1, p2(i))
   call assign_vector_R8P_dev(mnr_dev(i), t1)
   call assign_vector_R8P_dev(t1, p0(i))
   m = mirm(:,:,i)
   call mirror_by_matrix_R8P_dev(t1, m)
   call assign_vector_R8P_dev(mmx_dev(i), t1)
   agl_dev(i) = angle_R8P_dev(p0(i), p1(i))
   call normalized_checked_R8P_dev(p0(i), nck_dev(i), okk_dev(i))
   call normalized_checked_R8P_dev(p0(i), nc5_dev(i), ok5_dev(i), min_norm=50._R8P)
   call crossproduct_accurate_R8P_dev(p1(i), p2(i), cxa_dev(i))
   dta_dev(i) = dotproduct_accurate_R8P_dev(p1(i), p2(i))
#ifdef _OPENACC
   on_device(i) = acc_on_device(acc_device_not_host)
#endif
enddo
!$acc end parallel loop

! host: the reference procedures and the `_dev` forms
do i = 1, n
   nrm_ref(i) = normL2_R8P(p0(i))
   nrm_hst(i) = normL2_R8P_dev(p0(i))
   sq_ref(i) = sq_norm_R8P(p0(i))
   sq_hst(i) = sq_norm_R8P_dev(p0(i))
   nzd_ref(i) = normalized_R8P(p0(i))
   call normalized_R8P_dev(p0(i), nzd_hst(i))
   nze_ref(i) = p0(i)
   call nze_ref(i)%normalize()
   nze_hst(i) = p0(i)
   call normalize_R8P_dev(nze_hst(i))
   par_ref(i) = p1(i)%parallel(p2(i))
   call parallel_R8P_dev(p1(i), p2(i), par_hst(i))
   ort_ref(i) = p1(i)%orthogonal(p2(i))
   call orthogonal_R8P_dev(p1(i), p2(i), ort_hst(i))
   dtl_ref(i) = distance_to_line_R8P(p0(i), p1(i), p2(i))
   dtl_hst(i) = distance_to_line_R8P_dev(p0(i), p1(i), p2(i))
   f3n_ref(i) = face_normal3_R8P(pt1=p1(i), pt2=p2(i), pt3=p3(i), norm='y')
   call face_normal3_R8P_dev(p1(i), p2(i), p3(i), f3n_hst(i), norm='y')
   f3a_ref(i) = face_normal3_R8P(pt1=p1(i), pt2=p2(i), pt3=p3(i))
   call face_normal3_R8P_dev(p1(i), p2(i), p3(i), f3a_hst(i))
   f4n_ref(i) = face_normal4_R8P(pt1=p0(i), pt2=p1(i), pt3=p2(i), pt4=p3(i), norm='y')
   call face_normal4_R8P_dev(p0(i), p1(i), p2(i), p3(i), f4n_hst(i), norm='y')
   f4a_ref(i) = face_normal4_R8P(pt1=p0(i), pt2=p1(i), pt3=p2(i), pt4=p3(i))
   call face_normal4_R8P_dev(p0(i), p1(i), p2(i), p3(i), f4a_hst(i))
   dtp_ref(i) = distance_to_plane_R8P(p0(i), p1(i), p2(i), p3(i))
   dtp_hst(i) = distance_to_plane_R8P_dev(p0(i), p1(i), p2(i), p3(i))
   dvp_ref(i) = distance_vectorial_to_plane_R8P(p0(i), p1(i), p2(i), p3(i))
   call distance_vectorial_to_plane_R8P_dev(p0(i), p1(i), p2(i), p3(i), dvp_hst(i))
   prj_ref(i) = projection_onto_plane_R8P(p0(i), p1(i), p2(i), p3(i))
   call projection_onto_plane_R8P_dev(p0(i), p1(i), p2(i), p3(i), prj_hst(i))
   col_ref(i) = is_collinear_R8P(q(i), p1(i), p2(i))
   col_hst(i) = is_collinear_R8P_dev(q(i), p1(i), p2(i))
   colt_ref(i) = is_collinear_R8P(q(i), p1(i), p2(i), tolerance=1e-9_R8P)
   colt_hst(i) = is_collinear_R8P_dev(q(i), p1(i), p2(i), tolerance=1e-9_R8P)
   ccl_ref(i) = is_concyclic_R8P(c0(i), c1(i), c2(i), c3(i))
   ccl_hst(i) = is_concyclic_R8P_dev(c0(i), c1(i), c2(i), c3(i))
   cclt_ref(i) = is_concyclic_R8P(c0(i), c1(i), c2(i), c3(i), tolerance=1e-9_R8P)
   cclt_hst(i) = is_concyclic_R8P_dev(c0(i), c1(i), c2(i), c3(i), tolerance=1e-9_R8P)
   rax_ref(i) = p0(i)
   call rax_ref(i)%rotate(axis=p1(i), angle=ang(i))
   rax_hst(i) = p0(i)
   call rotate_by_axis_angle_R8P_dev(rax_hst(i), p1(i), ang(i))
   rmx_ref(i) = p0(i)
   call rmx_ref(i)%rotate(matrix=rotm(:,:,i))
   rmx_hst(i) = p0(i)
   call rotate_by_matrix_R8P_dev(rmx_hst(i), rotm(:,:,i))
   mnr_ref(i) = p0(i)
   call mnr_ref(i)%mirror(normal=p2(i))
   mnr_hst(i) = p0(i)
   call mirror_by_normal_R8P_dev(mnr_hst(i), p2(i))
   mmx_ref(i) = p0(i)
   call mmx_ref(i)%mirror(matrix=mirm(:,:,i))
   mmx_hst(i) = p0(i)
   call mirror_by_matrix_R8P_dev(mmx_hst(i), mirm(:,:,i))
   agl_ref(i) = angle_R8P(p0(i), p1(i))
   agl_hst(i) = angle_R8P_dev(p0(i), p1(i))
   call normalized_checked_R8P(p0(i), nck_ref(i), okk_ref(i))
   call normalized_checked_R8P_dev(p0(i), nck_hst(i), okk_hst(i))
   call normalized_checked_R8P(p0(i), nc5_ref(i), ok5_ref(i), min_norm=50._R8P)
   call normalized_checked_R8P_dev(p0(i), nc5_hst(i), ok5_hst(i), min_norm=50._R8P)
   cxa_ref(i) = crossproduct_accurate_R8P(p1(i), p2(i))
   call crossproduct_accurate_R8P_dev(p1(i), p2(i), cxa_hst(i))
   dta_ref(i) = dotproduct_accurate_R8P(p1(i), p2(i))
   dta_hst(i) = dotproduct_accurate_R8P_dev(p1(i), p2(i))
enddo

call check_real('normL2_dev', nrm_dev, nrm_ref, nrm_hst)
call check_real('sq_norm_dev', sq_dev, sq_ref, sq_hst)
call check_vec('normalized_dev', nzd_dev, nzd_ref, nzd_hst)
call check_vec('normalize_dev', nze_dev, nze_ref, nze_hst)
! parallel, orthogonal: nvfortran contracts the dot product of `.paral.` into FMAs differently on the host form and on
! the `_dev` form, depending on the compilation context (below 1 ulp; gfortran is bit-exact). The dot product changes
! by at most 2*gamma_3*sum|a_k*b_k| <= 6*eps*|a||b|, that is at most 6*eps*|a| on each component of the parallel part;
! the subtraction adds one rounding.
do i = 1, n
   ort_bnd(:,i) = 8 * epsilon(1._R8P) * (normL2_R8P(p1(i)) + abs([par_ref(i)%x, par_ref(i)%y, par_ref(i)%z]))
enddo
call check_vec_bound('parallel_dev', par_dev, par_ref, par_hst, ort_bnd)
call check_vec_bound('orthogonal_dev', ort_dev, ort_ref, ort_hst, ort_bnd)
! distance_to_line: |u x v| / |s|, u = a - pt1, v = a - pt2, s = pt2 - pt1. The cross product components change by at
! most ~2*eps*|u||v| when nvfortran contracts them into FMAs (gfortran is bit-exact), the norms and the division add
! a few roundings: bound 16*eps*(|u||v|/|s| + d).
do i = 1, n
   dtl_bnd(i) = 16 * epsilon(1._R8P) * (normL2_R8P(p0(i) - p1(i)) * normL2_R8P(p0(i) - p2(i)) / normL2_R8P(p2(i) - p1(i)) &
                                        + dtl_ref(i))
enddo
call check_real_bound('distance_to_line_dev', dtl_dev, dtl_ref, dtl_hst, dtl_bnd)
! face normals: w = s12 x s13 (d13 x d24 for face_normal4). Unnormalized, each component changes by at most ~2*eps*
! |s12||s13| under FMA contraction: bound 4*eps*|s12||s13|. Normalized, the direction of w changes by ~eps times the
! condition |s12||s13|/|w| of the cross product: bound 16*eps*(1 + |s12||s13|/|w|) on the unit components.
do i = 1, n
   f3_bnd(:,i) = 4 * epsilon(1._R8P) * normL2_R8P(p2(i) - p1(i)) * normL2_R8P(p3(i) - p1(i))
   cnd = cond_cross(p2(i) - p1(i), p3(i) - p1(i))
   f3n_bnd(:,i) = 16 * epsilon(1._R8P) * (1._R8P + cnd)
   f4_bnd(:,i) = 4 * epsilon(1._R8P) * normL2_R8P(p2(i) - p0(i)) * normL2_R8P(p3(i) - p1(i))
   cnd = cond_cross(p2(i) - p0(i), p3(i) - p1(i))
   f4n_bnd(:,i) = 16 * epsilon(1._R8P) * (1._R8P + cnd)
enddo
call check_vec_bound('face_normal3_dev norm', f3n_dev, f3n_ref, f3n_hst, f3n_bnd)
call check_vec_bound('face_normal3_dev', f3a_dev, f3a_ref, f3a_hst, f3_bnd)
call check_vec_bound('face_normal4_dev norm', f4n_dev, f4n_ref, f4n_hst, f4n_bnd)
call check_vec_bound('face_normal4_dev', f4a_dev, f4a_ref, f4a_hst, f4_bnd)
! plane family: d = n.r, r = a - pt1, n the unit normal of the face (error ~16*eps*(1 + cond), see face normals): bound
! 32*eps*|r|*(1 + cond) on d and on the components of d*n; the projection a - d*n adds one rounding of |a_i|.
do i = 1, n
   cnd = cond_cross(p2(i) - p1(i), p3(i) - p1(i))
   dtp_bnd(i) = 32 * epsilon(1._R8P) * normL2_R8P(p0(i) - p1(i)) * (1._R8P + cnd)
   dvp_bnd(:,i) = dtp_bnd(i)
   prj_bnd(:,i) = dtp_bnd(i) + 2 * epsilon(1._R8P) * abs([p0(i)%x, p0(i)%y, p0(i)%z])
enddo
call check_real_bound('distance_to_plane_dev', dtp_dev, dtp_ref, dtp_hst, dtp_bnd)
call check_vec_bound('distance_vectorial_to_plane_dev', dvp_dev, dvp_ref, dvp_hst, dvp_bnd)
call check_vec_bound('projection_onto_plane_dev', prj_dev, prj_ref, prj_hst, prj_bnd)
! predicates: without tolerance, points exactly on the line or circle (odd i) sit on the threshold, where a rounding
! difference (FMA contraction) legitimately flips the answer: compared only on the points off it (even i). With
! tolerance 1e-9, far above rounding, every point is compared.
call check_logical('is_collinear_dev', col_dev(2::2), col_ref(2::2), col_hst(2::2))
call check_logical('is_collinear_dev tolerance', colt_dev, colt_ref, colt_hst)
call check_logical('is_concyclic_dev', ccl_dev(2::2), ccl_ref(2::2), ccl_hst(2::2))
call check_logical('is_concyclic_dev tolerance', cclt_dev, cclt_ref, cclt_hst)
! both outcomes must occur, or the predicates are not exercised
if (count(colt_ref) == 0 .or. count(.not. colt_ref) == 0 .or. count(cclt_ref) == 0 .or. count(.not. cclt_ref) == 0) then
   print "(A)", "is_collinear/is_concyclic: the data do not exercise both outcomes"
   all_passed = .false.
endif
! rotate/mirror: the host forms apply matmul (summation order the compiler's: 6*eps*sum|m_ij*a_j|) to matrices whose
! elements are at most 1 in magnitude; by axis/angle the device sin/cos also differ in the last bit (rotation_matrix:
! at most 1 ulp of 1.0 per element). Bound 16*eps*(|a_x| + |a_y| + |a_z|) with the matrix built inside, 8*eps*(...)
! with the matrix given.
do i = 1, n
   trf_bnd(:,i) = 16 * epsilon(1._R8P) * (abs(p0(i)%x) + abs(p0(i)%y) + abs(p0(i)%z))
   trm_bnd(:,i) = 8 * epsilon(1._R8P) * (abs(p0(i)%x) + abs(p0(i)%y) + abs(p0(i)%z))
enddo
call check_vec_bound('rotate_by_axis_angle_dev', rax_dev, rax_ref, rax_hst, trf_bnd)
call check_vec_bound('rotate_by_matrix_dev', rmx_dev, rmx_ref, rmx_hst, trm_bnd)
call check_vec_bound('mirror_by_normal_dev', mnr_dev, mnr_ref, mnr_hst, trf_bnd)
call check_vec_bound('mirror_by_matrix_dev', mmx_dev, mmx_ref, mmx_hst, trm_bnd)
! angle: atan2(|v1 x v2|, v1.v2) of unit vectors; FMA contraction moves sin and cos by a few eps, which moves the
! angle by about as much (d(atan2) = (c*ds - s*dc)/(s**2 + c**2)), and the device atan2 can differ in the last bit:
! absolute bound 16*eps (the angle is at most pi).
agl_bnd = 16 * epsilon(1._R8P)
call check_real_bound('angle_dev', agl_dev, agl_ref, agl_hst, agl_bnd)
call check_vec('normalized_checked_dev', nck_dev, nck_ref, nck_hst)
call check_logical('normalized_checked_dev ok', okk_dev, okk_ref, okk_hst)
call check_vec('normalized_checked_dev min_norm', nc5_dev, nc5_ref, nc5_hst)
call check_logical('normalized_checked_dev min_norm ok', ok5_dev, ok5_ref, ok5_hst)
if (okk_ref(1) .or. count(ok5_ref) == 0 .or. count(.not. ok5_ref) == 0) then
   print "(A)", "normalized_checked: the data do not exercise both outcomes"
   all_passed = .false.
endif
call check_vec('crossproduct_accurate_dev', cxa_dev, cxa_ref, cxa_hst)
call check_real('dotproduct_accurate_dev', dta_dev, dta_ref, dta_hst)

#ifdef _OPENACC
if (.not. all(on_device)) then
   print "(A,I0,A,I0)", "device loop ran on the host for iterations: ", count(.not. on_device), " of ", n
   all_passed = .false.
endif
#endif

print "(A,L1)", "Are all tests passed? ", all_passed
if (.not. all_passed) error stop "vecfor_test_device_geometry FAILED"
contains
   subroutine check_real(label, dev, ref, hst, tol)
   !< Host `_dev` bit-exact vs reference; device vs reference bit-exact, or within `tol` when given.
   character(*), intent(in)           :: label    !< Entry point.
   real(R8P),    intent(in)           :: dev(:)   !< Device results.
   real(R8P),    intent(in)           :: ref(:)   !< Host reference results.
   real(R8P),    intent(in)           :: hst(:)   !< Host `_dev` results.
   real(R8P),    intent(in), optional :: tol      !< Device vs host tolerance.

   if (any(hst /= ref)) then
      print "(A,A,I0)", label, " on the host differs from the host procedure, elements: ", count(hst /= ref)
      all_passed = .false.
   endif
   if (present(tol)) then
      if (any(abs(dev - ref) > tol)) then
         print "(A,A,ES10.3)", label, " on the device off the host by: ", maxval(abs(dev - ref))
         all_passed = .false.
      endif
   elseif (any(dev /= ref)) then
      print "(A,A,I0,A,ES10.3)", label, " on the device differs from the host, elements: ", count(dev /= ref), &
                                 ", max abs diff: ", maxval(abs(dev - ref))
      all_passed = .false.
   endif
   endsubroutine check_real

   subroutine check_vec(label, dev, ref, hst)
   !< Host `_dev` and device bit-exact vs the host reference, component by component.
   character(*),     intent(in) :: label  !< Entry point.
   type(vector_R8P), intent(in) :: dev(:) !< Device results.
   type(vector_R8P), intent(in) :: ref(:) !< Host reference results.
   type(vector_R8P), intent(in) :: hst(:) !< Host `_dev` results.

   call check_real(label//' x', dev%x, ref%x, hst%x)
   call check_real(label//' y', dev%y, ref%y, hst%y)
   call check_real(label//' z', dev%z, ref%z, hst%z)
   endsubroutine check_vec

   subroutine check_vec_bound(label, dev, ref, hst, bnd)
   !< Host `_dev` and device within the per-component bound `bnd(3,:)` of the host reference.
   character(*),     intent(in) :: label    !< Entry point.
   type(vector_R8P), intent(in) :: dev(:)   !< Device results.
   type(vector_R8P), intent(in) :: ref(:)   !< Host reference results.
   type(vector_R8P), intent(in) :: hst(:)   !< Host `_dev` results.
   real(R8P),        intent(in) :: bnd(:,:) !< Bound of each component.

   if (any(abs(hst%x - ref%x) > bnd(1,:) .or. abs(hst%y - ref%y) > bnd(2,:) .or. abs(hst%z - ref%z) > bnd(3,:))) then
      print "(A,A)", label, " on the host differs from the host procedure beyond the bound"
      all_passed = .false.
   endif
   if (any(abs(dev%x - ref%x) > bnd(1,:) .or. abs(dev%y - ref%y) > bnd(2,:) .or. abs(dev%z - ref%z) > bnd(3,:))) then
      print "(A,A,ES10.3)", label, " on the device differs from the host beyond the bound, max abs diff: ", &
         maxval(abs([dev%x - ref%x, dev%y - ref%y, dev%z - ref%z]))
      all_passed = .false.
   endif
   endsubroutine check_vec_bound

   subroutine check_real_bound(label, dev, ref, hst, bnd)
   !< Host `_dev` and device within the bound `bnd(:)` of the host reference.
   character(*), intent(in) :: label  !< Entry point.
   real(R8P),    intent(in) :: dev(:) !< Device results.
   real(R8P),    intent(in) :: ref(:) !< Host reference results.
   real(R8P),    intent(in) :: hst(:) !< Host `_dev` results.
   real(R8P),    intent(in) :: bnd(:) !< Bound of each element.

   if (any(abs(hst - ref) > bnd)) then
      print "(A,A)", label, " on the host differs from the host procedure beyond the bound"
      all_passed = .false.
   endif
   if (any(abs(dev - ref) > bnd)) then
      print "(A,A,ES10.3)", label, " on the device differs from the host beyond the bound, max abs diff: ", &
         maxval(abs(dev - ref))
      all_passed = .false.
   endif
   endsubroutine check_real_bound

   function cond_cross(u, v) result(cnd)
   !< Condition of the cross product `u x v`: `|u||v| / |u x v|`.
   type(vector_R8P), intent(in) :: u   !< First vector.
   type(vector_R8P), intent(in) :: v   !< Second vector.
   real(R8P)                    :: cnd !< Condition.
   type(vector_R8P)             :: w   !< `u x v`.

   w = u%crossproduct(v)
   cnd = u%normL2() * v%normL2() / w%normL2()
   endfunction cond_cross

   subroutine check_logical(label, dev, ref, hst)
   !< Host `_dev` and device equal to the host reference.
   character(*), intent(in) :: label  !< Entry point.
   logical,      intent(in) :: dev(:) !< Device results.
   logical,      intent(in) :: ref(:) !< Host reference results.
   logical,      intent(in) :: hst(:) !< Host `_dev` results.

   if (any(hst .neqv. ref)) then
      print "(A,A,I0)", label, " on the host differs from the host procedure, elements: ", count(hst .neqv. ref)
      all_passed = .false.
   endif
   if (any(dev .neqv. ref)) then
      print "(A,A,I0)", label, " on the device differs from the host, elements: ", count(dev .neqv. ref)
      all_passed = .false.
   endif
   endsubroutine check_logical
endprogram vecfor_test_device_geometry
