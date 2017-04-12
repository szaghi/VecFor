---
project: VecFor
src_dir: ../src/lib
src_dir: ../src/tests
src_dir: ../src/third_party/PENF/src/lib
output_dir: html/publish/
project_github: https://github.com/szaghi/VecFor
project_download: https://github.com/szaghi/VecFor/releases/latest
summary: Vector algebra class for Fortran poor people
author: Stefano Zaghi
github: https://github.com/szaghi
website: https://github.com/szaghi
md_extensions: markdown.extensions.toc(anchorlink=True)
               markdown.extensions.smarty(smart_quotes=False)
               markdown.extensions.extra
               markdown_checklist.extension
docmark: <
display: public
         protected
         private
source: true
warn: true
graph: true
sort: alpha
print_creation_date: true
creation_date: %Y-%m-%d %H:%M %z
extra_mods: iso_fortran_env:https://gcc.gnu.org/onlinedocs/gfortran/ISO_005fFORTRAN_005fENV.html

{!../README.md!}
---
