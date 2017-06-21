#!/usr/bin/make

#main building variables
DOBJ   = exe/obj
DMOD   = exe/mod
DEXE   = exe
DSRC   = src
DTESTS = $(DSRC)/tests
FC     = gfortran
OPTSC  = -cpp -c -frealloc-lhs -O3 -J $(DMOD)
OPTSL  = -J $(DMOD)
VPATH  = $(DSRC) $(DOBJ) $(DMOD) $(DTESTS)
MKDIRS = $(DOBJ) $(DMOD) $(DEXE)
TESTS  = $(wildcard $(DTESTS)/*.f90)
TOBJS  = $(patsubst $(DTESTS)/%.f90,$(DOBJ)/%.o,$(TESTS))
TEXES  = $(patsubst $(DTESTS)/%.f90,$(DEXE)/%,$(TESTS))

#auxiliary variables
COTEXT = "Compile $(<F)"
LITEXT = "Build $@"

#building rule
all : $(MKDIRS) $(TEXES)

$(TEXES) : $(DEXE)/% : $(DOBJ)/%.o
	@echo $(LITEXT)
	@$(FC) $(OPTSL) $(DOBJ)/penf*.o $(DOBJ)/vecfor.o $< -o $@

$(TOBJS) : $(DOBJ)/%.o : $(DTESTS)/%.f90 $(DOBJ)/vecfor.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC) $< -o $@

#compiling rules
$(DOBJ)/vecfor.o: src/lib/vecfor.F90 \
	$(DOBJ)/penf.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC) $< -o $@

$(DOBJ)/penf.o: src/third_party/PENF/src/lib/penf.F90 \
	$(DOBJ)/penf_global_parameters_variables.o \
	$(DOBJ)/penf_b_size.o \
	$(DOBJ)/penf_stringify.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC) $< -o $@

$(DOBJ)/penf_global_parameters_variables.o: src/third_party/PENF/src/lib/penf_global_parameters_variables.F90
	@echo $(COTEXT)
	@$(FC) $(OPTSC) $< -o $@

$(DOBJ)/penf_b_size.o: src/third_party/PENF/src/lib/penf_b_size.F90 \
	$(DOBJ)/penf_global_parameters_variables.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC) $< -o $@

$(DOBJ)/penf_stringify.o: src/third_party/PENF/src/lib/penf_stringify.F90 \
	$(DOBJ)/penf_b_size.o \
	$(DOBJ)/penf_global_parameters_variables.o
	@echo $(COTEXT)
	@$(FC) $(OPTSC) $< -o $@

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
.PHONY : clean
clean: cleanobj cleanmod
