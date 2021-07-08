# Makefile for TTRPG projects ###########################################################################
# By Cadera Spindrift
#
# FOR INTERNAL USE ONLY

# Project Configuration #################################################################################
#
# Project id 
#   Edit: yes
PROJ = pioneers

# Directories
#   Edit: probably unnecessary
IMGDIR    = ./art
STYLEDIR  = ./style
OUT       = out
OUTDIR    = ./$(OUT)
BINDIR    = ./bin
SRCDIR    = ./src
BUILDDIR  = ./build
BACKDIR   = ./old/backups
DOCSDIR   = ./docs

# Backups
#   Edit: if you want/don't want to back up files when you do make clean
BACKUPS   = --backup = numbered
# BACKUPS = -b
# BACKUPS =

# File Locations
#   Edit: probably unnecessary
PROJ_RECIPE    = $(PROJ)
PROJ_SRC       = $(BUILDDIR)/$(PROJ).md
PROJ_OUT       = $(OUTDIR)/$(PROJ).pdf
HTML_OUT       = $(OUTDIR)/$(PROJ).html
MOBILE_OUT     = $(OUTDIR)/$(PROJ)-pocket.pdf
DRAC_OUT       = $(OUTDIR)/$(PROJ)-drac.pdf
DRAC_SRC       = $(SRCDIR)/drac.md
SHEET_RECIPE   = sheet
SHEET_SRC      = $(BUILDDIR)/sheet.md
SHEET_HTML_OUT = $(OUTDIR)/$(PROJ)-sheets.html
SHEET_OUT      = $(OUTDIR)/$(PROJ)-sheets.pdf
SHEET_ALT_OUT  = $(OUTDIR)/$(PROJ)-sheets-alt.pdf
PLAINTEXT_OUT  = $(OUTDIR)/$(PROJ)-plaintext.pdf
TEASER_RECIPE  = teaser
TEASER_SRC     = $(BUILDDIR)/teaser.md
TEASER_OUT     = $(OUTDIR)/pioneers-teaser.pdf

# CSS Location
#   Edit: if you have more than one stylesheet
# PROJ_CSS    = --css = $(STYLEDIR)/$(PROJ).css
PROJ_CSS      = --css=$(STYLEDIR)/style.css
PLAINTEXT_CSS = --css=$(STYLEDIR)/plain.css
SHEET_CSS     = --css=$(STYLEDIR)/charsheet.css
SHEET_ALT_CSS = --css=$(STYLEDIR)/alt-charsheet.css
MOBILE_CSS    = --css=$(STYLEDIR)/mobile.css
DRAC_CSS      = --css=$(STYLEDIR)/drac.css

# Derived Flags
#   Edit: probably unnecessary
FLAGS           = -t html5 --standalone --resource-path=$(IMGDIR)
PROJ_FLAGS      = $(FLAGS) $(PROJ_CSS)      $(PRINCEFLAGS)
SHEET_FLAGS     = $(FLAGS) $(SHEET_CSS)     $(PRINCEFLAGS_SHEET)
SHEET_ALT_FLAGS = $(FLAGS) $(SHEET_ALT_CSS) $(PRINCEFLAGS_SHEET_ALT)
PLAINTEXT_FLAGS = $(FLAGS) $(PLAINTEXT_CSS) $(PRINCEFLAGS_PLAIN)
MOBILE_FLAGS    = $(FLAGS) $(MOBILE_CSS)    $(PRINCEFLAGS_MOBILE)
DRAC_FLAGS      = $(FLAGS) $(DRAC_CSS)      $(PRINCEFLAGS_DRAC)

# Application Configruation #############################################################################
#
# Pandoc Config
#   Edit: probably unnecessary
PANDOC         = /usr/bin/pandoc
PANDOCFLAGS    = --variable=date:"$(DATE)" -f $(PANDOC_MD_EXT) --pdf-engine=prince 
PANDOC_MD_EXT  = markdown+pipe_tables+escaped_line_breaks+header_attributes+fancy_lists+startnum+table_captions+link_attributes+fenced_divs+implicit_figures+bracketed_spans+auto_identifiers

