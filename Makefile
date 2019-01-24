# Variables
ROCKSDB_VERSION=5.18.1

.PHONY: all dcurl rocksdb iri check

# Rules
all: dcurl rocksdb iri

dcurl:
	git submodule update --init $@
	# FIXME: support other architecture rather than x86_64
	$(MAKE) -C $@ BUILD_AVX=1 BUILD_JNI=1

rocksdb:
	git submodule update --init $@
	# build
	$(MAKE) -C $@ rocksdbjavastatic -j$(shell getconf _NPROCESSORS_ONLN)
	# install
	mvn install:install-file \
	-DgroupId=org.rocksdb \
	-DartifactId=rocksdbjni \
	-Dversion=${ROCKSDB_VERSION} \
	-Dfile=$@/java/target/rocksdbjni-${ROCKSDB_VERSION}-linux64.jar \
	-Dpackaging=jar

iri:
	mvn -q clean && \
	mvn -q package -Dmaven.test.skip

check: rocksdb
	mvn -q clean && \
	mvn integration-test -Dlogging-level=INFO
