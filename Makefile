.PHONY: all test

all:
	make -C ./driver-location
	make -C ./gateway
	make -C ./zombie-driver

setup:
	make -C ./driver-location setup
	make -C ./gateway setup
	make -C ./zombie-driver setup

test:
	make -C ./driver-location test
	make -C ./gateway test
	make -C ./zombie-driver test
