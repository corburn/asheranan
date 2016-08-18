SRC ?= /usr/local/src
LOCAL ?= /opt

SAMTOOLS_VERION ?= 1.3.1

# samtools v0.1.x
# These versions do not depend on the samtools htslib.
SAMTOOLS_V0_1_X := \
	0.1.18 \
	0.1.19 \
	0.1.20 \

# samtools v1.x
SAMTOOLS_V1_X := \
	1.0 \
	1.1 \
	1.2 \
	1.3 \
	1.3.1

.PHONY: all_samtools samtools

# Compile all samtools versions
all_samtools: $(foreach SAMTOOLS_VERSION,$(SAMTOOLS_V0_1_X),${LOCAL}/samtools/${SAMTOOLS_VERSION}) $(foreach SAMTOOLS_VERSION,$(SAMTOOLS_V1_X),${LOCAL}/samtools/${SAMTOOLS_VERSION})

samtools: ${LOCAL}/samtools/${SAMTOOLS_VERSION}


### DOWNLOAD SOURCE ###

## SAMTOOLS SOURCE ##

# Pattern rule to download source for any samtools version
# SAMTOOLS_VERSION == '%' in the target and $(notdir $@) in the rule
${SRC}/samtools/%:
	mkdir -p $(dir $@) \
	&& cd $(dir $@) \
	&& { \
		{ curl -L https://github.com/samtools/samtools/releases/download/$(notdir $@)/samtools-$(notdir $@).tar.bz2 | tar -xj --no-same-owner --no-same-permissions --transform 's/samtools-$(notdir $@)/$(notdir $@)/' 2> /dev/null \
		|| curl -L https://github.com/samtools/samtools/archive/$(notdir $@).tar.bz2 | tar -xj --no-same-owner --no-same-permissions --transform 's/samtools-$(notdir $@)/$(notdir $@)/' 2>/dev/null; } \
		|| curl -L https://github.com/samtools/samtools/archive/$(notdir $@).tar.gz | tar xz --no-same-owner --no-same-permissions --transform 's/samtools-$(notdir $@)/$(notdir $@)/'; \
	}


## HTSLIB SOURCE ##

${SRC}/htslib/%:
	mkdir -p $(dir $@) \
	&& cd $(dir $@) \
	&& { \
		{ curl -L https://github.com/samtools/htslib/releases/download/$(notdir $@)/htslib-$(notdir $@).tar.bz2 | tar -xj --no-same-owner --no-same-permissions --transform 's/htslib-$(notdir $@)/$(notdir $@)/' 2> /dev/null \
		|| curl -L https://github.com/samtools/htslib/archive/$(notdir $@).tar.bz2 | tar -xj --no-same-owner --no-same-permissions --transform 's/htslib-$(notdir $@)/$(notdir $@)/' 2>/dev/null; } \
		|| curl -L https://github.com/samtools/htslib/archive/$(notdir $@).tar.gz | tar xz --no-same-owner --no-same-permissions --transform 's/htslib-$(notdir $@)/$(notdir $@)/'; \
	}

## BCFTOOLS SOURCE ##


$(addprefix ${SRC}/bcftools/, 1.0 1.1):
	mkdir -p $(dir $@) \
	&& cd $(dir $@) \
	&& wget https://github.com/samtools/bcftools/archive/$(notdir $@).tar.gz \
	&& tar xf $(notdir $@).tar.gz --transform 's/bcftools-$(notdir $@)/$(notdir $@)/' \
	&& rm $(notdir $@).tar.gz


### COMPILE ###

$(addprefix ${LOCAL}/samtools/, $(SAMTOOLS_V0_1_X)): ${LOCAL}/samtools/%: ${SRC}/samtools/%
	sed -i "s|^prefix.*=|prefix = $@|" $</Makefile
	$(MAKE) -C $<
	#mkdir -m 755 -p $@/bin $@/share/man1/man
	install -D --target-directory=$@/bin $(addprefix $</, samtools bcftools/bcftools bcftools/vcfutils.pl)
	install -D --target-directory=$@/bin $(filter-out $</misc/Makefile $(wildcard $</misc/*.h) $(wildcard $</misc/*.c) $(wildcard $</misc/*.java), $(wildcard $</misc/*))
	install -D --target-directory=$@/share/man --mode=0644 $</samtools.1 || true
	install -D --target-directory=$@/share/man --mode=0644 $</bcftools/bcftools.1 || true

$(addprefix ${LOCAL}/samtools/, 1.0 1.1): ${LOCAL}/samtools/%: ${SRC}/samtools/% ${SRC}/htslib/%
	sed -i "s|^prefix.*=|prefix = $@|" $</Makefile
	sed -i "s|^HTSDIR.*=|HTSDIR = ${SRC}/htslib/$(notdir $@)|" $</Makefile
	$(MAKE) -C $<
	mkdir -m 755 -p $@/bin $@/share/man/man1
	install -D --target-directory=$@/bin $</samtools
	install -D --target-directory=$@/bin $(filter-out Makefile $(wildcard $</misc/*.c) $(wildcard $</misc/*.c) $(wildcard $</misc/*.java), $(wildcard $</misc/*))
	install -D --target-directory=$@/share/man/man1 --mode=0644 $</samtools.1 || true
	install -D --target-directory=$@/share/man/man1 --mode=0644 $</bcftools/bcftools.1 || true

${LOCAL}/samtools/1.2: ${SRC}/samtools/1.2 ${SRC}/htslib/1.2.1
	sed -i "s|^prefix.*=|prefix = $@|" $</Makefile
	sed -i "s|^HTSDIR.*=|HTSDIR = ${SRC}/htslib/1.2.1|" $</Makefile
	$(MAKE) -C $<
	${MAKE} -C $< install

${LOCAL}/samtools/%: ${SRC}/samtools/% ${SRC}/htslib/%
	cd $< \
	&& ./configure --prefix=$@ --with-htslib=${SRC}/htslib/$(notdir $@) \
	&& ${MAKE} \
	&& ${MAKE} install