# Prince Config
#   Edit: Sure, if you need to
#  
# PRINCEFLAGS    = --pdf-engine-opt=--css-dpi=300
#
# These options produce individual page png files
PRINCEFLAGS             = --pdf-engine-opt=--raster-output=$(OUTDIR)/pages/page_%d.png
# PRINCEFLAGS_SHEET     = --pdf-engine-opt=--raster-output=$(OUTDIR)/pages/sheet_%d.png
# PRINCEFLAGS_SHEET_ALT = --pdf-engine-opt=--raster-output=$(OUTDIR)/pages/sheet_alt_%d.png
# PRINCEFLAGS_MOBILE    = --pdf-engine-opt=--raster-output=$(OUTDIR)/pages/mobile_%d.png
# PRINCEFLAGS_PLAIN     = --pdf-engine-opt=--raster-output=$(OUTDIR)/pages/plain_%d.png
PRINCEFLAGS_DRAC        = --pdf-engine-opt=--raster-output=$(OUTDIR)/pages/drac_%d.png
#
# These do not
#
# PRINCEFLAGS         =
PRINCEFLAGS_SHEET     =
PRINCEFLAGS_SHEET_ALT =
PRINCEFLAGS_MOBILE    =
PRINCEFLAGS_PLAIN     =
# PRINCEFLAGS_DRAC      =

# Pdfinfo Config
#   Edit: probably unnecessary
PDFINFO      = /usr/bin/pdfinfo
PDFINFO_GREP = | grep -v no

# Make Markdown Script Config
#   Edit: you can turn off quiet mode
MAKE_MD = $(BINDIR)/make-markdown.lua -q
# MAKE_MD = $(BINDIR)/make-markdown.lua

# Editor Config (for make edit)
EDITOR = /usr/bin/vim

# Open Windows File Explorer
#   Edit: if you want to open the directory
# EXPLORER = /mnt/c/WINDOWS/explorer.exe $(OUT)
EXPLORER = 

# Variables #############################################################################################
#
# Date Variable
#   Edit: no
DATE           = $(shell date '+%Y-%b-%d %H:%M %z')

# Color variables
#   Edit: no

dkblck := $(shell tput setaf 0)
dkredd := $(shell tput setaf 1)
dkgren := $(shell tput setaf 2)
dkyelo := $(shell tput setaf 3)
dkblue := $(shell tput setaf 4)
dkmagn := $(shell tput setaf 5)
dkcyan := $(shell tput setaf 6)
dkwhit := $(shell tput setaf 7)
dkorng := $(shell tput setaf 166)
ltgray := $(shell tput setaf 8)
ltredd := $(shell tput setaf 9)
ltgren := $(shell tput setaf 10)
ltyelo := $(shell tput setaf 11)
ltblue := $(shell tput setaf 12)
ltmagn := $(shell tput setaf 13)
ltcyan := $(shell tput setaf 14)
ltwhit := $(shell tput setaf 15)
ltorng := $(shell tput setaf 208)
resetc := $(shell tput sgr0)

bgblck := $(shell tput setab 0)
bgredd := $(shell tput setab 1)
bggren := $(shell tput setab 2)
bgyelo := $(shell tput setab 3)
bgblue := $(shell tput setab 4)
bgmagn := $(shell tput setab 5)
bgcyan := $(shell tput setab 6)
bgwhit := $(shell tput setab 7)
bgorng := $(shell tput setab 166)
blgray := $(shell tput setab 8)
blredd := $(shell tput setab 9)
blgren := $(shell tput setab 10)
blyelo := $(shell tput setab 11)
blblue := $(shell tput setab 12)
blmagn := $(shell tput setab 13)
blcyan := $(shell tput setab 14)
blwhit := $(shell tput setab 15)
blorng := $(shell tput setab 208)

# Default Make Script ###################################################################################
#   Edit: if you want to change the default, e.g. to make testing easier
default: help
# default: sheet
# default: pdf
# default: mobile
# default: all

