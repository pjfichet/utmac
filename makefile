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

TMAC=u-apolline.tmac u-biolib.tmac u-biolinum.tmac u-en.tmac \
	u-include.tmac u-fonts.tmac u-fr.tmac uh.tmac u-idx.tmac \
	u-libertine.tmac u-links.tmac ul.tmac um.tmac u-pdf.tmac \
	u-ref.tmac us.tmac u-sum.tmac u-typo.tmac u-var.tmac \
	u-grind.tmac ut.tmac uw.tmac ux.tmac u-graph.tmac u-tbl.tmac

PREMAC=u-idx.tmac u-ref.tmac

MAN=u-ref.7 utmac.7 utmac-hack.7

all: $(TMAC) $(MAN)


%.tmac: %.tr
	sed -e "s#@BINDIR@#$(BINDIR)#g" $< > $@

%.7: %.man
	sed -e "s#@MACDIR@#$(MACDIR)#g" $< > $@

$(DESTDIR)$(MACDIR)/%: %
	@test -d $(DESTDIR)$(MACDIR) || mkdir -p $(DESTDIR)$(MACDIR)
	$(INSTALL) -c -m 644 $< $@

$(DESTDIR)$(MANDIR)/man7/%: %
	@test -d $(DESTDIR)$(MANDIR)/man7 || mkdir -p $(DESTDIR)$(MANDIR)/man7
	$(INSTALL) -c -m 644 $< $@

install: $(TMAC:%=$(DESTDIR)$(MACDIR)/%) $(MAN:%=$(DESTDIR)$(MANDIR)/man7/%)

uninstall:
	rm -f $(TMAC:%=$(DESTDIR)$(MACDIR)/%)
	rm -f $(MAN:%=$(DESTDIR)$(MANDIR)/man7/%)

clean:
	rm -f $(PREMAC) $(MAN)

tmac.eps:
	@echo Downloading tmac.eps from neatroff_make
	@wget -q https://raw.githubusercontent.com/aligrudi/neatroff_make/master/tmac/tmac.eps
