GATK_PROTECTED_VERSION ?= 0.7.15

GATK_PROTECTED_VERSIONS := \
	3.6 \
	3.5 \
	3.4 \
	3.3 \
	3.2 \
	3.1 \
	3.0 \
#	2.8 \
#	2.7 \
#	2.6 \
#	2.5 \
#	2.4 \
#	2.3 \
#	2.2 \
#	2.1 \
#	2.0 \
#	1.6 \
#	1.5 \
#	1.4 \
#	1.3 \
#	1.2 \
#	1.1 \
#	1.0
	

.PHONY: all_gatk-protected gatk-protected

all_gatk-protected: $(foreach GATK_PROTECTED_VERSION,$(GATK_PROTECTED_VERSIONS),${LOCAL}/gatk-protected/${GATK_PROTECTED_VERSION})

gatk-protected: ${LOCAL}/gatk-protected/${GATK_PROTECTED_VERSION}

${SRC}/gatk-protected/%:
	mkdir -p $(dir $@) \
	&& cd $(dir $@) \
	&& { \
		{ curl -L https://github.com/broadgsa/gatk-protected/releases/download/v$(notdir $@)/gatk-protected-$(notdir $@).tar.bz2 | tar -xj --no-same-owner --no-same-permissions --transform 's/gatk-protected-$(notdir $@)/$(notdir $@)/' 2> /dev/null \
		|| curl -L https://github.com/broadgsa/gatk-protected/archive/$(notdir $@).tar.bz2 | tar -xj --no-same-owner --no-same-permissions --transform 's/gatk-protected-$(notdir $@)/$(notdir $@)/' 2>/dev/null; } \
		|| curl -L https://github.com/broadgsa/gatk-protected/archive/$(notdir $@).tar.gz | tar xz --no-same-owner --no-same-permissions --transform 's/gatk-protected-$(notdir $@)/$(notdir $@)/'; \
	}

${LOCAL}/gatk-protected/%: ${SRC}/gatk-protected/%
	cd $< \
	&& mvn install -DskipTests=true -Dmaven.javadoc.skip=true -B -V
