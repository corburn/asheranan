VARSCAN_VERSION ?= 2.4.2

VARSCAN_VERSIONS := \
	2.4.0 \
	2.4.1 \
	2.4.2

.PHONY: all_varscan varscan

all_varscan: $(foreach VARSCAN_VERSION,$(VARSCAN_VERSIONS),${LOCAL}/varscan/${VARSCAN_VERSION})

varscan: ${LOCAL}/varscan/${VARSCAN_VERSION}

# This one has an 'v' before the first version number in the url
${SRC}/varscan/2.4.1:
	mkdir -p $@
	${CURL} -L -o $@/VarScan.jar https://github.com/dkoboldt/varscan/releases/download/v$(notdir $@)/VarScan.v$(notdir $@).jar

${SRC}/varscan/%:
	mkdir -p $@
	${CURL} -L -o $@/VarScan.jar https://github.com/dkoboldt/varscan/releases/download/$(notdir $@)/VarScan.v$(notdir $@).jar

${LOCAL}/varscan/%: ${SRC}/varscan/%
	mkdir -m 0755 -p $@
	mv $</VarScan.jar $@
