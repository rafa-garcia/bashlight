prefix = /usr/local
sysconfdir = /etc
bindir = $(prefix)/bin
mandir = $(prefix)/share/man/man1

.PHONY: install
install: bashlight bashlight.1 90-backlight.rules
	$(NORMAL_INSTALL)
	install -vCDt $(DESTDIR)$(bindir) bashlight
	install -vCDt $(DESTDIR)$(mandir) bashlight.1
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
	rm -f $(DESTDIR)$(sysconfdir)/udev/rules.d/90-backlight.rules

.PHONY: check
check:
	shellcheck bashlight
	shfmt -d bashlight
	bats tests
