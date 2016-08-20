BOWTIE2_VERSION ?= 2.2.9

BOWTIE2_VERSIONS := \
	2.0.5 \
	2.0.6 \
	2.0.7 \
	2.2.0 \
	2.2.1 \
	2.2.2 \
	2.2.3 \
	2.2.4 \
	2.2.5 \

FOO := \
	2.2.6 \
	2.2.7 \
	2.2.8 \
	2.2.9 \
	

.PHONY: all_bowtie2 bowtie2

all_bowtie2: $(foreach BOWTIE2_VERSION,$(BOWTIE2_VERSIONS),${LOCAL}/bowtie2/${BOWTIE2_VERSION})

bowtie2: ${LOCAL}/bowtie2/${BOWTIE2_VERSION}

${SRC}/bowtie2/%:
	mkdir -p $(dir $@) \
	&& cd $(dir $@) \
	&& { \
		{ ${CURL} -L https://github.com/BenLangmead/bowtie2/releases/download/v$(notdir $@)/bowtie2-$(notdir $@).tar.bz2 | tar -xj --no-same-owner --no-same-permissions --transform 's/bowtie2-$(notdir $@)/$(notdir $@)/' 2> /dev/null \
		|| ${CURL} -L https://github.com/BenLangmead/bowtie2/archive/v$(notdir $@).tar.bz2 | tar -xj --no-same-owner --no-same-permissions --transform 's/bowtie2-$(notdir $@)/$(notdir $@)/' 2>/dev/null; } \
		|| ${CURL} -L https://github.com/BenLangmead/bowtie2/archive/v$(notdir $@).tar.gz | tar xz --no-same-owner --no-same-permissions --transform 's/bowtie2-$(notdir $@)/$(notdir $@)/'; \
	}

${LOCAL}/bowtie2/%: ${SRC}/bowtie2/%
	${MAKE} -C $<

	# Insert a basic install rule if not present.
	# Assign a default value to the prefix variable in case the Makefile
	# is run outside this script without passing a value to prefix.
	grep -q '^install:' $</Makefile \
	|| $(info insert an install rule) \
	printf '\n\nprefix ?= /usr/local\n.PHONY: install\ninstall: $${BOWTIE2_BIN_LIST}\n\tinstall -D --target-directory=$${prefix}/bin $${BOWTIE2_BIN_LIST}\n' >> $</Makefile \
	&& mkdir -m 0755 -p $@/bin

	${MAKE} -C $< prefix=$@ install
