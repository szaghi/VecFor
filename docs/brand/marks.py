#!/usr/bin/env python3
"""Generate the VecFor marks: python3 docs/brand/marks.py OUTDIR

Outputs (the repository copies are the files this script writes, byte-identical):
  logo.svg, logo-dark.svg  -> docs/public/   nav and hero logo; VitePress picks one by its theme toggle
                                           (config.mts `logo: { light, dark }`, index.md hero `image: { light, dark }`)
  favicon.svg              -> docs/public/   small-size cut (three larger shock diamonds, tighter frame); follows the OS
                                           theme through an embedded prefers-color-scheme rule, like the browser tab
  fish.svg, fish-dark.svg  -> docs/brand/    spare mark, kept for future projects (not used by VecFor)

Design: every shape is a vector. The rocket's hull and fins are fat arrows split along their axes into a lit and a
shaded face (light from the upper left, as in FoXy's low-poly fox); its Mach wake is pairs of fat-head arrows with tiny
shafts, tail to tail, pointing opposite ways, each pair a shock diamond, cooling from light orange to plum. The fish is
two crossing arcs (the cross x) with an arrow spine coloured like the wake.

Palette (shared with FoXy, ~/fortran/FoXy/docs/public/logo.svg):
  slate faces  #4c5c7d #3d4b69 #33415c #2d3a52   (dark theme: #aebfdc #93a6cb #9fb2d4 #8a9cc2)
  wake ramp    #ffc078 #ffa94d | #f08c2e #e8590c | #e8590c #c92a2a | #a61e4d #862e9c   (hot to cool, lit|shaded)
  docs theme   docs/.vitepress/theme/style.css: links #c2410c (5.2:1 on white) / #ffa94d (9.0:1 on #1b1b1f),
               buttons white on #c2410c, hover #9a3412

To reuse a mark in another project, run this script and take the files, or change SLATE/RAMP for another palette."""
import math, os, sys

def f(x): return f"{x:.2f}".rstrip('0').rstrip('.')
def P(pts): return "M" + " L".join(f(a) + " " + f(b) for a, b in pts) + " Z"
def _geom(t, h, hl):
    dx, dy = h[0] - t[0], h[1] - t[1]; L = math.hypot(dx, dy); ux, uy = dx / L, dy / L; px, py = -uy, ux
    b = (h[0] - ux * hl, h[1] - uy * hl)
    return b, (lambda q, s, w: (q[0] + px * w * s, q[1] + py * w * s))
def arrow(t, h, hl, hw, sw):
    """fat arrow from tail t to tip h: head length hl, head half-width hw, shaft half-width sw"""
    b, S = _geom(t, h, hl)
    return P([S(t, 1, sw), S(b, 1, sw), S(b, 1, hw), h, S(b, -1, hw), S(b, -1, sw), S(t, -1, sw)])
def halves(t, h, hl, hw, sw):
    """the two faces of a fat arrow split along its axis: (left face, right face) looking from tail to tip"""
    b, S = _geom(t, h, hl)
    return P([t, S(t, -1, sw), S(b, -1, sw), S(b, -1, hw), h]), P([t, S(t, 1, sw), S(b, 1, sw), S(b, 1, hw), h])

SLATE = ["#4c5c7d", "#3d4b69", "#33415c", "#2d3a52"]                        # lit to shaded (FoXy)
SLATE_DARK = {"#4c5c7d": "#aebfdc", "#3d4b69": "#93a6cb", "#33415c": "#9fb2d4", "#2d3a52": "#8a9cc2"}
RAMP = [("#ffc078", "#ffa94d"), ("#f08c2e", "#e8590c"), ("#e8590c", "#c92a2a"), ("#a61e4d", "#862e9c")]  # hot to cool

# rocket, in a local frame: nose up at y=-21, wake along +y; the group is turned 45 degrees to climb to the upper right
HULL = ((0, 14), (0, -21), 13.5, 10, 5)
FINS = (((-4.4, 4.2), (-12.6, 14), 7, 6, 1.8), ((4.4, 4.2), (12.6, 14), 7, 6, 1.8))
# Mach wake: each shock diamond is two fat-head arrows with tiny shafts, tail to tail, pointing opposite ways
WAKE = [(19.2, 3.5, 4.6, .8, 1.7), (27.4, 3.1, 3.9, .7, 1.5), (34.6, 2.7, 3.2, .6, 1.3), (40.8, 2.2, 2.5, .5, 1.1)]
WAKE_FAV = [(19.6, 4.0, 5.2, .8, 1.9), (28.6, 3.4, 4.3, .7, 1.6), (36.4, 2.8, 3.4, .6, 1.3)]   # three larger, for 16-32 px

