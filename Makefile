prefix = /usr/local
sysconfdir = /etc
bindir = $(prefix)/bin
mandir = $(prefix)/share/man/man1
bashcompdir = $(prefix)/share/bash-completion/completions
zshcompdir = $(prefix)/share/zsh/site-functions

.PHONY: install
install: bashlight bashlight.1 90-backlight.rules completions/bashlight completions/_bashlight
	$(NORMAL_INSTALL)
	install -vCDt $(DESTDIR)$(bindir) bashlight
	install -vCDt $(DESTDIR)$(mandir) bashlight.1
	install -vCDt $(DESTDIR)$(bashcompdir) completions/bashlight
	install -vCDt $(DESTDIR)$(zshcompdir) completions/_bashlight
	install -vCDt $(DESTDIR)$(sysconfdir)/udev/rules.d 90-backlight.rules
	$(POST_INSTALL)
ifeq ($(DESTDIR),)
	udevadm control --reload-rules
	udevadm trigger -s backlight -c add
endif

.PHONY: uninstall
uninstall:
	rm -f $(DESTDIR)$(bindir)/bashlight
	rm -f $(DESTDIR)$(mandir)/bashlight.1
	rm -f $(DESTDIR)$(bashcompdir)/bashlight
	rm -f $(DESTDIR)$(zshcompdir)/_bashlight
	rm -f $(DESTDIR)$(sysconfdir)/udev/rules.d/90-backlight.rules

.PHONY: check
check:
	shellcheck bashlight completions/bashlight
	shfmt -d bashlight completions/bashlight
	bats tests
