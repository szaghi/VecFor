#!/usr/bin/env bash
# Build and run the documentation examples, regenerating everything the pages include from them.
#
#   docs/examples/src/*.f90      the example programs (hand-written), with marker comments:
#                                  !run ID COMMAND        a run shown in the pages (!run -s: with its exit status)
#                                  !region NAME ... !endregion NAME   a part of the program included on its own
#                                  !as NAME               its runs call it NAME (the chapters of the tutorial are all probe)
#                                  !quad                  built against VecFor compiled with -DPENF_R16P (true quadruple
#                                                         precision) instead of the default build
#   docs/examples/figures/*.f90  the programs that draw the figures (hand-written): each computes its geometry with VecFor
#                                and writes, through docs/examples/lib/sketch.f90, the data files of its drawing
#   docs/examples/figures/*.gp   the foresight script of each figure, run in the directory of the data files after the
#                                frame written by the program (<figure>.frame.gp: the ranges that show the drawing whole)
#   docs/examples/snippets/      generated: <program>.f90 without the markers, and <program>-<region>.f90
#   docs/examples/output/        generated: <ID>.txt, "$ COMMAND" then what the run writes on standard output and error
#   docs/public/figures/         generated: <figure>.svg, drawn by foresight
#
# The library is rebuilt from scratch by FoBiS (mode static-gnu) and the examples are built by the same compiler, gfortran
# or $FC. Each run happens in a scratch directory, with HOME pointing there and a minimal environment, so nothing outside
# it is read or written. The figures need foresight (https://github.com/szaghi/foresight, v0.4.0 or later): `foresight`
# on the PATH, or $FORESIGHT.
#
# Usage: bash scripts/docs_examples.sh            (FC=gfortran-14 bash scripts/docs_examples.sh: another compiler)
set -euo pipefail

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
ex=$root/docs/examples
figures=$root/docs/public/figures
build=$root/build/docs-examples # git-ignored
run_dir=$build/run
fig_dir=$build/figures
home=/home/user                 # how the run directory is shown

fc=${FC:-gfortran}
foresight=${FORESIGHT:-foresight}
command -v "$foresight" > /dev/null || { echo "docs_examples: foresight not found (PATH or \$FORESIGHT)" >&2; exit 1; }
mkdir -p "$root/build"
(cd "$root" && fobis clean --mode static-gnu && fobis build --mode static-gnu --fc "$fc") \
  > "$root/build/docs-examples.log" 2>&1 || {
  cat "$root/build/docs-examples.log"; echo "docs_examples: library build failed" >&2; exit 1; }
rm -rf -- "$build"
mkdir -p "$build/bin" "$build/lib" "$build/quad/obj" "$build/quad/mod" "$run_dir" "$fig_dir" "$ex/snippets" \
         "$ex/output" "$figures"
rm -f -- "$ex"/snippets/*.f90 "$ex"/output/*.txt "$figures"/*.svg

# the library in true quadruple precision, for the programs marked !quad: the sources of the default build, -DPENF_R16P
penf=$root/src/third_party/PENF/src/lib
for src in "$penf"/penf_global_parameters_variables.F90 "$penf"/penf_b_size.F90 "$penf"/penf_stringify.F90 \
           "$penf"/penf_allocatable_memory.F90 "$penf"/penf.F90 "$root"/src/lib/vecfor_R4P.F90 \
           "$root"/src/lib/vecfor_R8P.F90 "$root"/src/lib/vecfor_R16P.F90 "$root"/src/lib/vecfor_RPP.F90 \
           "$root"/src/lib/vecfor.F90; do
  "$fc" -c -O2 -DPENF_R16P -I"$root/src/lib" -J"$build/quad/mod" "$src" -o "$build/quad/obj/$(basename "$src" .F90).o"
done
ar -rcs "$build/quad/libvecfor.a" "$build"/quad/obj/*.o

# snippets: the whole program and each region, without the markers, dedented
dedent() { awk '{l[NR]=$0; if ($0 ~ /[^ ]/) {match($0, /^ */); if (m == "" || RLENGTH < m) m = RLENGTH}}
                END {for (i = 1; i <= NR; i++) print substr(l[i], m + 1)}' "$1"; }
