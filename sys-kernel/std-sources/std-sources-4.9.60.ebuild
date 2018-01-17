# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils

# When updating ebuild, manually edit kernel config:
# 1. Remove text in CONFIG_INITRAMFS_SOURCE
# 2. Set CONFIG_LOCALVERSION to the value in $TAIL
# 3. Unset CONFIG_STACK_VALIDATION

# For System Rescue CD 5.1.2 (Standard Kernel - x86_64)
TAIL="std512-amd64"
KERNEL="linux-${PV}-${TAIL}"
KERNEL_CONF="kernel-${PV}-${TAIL}.conf"
_KV="4.9"
KERNEL_FILE="linux-${_KV}.tar.xz"
FEDORA_VERSION="24"

DESCRIPTION="Kernel Sources and Patches for the System Rescue CD Standard Kernel"
HOMEPAGE="http://kernel.sysresccd.org/"
SRC_URI="mirror://kernel/linux/kernel/v4.x/${KERNEL_FILE}"

RESTRICT="mirror"
LICENSE="GPL-2"
SLOT="${PV}"
KEYWORDS="-* ~amd64"

S="${WORKDIR}/${KERNEL}"

# Not including reiser4 patch until ZFS includes new fix
# that allows both to work together (ZFS patch already in tree,
# just not released)
PATCHES=( 
	"${FILESDIR}/${PV}/${PN}-${_KV}-01-stable-${PV}.patch"
	"${FILESDIR}/${PV}/${PN}-${_KV}-02-fc${FEDORA_VERSION}.patch"
	"${FILESDIR}/${PV}/${PN}-${_KV}-03-aufs.patch"
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
