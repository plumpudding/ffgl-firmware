#!/bin/bash
if [ ! -d build ]
then
	git clone https://github.com/freifunk-gluon/gluon build
fi
cd build
git checkout v2015.1.2
ARGS="GLUON_SITEDIR=$(pwd)/../basesites/$(ls ../basesites/ | sort -n | head -1) GLUON_TARGET=ar71xx-generic"
make update $ARGS
echo make clean $ARGS
make clean $ARGS

for file in ../patches/*.patch
do
	patch -p1 -f --no-backup-if-mismatch -r - < $file
done