def rocket(sl, wake, ramp):
    b = []
    for (yc, hl, hw, s, sw), (cl, cd) in zip(wake, ramp):
        for tip, c in (((0, yc - s - hl), cl), ((0, yc + s + hl), cd)):
            l, r = halves((0, yc), tip, hl, hw, sw); b += [f'<path d="{l}" fill="{cl}"/>', f'<path d="{r}" fill="{cd}"/>']
    for fin in FINS:
        l, r = halves(*fin); b += [f'<path d="{l}" fill="{sl[1]}"/>', f'<path d="{r}" fill="{sl[3]}"/>']
    l, r = halves(*HULL); b += [f'<path d="{l}" fill="{sl[0]}"/>', f'<path d="{r}" fill="{sl[2]}"/>']
    return b

def doc(comment, body, size=None, style=None, group=None):
    wh = f' width="{size}" height="{size}"' if size else ''
    s = f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64"{wh} role="img" aria-label="VecFor">\n  <!-- {comment} -->\n'
    if style: s += f'  {style}\n'
    if group: s += f'  <g transform="{group}">\n' + "\n".join("    " + x for x in body) + '\n  </g>\n'
    else: s += "\n".join("  " + x for x in body) + "\n"
    return s + '</svg>\n'
def dark_rule(mapping, attr='fill'):
    """an embedded rule that swaps colours when the OS theme is dark (works for <img> and inline SVG, not CSS backgrounds)"""
    return ('<style>@media (prefers-color-scheme: dark){' + " ".join(f'[{attr}="{a}"]{{{attr}:{b}}}' for a, b in mapping.items())
            + '}</style>')

CMT = ("VecFor: a rocket drawn with vectors. Hull and fins are fat arrows with lit and shaded faces; the Mach wake is pairs "
       "of opposite arrows, tail to tail, each pair a shock diamond. Palette shared with FoXy.")
G, G_FAV = 'translate(39 24) rotate(45) scale(1.15)', 'translate(40.6 22.6) rotate(45) scale(1.3)'
DARKS = [SLATE_DARK[c] for c in SLATE]

def fish(slate):
    """the spare mark: two crossing arcs (the cross x) make body and tail, the spine is an arrow cooling like the wake"""
    def arc(sg): return f"M56 32 Q{f(56 - 21)} {f(32 + sg * 27.3)} {f(56 - 48.3)} {f(32 - sg * 18.9)}"
    return [f'<path d="{arc(-1)} {arc(1)}" fill="none" stroke="{slate}" stroke-width="4" stroke-linecap="round"/>',
            '<path d="M23 30.4 H29 V33.6 H23 Z" fill="#862e9c"/>', '<path d="M29 30.4 H35 V33.6 H29 Z" fill="#c92a2a"/>',
            '<path d="M35 30.4 H41 V33.6 H35 Z" fill="#e8590c"/>',
            '<path d="M41 30.4 L43 30.4 L43 27 L51.5 32 L43 37 L43 33.6 L41 33.6 Z" fill="#f08c2e"/>',
            '<circle cx="40.5" cy="25" r="2.6" fill="#a61e4d"/>']

def main(out):
    os.makedirs(out, exist_ok=True)
    w = lambda n, s: open(os.path.join(out, n), 'w').write(s)
    w('logo.svg', doc(CMT, rocket(SLATE, WAKE, RAMP), 256, group=G))
    w('logo-dark.svg', doc(CMT + " Dark-theme variant: lifted slates.", rocket(DARKS, WAKE, RAMP), 256, group=G))
    w('favicon.svg', doc(CMT + " Favicon cut: three larger diamonds, tighter frame; slates lift when the OS theme is dark.",
                         rocket(SLATE, WAKE_FAV, [RAMP[0], RAMP[1], RAMP[3]]),
                         style=dark_rule(dict(zip(SLATE, DARKS))), group=G_FAV))
    FC = "VecFor spare mark: a fish of two crossing arcs (the cross x), its spine an arrow cooling plum to orange like the rocket wake."
    w('fish.svg', doc(FC + " Slate lifts when the OS theme is dark.", fish("#33415c"), style=dark_rule({"#33415c": "#9fb2d4"}, "stroke")))
    w('fish-dark.svg', doc(FC + " Dark-theme variant.", fish("#9fb2d4")))

if __name__ == '__main__':
    main(sys.argv[1] if len(sys.argv) > 1 else '.')
