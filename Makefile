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
FMTDIR    = $(PROJ)-source
DISTDIR   = $(PROJ)-ttrpg

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
MOBILE_OUT     = $(OUTDIR)/$(PROJ)-pocket.pdf
PRINT_OUT      = $(OUTDIR)/$(PROJ)-printable.pdf
SHEET_OUT      = $(OUTDIR)/$(PROJ)-sheets.pdf
SHEET_ALT_OUT  = $(OUTDIR)/$(PROJ)-sheets-alt.pdf

HTML_OUT       = $(OUTDIR)/$(PROJ).html
SHEET_HTML_OUT = $(OUTDIR)/$(PROJ)-sheets.html

TEASER_OUT     = $(OUTDIR)/pioneers-teaser.pdf
DRAC_OUT       = $(OUTDIR)/$(PROJ)-drac.pdf
DRAC_SRC       = $(SRCDIR)/drac.md

SHEET_RECIPE   = sheet
SHEET_SRC      = $(BUILDDIR)/sheet.md
TEASER_RECIPE  = teaser
TEASER_SRC     = $(BUILDDIR)/teaser.md

TEXT_OUT       = $(OUTDIR)/$(FMTDIR)/$(PROJ).txt
ODT_OUT        = $(OUTDIR)/$(FMTDIR)/$(PROJ).odt
RTF_OUT        = $(OUTDIR)/$(FMTDIR)/$(PROJ).rtf
DOCX_OUT       = $(OUTDIR)/$(FMTDIR)/$(PROJ).docx
GFM_OUT        = $(OUTDIR)/$(FMTDIR)/$(PROJ).gfm 
INDESIGN_OUT   = $(OUTDIR)/$(FMTDIR)/$(PROJ).icml
OPENDOC_OUT    = $(OUTDIR)/$(FMTDIR)/$(PROJ).fodt
HTML5_OUT      = $(OUTDIR)/$(FMTDIR)/$(PROJ).html
HTML5SELF_OUT  = $(OUTDIR)/$(FMTDIR)/$(PROJ)-complete.html

ZIP_FMT_OUT    = ./$(PROJ)-source.zip
ZIP_DIST_OUT   = ./$(PROJ)-ttrpg.zip

# CSS Location
#   Edit: if you have more than one stylesheet
# PROJ_CSS    = --css = $(STYLEDIR)/$(PROJ).css
PROJ_CSS      = --css=$(STYLEDIR)/style.css
PRINT_CSS     = --css=$(STYLEDIR)/print.css
SHEET_CSS     = --css=$(STYLEDIR)/charsheet.css
SHEET_ALT_CSS = --css=$(STYLEDIR)/alt-charsheet.css
MOBILE_CSS    = --css=$(STYLEDIR)/mobile.css
DRAC_CSS      = --css=$(STYLEDIR)/drac.css
TEASER_CSS    = --css=$(STYLEDIR)/teaser.css

# Derived Flags
#   Edit: probably unnecessary
FLAGS           = -t html5 --standalone --resource-path=$(IMGDIR)
PROJ_FLAGS      = $(FLAGS) $(PROJ_CSS)      $(PRINCEFLAGS)
SHEET_FLAGS     = $(FLAGS) $(SHEET_CSS)     $(PRINCEFLAGS_SHEET)
SHEET_ALT_FLAGS = $(FLAGS) $(SHEET_ALT_CSS) $(PRINCEFLAGS_SHEET_ALT)
PRINT_FLAGS = $(FLAGS) $(PRINT_CSS) $(PRINCEFLAGS_PLAIN)
MOBILE_FLAGS    = $(FLAGS) $(MOBILE_CSS)    $(PRINCEFLAGS_MOBILE)
DRAC_FLAGS      = $(FLAGS) $(DRAC_CSS)      $(PRINCEFLAGS_DRAC)
TEASER_FLAGS    = $(FLAGS) $(TEASER_CSS)    $(PRINCEFLAGS_TEASER)