# Make Help #############################################################################################
#
# make help
#  Edit: if you add additional make options e.g. another pdf to make
help:
	@ echo   '$(dkcyan)make$(resetc) arguments:'
	@ echo '  $(dkcyan)make$(resetc) $(ltmagn)markdown   $(resetc)- collect markdown'
	@ echo '  $(dkcyan)make$(resetc) $(ltblue)pdf        $(resetc)- create pdf'
	@ echo '  $(dkcyan)make$(resetc) $(ltblue)plain      $(resetc)- create plain text pdf'
	@ echo '  $(dkcyan)make$(resetc) $(ltblue)pocket     $(resetc)- create pocket text pdf'
	@ echo '  $(dkcyan)make$(resetc) $(ltblue)sheets     $(resetc)- create character sheets'
	@ echo '  $(dkcyan)make$(resetc) $(ltblue)alt-sheets $(resetc)- create alternative character sheets'
	@ echo '  $(dkcyan)make$(resetc) $(ltcyan)html       $(resetc)- create html'
	@ echo '  $(dkcyan)make$(resetc) $(ltgren)all        $(resetc)- create markdown, pdf, plain, pocket, sheets, alt-sheets'
	@ echo '  $(dkcyan)make$(resetc) $(ltyelo)clean      $(resetc)- clean $(OUTDIR), $(BUILDDIR); makes backups'
	@ echo '  $(dkcyan)make$(resetc) $(ltorng)backups    $(resetc)- back up $(OUTDIR), $(BUILDDIR)'
	@ echo '  $(dkcyan)make$(resetc) $(dkredd)purge      $(resetc)- $(dkredd)purge$(resetc) $(OUTDIR), $(BUILDDIR), $(BACKDIR)'
	@ echo '  $(dkcyan)make$(resetc) $(dkmagn)edit       $(resetc)- edit the Makefile in $(EDITOR)'
	@ echo '  $(dkcyan)make$(resetc) $(dkblue)ls         $(resetc)- recursive ls'

# Various Make Utilities ################################################################################
#
# make edit
#  Edit: no
edit:
	@ $(EDITOR) Makefile

