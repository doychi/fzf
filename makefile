#
# This makefile perorms the install steps to allow Debian packing
# DH Make
#
#
DESTDIR=/usr/local

URL=https://github.com/junegunn/fzf-bin/releases/download/$(VERSION)/$(BINFILE).tgz

VERSION=0.12.0
ARCH=linux_amd64
BINFILE=fzf-$(VERSION)-$(ARCH)

MANFILE=fzf.1
MANDEST=$(DESTDIR)/share/man/man1
MANSRC=./man/man1
MANDESTFILE=$(MANDEST)/$(MANFILE)
MANSRCFILE=$(MANSRC)/$(MANFILE)

DESTFILE=$(DESTDIR)/bin/$(BINFILE)
DESTLNK=$(DESTDIR)/bin/fzf

install: bin/$(BINFILE)
	echo Installing
	cp bin/$(BINFILE) $(DESTFILE)
	ln -s $(DESTDIR)/bin/$(BINFILE) $(DESTLNK)
	mkdir -p $(MANDEST)
	cp -r $(MANSRCFILE) $(MANDEST)
	mandb

bin/$(BINFILE):
	echo Downloading Binary
	curl -fL $(URL) | tar -xz -C bin
	touch bin/$(BINFILE)

uninstall: FORCE
	if [ -e $(DESTFILE) ] ; then \
		rm $(DESTFILE) ; \
	fi
	if [ -e $(DESTLNK) ] ; then \
		rm $(DESTLNK) ; \
	fi
	if [ -e $(MANDESTFILE) ] ; then \
		rm $(MANDESTFILE) ; \
	fi
	if [ -e $(MANDEST)/* ] ; then \
		rmdir $(MAKEDEST) ; \
	fi
	mandb

clean: FORCE
	rm bin/$(BINFILE)
	
.PHONY: clean uninstall

FORCE:
	