# File Formats
DOCX_FLAGS      = -t docx
GFM_FLAGS       = -t gfm
INDESIGN_FLAGS  = -t icml
ODT_FLAGS       = -t odt
OPENDOC_FLAGS   = -t opendocument --standalone
RTF_FLAGS       = -t rtf
TEXT_FLAGS      = -t plain        --columns=72
HTML5_FLAGS     = -t html5        --standalone
HTML5SELF_FLAGS = -t html5        --self-contained $(PRINT_CSS)

# Application Configruation #############################################################################
#
# Pandoc Config
#   Edit: probably unnecessary
PANDOC         = /usr/bin/pandoc
PANDOCFLAGS    = --variable=date:"$(DATE)" -f $(PANDOC_MD_EXT) --pdf-engine=prince 
PANDOCFLAGS_ALT = --variable=date:"$(DATE)" -f $(PANDOC_MD_EXT_ALT) --pdf-engine=prince 
PANDOC_MD_EXT  = markdown+pipe_tables+header_attributes+fancy_lists+startnum+link_attributes+fenced_divs+bracketed_spans+multiline_tables+grid_tables+simple_tables
PANDOC_MD_EXT_ALT  = markdown+pipe_tables+escaped_line_breaks+header_attributes+fancy_lists+startnum+table_captions+link_attributes+fenced_divs+implicit_figures+bracketed_spans+auto_identifiers

# Prince Config
#   Edit: Sure, if you need to
#  
# PRINCEFLAGS    = --pdf-engine-opt=--css-dpi=300
#
# These options produce individual page png files
PRINCEFLAGS             = --pdf-engine-opt=--raster-output=$(OUTDIR)/pages/page_%d.png
PRINCEFLAGS_TEASER      = --pdf-engine-opt=--raster-output=$(OUTDIR)/teaser/teaser_%d.png
# PRINCEFLAGS_SHEET     = --pdf-engine-opt=--raster-output=$(OUTDIR)/pages/sheet_%d.png
# PRINCEFLAGS_SHEET_ALT = --pdf-engine-opt=--raster-output=$(OUTDIR)/pages/sheet_alt_%d.png
PRINCEFLAGS_MOBILE    = --pdf-engine-opt=--raster-output=$(OUTDIR)/pages/mobile_%d.png
# PRINCEFLAGS_PLAIN     = --pdf-engine-opt=--raster-output=$(OUTDIR)/pages/plain_%d.png
PRINCEFLAGS_DRAC        = --pdf-engine-opt=--raster-output=$(OUTDIR)/pages/drac_%d.png
#
# These do not
#
# PRINCEFLAGS         =
PRINCEFLAGS_SHEET     =
PRINCEFLAGS_SHEET_ALT =
# PRINCEFLAGS_MOBILE    =
PRINCEFLAGS_PLAIN     =
# PRINCEFLAGS_DRAC      =

# Pdfinfo Config
#   Edit: probably unnecessary
PDFINFO      = /usr/bin/pdfinfo
PDFINFO_GREP = | grep -v no

# Make Markdown Script Config
#   Edit: you can turn off quiet mode
MAKE_MD = $(BINDIR)/make-markdown.lua -v
# MAKE_MD = $(BINDIR)/make-markdown.lua

# Editor Config (for make edit)
EDITOR = /usr/bin/vim

# Open Windows File Explorer
#   Edit: if you want to open the directory
# EXPLORER = /mnt/c/WINDOWS/explorer.exe $(OUT)
EXPLORER = 

# Zip
ZIP = /usr/bin/zip -r

