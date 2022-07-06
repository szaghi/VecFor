#!/usr/bin/make

#main building variables
DSRC    = src
DOBJ    = static/obj/
DMOD    = static/mod/
DEXE    = static/
FC      = gfortran
OPTSC   = -c -frealloc-lhs -O2 -D_R16P_SUPPORTED -J static/mod
OPTSL   = -O2 -J static/mod
VPATH   = $(DSRC) $(DOBJ) $(DMOD)
MKDIRS  = $(DOBJ) $(DMOD) $(DEXE)

#auxiliary variables
COTEXT  = "Compiling $(<F)"
LITEXT  = "Assembling $@"

#building rules
$(DEXE)vecfor.a: $(MKDIRS) $(DOBJ)vecfor.o
	@echo $(LITEXT)
	@ar -rcs $@ $(DOBJ)*.o ; ranlib $@

#compiling rules
$(DOBJ)vecfor_r16p.o: src/lib/vecfor_R16P.F90 src/lib/vecfor_RPP.INC \
	$(DOBJ)penf.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC) -Isrc/lib  $< -o $@

$(DOBJ)vecfor.o: src/lib/vecfor.F90 \
	$(DOBJ)vecfor_rpp.o \
	$(DOBJ)vecfor_r4p.o \
	$(DOBJ)vecfor_r8p.o \
	$(DOBJ)vecfor_r16p.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC) -Isrc/lib  $< -o $@

$(DOBJ)vecfor_rpp.o: src/lib/vecfor_RPP.F90 src/lib/vecfor_RPP.INC \
	$(DOBJ)penf.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC) -Isrc/lib  $< -o $@

$(DOBJ)vecfor_r4p.o: src/lib/vecfor_R4P.F90 src/lib/vecfor_RPP.INC \
	$(DOBJ)penf.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC) -Isrc/lib  $< -o $@

$(DOBJ)vecfor_r8p.o: src/lib/vecfor_R8P.F90 src/lib/vecfor_RPP.INC \
	$(DOBJ)penf.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC) -Isrc/lib  $< -o $@

$(DOBJ)penf_stringify.o: src/third_party/PENF/src/lib/penf_stringify.F90 \
	$(DOBJ)penf_b_size.o \
	$(DOBJ)penf_global_parameters_variables.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC) -Isrc/lib  $< -o $@

$(DOBJ)penf.o: src/third_party/PENF/src/lib/penf.F90 \
	$(DOBJ)penf_global_parameters_variables.o \
	$(DOBJ)penf_b_size.o \
	$(DOBJ)penf_stringify.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC) -Isrc/lib  $< -o $@

$(DOBJ)penf_b_size.o: src/third_party/PENF/src/lib/penf_b_size.F90 \
	$(DOBJ)penf_global_parameters_variables.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC) -Isrc/lib  $< -o $@

$(DOBJ)penf_global_parameters_variables.o: src/third_party/PENF/src/lib/penf_global_parameters_variables.F90
	@echo $(COTEXT)
	@$(FC) $(OPTSC) -Isrc/lib  $< -o $@

#phony auxiliary rules
.PHONY : $(MKDIRS)
$(MKDIRS):
	@mkdir -p $@
.PHONY : cleanobj
cleanobj:
	@echo deleting objects
	@rm -fr $(DOBJ)
.PHONY : cleanmod
cleanmod:
	@echo deleting mods
	@rm -fr $(DMOD)
.PHONY : cleanexe
cleanexe:
	@echo deleting exes
	@rm -f $(addprefix $(DEXE),$(EXES))
.PHONY : clean
clean: cleanobj cleanmod
.PHONY : cleanall
cleanall: clean cleanexe
