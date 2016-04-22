#
# This makefile perorms the install steps to allow Debian packing
# DH Make
#
#
DESTDIR=/usr/local
DESTCONF=/etc/fzf

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

SCRIPTS=shell
PLUGINS=plugin

install: bin/$(BINFILE) $(DESTCONF)
	@echo Installing
	cp bin/$(BINFILE) $(DESTFILE)
	ln -s $(DESTDIR)/bin/$(BINFILE) $(DESTLNK)
	mkdir -p $(MANDEST)
	cp -r $(MANSRCFILE) $(MANDEST)
	mandb
	@echo "Configuraiton files for Vim, Bash, Zsh and Fish etc are in: "
	@echo "	$(DESTCONF)"
	@echo "This configuration is not linked to other configuraion files."

bin/$(BINFILE):
	@echo Downloading Binary
	curl -fL $(URL) | tar -xz -C bin
	touch bin/$(BINFILE)

$(DESTCONF):
	@echo Installing configuration
	mkdir $(DESTCONF)
	mkdir -p $(DESTCONF)/$(SCRIPTS)
	mkdir -p $(DESTCONF)/$(PLUGINS)
	cp $(SCRIPTS)/* $(DESTCONF)/$(SCRIPTS)
	cp $(PLUGINS)/* $(DESTCONF)/$(PLUGINS)

uninstall: FORCE
	if [ -e $(DESTFILE) ] ; then \
		echo "removing $(DESTFILE)" ; \
		rm $(DESTFILE) ; \
	fi
	if [ -L $(DESTLNK) ] ; then \
		echo "removing $(DESTLNK)" ; \
		rm $(DESTLNK) ; \
	fi
	# Remove the man page
	if [ -e $(MANDESTFILE) ] ; then \
		echo "removing $(MANDESTFILE)" ; \
		rm $(MANDESTFILE) ; \
	fi
	rmdir $(MANDEST)
	mandb
	# Remove the configuration
	if [ -d $(DESTCONF) ] ; then \
		echo "removing $(DESTCONF)" ; \
		rm -fr $(DESTCONF) ; \
	fi

clean: FORCE
	rm bin/$(BINFILE)
	
.PHONY: clean uninstall

FORCE:
	

