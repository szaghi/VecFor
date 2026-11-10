#!/usr/bin/env python3
"""Generate the VecFor identity, Naruto in Beni: python3 docs/brand/naruto.py [DOCS_DIR]

Writes, under DOCS_DIR (default: the docs/ folder this script lives in):
  public/logo.svg, public/logo-dark.svg      nav and hero logo (VitePress picks one by the theme toggle)
  public/favicon.svg                         the small cut: coarser field, thicker arrows; follows the OS theme
  public/favicon-16.png, favicon-32.png,     PNG fallbacks and the iOS home-screen icon, washi tile
  public/apple-touch-icon.png                (rendered with rsvg-convert when it is installed)
  public/icons/<name>.svg, <name>-dark.svg   the eight feature icons of the home page

The mark: a quiver field sampled on a regular grid from one 2-D flow, a point vortex with a smooth core plus a gentle
sink, u = G/2pi (-dy, dx)/(r^2 + rc^2) - Q/2pi (dx, dy)/(r^2 + rc^2), after Hiroshige's "Awa Province: Naruto
Whirlpools" (1855); a crimson carp curves round the top of the whirlpool, swimming against the turn. Arrow length
grows with the local speed; arrows that would cross the carp are left out. Under the mark, the family's brushed AMR
ground (a quadtree refined under the ink) and the family seal. Every shape is generated: never hand-edit the SVGs,
change this script and run it again. The brush itself is brush.py (tapered strokes, bristle edges, dry streaks).

Palette Beni (safflower crimson), washi and night: see INK below and docs/.vitepress/theme/style.css."""
import math, os, shutil, subprocess, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from brush import *            # stroke, sumi, wedge, arc, vector helpers, amr_mesh, seal, path
from shapely.geometry import Polygon, LineString
from shapely.ops import unary_union

INK = {
    'light': dict(ground='#f3ede1', ink='#1f1a1a', mesh='#716868', carp='#c92a2a', seal='#c92a2a'),
    'dark':  dict(ground='#120e0f', ink='#f0e7e7', mesh='#908586', carp='#ff6b6b', seal='#ff6b6b'),
}
ROLE = {'ink': 'ink', 'accent': 'carp'}


# ---------------------------------------------------------------- the mark
def qarrow(a, b, w, seed, fav=False, spread=30):
    """a small brushed quiver arrow: a pressed stroke and two flicked barbs"""
    d = nrm(sub(b, a)); L = math.dist(a, b)
    sh = sumi([a, lerp(a, b, 0.5), b], w, 'swell', seed=seed, edge=0.1, rough=0.08, entry=None)
    hl = max(min(2.6 * w, 0.48 * L), 1.5)
    bb = []
    for s in (1, -1):
        e = add(b, mul(rot(mul(d, -1), s * spread), hl))
        bb.append(sumi([b, lerp(b, e, 0.5), e], w * (0.8 if spread > 31 else 0.9), 'flick', seed=seed + (3 if s > 0 else 4), edge=0.1))
    return unary_union([sh] + bb)


def flow(x, y, uni=(0.0, 0.0), vort=(), sink=None):
    u, v = uni
    for (xv, yv, G, rc) in vort:
        dx, dy = x - xv, y - yv
        q = G / (2 * math.pi * (dx * dx + dy * dy + rc * rc))
        u += -q * dy; v += q * dx
    if sink:
        xs, ys, Q, rc = sink
        dx, dy = x - xs, y - ys
        q = Q / (2 * math.pi * (dx * dx + dy * dy + rc * rc))
        u -= q * dx; v -= q * dy
    return u, v


