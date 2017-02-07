# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils

# For System Rescue CD 4.9.2 (Standard Kernel - x86_64)
TAIL="std492-amd64"
KERNEL="linux-${PV}-${TAIL}"
KERNEL_CONF="kernel-${PV}-${TAIL}.conf"
_KV="4.4"
KERNEL_FILE="linux-${_KV}.tar.xz"
FEDORA_VERSION="22"

DESCRIPTION="Kernel Sources and Patches for the System Rescue CD Standard Kernel"
HOMEPAGE="http://kernel.sysresccd.org/"
SRC_URI="mirror://kernel/linux/kernel/v4.x/${KERNEL_FILE}"

RESTRICT="mirror"
LICENSE="GPL-2"
SLOT="${PV}"
KEYWORDS="-* ~amd64"

S="${WORKDIR}/${KERNEL}"

PATCHES=( 
	"${FILESDIR}/${PV}/${PN}-${_KV}-01-stable-${PV}.patch"
	"${FILESDIR}/${PV}/${PN}-${_KV}-02-fc${FEDORA_VERSION}.patch"
	"${FILESDIR}/${PV}/${PN}-${_KV}-03-aufs.patch"
	"${FILESDIR}/${PV}/${PN}-${_KV}-04-reiser4.patch"
)

src_unpack()
{
	unpack ${KERNEL_FILE}
	mv ${KERNEL_FILE%.tar*} ${KERNEL}
}

src_compile() {
	# Unset ARCH so that you don't get Makefile not found messages
	unset ARCH && return;
}

src_install()
{
	# Copy kernel sources to the sandbox's /usr/src
	dodir /usr/src
	cp -r "${S}" "${D}/usr/src"

	# Clean kernel sources directory and copy configuration file
	cd "${D}/usr/src/${KERNEL}"
	make distclean
	cp "${FILESDIR}/${PV}/${KERNEL_CONF}" .config
}
