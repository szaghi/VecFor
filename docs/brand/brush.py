"""Sumi brush engine for the VecFor marks: tapered, slightly wavering strokes as filled outlines,
dry-brush (kasure) slivers, brushed arrowheads, and the brushed AMR quadtree ground."""
import math, random
from shapely.geometry import Polygon, MultiPolygon, LineString, box
from shapely.ops import unary_union
from shapely import affinity


# ---------------------------------------------------------------- small vector helpers
def add(a, b): return (a[0] + b[0], a[1] + b[1])
def sub(a, b): return (a[0] - b[0], a[1] - b[1])
def mul(a, s): return (a[0] * s, a[1] * s)
def nrm(a):
    L = math.hypot(*a) or 1.0
    return (a[0] / L, a[1] / L)
def perp(a): return (-a[1], a[0])
def rot(a, deg):
    c, s = math.cos(math.radians(deg)), math.sin(math.radians(deg))
    return (a[0] * c - a[1] * s, a[0] * s + a[1] * c)
def lerp(a, b, t): return (a[0] + (b[0] - a[0]) * t, a[1] + (b[1] - a[1]) * t)
def arc(c, r, a0, a1, n=24, ry=None):
    ry = r if ry is None else ry
    return [(c[0] + r * math.cos(math.radians(a0 + (a1 - a0) * i / n)),
             c[1] + ry * math.sin(math.radians(a0 + (a1 - a0) * i / n))) for i in range(n + 1)]


# ---------------------------------------------------------------- paths
def catmull(pts, k=10):
    if len(pts) < 3:
        return list(pts)
    P = [pts[0]] + list(pts) + [pts[-1]]
    out = []
    for i in range(1, len(P) - 2):
        p0, p1, p2, p3 = P[i - 1], P[i], P[i + 1], P[i + 2]
        for j in range(k):
            t = j / k; t2, t3 = t * t, t * t * t
            out.append(tuple(0.5 * ((2 * p1[d]) + (-p0[d] + p2[d]) * t + (2 * p0[d] - 5 * p1[d] + 4 * p2[d] - p3[d]) * t2
                                    + (-p0[d] + 3 * p1[d] - 3 * p2[d] + p3[d]) * t3) for d in (0, 1)))
    out.append(pts[-1])
    return out


def resample(pts, step=0.25):
    seg = [math.dist(pts[i], pts[i + 1]) for i in range(len(pts) - 1)]
    L = sum(seg)
    n = max(2, int(L / step))
    out, i, acc = [], 0, 0.0
    for j in range(n + 1):
        s = L * j / n
        while i < len(seg) - 1 and acc + seg[i] < s:
            acc += seg[i]; i += 1
        t = 0 if seg[i] == 0 else (s - acc) / seg[i]
        out.append(lerp(pts[i], pts[i + 1], min(max(t, 0), 1)))
    return out, L


class Noise:
    """smooth 1-D value noise on [0, 1]"""
    def __init__(self, seed, knots=7):
        r = random.Random(seed)
        self.v = [r.uniform(-1, 1) for _ in range(knots + 1)]
        self.k = knots
    def __call__(self, t):
        x = min(max(t, 0), 1) * self.k
        i = min(int(x), self.k - 1); f = x - i
        f = (1 - math.cos(math.pi * f)) / 2
        return self.v[i] * (1 - f) + self.v[i + 1] * f