def quiver(field, avoid, k=1.0, fav=False, step=7.4, x0=4.6, y0=4.6, vref=1.0, Lmin=3.0, Lmax=7.0, w=1.45, seed=900):
    if fav:
        step, x0, y0, Lmin, Lmax, w = 13.0, 6.5, 6.5, 5.5, 11.5, 2.6
    arrows = []
    n = int((64 - x0) / step) + 1
    keep = avoid.buffer(2.6 if not fav else 3.5)
    for i in range(n):
        for j in range(n):
            x, y = x0 + i * step, y0 + j * step
            if x > 64 - 1 or y > 64 - 1:
                continue
            if not fav and x > 45.5 and y < 16.5:
                continue            # the seal
            u, v = field(x, y)
            s = math.hypot(u, v)
            if s < 1e-6:
                continue
            L = Lmin + (Lmax - Lmin) * min((s / vref) ** 0.7, 1.6) / 1.6
            d = (u / s, v / s)
            a = (x - d[0] * L / 2, y - d[1] * L / 2); b = (x + d[0] * L / 2, y + d[1] * L / 2)
            if keep.intersects(LineString([a, b])):
                continue
            ww = w * k * (0.75 + 0.35 * min(s / vref, 1.6) / 1.6)
            arrows.append(qarrow(a, b, ww, seed + 13 * i + j, fav, spread=34))
    return unary_union(arrows)


