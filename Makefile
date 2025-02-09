##############
# parameters #
##############
# do you want dependency on the makefile itself ?
DO_ALLDEP:=1
# do you want to show the commands executed ?
DO_MKDBG:=0
# do you want to convert .tex to .pdf ?
DO_TEX_PDF:=1
# do you want to lint your python scripts?
DO_PY_LINT:=1

########
# code #
########
ALL:=

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

PY_SRC:=$(shell find scripts -type f -and -name "*.py")
PY_LINT:=$(addprefix out/, $(addsuffix .lint, $(basename $(PY_SRC))))

ifeq ($(DO_TEX_PDF),1)
ALL+=$(TEX_PDF)
endif # DO_PDF

ifeq ($(DO_PY_LINT),1)
ALL+=$(PY_LINT)
endif # DO_PY_LINT

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
	$(info PY_LINT is $(PY_LINT))
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
$(TEX_PDF): out/%.pdf: %.tex scripts/wrapper_lacheck.py
	$(info doing [$@])
	$(Q)mkdir -p $(dir $@)
	$(Q)scripts/wrapper_lacheck.py $<
	$(Q)pymakehelper wrapper_pdflatex --input_file $< --output_file $@
$(PY_LINT): out/%.lint: %.py
	$(info doing [$@])
	$(Q)pylint --reports=n --score=n $<
	$(Q)pymakehelper touch_mkdir $@

##########
# alldep #
##########
ifeq ($(DO_ALLDEP),1)
.EXTRA_PREREQS+=$(foreach mk, ${MAKEFILE_LIST},$(abspath ${mk}))
endif # DO_ALLDEP
