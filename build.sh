#!/bin/bash

##########################################################

#sites and architectures to build

SITES="gek"
#SITES="bcd bgl cgr kut lgn lln ode ovr rrh"
#ARCHS="ar71xx-generic"
ARCHS="ar71xx-generic ar71xx-nand mpc85xx-generic x86-kvm_guest x86-generic"
BRANCH="stable"

##########################################################

SCRIPTHOME=$(pwd)

function mksite {
	#ARGS: site_code name homepage base SSID
	echo $1
	cp -r $SCRIPTHOME/basesites/$4/ $SCRIPTHOME/sites/$1
	sed -e "s/basesitecode/$1/g" -i $SCRIPTHOME/sites/$1/site.conf
	sed -e "s/basename/$2/g" -i $SCRIPTHOME/sites/$1/site.conf
	sed -e "s/basehomepage/$3/g" -i $SCRIPTHOME/sites/$1/i18n/en.po
	sed -e "s/basehomepage/$3/g" -i $SCRIPTHOME/sites/$1/i18n/de.po
	sed -e "s/basename/$2/g" -i $SCRIPTHOME/sites/$1/i18n/en.po
	sed -e "s/basename/$2/g" -i $SCRIPTHOME/sites/$1/i18n/de.po
	sed -e "s/basessid/$5/g" -i $SCRIPTHOME/sites/$1/site.conf
	sed -e "s/basebranch/$BRANCH/g" -i $SCRIPTHOME/sites/$1/site.conf
}

function sites {
	echo -generating sites-
	#clean generated sites dir
	rm -rf $SCRIPTHOME/sites
	mkdir -p $SCRIPTHOME/sites

	#call mksite function for each site to copy the corresponding base site and replace values
	mksite bcd Burscheid freifunk-burscheid.de gl Freifunk-Burscheid
	mksite bgl "Bergisch Gladbach" freifunk-bergisch-gladbach.de gl Freifunk
	mksite cgr Rechtsrheinisch-Köln freifunk-gl.de gl Freifunk
	mksite kut Kürten freifunk-gl.de gl Freifunk
	mksite lgn Langenfeld freifunk-gl.de gl Freifunk
	mksite lln Leichlingen leichlingen.freifunk.net gl Freifunk
	mksite ode Odenthal "odenthal.de\/freifunk.html" gl Freifunk
	mksite ovr Overath freifunk-gl.de gl Freifunk
	mksite rrh Rösrath freifunk-gl.de gl Freifunk

	mksite gek Gelsenkirchen freifunk-gelsenkirchen.de gek Freifunk

	echo done.
}

function images {
	cd $SCRIPTHOME/build
	#clean images dirs
	rm -rf $SCRIPTHOME/oldimages
	mv $SCRIPTHOME/images $SCRIPTHOME/oldimages

	for f in $SITES
	do
		for g in $ARCHS
		do
			echo -building $f $g-
			ARGS="GLUON_TARGET=$g GLUON_SITEDIR=$SCRIPTHOME/sites/$f GLUON_IMAGEDIR=$SCRIPTHOME/images/$f/$BRANCH GLUON_BRANCH=$BRANCH"
#			make update $ARGS
#			make clean $ARGS
			make -j20 BROKEN=1 $ARGS
		done
		make manifest $ARGS
#		contrib/sign.sh $SCRIPTHOME/secret.key $SCRIPTHOME/images/$f/$BRANCH/sysupgrade/$BRANCH.manifest
	done
}

if [ -z "$1" ]
then
	sites
	images
else
	$1
fi