def profile(name, t):
    if name == 'load':      # loaded start, long sharp release: the sumi stroke
        return (0.78 + 0.22 * math.sin(math.pi / 2 * min(t / 0.18, 1))) * (1 - 0.82 * t ** 2.4)
    if name == 'even':      # a steady hand, barely lifting at the end
        return 1 - 0.35 * t ** 5
    if name == 'lens':      # a dab: pressed in the middle, both ends sharp (a shock diamond)
        return max(1 - abs(2 * t - 1), 0) ** 0.9
    if name == 'wedge':     # an arrowhead painted from its base to the tip
        return max(1 - t, 0) ** 0.92
    if name == 'flick':     # a barb: pressed at the tip, flicked away
        return (1 - t) ** 1.3
    if name == 'swell':     # thin entry, pressed exit (a stroke that ends in a tip set by a wedge)
        return 0.55 + 0.45 * math.sin(math.pi / 2 * t)
    if name == 'dry':       # a dry streak: a thread of paper that widens as the ink runs out
        return 0.12 + 0.88 * t ** 0.85
    if name == 'hair':      # hairline entry, quick press, long release
        return (0.18 + 0.82 * math.sin(math.pi / 2 * min(t / 0.22, 1))) * (1 - 0.88 * t ** 2.0)
    if name == 'comma':     # a ten (点): round pressed head, quick tail
        return (1 - t) ** 0.85 * (0.7 + 0.3 * math.sin(math.pi / 2 * min(t / 0.12, 1)))
    if name == 'harai':     # a sweeping release: steady, then a long taper to nothing
        return 1 if t < 0.35 else max(1 - ((t - 0.35) / 0.65) ** 1.15, 0)
    if isinstance(name, tuple) and name[0] == 'ippitsu':   # one gesture: hairline fin tip, hull, spear-head nose
        b0, bc, bw = name[1:]
        base = b0 + (0.34 - b0) * (1 - math.cos(math.pi * min(t / 0.3, 1))) / 2
        if t <= bc:
            return base + bw * math.exp(-((t - bc) / 0.09) ** 2)
        u = (t - bc) / (1 - bc)
        return (0.34 + bw) * max(1 - u, 0) ** 1.25 * (1 + 0.25 * math.sin(math.pi * u))
    raise ValueError(name)


def stroke(pts, w, prof='load', rough=0.07, wob=0.12, seed=1, smooth=True, cap0=True, cap1=True, step=0.25, edge=0.0):
    """pts: centre line; w: full width at the press. returns a shapely polygon"""
    C = catmull(pts) if smooth else list(pts)
    P, L = resample(C, step)
    n = len(P)
    nz, nw = Noise(seed, 6), Noise(seed * 7 + 3, 5)
    kn = max(6, int(L / 1.6))
    eL, eR = Noise(seed * 13 + 5, kn), Noise(seed * 17 + 11, kn)
    eL2, eR2 = Noise(seed * 19 + 2, kn * 3), Noise(seed * 23 + 7, kn * 3)
    left, right, half = [], [], []
    for i, p in enumerate(P):
        t = i / (n - 1)
        a, b = P[max(i - 1, 0)], P[min(i + 1, n - 1)]
        nn = perp(nrm(sub(b, a)))
        hw = 0.5 * w * profile(prof, t) * (1 + rough * nz(t))
        hw = max(hw, 0.0)
        c = add(p, mul(nn, wob * nw(t)))
        half.append(hw)
        hl = hw * (1 + edge * (0.7 * eL(t) + 0.45 * eL2(t)))
        hr = hw * (1 + edge * (0.7 * eR(t) + 0.45 * eR2(t)))
        left.append(add(c, mul(nn, hl)))
        right.append(sub(c, mul(nn, hr)))
    ring = list(left)
    if cap1 and half[-1] > 0.15:
        d = nrm(sub(P[-1], P[-2])); nn = perp(d)
        ring += [add(P[-1], add(mul(nn, half[-1] * math.cos(a)), mul(d, half[-1] * math.sin(a))))
                 for a in [math.pi * k / 10 for k in range(1, 10)]][::-1] if False else \
                [add(P[-1], add(mul(nn, half[-1] * math.cos(math.pi * k / 10)), mul(d, half[-1] * math.sin(math.pi * k / 10))))
                 for k in range(1, 10)]
    ring += right[::-1]
    if cap0 and half[0] > 0.15:
        d = nrm(sub(P[1], P[0])); nn = perp(d)
        ring += [add(P[0], add(mul(nn, -half[0] * math.cos(math.pi * k / 10)), mul(d, -half[0] * math.sin(math.pi * k / 10))))
                 for k in range(1, 10)]
    poly = Polygon(ring)
    if not poly.is_valid:
        from shapely.validation import make_valid
        mv = make_valid(poly)
        poly = unary_union([g for g in getattr(mv, 'geoms', [mv]) if g.geom_type in ('Polygon', 'MultiPolygon')])
    return poly.buffer(0)


