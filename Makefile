# Variables

.PHONY: all dcurl iri check

# Rules
all: dcurl iri

dcurl:
	git submodule update --init $@
	# FIXME: support other architecture rather than x86_64
	$(MAKE) -C $@ BUILD_AVX=1 BUILD_JNI=1

iri:
	mvn -q clean && \
	mvn -q package -Dmaven.test.skip

check:
	mvn -q clean && \
	mvn integration-test -Dlogging-level=INFO
