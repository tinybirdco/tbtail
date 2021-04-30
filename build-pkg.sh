#!/bin/bash

# Build deb or rpm packages for tbtail.
set -e

function usage() {
    echo "Usage: build-pkg.sh -v <version> -t <package_type>"
    exit 2
}

while getopts "v:t:" opt; do
    case "$opt" in
    v)
        version=$OPTARG
        ;;
    t)
        pkg_type=$OPTARG
        ;;
    esac
done

if [ -z "$version" ] || [ -z "$pkg_type" ]; then
    usage
fi

fpm -s dir -n tbtail \
    -m "Support <support@tinybird.co>" \
    -p $GOPATH/bin \
    -v $version \
    -t $pkg_type \
    --pre-install=./preinstall \
    $GOPATH/bin/tbtail=/usr/local/bin/tbtail \
    ./tbtail.upstart=/etc/init/tbtail.conf \
    ./tbtail.service=/lib/systemd/system/tbtail.service \
    ./tbtail.conf=/etc/tbtail/tbtail.conf
