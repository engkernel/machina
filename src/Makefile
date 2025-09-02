SUBDIRS := $(filter-out include/,$(wildcard */))

all:
	@for dir in $(SUBDIRS); do \
		$(MAKE) -C $$dir; \
	done

.PHONE: clean
clean:
	@for dir in $(SUBDIRS); do \
		$(MAKE) -C $$dir clean; \
	done
