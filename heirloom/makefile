include config.mk

# Github version of heirloom doctools
GITURL=https://github.com/n-t-roff/heirloom-doctools.git

# Legacy version of Heirloom Doc Tools
HLMURL=http://heirloom.cvs.sourceforge.net/viewvc/heirloom/heirloom-doctools/?view=tar
HLMDIR=heirloom-doctools
HLMTAR=$(HLMDIR).tar.gz

CLEAN=$(HLMDIR) $(HLMTAR)

help:
	@echo "Installing Heirloom Doctools for Utroff -- Usage."
	@echo "1. Edit config.mk."
	@echo "2. Download the desired version:"
	@echo "    make github (last release)"
	@echo "    make sourceforge (legacy version)"
	@echo "3. configure, build, install"
	@echo "    make configure"
	@echo "    make build"
	@echo "    make install"
	@echo "4. Optionally clean the working directory."
	@echo "    make clean"
	@echo "5. Using an insecure script, you can attempt to uninstall:"
	@echo "    make uninstall"

github:
	git clone $(GITURL)

$(HLMTAR):
	wget -q -O $(HLMTAR) $(HLMURL)

sourceforge: $(HLMTAR)
	tar -xzf $(HLMTAR)

configure: $(HLMDIR)
	@test -e $(HLMDIR)/heirloom.config \
		|| mv $(HLMDIR)/mk.config $(HLMDIR)/heirloom.config
	@echo -e "INSTALL=$(INSTALL)\n\
	ROOT=$(DESTDIR)\n\
	PREFIX=$(PREFIX)\n\
	BINDIR=$(BINDIR)\n\
	LIBDIR=$(LIBDIR)\n\
	PUBDIR=$(LIBDIR)/eqn\n\
	MANDIR=$(MANDIR)\n\
	MACDIR=$(MACDIR)\n\
	FNTDIR=$(FNTDIR)\n\
	PSTDIR=$(LIBDIR)/dpost\n\
	TABDIR=$(LIBDIR)/nterm\n\
	HYPDIR=$(LIBDIR)/hyphen\n\
	REFDIR=$(REFDIR)\n\
	EUC=$(EUC)\n\
	STRIP=$(STRIP)\n\
	CC=$(CC)\n\
	CCC=$(CCC)\n\
	CFLAGS=$(CFLAGS)\n\
	CPPFLAGS=$(CPPFLAGS)\n\
	LDFLAGS=$(LDFLAGS)\n\
	LIBS=$(LIBS)\n\
	SHELL=$(SHELL)\n\
	SUBDIRS=$(HLMSUB)\n\
	RANLIB=ranlib\n\
	" > $(HLMDIR)/utroff.config
	@test -e $(HLMDIR)/mk.config \
		|| cd $(HLMDIR) && ln -s utroff.config mk.config
	@echo -e "$(HLMDIR)/mk.config created. Read it before resuming."

build:
	cd $(HLMDIR) && make SUBDIRS="$(HLMSUB)"


hlm-install:
	test -d $(DESTDIR)$(BINDIR) || mkdir -p $(DESTDIR)$(BINDIR)
	test -d $(DESTDIR)$(MANDIR)/man1 || mkdir -p $(DESTDIR)$(MANDIR)/man1
	test -d $(DESTDIR)$(LIBDIR) || mkdir -p $(DESTDIR)$(LIBDIR)
	test -d $(DESTDIR)$(MACDIR) || mkdir -p $(DESTDIR)$(MACDIR)
	test -d $(DESTDIR)$(FNTDIR) || mkdir -p $(DESTDIR)$(FNTDIR)
	cd $(HLMDIR) && make SUBDIRS="$(HLMSUB)" install

MANSED=sed -i -e '\
	s|/usr/ucblib/doctools/font/devpost/postscript|$(LIBDIR)/dpost|g; \
	s|/usr/ucblib/doctools/font|$(LIBDIR)/font|g; \
	s|/usr/ucblib/doctools/tmac/tmac\.|$(MACDIR)/|g; \
	s|/usr/ucblib/doctools/tmac|$(MACDIR)|g; \
	s|/usr/lib/lp/postscript|$(LIBDIR)/dpost|g; \
	s|/usr/ucblib|$(LIBDIR)|g; \
	s|/usr/ucb|$(BINDIR)|g; \
	s|/usr/pub/eqnchar|$(LIBDIR)/eqn/eqnchars|g;'

man-sed:
	for f in dpost eqn nroff otf_info pic tbl troff; do \
		$(MANSED) $(DESTDIR)$(MANDIR)/man1/$$f.1;\
	done
	for f in eqnchar mpictures mcolor; do \
		$(MANSED) $(DESTDIR)$(MANDIR)/man7/$$f.7;\
	done


install: hlm-install man-sed
	test -e $(DESTDIR)$(LIBDIR)/font/devpost/postscript \
	|| ln -s $(DESTDIR)$(LIBDIR)/dpost $(DESTDIR)$(LIBDIR)/font/devpost/postscript
	find $(DESTDIR)$(PREFIX) -mmin -5 > $(DESTDIR)$(PREFIX)/hlm-files
	sed -i '/hlm-files/d' $(DESTDIR)$(PREFIX)/hlm-files

uninstall:
	- cat $(DESTDIR)$(PREFIX)/hlm-files | while read line; do \
		if [ -e $$line ] && [ -f $$line ] || [ -h $$line ]; then \
			echo rm $$line; rm $$line; \
		fi; done
	- tac $(DESTDIR)$(PREFIX)/hlm-files | while read line; do \
		if [ -e $$line ] && [ -d $$line ]; then \
			echo rmdir $$line; rmdir $$line; \
		fi; done
	- rm $(DESTDIR)$(PREFIX)/hlm-files

clean:
	rm -rf $(HLMDIR) $(HLMTAR) $(GITTAR) master.zip


