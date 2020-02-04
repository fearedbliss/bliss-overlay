# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{3_6,3_7,3_8} )
inherit python-single-r1

GITHUB_USER="fearedbliss"
GITHUB_REPO="bliss-initramfs"
GITHUB_TAG="${PV}"

DESCRIPTION="Boot your system's rootfs from OpenZFS/LUKS."
HOMEPAGE="https://github.com/${GITHUB_USER}/${GITHUB_REPO}"
SRC_URI="https://github.com/${GITHUB_USER}/${GITHUB_REPO}/archive/${GITHUB_TAG}.tar.gz -> ${P}.tar.gz"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="strip"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="-* amd64"

RDEPEND="
	${PYTHON_DEPS}
	app-arch/cpio
	virtual/udev"

S="${WORKDIR}/${GITHUB_REPO}-${GITHUB_TAG}"

src_install() {
	# Copy the main executable
	local executable="mkinitrd.py"
	exeinto "/opt/${PN}"
	doexe "${executable}"

	# Copy the libraries required by this executable
	cp -r "${S}/files" "${D}/opt/${PN}" || die
	cp -r "${S}/pkg" "${D}/opt/${PN}" || die

	# Copy documentation files
	dodoc README.md README-MORE USAGE

	# Make a symbolic link: /sbin/bliss-initramfs
	dosym "${EPREFIX}/opt/${PN}/${executable}" "/sbin/${PN}"
}
