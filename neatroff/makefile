PREFIX=$(HOME)/.local/
BINDIR=$(PREFIX)/bin
LIBDIR=$(PREFIX)/share
MACDIR=$(LIBDIR)/tmac
HYPDIR=$(LIBDIR)/hyph
FNTDIR=$(LIBDIR)/font
TTFDIR=$(FNTDIR)/ttf
DEVDIR=$(FNTDIR)/devutf
OTFDIR=/usr/share/fonts/
HYLANG=fr

FONTS =	LinBiolinum_K \
	LinBiolinum_RB \
	LinBiolinum_RI \
	LinBiolinum_R \
	LinLibertine_DR \
	LinLibertine_I \
	LinLibertine_M \
	LinLibertine_RBI \
	LinLibertine_RB \
	LinLibertine_RI \
	LinLibertine_R \
	LinLibertine_RZI \
	LinLibertine_RZ

help:
	@echo "Run make target, with target in:"
	@echo "    help: short usage."
	@echo "    bin: build roff, post, pdf, mkfn."
	@echo "    install: install roff, post, pdf, and mkfn."
	@echo "    fonts: install the linux libertine font."
	@echo "    hyphen: download the hyphenation files."
	@echo "    all: install everything"
	@echo "    clean: clean the current directory."
	@echo "    uninstall: uninstall everything."

ALLDIR=$(BINDIR) $(LIBDIR) $(DEVDIR) $(FNTDIR) $(TTFDIR) $(HYPDIR)
NEAT = neatroff neatpost neatmkfn

$(ALLDIR):
	mkdir -p $@

$(NEAT):
	git clone git://repo.or.cz/$@.git

mkfn: neatmkfn
	cd $< && $(MAKE)

roff: neatroff
	-cd neatroff && git apply ../neatroff.diff
	cd neatroff && $(MAKE) FDIR="$(FNTDIR)" MDIR="$(MACDIR)"

post: neatpost
	-cd neatpost && git apply ../invisible_links.diff
	-cd neatpost && git apply ../metadata.diff
	cd neatpost && $(MAKE) FDIR="$(FNTDIR)" MDIR="$(MACDIR)"

install: $(BINDIR)
	install -c neatmkfn/mkfn $(BINDIR)/mkfn
	install -c neatroff/roff $(BINDIR)/roff
	install -c neatpost/post $(BINDIR)/post
	install -c neatpost/pdf $(BINDIR)/pdf

bin: mkfn roff post

.PHONY: mkfn roff post install bin

### Fonts

$(TTFDIR)/%.ttf:
	@echo "Generating $@"
	@find $(OTFDIR) -name $(notdir $(basename $@)).otf | while read FN; do \
	fontforge -lang=ff -c "Open(\"$$FN\"); Generate(\"$@\");" > /dev/null 2>&1; \
	done

$(DEVDIR)/DESC:
	@echo "Generating $@"
	@echo "fonts 1 LinLibertine_R" > $@
	@echo "res 720" >> $@
	@echo "hor 1" >> $@
	@echo "ver 1" >> $@
	@echo "unitwidth 10" >> $@

$(DEVDIR)/%: $(TTFDIR)/%.ttf
	@echo "Generating $@"
	@cat $< | $(BINDIR)/mkfn -b -l -o -r720 -Slatn -t $(notdir $@) -f "$<" > $@

fonts: $(TTFDIR) $(DEVDIR) \
	$(FONTS:%=$(TTFDIR)/%.ttf) \
	$(DEVDIR)/DESC $(FONTS:%=$(DEVDIR)/%) 

.PHONY: fonts

### Hyphenation files

CTAN=http://ctan.org/tex-archive/language/hyph-utf8/tex/generic/hyph-utf8/patterns/txt/

$(HYPDIR)/%:
	@echo "Downloading $@"
	@wget -O $@ "$(CTAN)/hyph-$(notdir $@)"

hyphen: $(HYPDIR) $(HYLANG:%=$(HYPDIR)/%.hyp.txt) \
	$(HYLANG:%=$(HYPDIR)/%.pat.txt) \
	$(HYLANG:%=$(HYPDIR)/%.chr.txt)

.PHONY: hyphen


### all

all: bin install fonts hyphen

clean:
	rm -rf $(NEAT)

uninstall:
	rm -f $(BINDIR)/mkfn $(BINDIR)/roff $(BINDIR)/post $(BINDIR)/pdf
	rm -f $(FONTS:%=$(TTFDIR)/%.ttf)  $(DEVDIR)/DESC $(FONTS:%=$(DEVDIR)/%)
	rm -f $(HYLANG:%=$(HYPDIR)/%.hyp.txt) $(HYLANG:%=$(HYPDIR)/%.pat.txt) \
		$(HYLANG:%=$(HYPDIR)/%.chr.txt)

.PHONY: all clean uninstall