def kasure(poly, pts, w, seed=3, n=3, t0=(0.5, 0.75), thick=(0.16, 0.3), smooth=True, t1=1.0, spread=0.8, run=2.0):
    """dry brush: streaks of bare paper that open where the brush runs dry; each streak starts thin, widens as it
    runs out, wavers, and is sometimes bridged by ink"""
    C = catmull(pts) if smooth else list(pts)
    P, L = resample(C, 0.2)
    r = random.Random(seed)
    cuts = []
    for k in range(n):
        a = r.uniform(*t0)
        lat = ((k + 0.5) / n - 0.5) * 2 * 0.5 + r.uniform(-0.1, 0.1)
        e = min(t1 * r.uniform(0.9, 1.0), 1.0) if t1 < 1.0 else 1.0
        i0, i1 = int(a * (len(P) - 1)), int(e * (len(P) - 1))
        if i1 - i0 < 4:
            continue
        nz = Noise(seed * 31 + k, 5)
        seg = []
        for i in range(i0, i1 + 1):
            p, q = P[max(i - 1, 0)], P[min(i + 1, len(P) - 1)]
            nn = perp(nrm(sub(q, p)))
            tt = (i - i0) / (i1 - i0)
            seg.append(add(P[i], mul(nn, (lat + 0.06 * nz(tt)) * w * spread)))
        if t1 >= 1.0:
            d = nrm(sub(P[-1], P[-2]))
            seg.append(add(seg[-1], mul(d, run)))
        tw = r.uniform(*thick) * 2.4
        sl = stroke(seg, tw, 'dry', rough=0.25, wob=0.0, seed=seed * 7 + k, smooth=False, cap0=False, cap1=True, step=0.15)
        if r.random() < 0.45 and len(seg) > 12:   # an ink bridge across the streak
            j = r.randint(len(seg) // 4, len(seg) // 2)
            br = Polygon([add(seg[j], v) for v in ((-0.5, -0.5), (0.5, -0.5), (0.5, 0.5), (-0.5, 0.5))]).buffer(0.35 * w * 0.25 + 0.2)
            sl = sl.difference(br)
        cuts.append(sl)
    return poly.difference(unary_union(cuts)) if cuts else poly


def wedge(base, tip, width, rough=0.05, seed=5, edge=0.0):
    """a brushed arrowhead: pressed at its base, drawn out to the point"""
    return stroke([base, lerp(base, tip, 0.5), tip], width, 'wedge', rough=rough, wob=0.04, seed=seed,
                  smooth=False, cap0=False, cap1=False, step=0.12, edge=edge)


def nib(p, w, angle, seed=1, edge=0.08):
    """the brush laid down at an angle: the blunt, oblique start of a sumi stroke"""
    r = random.Random(seed)
    pts = []
    for i in range(28):
        a = math.tau * i / 28
        rr = 1 + edge * r.uniform(-1, 1)
        q = (0.5 * w * 0.95 * math.cos(a) * rr, 0.5 * w * 0.62 * math.sin(a) * rr)
        q = rot(q, angle)
        pts.append(add(p, q))
    return Polygon(pts).buffer(0)


def sumi(pts, w, prof='load', rough=0.08, wob=0.12, seed=1, edge=0.07, entry=None, entry_w=1.15, dry=0, dry_t=(0.35, 0.6),
         dry_t1=1.0, dry_thick=(0.14, 0.28), split=0, split_at=0.72, split_thick=(0.12, 0.2), cap0=True, cap1=False,
         smooth=True, step=0.25):
    """a sumi stroke: bristle edges, an oblique entry, dry-brush streaks and a tail that splits into strands"""
    g = stroke(pts, w, prof, rough=rough, wob=wob, seed=seed, smooth=smooth, cap0=cap0 and entry is None, cap1=cap1, step=step, edge=edge)
    if entry is not None:
        g = unary_union([g, nib(pts[0], w * entry_w, entry, seed=seed + 101, edge=edge * 1.2)])
    if dry:
        g = kasure(g, pts, w, seed=seed + 7, n=dry, t0=dry_t, t1=dry_t1, thick=dry_thick, smooth=smooth, spread=0.7)
    if split:
        g = kasure(g, pts, w, seed=seed + 13, n=split - 1, t0=(split_at, split_at + 0.06), thick=split_thick, smooth=smooth,
                   spread=0.55, run=3.0)
    return g


def barbs(tip, back_dir, length, width, spread=28, seed=9, rough=0.06):
    """two flicks leaving the tip of an arrow"""
    d = nrm(back_dir)
    out = []
    for s, k in ((1, 0), (-1, 1)):
        e = add(tip, mul(rot(d, s * spread), length))
        m = add(lerp(tip, e, 0.5), mul(perp(rot(d, s * spread)), s * 0.12 * length))
        out.append(stroke([tip, m, e], width, 'flick', rough=rough, wob=0.05, seed=seed + k, cap0=True, cap1=False, step=0.12))
    return unary_union(out)


def arrow(a, b, w, hand, seed=1, head=None, prof=None):
    """an arrow from a to b in a given hand: hand['head'] is 'wedge' or 'barb'"""
    head = head or hand['head']
    d = nrm(sub(b, a)); L = math.dist(a, b)
    hl = min(hand.get('hl', 2.6) * w, 0.42 * L)
    prof = prof or hand.get('prof', 'load')
    if head == 'wedge':
        base = sub(b, mul(d, hl))
        sh = stroke([a, lerp(a, base, 0.5), add(base, mul(d, 0.3 * w))], w, 'even' if prof == 'load' else prof,
                    rough=hand['rough'], wob=hand['wob'], seed=seed, cap1=False, edge=hand.get('edge', 0))
        hd = wedge(base, b, w * hand.get('hw', 2.4), rough=hand['rough'] * 0.6, seed=seed + 40, edge=hand.get('edge', 0))
        return unary_union([sh, hd])
    sh = stroke([a, lerp(a, b, 0.5), b], w, 'swell' if prof == 'load' else prof, rough=hand['rough'], wob=hand['wob'], seed=seed,
                edge=hand.get('edge', 0))
    bb = barbs(b, mul(d, -1), hl * 1.15, w * 0.95, spread=hand.get('spread', 30), seed=seed + 50, rough=hand['rough'])
    return unary_union([sh, bb])


# ---------------------------------------------------------------- svg output
def fmt(x): return f"{x:.2f}"


def d_of(geom):
    if geom.is_empty:
        return ""
    polys = geom.geoms if isinstance(geom, MultiPolygon) else [geom] if isinstance(geom, Polygon) else \
        [g for g in getattr(geom, 'geoms', []) if isinstance(g, Polygon)]
    parts = []
    for p in polys:
        for ring in [p.exterior] + list(p.interiors):
            c = list(ring.coords)[:-1]
            c = simplify_ring(c)
            parts.append("M" + " L".join(f"{fmt(x)} {fmt(y)}" for x, y in c) + " Z")
    return " ".join(parts)


def simplify_ring(c, tol=0.04):
    if len(c) < 8:
        return c
    g = Polygon(c).exterior.simplify(tol)
    return list(g.coords)[:-1]


def path(geom, fill):
    d = d_of(geom)
    return f'<path fill="{fill}" fill-rule="evenodd" d="{d}"/>' if d else ""


# ---------------------------------------------------------------- the family seal (quadrant carved square)
def seal(color, cut, x=50, y=4, s=10):
    k = s / 10
    def R(a, b, w, h, fill=None, stroke=None, sw=None):
        if stroke:
            return f'<rect x="{fmt(x + a * k)}" y="{fmt(y + b * k)}" width="{fmt(w * k)}" height="{fmt(h * k)}" fill="none" stroke="{stroke}" stroke-width="{fmt(sw * k)}"/>'
        return f'<rect x="{fmt(x + a * k)}" y="{fmt(y + b * k)}" width="{fmt(w * k)}" height="{fmt(h * k)}" fill="{fill}"/>'
    return (f'<rect x="{fmt(x)}" y="{fmt(y)}" width="{fmt(s)}" height="{fmt(s)}" rx="{fmt(k)}" fill="{color}"/>'
            + R(5.3, 5.3, 1.25, 1.25, cut) + R(7.15, 5.3, 1.25, 1.25, cut) + R(5.3, 7.15, 1.25, 1.25, cut)
            + R(7.15, 7.15, .33, .33, cut) + R(8.07, 7.15, .33, .33, cut) + R(7.15, 8.08, .33, .33, cut) + R(8.07, 8.08, .33, .33, cut)
            + R(1.6, 1.6, 3.1, 3.1, stroke=cut, sw=.7))


# ---------------------------------------------------------------- brushed AMR ground
def amr_mesh(ink, color, size=64, base=8, levels=(1.6, 0.35)):
    """balanced quadtree: one level deeper wherever the ink is; the finest lines are the thinnest"""
    near = [ink.buffer(levels[0]), ink.buffer(levels[1])]
    leaves = {}
    def rec(x, y, s, lev):
        if lev < 2 and near[lev].intersects(box(x, y, x + s, y + s)):
            h = s / 2
            for dx in (0, h):
                for dy in (0, h):
                    rec(x + dx, y + dy, h, lev + 1)
        else:
            leaves[(x, y, s)] = lev
    for x in range(0, size, base):
        for y in range(0, size, base):
            rec(x, y, base, 0)
    # 2:1 balance, with a lookup of the leaf level on the finest (base/4) lattice
    u = base / 4
    lv = {}
    def paint(x, y, s, lev):
        for i in range(int(s / u)):
            for j in range(int(s / u)):
                lv[(int(x / u) + i, int(y / u) + j)] = lev
    for (x, y, s), lev in leaves.items():
        paint(x, y, s, lev)
    changed = True
    while changed:
        changed = False
        for (x, y, s), lev in sorted(leaves.items()):
            if lev >= 1 and False:
                pass
            m = int(s / u); gx, gy = int(x / u), int(y / u)
            nb = [(gx - 1, gy + k) for k in range(m)] + [(gx + m, gy + k) for k in range(m)] + \
                 [(gx + k, gy - 1) for k in range(m)] + [(gx + k, gy + m) for k in range(m)]
            if any(lv.get(c, -9) >= lev + 2 for c in nb):
                del leaves[(x, y, s)]
                h = s / 2
                for dx in (0, h):
                    for dy in (0, h):
                        leaves[(x + dx, y + dy, h)] = lev + 1
                        paint(x + dx, y + dy, h, lev + 1)
                changed = True
    widths = {0: 0.22, 1: 0.14, 2: 0.10}
    segs = {0: set(), 1: set(), 2: set()}
    for (x, y, s), lev in leaves.items():
        for e in (((x, y), (x + s, y)), ((x, y), (x, y + s)), ((x + s, y), (x + s, y + s)), ((x, y + s), (x + s, y + s))):
            segs[lev].add(e)
    for lev in (1, 0):   # an edge already drawn finer is not drawn coarser
        pass
    out = [f'<g stroke="{color}" stroke-linecap="round" opacity="0.55" fill="none">']
    for lev in (0, 1, 2):
        d = "".join(f"M{fmt(a[0]).rstrip('0').rstrip('.')} {fmt(a[1]).rstrip('0').rstrip('.')}L{fmt(b[0]).rstrip('0').rstrip('.')} {fmt(b[1]).rstrip('0').rstrip('.')}"
                    for a, b in sorted(segs[lev]))
        if d:
            out.append(f'<path d="{d}" stroke-width="{widths[lev]}"/>')
    out.append('</g>')
    return "".join(out)
