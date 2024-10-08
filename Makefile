##############
# parameters #
##############
# do you want dependency on the makefile itself ?
DO_ALLDEP:=1
# do you want to show the commands executed ?
DO_MKDBG:=0
# do you want to convert .tex to .pdf ?
DO_TEX_PDF:=1

########
# code #
########
ALL:=

# tools
TOOL_LATEX2HTML:=latex2html
TOOL_LACHECK:=scripts/wrapper_lacheck.py
TOOL_SKETCH:=sketch
TOOL_PDFLATEX:=pdflatex
USE_LATEX2PDF:=scripts/wrapper_pdflatex.py

# silent stuff
ifeq ($(DO_MKDBG),1)
Q:=
# we are not silent in this branch
else # DO_MKDBG
Q:=@
#.SILENT:
endif # DO_MKDBG

TEX_SRC:=$(shell find src -type f -and -name "*.tex")
TEX_PDF:=$(addprefix out/, $(addsuffix .pdf, $(basename $(TEX_SRC))))

PY_SRC:=$(shell find scripts -type f -not -path "./.venv/*" -name "*.py")
PY_PYLINT:=$(addprefix out/, $(addsuffix .pylint, $(basename $(PY_SRC))))

ifeq ($(DO_TEX_PDF),1)
ALL+=$(TEX_PDF)
endif # DO_PDF

ifeq ($(DO_PYLINT),1)
ALL:=$(ALL) out/pylint.stamp
endif # DO_PYLINT

#########
# rules #
#########
# do not touch this rule (see demos-make for explanation of order in makefile)
all: $(ALL)
	@true

.PHONY: debug
debug:
	$(info TEX_SRC is $(TEX_SRC))
	$(info TEX_PDF is $(TEX_PDF))
	$(info PY_SRC is $(PY_SRC))
	$(info PY_PYLINT is $(PY_PYLINT))
	$(info ALL is $(ALL))
.PHONY: clean
clean:
	$(info doing [$@])
	$(Q)rm -f $(ALL)
.PHONY: clean_hard
clean_hard:
	$(info doing [$@])
	$(Q)git clean -qffxd
############
# patterns #
############
$(TEX_PDF): out/%.pdf: %.tex $(USE_LATEX2PDF) $(TOOL_LACHECK)
	$(info doing [$@])
	$(Q)mkdir -p $(dir $@)
	$(Q)$(TOOL_LACHECK) $<
	$(Q)$(USE_LATEX2PDF) $< $@

##########
# alldep #
##########
ifeq ($(DO_ALLDEP),1)
.EXTRA_PREREQS+=$(foreach mk, ${MAKEFILE_LIST},$(abspath ${mk}))
endif # DO_ALLDEP
