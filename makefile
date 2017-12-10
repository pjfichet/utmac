# Utmac macros and manual pages
 
# Packaging directory
DESTDIR=
# Prefix directory
PREFIX=/opt/utroff
# Bin directoy
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
u-libertine u-links u-locale ul um u-pdf u-ref us u-sum ut u-typo u-var uw ux
MAN= u-ref.7 utmac.7

.SUFFIXES: .tmac .1 .7 .man

all: $(TMAC) $(MAN)

.tmac:
	sed -e "s#@BINDIR@#$(BINDIR)#g" $< > $@

%.1 %.7: %.man
	sed -e "s#@MACDIR@#$(MACDIR)#g; s#@TMAC@#$(TMAC)#g" $< > $@

$(DESTDIR)$(MACDIR) \
$(DESTDIR)$(MANDIR)/man7:
	test -d $@ || mkdir -p $@

$(DESTDIR)$(MACDIR)/%: % $(DESTDIR)$(MACDIR)
	$(INSTALL) -c -m 644 $(@F) $@

$(DESTDIR)$(MANDIR)/man7/%: % $(DESTDIR)$(MANDIR)/man7
	$(INSTALL) -c -m 644 $(@F) $@

install: $(TMAC:%=$(DESTDIR)$(MACDIR)/%) $(MAN:%=$(DESTDIR)$(MANDIR)/man7/%)

uninstall:
	rm $(TMAC:%=$(DESTDIR)$(MACDIR)/%)
	rmdir $(DESTDIR)$(MACDIR)
	rm $(MAN:%=$(DESTDIR)$(MANDIR)/%)
	rmdir $(DESTDIR)$(MANDIR)

clean:
	rm -f $(TMAC) $(MAN)

diff:
	@for f in $(TMAC); do echo "diff $$f.tmac $$f"; diff $$f.tmac $$f; done

