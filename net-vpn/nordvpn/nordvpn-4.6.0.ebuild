# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker systemd tmpfiles xdg-utils

MY_PV=$(ver_rs 3 '-')

DESCRIPTION="NordVPN native client"
HOMEPAGE="https://nordvpn.com"
SRC_URI="amd64? ( https://repo.nordvpn.com/deb/nordvpn/debian/pool/main/n/nordvpn/nordvpn_${MY_PV}_amd64.deb )
	arm64? ( https://repo.nordvpn.com/deb/nordvpn/debian/pool/main/n/nordvpn/nordvpn_${MY_PV}_arm64.deb )"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm64"

# Mirrors the current upstream Debian package deps, plus the dedicated service group.
RDEPEND="
	acct-group/nordvpn
	app-misc/ca-certificates
	dev-db/sqlite:3
	dev-libs/libnl:3
	dev-libs/libxslt
	net-dns/libidn2
	net-firewall/iptables
	sys-apps/iproute2
	sys-libs/zlib
	sys-process/procps
"

RESTRICT="strip"
S="${WORKDIR}"

src_unpack() {
	# Unpack Debian package containing application's files.
	unpack_deb ${A}
	gzip "${S}"/usr/share/doc/nordvpn/changelog.Debian.gz -d
	gzip "${S}"/usr/share/man/man1/nordvpn.1.gz -d
}

src_install() {
	cd "${S}" || die

	newinitd "${FILESDIR}/nordvpn.initd" ${PN}
	systemd_dounit usr/lib/systemd/system/nordvpnd.{service,socket}

	dobin usr/bin/nordvpn
	dosbin usr/sbin/nordvpnd

	insinto /usr/lib/
	doins -r usr/lib/nordvpn

	fowners root:nordvpn /usr/lib/nordvpn/norduserd
	fperms 0550 /usr/lib/nordvpn/norduserd
	fowners root:nordvpn /usr/lib/nordvpn/nordfileshare
	fperms 0550 /usr/lib/nordvpn/nordfileshare
	fowners root:nordvpn /usr/lib/nordvpn/openvpn
	fperms 0550 /usr/lib/nordvpn/openvpn

	insinto /usr/share/
	doins -r usr/share/applications
	doins -r usr/share/zsh
	doins -r usr/share/bash-completion
	doins -r usr/share/icons

	insinto /var/lib/
	doins -r var/lib/nordvpn

	dodoc usr/share/doc/nordvpn/changelog.Debian
	doman usr/share/man/man1/nordvpn.1

	dotmpfiles usr/lib/tmpfiles.d/nordvpn.conf
	newenvd "${FILESDIR}/nordvpn.env" 99nordvpn
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	tmpfiles_process nordvpn.conf
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
