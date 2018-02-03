#!/bin/bash

set -e

. scripts/modules.sh

FEEDS="$GLUON_SITE_FEEDS $GLUON_FEEDS"

(
	cat openwrt/feeds.conf.default
	echo 'src-link gluon ../../package'
	for feed in $FEEDS; do
		echo "src-link packages_$feed ../../packages/$feed"
	done
) > openwrt/feeds.conf

rm -rf openwrt/tmp
rm -rf openwrt/feeds
rm -rf openwrt/package/feeds

mkdir -p openwrt/overlay
rm -f openwrt/overlay/gluon
ln -s ../../overlay openwrt/overlay/gluon

openwrt/scripts/feeds update 'gluon'
for feed in $FEEDS; do
	openwrt/scripts/feeds update "packages_$feed"
done

openwrt/scripts/feeds install -a
