# Variables
DCURL_VERSION=0.5.0

.PHONY: all dcurl iri check

# Rules
all: dcurl iri

dcurl:
	git submodule update --init $@
	# FIXME: support other architecture rather than x86_64
	$(MAKE) -C $@ BUILD_AVX=1 BUILD_REMOTE=1 BUILD_JNI=1
	# install
	mvn install:install-file \
	-DgroupId=org.dltcollab \
	-DartifactId=dcurljni \
	-Dversion=${DCURL_VERSION} \
	-Dfile=$@/build/dcurljni-${DCURL_VERSION}.jar \
	-Dpackaging=jar

iri:
	mvn -q clean && \
	mvn -q package -Dmaven.test.skip

check: dcurl
	mvn -q clean && \
	mvn integration-test -Dlogging-level=INFO
