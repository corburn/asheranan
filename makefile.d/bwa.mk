BWA_VERSION ?= 0.7.15

BWA_VERSIONS := \
	0.7.15 \
	0.7.13 \
	0.7.12 \
	0.7.11 \
	0.7.10 \
	0.7.9 \
	0.7.8 \
	0.7.7 \
	0.7.5
	

.PHONY: all_bwa bwa

all_bwa: $(foreach BWA_VERSION,$(BWA_VERSIONS),${LOCAL}/bwa/${BWA_VERSION})

bwa: ${LOCAL}/bwa/${BWA_VERSION}

${SRC}/bwa/%:
	mkdir -p $(dir $@) \
	&& cd $(dir $@) \
	&& { \
		{ curl -L https://github.com/lh3/bwa/releases/download/v$(notdir $@)/bwa-$(notdir $@).tar.bz2 | tar -xj --no-same-owner --no-same-permissions --transform 's/bwa-$(notdir $@)/$(notdir $@)/' 2> /dev/null \
		|| curl -L https://github.com/lh3/bwa/archive/$(notdir $@).tar.bz2 | tar -xj --no-same-owner --no-same-permissions --transform 's/bwa-$(notdir $@)/$(notdir $@)/' 2>/dev/null; } \
		|| curl -L https://github.com/lh3/bwa/archive/$(notdir $@).tar.gz | tar xz --no-same-owner --no-same-permissions --transform 's/bwa-$(notdir $@)/$(notdir $@)/'; \
	}

${LOCAL}/bwa/%: ${SRC}/bwa/%
	${MAKE} -C $<
	mkdir -m 0755 $@/bin
	install -D --target-directory=$@/bin $</bwa $(wildcard $</*.pl)
	$(info TODO: install bwakit)
