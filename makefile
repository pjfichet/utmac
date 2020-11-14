# Packaging directory
DESTDIR=
# Prefix directory
PREFIX=$(HOME)/.local
# Utroff binaries (refer and idx) directory
BINDIR=$(PREFIX)/bin
# Library directory
LIBDIR=$(PREFIX)/share
# Man directory
MANDIR=$(LIBDIR)/man
# Tmac directory
MACDIR=$(LIBDIR)/tmac
# install binary
INSTALL=install

TMAC= u-apolline u-biolib u-biolinum u-en u-include u-fonts u-fr uh u-idx \
	u-libertine u-links ul um u-pdf u-ref us u-sum u-typo u-var \
	u-grind ut uw ux u-graph u-tbl

PREMAC= u-idx.tr u-ref.tr

MAN= u-ref.7 utmac.7 utmac-hack.7

all: $(TMAC:%=%.tmac) $(MAN)


%.tmac: %.tr
	sed -e "s#@BINDIR@#$(BINDIR)#g" $< > $@

%.7: %.man
	sed -e "s#@MACDIR@#$(MACDIR)#g" $< > $@

$(DESTDIR)$(MACDIR)/%.tmac: %.tmac
	@test -d $(DESTDIR)$(MACDIR) || mkdir -p $(DESTDIR)$(MACDIR)
	$(INSTALL) -c -m 644 $< $@

$(DESTDIR)$(MANDIR)/man7/%: %
	@test -d $(DESTDIR)$(MANDIR)/man7 || mkdir -p $(DESTDIR)$(MANDIR)/man7
	$(INSTALL) -c -m 644 $< $@

install: $(TMAC:%=$(DESTDIR)$(MACDIR)/%.tmac) $(MAN:%=$(DESTDIR)$(MANDIR)/man7/%)

uninstall:
	rm -f $(TMAC:%=$(DESTDIR)$(MACDIR)/%.tmac)
	rm -f $(MAN:%=$(DESTDIR)$(MANDIR)/man7/%)

clean:
	rm -f $(PREMAC:%=%.tmac) $(MAN)

tmac.eps:
	@echo Downloading tmac.eps from neatroff_make
	@wget -q https://raw.githubusercontent.com/aligrudi/neatroff_make/master/tmac/tmac.eps