# Variables #############################################################################################
#
# Date Variable
#   Edit: no
DATE   = $(shell date '+%B %e, %Y')
# DATE = $(shell date '+%Y-%b-%d %H:%M %z')

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
# default: help
# default: sheet
default: pdf
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
	@ echo '  $(dkcyan)make$(resetc) $(ltblue)print      $(resetc)- create printable pdf'
	@ echo '  $(dkcyan)make$(resetc) $(ltblue)pocket     $(resetc)- create pocket text pdf'
	@ echo '  $(dkcyan)make$(resetc) $(ltblue)sheets     $(resetc)- create character sheets'
	@ echo '  $(dkcyan)make$(resetc) $(ltblue)alt-sheets $(resetc)- create alternative character sheets'
	@ echo '  $(dkcyan)make$(resetc) $(ltcyan)html       $(resetc)- create html'
	@ echo '  $(dkcyan)make$(resetc) $(ltgren)all        $(resetc)- create markdown, pdf, print, pocket, sheets, alt-sheets'
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

print: markdown
	@ echo '$(ltblue)Making Printable PDF.$(resetc)'
	@       $(PANDOC) $(PANDOCFLAGS) $(PRINT_FLAGS) -o $(PRINT_OUT) $(PROJ_SRC)
	@       $(PDFINFO) $(PRINT_OUT) $(PDFINFO_GREP)
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
	       $(PANDOC) $(PANDOCFLAGS_ALT) $(TEASER_FLAGS) -o $(TEASER_OUT) $(TEASER_SRC)
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

dist-dir:
	@ echo -n '$(ltorng)Checking: $(resetc)'
	@ mkdir -p $(OUTDIR)/$(DISTDIR)
	@ echo '$(ltorng)$(OUTDIR)/$(DISTDIR) exists.$(resetc)'

formats-dir:
	@ echo -n '$(ltorng)Checking: $(resetc)'
	@ mkdir -p $(OUTDIR)/$(FMTDIR)
	@ echo '$(ltorng)$(OUTDIR)/$(FMTDIR) exists.$(resetc)'

text: markdown formats-dir
	@ echo '$(ltcyan)Making Text.$(resetc)'
	@       $(PANDOC) $(PANDOCFLAGS) $(TEXT_FLAGS) -o $(TEXT_OUT) $(PROJ_SRC)
	@ echo '$(ltcyan)Text built.$(resetc)'

docx: markdown formats-dir
	@ echo '$(ltcyan)Making DocX.$(resetc)'
	@       $(PANDOC) $(PANDOCFLAGS) $(DOCX_FLAGS) -o $(DOCX_OUT) $(PROJ_SRC)
	@ echo '$(ltcyan)DocX built.$(resetc)'

rtf: markdown formats-dir
	@ echo '$(ltcyan)Making RTF.$(resetc)'
	@       $(PANDOC) $(PANDOCFLAGS) $(RTF_FLAGS) -o $(RTF_OUT) $(PROJ_SRC)
	@ echo '$(ltcyan)RTF built.$(resetc)'

odt: markdown formats-dir
	@ echo '$(ltcyan)Making ODT.$(resetc)'
	@       $(PANDOC) $(PANDOCFLAGS) $(ODT_FLAGS) -o $(ODT_OUT) $(PROJ_SRC)
	@ echo '$(ltcyan)ODT built.$(resetc)'

in-design: markdown formats-dir
	@ echo '$(ltcyan)Making InDesign.$(resetc)'
	@       $(PANDOC) $(PANDOCFLAGS) $(INDESIGN_FLAGS) -o $(INDESIGN_OUT) $(PROJ_SRC)
	@ echo '$(ltcyan)InDesign built.$(resetc)'

gfm: markdown formats-dir
	@ echo '$(ltcyan)Making GitHub-Flavored Markdown.$(resetc)'
	@       $(PANDOC) $(PANDOCFLAGS) $(GFM_FLAGS) -o $(GFM_OUT) $(PROJ_SRC)
	@ echo '$(ltcyan)GFM built.$(resetc)'