for src in "$ex"/src/*.f90; do
  name=$(basename "$src" .f90)
  grep -Ev '^ *!(run|region|endregion|as|quad)( |$)' "$src" > "$ex/snippets/$name.f90" || true
  for region in $(sed -n 's/^ *!region \([A-Za-z0-9_-]*\).*/\1/p' "$src"); do
    awk -v r="$region" '$1 == "!endregion" && $2 == r {on = 0}
                        on && $0 !~ /^ *!(run|region|endregion|as|quad)( |$)/ {print}
                        $1 == "!region" && $2 == r {on = 1}' "$src" > "$build/region.f90"
    dedent "$build/region.f90" > "$ex/snippets/$name-$region.f90"
  done
done

# programs
for src in "$ex"/src/*.f90; do
  lib=$root/static
  if grep -Eq '^ *!quad( |$)' "$src"; then lib=$build/quad; fi
  "$fc" -I"$lib/mod" -o "$build/bin/$(basename "$src" .f90)" "$src" "$lib/libvecfor.a"
done

# runs, in the order of the files and of the lines
path=$build/bin
run() { # run [-s] ID COMMAND
  local show=0 status=0
  if [ "$1" = -s ]; then show=1; shift; fi
  local id=$1; shift
  local cmd="$*"
  (cd "$run_dir" && env -i HOME="$run_dir" PATH="$path:/usr/bin:/bin" LC_ALL=C.UTF-8 GFORTRAN_ERROR_BACKTRACE=0 \
                   bash -c "$cmd" < /dev/null > "$build/capture" 2>&1) || status=$?
  {
    printf '$ %s\n' "$cmd"
    cat "$build/capture"
    if [ $show = 1 ]; then printf '[exit status %d]\n' "$status"; fi
  } | sed -e "s|$run_dir|$home|g" > "$ex/output/$id.txt"
}
for src in "$ex"/src/*.f90; do
  path=$build/bin
  as=$(sed -n 's/^ *!as \([A-Za-z0-9_-]*\).*/\1/p' "$src" | head -n 1)
  if [ -n "$as" ]; then
    path=$build/as/$(basename "$src" .f90)
    mkdir -p "$path" && ln -sf "$build/bin/$(basename "$src" .f90)" "$path/$as"
    path=$path:$build/bin
  fi
  while IFS= read -r line; do
    line=${line#*!run }
    opts=()
    if [ "${line%% *}" = -s ]; then opts=(-s); line=${line#-s }; fi
    run "${opts[@]}" "${line%% *}" "${line#* }"
  done < <(grep -E '^ *!run ' "$src" || true)
done

# figures: each program writes the data files of its drawing, foresight draws it
"$fc" -c -I"$root/static/mod" -J"$build/lib" "$ex/lib/sketch.f90" -o "$build/lib/sketch.o"
for src in "$ex"/figures/*.f90; do
  name=$(basename "$src" .f90)
  "$fc" -I"$root/static/mod" -I"$build/lib" -o "$build/bin/fig-$name" "$src" "$build/lib/sketch.o" \
        "$root/static/libvecfor.a"
  (cd "$fig_dir" && "$build/bin/fig-$name" && cat "$name.frame.gp" "$ex/figures/$name.gp" > "$name.gp" \
                 && "$foresight" "$name.gp" > /dev/null)
  cp "$fig_dir/$name.svg" "$figures/$name.svg"
done
echo "docs_examples: $(ls "$ex"/src/*.f90 | wc -l) programs, $(ls "$ex"/output/*.txt | wc -l) runs," \
     "$(ls "$figures"/*.svg | wc -l) figures"
