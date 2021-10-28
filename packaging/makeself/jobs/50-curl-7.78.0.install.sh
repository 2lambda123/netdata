#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-or-later

# shellcheck source=packaging/makeself/functions.sh
. "$(dirname "${0}")/../functions.sh" "${@}" || exit 1

[ -n "${GITHUB_ACTIONS}" ] && echo "::group::Building cURL"

fetch "curl-7.78.0" "https://curl.haxx.se/download/curl-7.78.0.tar.gz"

export CFLAGS="-I/openssl-static/include"
export LDFLAGS="-static -L/openssl-static/lib"
export PKG_CONFIG="pkg-config --static"
export PKG_CONFIG_PATH="/openssl-static/lib/pkgconfig"

run autoreconf -fi

run ./configure \
  --prefix="${NETDATA_INSTALL_PATH}" \
  --enable-optimize \
  --disable-shared \
  --enable-static \
  --enable-http \
  --disable-ldap \
  --disable-ldaps \
  --enable-proxy \
  --disable-dict \
  --disable-telnet \
  --disable-tftp \
  --disable-pop3 \
  --disable-imap \
  --disable-smb \
  --disable-smtp \
  --disable-gopher \
  --enable-ipv6 \
  --enable-cookies \
  --with-ca-fallback \
  --with-openssl

# Curl autoconf does not honour the curl_LDFLAGS environment variable
run sed -i -e "s/curl_LDFLAGS =/curl_LDFLAGS = -all-static/" src/Makefile

run make clean
run make -j "$(nproc)"
run make install

if [ ${NETDATA_BUILD_WITH_DEBUG} -eq 0 ]; then
  run strip "${NETDATA_INSTALL_PATH}"/bin/curl
fi

[ -n "${GITHUB_ACTIONS}" ] && echo "::group::Preparing build environment"