opendocument: markdown formats-dir
	@ echo '$(ltcyan)Making OpenDocument.$(resetc)'
	@       $(PANDOC) $(PANDOCFLAGS) $(OPENDOC_FLAGS) -o $(OPENDOC_OUT) $(PROJ_SRC)
	@ echo '$(ltcyan)OpenDocument built.$(resetc)'

html5: markdown formats-dir
	@ echo '$(ltcyan)Making HTML 5.$(resetc)'
	@       $(PANDOC) $(PANDOCFLAGS) $(HTML5_FLAGS) -o $(HTML5_OUT) $(PROJ_SRC)
	@ echo '$(ltcyan)HTML 5 built.$(resetc)'

html5-complete: markdown formats-dir
	@ echo '$(ltcyan)Making HTML 5 Self-Contained.$(resetc)'
	@       $(PANDOC) $(PANDOCFLAGS) $(HTML5SELF_FLAGS) -o $(HTML5SELF_OUT) $(PROJ_SRC)
	@ echo '$(ltcyan)HTML 5 Self-Contained built.$(resetc)'

formats-zip: formats formats-dir
	@ echo '$(ltorng)Removing old ZIP if present.$(resetc)'
	-@ cd $(OUTDIR); rm -f $(ZIP_FMT_OUT)
	@ echo '$(ltyelo)Copying READMEs to $(FMTDIR).$(resetc)'
	-@ cp $(DOCSDIR)/README_PIONEERS_SRC.md $(OUTDIR)/$(FMTDIR)/
	-@ cp $(DOCSDIR)/LICENSE.md $(OUTDIR)/$(FMTDIR)
	@ echo '$(ltorng)Making File Formats ZIP file.$(resetc)'
	@ cd $(OUTDIR); $(ZIP) $(ZIP_FMT_OUT) $(FMTDIR)
	@ echo '$(ltorng)File Formats ZIP file created.$(resetc)'

dist-files: dist-dir
	@ echo '$(ltorng)Removing old ZIP if present.$(resetc)'
	-@ cd $(OUTDIR); rm -f $(ZIP_DIST_OUT)
	@ echo '$(ltyelo)Copying files to $(DISTDIR).$(resetc)'
	-@ cp $(DOCSDIR)/README_PIONEERS.md $(OUTDIR)/$(DISTDIR)/
	@ cp $(PROJ_OUT)      $(OUTDIR)/$(DISTDIR)/
	@ cp $(MOBILE_OUT)    $(OUTDIR)/$(DISTDIR)/
	@ cp $(PRINT_OUT)     $(OUTDIR)/$(DISTDIR)/
	@ cp $(SHEET_OUT)     $(OUTDIR)/$(DISTDIR)/
	@ cp $(SHEET_ALT_OUT) $(OUTDIR)/$(DISTDIR)/

dist: all dist-files
	@ echo '$(ltorng)Making Distribution ZIP file.$(resetc)'
	-@ cd $(OUTDIR); $(ZIP) $(ZIP_DIST_OUT) $(DISTDIR)
	@ echo '$(ltorng)Distribution ZIP file created.$(resetc)'

# make all
#   Edit: if you are making more than one pdf or html
# all: pdf teaser html
all:     pdf print pocket sheet alt-sheet
formats: text docx rtf odt in-design gfm opendocument html5 html5-complete
all-all: all formats-zip dist teaser

# Make Aliases ##########################################################################################
#  Edit: only you if want to add something
alt-sheets:  alt-sheet
backup:      backups
charsheet:   sheet
charsheets:  sheet
dracula:     drac
fodt:        opendocument
game:        pdf
indesign:    in-design
libreoffice: odt
md:          markdown
opendoc:     opendocument
openoffice:  odt
plain:       text
plaintext:   print
pocket:      mobile
printable:   print
sheets:      sheet
txt:         text
vi:          edit
vim:         edit
word:        docx
xhtml:       html5
zip-formats: formats-zip
html-comp:   html5-complete
htmlc:       html5-complete
html5-comp:  html5-complete
source:      formats-zip