# make backups
#   Edit: no
backups:
	@ echo '$(ltorng)Backup up $(OUTDIR) and $(BUILDDIR).$(resetc)'
	@ -cp   $(BACKUPS) $(OUTDIR)/* $(BUILDDIR)/* $(BACKDIR)
	@ rm    $(BACKDIR)/README*
	@ cp    $(DOCSDIR)/README_BACKUPS.md $(BACKDIR)
	@ echo '$(ltorng)Copied to $(BACKDIR).$(resetc)'

# make clean
#   Edit: no
clean:
	@ echo '$(ltyelo)Cleaning $(OUTDIR) and $(BUILDDIR).$(resetc)'
	@ -mv   $(BACKUPS) $(OUTDIR)/* $(BUILDDIR)/* $(BACKDIR)
	@ cp    $(DOCSDIR)/README_OUT.md     $(OUTDIR)
	@ cp    $(DOCSDIR)/README_BUILD.md   $(BUILDDIR)
	@ rm    $(BACKDIR)/README*
	@ cp    $(DOCSDIR)/README_BACKUPS.md $(BACKDIR)
	@ echo '$(ltyelo)Moved to $(BACKDIR).$(resetc)'

# make purge
#  Edit: no
purge:
	@ echo '$(dkredd)Purging$(resetc) $(OUTDIR) $(BUILDDIR) and $(BACKDIR).'
	@ -rm   $(BACKDIR)/* $(BUILDDIR)/* $(OUTDIR)/*
	@ cp    $(DOCSDIR)/README_OUT.md     $(OUTDIR)
	@ cp    $(DOCSDIR)/README_BUILD.md   $(BUILDDIR)
	@ cp    $(DOCSDIR)/README_BACKUPS.md $(BACKDIR)
	@ echo '$(dkredd)Purged.$(resetc)'

# make ls
#   Edit: no
ls: ls-src ls-build ls-out ls-back

ls-src:
	@ echo -n '$(resetc)'
	@ /bin/ls -R --color $(SRCDIR)
	@ echo '$(resetc)'

ls-build:
	@ echo '$(resetc)$(blmagn)$(dkblck)$(BUILDDIR)'
	@ /bin/ls --color=never $(BUILDDIR)
	@ echo '$(resetc)'

ls-out:
	@ echo '$(resetc)$(blgren)$(dkblck)$(OUTDIR)'
	@ /bin/ls --color=never $(OUTDIR)
	@ echo '$(resetc)'

ls-back:
	@ echo '$(resetc)$(blorng)$(dkblck)$(BACKDIR)'
	@ /bin/ls --color=never $(BACKDIR)
	@ echo '$(resetc)'

# Actual Make Scripts ###################################################################################
#
# make markdown
#   Edit: if you are making multiple docs
markdown:
	@ echo '$(ltmagn)Collecting markdown.$(resetc)'
	@       $(MAKE_MD) $(PROJ_RECIPE)

markdown-teaser:
	@ echo '$(ltmagn)Collecting teaser markdown.$(resetc)'
	@       $(MAKE_MD) $(TEASER_RECIPE)

markdown-sheet:
	@ echo '$(ltmagn)Collecting sheet markdown.$(resetc)'
	@       $(MAKE_MD) $(SHEET_RECIPE)

# make pdf
#   Edit: if you are making more than one pdf
pdf: markdown
	@ echo '$(ltblue)Making PDF.$(resetc)'
	@       $(PANDOC) $(PANDOCFLAGS) $(PROJ_FLAGS) -o $(PROJ_OUT) $(PROJ_SRC)
	@       $(PDFINFO) $(PROJ_OUT) $(PDFINFO_GREP)
	@      -$(EXPLORER)

plaintext: markdown
	@ echo '$(ltblue)Making Plaintext PDF.$(resetc)'
	@       $(PANDOC) $(PANDOCFLAGS) $(PLAINTEXT_FLAGS) -o $(PLAINTEXT_OUT) $(PROJ_SRC)
	@       $(PDFINFO) $(PLAINTEXT_OUT) $(PDFINFO_GREP)
	@      -$(EXPLORER)

mobile: markdown
	@ echo '$(ltblue)Making Mobile PDF.$(resetc)'
	@       $(PANDOC) $(PANDOCFLAGS) $(MOBILE_FLAGS) -o $(MOBILE_OUT) $(PROJ_SRC)
	@       $(PDFINFO) $(MOBILE_OUT) $(PDFINFO_GREP)
	@      -$(EXPLORER)

drac:
	echo '$(ltblue)Making Dracula PDF.$(resetc)'
	      $(PANDOC) $(PANDOCFLAGS) $(DRAC_FLAGS) -o $(DRAC_OUT) $(DRAC_SRC)
	      $(PDFINFO) $(DRAC_OUT) $(PDFINFO_GREP)
	     -$(EXPLORER)


teaser: markdown-teaser
	 echo '$(ltblue)Making Teaser PDF.$(resetc)'
	       $(PANDOC) $(PANDOCFLAGS) $(PROJ_FLAGS) -o $(TEASER_OUT) $(TEASER_SRC)
	       $(PDFINFO) $(TEASER_OUT) $(PDFINFO_GREP)
	      -$(EXPLORER)

sheet: markdown-sheet
	@ echo '$(ltblue)Making character sheet PDF.$(resetc)'
	@       $(PANDOC) $(PANDOCFLAGS) $(SHEET_FLAGS) -o $(SHEET_OUT) $(SHEET_SRC)
	@       $(PDFINFO) $(SHEET_OUT) $(PDFINFO_GREP)
	@      -$(EXPLORER)

alt-sheet: markdown-sheet
	@ echo '$(ltblue)Making character sheet alternate PDF.$(resetc)'
	@       $(PANDOC) $(PANDOCFLAGS) $(SHEET_ALT_FLAGS) -o $(SHEET_ALT_OUT) $(SHEET_SRC)
	@       $(PDFINFO) $(SHEET_ALT_OUT) $(PDFINFO_GREP)
	@      -$(EXPLORER)

# make HTML
#   Edit: if you are making more than one html
html: markdown
	@ echo '$(ltcyan)Making HTML.$(resetc)'
	@       $(PANDOC) $(PANDOCFLAGS) $(FLAGS) -o $(HTML_OUT) $(PROJ_SRC)
	@ echo '$(ltcyan)HTML built.$(resetc)'
	@       $(EDITOR) $(HTML_OUT)

html-sheet: markdown-sheet
	@ echo '$(ltcyan)Making HTML.$(resetc)'
	@       $(PANDOC) $(PANDOCFLAGS) $(FLAGS) -o $(SHEET_HTML_OUT) $(SHEET_SRC)
	@ echo '$(ltcyan)HTML built.$(resetc)'
	@       $(EDITOR) $(SHEET_HTML_OUT)

# make all
#   Edit: if you are making more than one pdf or html
# all: pdf teaser html
all: pdf plain pocket sheet alt-sheet

# Make Aliases ##########################################################################################
#  Edit: only you if want to add something
md:         markdown
game:       pdf
backup:     backups
vi:         edit
vim:        edit
plain:      plaintext
sheets:     sheet
alt-sheets: alt-sheet
charsheet:  sheet
charsheets: sheet
pocket:     mobile
dracula:    drac
