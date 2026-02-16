# Copyright 1999-2025 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker xdg-utils tmpfiles

MY_PV=$(ver_rs 3 '-')

DESCRIPTION="NordVPN client gui"
HOMEPAGE="https://nordvpn.com"
SRC_URI="amd64? ( https://repo.nordvpn.com/deb/nordvpn/debian/pool/main/n/nordvpn-gui/nordvpn-gui_${MY_PV}_amd64.deb )
arm64? ( https://repo.nordvpn.com/deb/nordvpn/debian/pool/main/n/nordvpn-gui/nordvpn-gui_${MY_PV}_arm64.deb )"

LICENSE="NordVPN"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm64"

# TODO: verify that list of RDEPEND is complete
RDEPEND=">=net-vpn/nordvpn-4.0.0"

RESTRICT="strip"
S="${WORKDIR}"

src_unpack() {
	# Unpack Debian package containing application's files
	unpack_deb ${A}
	gzip "${S}"/usr/share/doc/nordvpn-gui/changelog.Debian.gz -d
}

src_install() {
	cd "${S}"

#   into<-->/opt
	insinto /opt/
	doins -r opt/nordvpn-gui

        dosym /opt/nordvpn-gui/nordvpn-gui /opt/bin/nordvpn-gui

	fowners root:nordvpn /opt/nordvpn-gui/nordvpn-gui
	fperms 0550 /opt/nordvpn-gui/nordvpn-gui

#   into<-->/usr
	insinto /usr/share/
	doins -r usr/share/applications
	doins -r usr/share/icons

	dodoc usr/share/doc/nordvpn-gui/changelog.Debian
}

pkg_postinst (){
	xdg_desktop_database_update
	xdg_icon_cache_update
	tmpfiles_process nordvpn.conf
}

pkg_postrm (){
	xdg_desktop_database_update
	xdg_icon_cache_update
}
