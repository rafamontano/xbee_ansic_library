SUBDIRS := src

all: $(SUBDIRS)

.PHONY: $(SUBDIRS)
$(SUBDIRS):
	$(MAKE) -C $@

.PHONY: clean install uninstall
clean install uninstall:
	for a in $(SUBDIRS); do $(MAKE) -C $$a $@; done
