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
	

.PHONY: all_gatk_protected gatk_protected

all_gatk_protected: $(foreach GATK_PROTECTED_VERSION,$(GATK_PROTECTED_VERSIONS),${LOCAL}/gatk_protected/${GATK_PROTECTED_VERSION})

gatk_protected: ${LOCAL}/gatk_protected/${GATK_PROTECTED_VERSION}

${SRC}/gatk_protected/%:
	mkdir -p $(dir $@) \
	&& cd $(dir $@) \
	&& { \
		{ ${CURL} -L https://github.com/broadgsa/gatk-protected/releases/download/v$(notdir $@)/gatk-protected-$(notdir $@).tar.bz2 | tar -xj --no-same-owner --no-same-permissions --transform 's/gatk-protected-$(notdir $@)/$(notdir $@)/' 2> /dev/null \
		|| ${CURL} -L https://github.com/broadgsa/gatk-protected/archive/$(notdir $@).tar.bz2 | tar -xj --no-same-owner --no-same-permissions --transform 's/gatk-protected-$(notdir $@)/$(notdir $@)/' 2>/dev/null; } \
		|| ${CURL} -L https://github.com/broadgsa/gatk-protected/archive/$(notdir $@).tar.gz | tar xz --no-same-owner --no-same-permissions --transform 's/gatk-protected-$(notdir $@)/$(notdir $@)/'; \
	}

# -T 1C allocates 1 thread per cpu core
# See https://cwiki.apache.org/confluence/display/MAVEN/Parallel+builds+in+Maven+3
${LOCAL}/gatk_protected/%: ${SRC}/gatk_protected/%
	cd $< \
	&& ${MVN} install -T 1C -DskipTests=true -Dmaven.javadoc.skip=true -B -V
