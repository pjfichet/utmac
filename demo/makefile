# Formatting text with Troff

# Default macro
M=-mul
#M=-muh -mu-apolline -mu-fr

# Prefix directory
PREFIX=/opt/utroff
# Where to find heirloom troff binaries 
BINDIR=$(PREFIX)/bin
# Where to find heirloom troff libraries
LIBDIR=$(PREFIX)/lib
# Where to find utroff xsl stylesheet
XSLDIR=$(LIBDIR)/xsl
# Where to find utmac macros
MACDIR=$(LIBDIR)/tmac
# Where to find troff fonts
FNTDIR=$(LIBDIR)/font
# Where to find OTF fonts
OTFDIR=/usr/share/fonts/OTF:/usr/share/fonts/ttf-linux-libertine/

# Where to find Heirloom tools
# Heirloom troff
TROFF=$(BINDIR)/troff
# Heirloom nroff
NROFF=$(BINDIR)/nroff
# Heirloom dpost
DPOST=$(BINDIR)/dpost
# Heirloom tbl
TBL=$(BINDIR)/tbl
# Heirloom eqn
EQN=$(BINDIR)/eqn

# Where to find Utroff tools
# Utroff refer
REFER=$(BINDIR)/refer
# Utroff soelim
SOELIM=$(BINDIR)/soelim
# Utroff ugrind
UGRIND=$(BINDIR)/ugrind
# Utroff prexml
PREXML=$(BINDIR)/prexml
# Utroff postxml
POSTXML=$(BINDIR)/postxml

# ps2pdf setting
PDFFLAGS1=-q -dPDFSETTINGS=/prepress -dEmbedAllFonts=true \
		  -sFONTPATH=$(TROFFONTS)
PDFFLAGS2=-dBATCH -dNOPAUSE -sDEVICE=pdfwrite \
		  -sProcessColorModel=DeviceGray
PDFCRYPT=-sOwnerPassword="`dd if=/dev/random bs=12 count=1 2>/dev/null \
		| md5sum | awk '{ print $$1 }'` " -dEncryptionR=3 \
		-dKeyLength=128 -dPermissions=-300



TROFFMACS=$(MACDIR)/
TROFFONTS=$(FNTDIR)/:$(OTFDIR)/
export TROFFONTS
export TROFFMACS

all: fonts.pdf index.pdf layout.pdf links.pdf notes.pdf para.pdf refer.pdf ugrind.pdf

%.tmp: %.tr
	@echo "Generating $@"
	@#$(SOELIM) $< | $(UGRIND) | $(EQN) | $(TBL) | $(REFER) -a -b -dAE -p $$(basename $< .tr).ref > $@
	@$(SOELIM) $< | $(UGRIND) | $(REFER) -a -b -dAE -p $$(basename $< .tr).ref > $@

%.to: %.tmp
	@echo "Generating $@ with $(M), pass 1"
	@$(TROFF) -rRH=0 $(M) $< 2>&1 > /dev/null
	@echo "Generating $@ with $(M), pass 2"
	@$(TROFF) -rRH=0 $(M) $< 2>&1 > /dev/null
	@echo "Generating $@ with $(M), pass 3"
	@$(TROFF) -rRH=1 $(M) $< > $@

%.ps: %.to
	@echo "Generating $@"
	@cat $< | $(DPOST) -pa4 >$@

%.pdf: %.ps
	@echo "Generating $@"
	@ps2pdf $(PDFFLAGS1) $< $@

%-crypt.pdf: %.ps
	@echo "Generating $@"
	@ps2pdf $(PDFFLAGS1) $(CRYPT) $< $@

%.txt: %.tmp
	@echo "Generating $@"
	@$(NROFF) -Tlocale -mut $< > $@

%.mkd: %.tmp
	@echo "Generating $@"
	@$(NROFF) -Tlocale -muw $< > $@

%.man: %.tr
	@echo "Generating $@"
	@cat $< | $(SOELIM) | $(UGRIND) \
		| $(REFER) -p $$(basename $< .tr).ref > $@ \
		| $(NROFF) -Tlocale -mum $< > $@

%.xml: %.tmp
	@echo "Generating $@"
	@$(PREXML) < $< | $(NROFF) -Tlocale -mux | $(POSTXML) > $@

%.html: %.xml
	@echo "Generating $@"
	@xsltproc $(XSLDIR)/utohtml.xsl $< > $@

%.fodt: %.xml
	@echo "Generating $@"
	@xsltproc $(XSLDIR)/utofodt.xsl $< > $@

clean:
	@rm -f *.ig *.tmp *.to *.ps *.pdf *.txt *.mkd *.man *.xml *.html *.fodt

