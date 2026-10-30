# Makefile -- build and test the whole example collection
#
#   make            build every example into bin/
#   make test       build, then verify every example against its tests.txt
#   make clean      remove bin/ and intermediate artifacts

.PHONY: all test clean

all:
	bash scripts/build.sh

test: all
	bash scripts/test.sh

clean:
	rm -rf bin
	find examples -name '*.o' -delete
	find examples -name '*.lst' -delete
	find examples -name '*.err' -delete
