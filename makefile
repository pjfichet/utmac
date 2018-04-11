# Utmac macros and manual pages
 
# Packaging directory
DESTDIR=
# Prefix directory
PREFIX=/opt/utroff
# Utroff bin directory
BINDIR=$(PREFIX)/bin
# Man directory
MANDIR=$(PREFIX)/man
# Library directory
LIBDIR=$(PREFIX)/lib
# Tmac directory
MACDIR=$(LIBDIR)/tmac
# Install binary
INSTALL=/usr/bin/install

TMAC= u-apolline u-biolib u-biolinum u-en u-eps u-fonts u-fr u-grind uh u-idx \
u-libertine u-links ul um u-pdf u-ref us u-sum ut u-typo u-var uw ux
MAN= u-ref.7 utmac.7 utmac-hack.7

.SUFFIXES: .tmac .1 .7 .man

all: $(TMAC) $(MAN)

.tmac:
	sed -e "s#@BINDIR@#$(BINDIR)#g" $< > $@

%.7: %.man
	sed -e "s#@MACDIR@#$(MACDIR)#g; s#@TMAC@#$(TMAC)#g" $< > $@

$(DESTDIR)$(MACDIR)/%: %
	@test -d $(DESTDIR)$(MACDIR) || mkdir -p $(DESTDIR)$(MACDIR)
	$(INSTALL) -c -m 644 $(@F) $@

$(DESTDIR)$(MANDIR)/man7/%: %
	@test -d $(DESTDIR)$(MANDIR)/man7 || mkdir -p $(DESTDIR)$(MANDIR)/man7
	$(INSTALL) -c -m 644 $(@F) $@

install: $(TMAC:%=$(DESTDIR)$(MACDIR)/%) $(MAN:%=$(DESTDIR)$(MANDIR)/man7/%)

uninstall:
	rm -f $(TMAC:%=$(DESTDIR)$(MACDIR)/%)
	rm -f $(MAN:%=$(DESTDIR)$(MANDIR)/man7/%)

clean:
	rm -f $(TMAC) $(MAN)

diff:
	@for f in $(TMAC); do echo "diff $$f.tmac $$f"; diff $$f.tmac $$f; done