def carp_path(body_pts, W, k=1.0, seed=600, fav=False, tail_open=1.0, fins=True):
    """a carp along a curved spine, head first"""
    head, tl = body_pts[0], body_pts[-1]
    L = sum(math.dist(body_pts[i], body_pts[i + 1]) for i in range(len(body_pts) - 1))
    d = nrm(sub(body_pts[-2], tl)); d = mul(d, 1)          # local heading at the tail
    n = perp(d)
    body = stroke(body_pts, W * k, 'comma', rough=0.05, wob=0.05, seed=seed, cap0=True, cap1=False, step=0.15, edge=0.05)
    parts = [body]
    for s, sd in ((1, 1), (-1, 2)):
        e = add(tl, add(mul(d, -0.36 * L * tail_open), mul(n, s * 0.22 * L * tail_open)))
        m = add(lerp(tl, e, 0.5), mul(n, s * 0.03 * L))
        parts.append(sumi([tl, m, e], 0.42 * W * k, 'flick', seed=seed + sd, edge=0.1, split=0 if fav else 2, split_at=0.6,
                          split_thick=(0.08, 0.12)))
    dh = nrm(sub(body_pts[0], body_pts[1])); nh = perp(dh)
    if fins and not fav:
        a = add(body_pts[len(body_pts) // 3], mul(nh, 0.42 * W))
        parts.append(sumi([a, add(a, add(mul(dh, -0.10 * L), mul(nh, 0.12 * L))), add(a, add(mul(dh, -0.22 * L), mul(nh, 0.17 * L)))],
                          0.26 * W * k, 'flick', seed=seed + 5, edge=0.1))
    g = unary_union(parts)
    if not fav:
        ec = add(add(head, mul(dh, -0.16 * L)), mul(nh, -0.12 * W)); r = 0.09 * W
        g = g.difference(Polygon([(ec[0] + r * math.cos(t / 10 * math.tau), ec[1] + r * math.sin(t / 10 * math.tau)) for t in range(10)]))
    return g


def naruto(k=1.0, fav=False):
    C = (31.0, 35.0); R = 18.5
    spine = [(C[0] + R * math.cos(math.radians(a)), C[1] + R * math.sin(math.radians(a))) for a in range(292, 196, -8)]
    body = carp_path(spine, 8.4 if not fav else 11.5, k, seed=1021, fav=fav, tail_open=0.9)
    f = lambda x, y: flow(x, y, vort=[(C[0], C[1], -260.0, 7.5)], sink=(C[0], C[1], 60.0, 7.5))
    eye = sumi(arc(C, 2.6, 0, 300, 20), 1.6 * k, 'hair', seed=1029, edge=0.12) if not fav else None
    out = [(quiver(f, body, k, fav, vref=4.5), 'ink'), (body, 'accent')]
    if eye is not None:
        out.append((eye, 'ink'))
    return out


# ---------------------------------------------------------------- the icon pack
W = 1.75


def A(a, b, w=W, seed=1, spread=34):
    return qarrow(a, b, w, seed, False, spread=spread)


def S(pts, w=W, seed=1, prof='even'):
    return sumi(pts, w, prof, seed=seed, edge=0.1, rough=0.08, wob=0.06)


def dot(c, r):
    return Polygon([(c[0] + r * math.cos(t / 14 * math.tau), c[1] + r * math.sin(t / 14 * math.tau)) for t in range(14)])


def naruto_icons():
    I = {}
    # The maths, as you write it: a, then b, head to tail; a + b closes the triangle
    I['a + b'] = [(unary_union([A((3.0, 20.0), (14.0, 19.0), W * .8, 2001), A((14.0, 19.0), (19.5, 6.5), W * .8, 2005)]), 'ink'),
                  (A((3.0, 20.0), (18.2, 5.2), W * 1.15, 2009), 'accent')]
    # Lengths, angles, directions: two arrows from one point and the arc between them
    I['angle'] = [(unary_union([A((3.5, 20.0), (21.0, 20.0), seed=2011), A((3.5, 20.0), (14.0, 4.5), seed=2015)]), 'ink'),
                  (S(arc((3.5, 20.0), 9.0, -54, -6, 16), W * .7, 2019, 'hair'), 'accent')]
    # Faces of a mesh: a face lying flat, its outward normal rising
    I['normal'] = [(unary_union([S([(2.5, 19.5), (10.0, 22.0), (19.0, 20.0)], W * .8, 2021, 'hair'), S([(19.0, 20.0), (14.5, 15.0)], W * .8, 2022, 'hair'),
                                 S([(14.5, 15.0), (5.5, 16.8)], W * .8, 2023, 'harai')]), 'ink'),
                   (A((10.5, 18.2), (16.5, 3.5), W * 1.05, 2025), 'accent')]
    # Points, lines, planes: a line, a point, the arrow of its distance to the foot
    I['distance'] = [(S([(2.5, 20.0), (12.0, 14.5), (21.5, 9.0)], W, 2031, 'hair'), 'ink'),
                     (dot((8.6, 5.0), W * 1.05), 'accent'),
                     (A((8.6, 5.0), (11.6, 10.4), W * .6, 2035, spread=38), 'ink')]
    # Rotations and mirrors: the whirlpool in small, an arrow turning round an eye
    ring = arc((12.0, 12.0), 8.4, 200, 455, 30)
    I['rotate'] = [(unary_union([S(ring[:-4], W, 2041, 'hair'), A(ring[-7], ring[-1], W, 2043)]), 'ink'),
                   (S(arc((12.0, 12.0), 2.4, 0, 300, 14), W * .6, 2047, 'hair'), 'accent')]
    # Whole arrays at once: a small quiver field, one arrow in the carp's ink
    arr, hi = [], None
    for i in range(3):
        for j in range(3):
            o = (3.0 + j * 6.8, 19.6 - i * 6.6)
            g = A(o, add(o, (4.6, -3.8)), W * .72, 2050 + 3 * i + j)
            if (i, j) == (2, 2):
                hi = g
            else:
                arr.append(g)
    I['array'] = [(unary_union(arr), 'ink'), (hi, 'accent')]
    # Single, double, quadruple: the same arrow in three weights
    I['kinds'] = [(unary_union([A((3.0, 5.5), (20.5, 5.5), W * .45, 2061), A((3.0, 12.0), (20.5, 12.0), W * .85, 2063)]), 'ink'),
                  (A((3.0, 18.8), (21.0, 18.8), W * 1.4, 2067), 'accent')]
    # On the GPU: the device, an arrow inside it
    chip = [S([(5.5, 5.5), (18.5, 5.5), (18.5, 18.5), (5.5, 18.5), (5.5, 5.9)], W * .9, 2071, 'even')]
    for t in (9, 12, 15):
        chip += [S([(t, 2.2), (t, 4.4)], W * .55, 2072 + t), S([(t, 19.6), (t, 21.8)], W * .55, 2073 + t),
                 S([(2.2, t), (4.4, t)], W * .55, 2074 + t), S([(19.6, t), (21.8, t)], W * .55, 2075 + t)]
    I['_dev'] = [(unary_union(chip), 'ink'), (A((8.4, 15.6), (15.8, 8.2), W * .9, 2080), 'accent')]
    return I


NAMES = ['a + b', 'angle', 'normal', 'distance', 'rotate', 'array', 'kinds', '_dev']
TITLES = {'a + b': 'The maths, as you write it', 'angle': 'Lengths, angles, directions', 'normal': 'Faces of a mesh',
          'distance': 'Points, lines, planes', 'rotate': 'Rotations and mirrors', 'array': 'Whole arrays at once',
          'kinds': 'Single, double, quadruple', '_dev': 'On the GPU'}


FILES = {'a + b': 'plus', 'angle': 'angle', 'normal': 'normal', 'distance': 'distance', 'rotate': 'rotate',
         'array': 'array', 'kinds': 'kinds', '_dev': 'dev'}


# ---------------------------------------------------------------- svg writers
def svg(view, body, label, size=None):
    wh = f' width="{size}" height="{size}"' if size else ''
    return f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {view} {view}"{wh} role="img" aria-label="{label}">{body}</svg>\n'


def logo(t):
    parts = naruto(1.0, False)
    body = amr_mesh(unary_union([g for g, _ in parts]), t['mesh'])
    body += ''.join(path(g, t[ROLE[r]]) for g, r in parts)
    body += seal(t['seal'], t['ground'])
    return svg(64, body, 'VecFor', 256)


def favicon():
    parts = naruto(1.28, True)
    u = unary_union([g for g, _ in parts])
    x0, y0, x1, y1 = u.bounds
    s = min(54 / (x1 - x0), 54 / (y1 - y0)); cx, cy = (x0 + x1) / 2, (y0 + y1) / 2
    tr = f'translate(32 32) scale({s:.3f}) translate({-cx:.2f} {-cy:.2f})'
    def body(t, cls):
        return (f'<rect class="g" width="64" height="64" rx="12" fill="{t["ground"]}"/><g transform="{tr}">'
                + ''.join(path(g, t[ROLE[r]]).replace('<path ', f'<path class="{ROLE[r][0]}" ') for g, r in parts) + '</g>')
    D = INK['dark']
    style = (f'<style>@media (prefers-color-scheme: dark){{.g{{fill:{D["ground"]}}}.i{{fill:{D["ink"]}}}.c{{fill:{D["carp"]}}}}}</style>')
    return svg(64, style + body(INK['light'], ''), 'VecFor'), svg(64, body(INK['light'], ''), 'VecFor')


def icon(parts, t):
    return svg(24, ''.join(path(g, t[ROLE[r]]) for g, r in parts), 'icon', 48)


def main():
    docs = sys.argv[1] if len(sys.argv) > 1 else os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    pub = os.path.join(docs, 'public'); ico = os.path.join(pub, 'icons')
    os.makedirs(ico, exist_ok=True)
    open(os.path.join(pub, 'logo.svg'), 'w').write(logo(INK['light']))
    open(os.path.join(pub, 'logo-dark.svg'), 'w').write(logo(INK['dark']))
    fav, fav_light = favicon()
    open(os.path.join(pub, 'favicon.svg'), 'w').write(fav)
    I = naruto_icons()
    for nm, fn in FILES.items():
        open(os.path.join(ico, f'{fn}.svg'), 'w').write(icon(I[nm], INK['light']))
        open(os.path.join(ico, f'{fn}-dark.svg'), 'w').write(icon(I[nm], INK['dark']))
    if shutil.which('rsvg-convert'):
        tmp = os.path.join(pub, '.favicon-light.svg'); open(tmp, 'w').write(fav_light)
        sq = os.path.join(pub, '.favicon-square.svg'); open(sq, 'w').write(fav_light.replace('rx="12"', 'rx="0"'))
        for name, px, src in (('favicon-16.png', 16, tmp), ('favicon-32.png', 32, tmp), ('apple-touch-icon.png', 180, sq)):
            subprocess.run(['rsvg-convert', '-w', str(px), '-h', str(px), src, '-o', os.path.join(pub, name)], check=True)
        os.remove(tmp); os.remove(sq)       # iOS rounds the touch icon itself: it gets a square tile
    else:
        print('rsvg-convert not found: PNG favicons not written')


if __name__ == '__main__':
    main()
