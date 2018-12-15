# Formatting text with Neatroff

# Default macro
TMAC=-mul
#TMAC=-muh -mu-apolline -mu-fr

# Prefix directory
PREFIX=$(HOME)/dev
# Where to find neatroff and utroff binaries 
BINDIR=$(PREFIX)/bin
# Where to find neatroff libraries
LIBDIR=$(PREFIX)/lib
# Where to find troffxml xsl stylesheet
XSLDIR=$(LIBDIR)/xslt
# Where to find utmac macros
MACDIR=$(LIBDIR)/tmac
# Where to find troff fonts
FNTDIR=$(LIBDIR)/font
# Where to find OTF fonts
OTFDIR=/usr/share/fonts/OTF:/usr/share/fonts/ttf-linux-libertine/

# Neatroff tools
ROFF=$(BINDIR)/roff
PDF=$(BINDIR)/pdf
POST=$(BINDIR)/post
TBL=$(BINDIR)/tbl
EQN=$(BINDIR)/eqn
# Utroff tools
REFER=$(BINDIR)/refer
UGRIND=$(BINDIR)/ugrind
PREXML=$(BINDIR)/prexml
POSTXML=$(BINDIR)/postxml

# Groff tools
NROFF=groff -k -Tutf8 -M$(MACDIR)
SOELIM=soelim


# ps2pdf setting
FONTS=$(FNTDIR)/:$(OTFDIR)/
PDFFLAGS1=-q -dPDFSETTINGS=/prepress -dEmbedAllFonts=true \
		  -sFONTPATH=$(FONTS)
PDFFLAGS2=-dBATCH -dNOPAUSE -sDEVICE=pdfwrite \
		  -sProcessColorModel=DeviceGray
PDFCRYPT=-sOwnerPassword="`dd if=/dev/random bs=12 count=1 2>/dev/null \
		| md5sum | awk '{ print $$1 }'` " -dEncryptionR=3 \
		-dKeyLength=128 -dPermissions=-300

ALL=fonts index layout links notes para refer ugrind orphan

all: $(ALL:%=%.ps.pdf)

%.tmp: %.tr
	@echo "Generating $@"
	@#$(SOELIM) $< $(EQN) | $(TBL) > $@
	@$(SOELIM) $< | $(UGRIND) | $(REFER) -a -b -dAE -p refer.ref > $@
	@#$(SOELIM) $< | $(UGRIND) | $(EQN) | $(TBL) | $(REFER) -a -b -dAE -p refer.ref > $@
	@#cp $< $@

%.to: %.tmp
	@echo "Generating $@ with $(TMAC)"
	@$(ROFF) $(TMAC) $< > $@

%.ps:
	@echo "Generating $@"
	@$(ROFF) $(TMAC) $< > /dev/null 2>&1 
	@$(ROFF) $(TMAC) $< > /dev/null 2>&1
	@$(ROFF) $(TMAC) $< | $(POST) -pa4 >$@

%.ps.pdf: %.ps
	@echo "Generating $@"
	@ps2pdf $(PDFFLAGS1) $< $@

%.pdf: %.tmp
	@echo "Generating $@"
	@$(ROFF) $(TMAC) $< > /dev/null 2>&1
	@$(ROFF) $(TMAC) $< > /dev/null 2>&1
	@$(ROFF) $(TMAC) $< | $(PDF) -pa4 > $@

%.c.pdf: %.pdf
	@echo "Compressing $<"
	@#mutool convert -o $@ -O compress,compress-fonts $<
	@gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 \
	-dPDFSETTINGS=/screen -dNOPAUSE -dQUIET -dBATCH \
	-sOutputFile=$@ $<


%-crypt.pdf: %.ps
	@echo "Generating $@"
	@ps2pdf $(PDFFLAGS1) $(CRYPT) $< $@

%.txt: %.tmp
	@echo "Generating $@"
	@$(NROFF) -mut $< > $@

%.mkd: %.tmp
	@echo "Generating $@"
	@$(NROFF) -muw $< > $@

%.man: %.tr
	@echo "Generating $@"
	@$(SOELIM) $< | $(UGRIND) | $(NROFF) -mum $< > $@

%.xml: %.tmp
	@echo "Generating $@"
	@$(PREXML) < $< | $(UGRIND) | $(NROFF) -mux | $(POSTXML) > $@

%.html: %.xml
	@echo "Generating $@"
	@xsltproc $(XSLDIR)/utohtml.xsl $< > $@

%.fodt: %.xml
	@echo "Generating $@"
	@xsltproc $(XSLDIR)/utofodt.xsl $< > $@

clean:
	@rm -f *.ig $(ALL:%=%.tmp) $(ALL:%=%.to) $(ALL:%=%.ps) $(ALL:%=%.ps.pdf) $(ALL:%=%.pdf) $(ALL:%=%.txt) $(ALL:%=%.txt) $(ALL:%=%.man) $(ALL:%=%.xml) $(ALL:%=%.html) $(ALL:%=%.fodt)
