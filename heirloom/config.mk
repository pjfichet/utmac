### Installation ###

# Packaging directory
DESTDIR=
# Prefix directory
PREFIX=/opt/utroff
# Where to place binaries
# and where to find utroff tools
BINDIR=$(PREFIX)/bin
# Where to place manuals
MANDIR=$(PREFIX)/man
# Where to place libraries
LIBDIR=$(PREFIX)/lib
# Where to place refer utilities
REFDIR=$(LIBDIR)/refer
# Where to place troff macros
MACDIR=$(LIBDIR)/tmac
# Where to place the troff fonts
FNTDIR=$(LIBDIR)/font
# Where are placed OTF fonts in your system
OTFDIR=/usr/share/fonts/OTF

### Build dependencies ###

# Posix shell
SHELL=/bin/sh
# Strip
STRIP=strip -s -R .comment -R .note
# Install
INSTALL=/usr/bin/install
# C compiler
CC=gcc
# C++ compiler
CCC=c++
# compilier flags
CFLAGS=-O
# Compiler warning
WARN=-Wall
# Support for locale specific character 
EUC=-DEUC
# Linker flags
LDFLAGS=
# Additionnal libraries to link with
LIBS=
# C preprocessor flags.
# Use -D_GNU_SOURCE for Linux with GNU libc.
# Use -D_INCLUDE__STDC_A1_SOURCE for HP-UX.
CPPFLAGS=-D_GNU_SOURCE

# Only build nroff and troff
HLMSUB= \
	stuff/bst \
	troff/libhnj \
	troff/libhnj/hyphen.d \
	troff/troff.d/font \
	troff/troff.d/tmac.d \
	troff/troff.d/postscript \
	troff/troff.d \
	troff/troff.d/dpost.d \
	troff/nroff.d \
	troff/nroff.d/terms.d \
	soelim \

# Uncomment the following line to build other tools
#HLMSUB+=eqn/eqn.d eqn/neqn.d eqn/checkeq.d eqn/eqnchar.d
#HLMSUB+=tbl
#HLMSUB+=pic
#HLMSUB+=grap picpack
#HLMSUB+=checknr
#HLMSUB+=mpm ptx

# uncomment if you prefer heirloom tools than utroff ones
#HLMSUB+=vgrind refer soelim


