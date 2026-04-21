# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker xdg-utils

DESCRIPTION="Desktop app for the OpenCode AI coding agent"
HOMEPAGE="https://opencode.ai/"
SRC_URI="https://github.com/anomalyco/opencode/releases/download/v${PV}/opencode-desktop-linux-amd64.deb"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="strip"

RDEPEND="
	dev-libs/glib:2
	net-libs/webkit-gtk:4.1
	x11-libs/gtk+:3
"

S="${WORKDIR}"

QA_PREBUILT="usr/bin/OpenCode usr/bin/opencode-cli"

src_unpack() {
	unpack_deb ${A}
}

src_install() {
	local desktop_file="${T}/ai.opencode.opencode.desktop"

	sed \
		-e 's/^Categories=$/Categories=Development;/' \
		"${S}/usr/share/applications/OpenCode.desktop" > "${desktop_file}" || die

	dobin usr/bin/OpenCode usr/bin/opencode-cli

	insinto /usr/share/applications
	doins "${desktop_file}"

	insinto /usr/share/icons
	doins -r usr/share/icons/hicolor

	insinto /usr/share/metainfo
	doins usr/share/metainfo/ai.opencode.opencode.metainfo.xml
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
