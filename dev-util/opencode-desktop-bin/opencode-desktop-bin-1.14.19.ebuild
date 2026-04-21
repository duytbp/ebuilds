# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker xdg-utils

DESCRIPTION="Electron desktop app for the OpenCode AI coding agent"
HOMEPAGE="https://opencode.ai/"
SRC_URI="https://github.com/anomalyco/opencode/releases/download/v${PV}/opencode-electron-linux-amd64.deb"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="strip"

RDEPEND="
	app-accessibility/at-spi2-core
	app-crypt/libsecret
	dev-libs/glib:2
	dev-libs/nss
	media-libs/alsa-lib
	media-libs/mesa
	sys-apps/dbus
	sys-apps/util-linux
	x11-libs/gtk+:3
	x11-libs/libnotify
	x11-libs/libXScrnSaver
	x11-libs/libXtst
	x11-misc/xdg-utils
"

S="${WORKDIR}"

QA_PREBUILT="opt/OpenCode/*"

src_unpack() {
	unpack_deb ${A}
}

src_install() {
	insinto /opt
	doins -r opt/OpenCode

	fperms 0755 \
		/opt/OpenCode/@opencode-aidesktop-electron \
		/opt/OpenCode/chrome-sandbox \
		/opt/OpenCode/chrome_crashpad_handler

	dosym /opt/OpenCode/@opencode-aidesktop-electron /usr/bin/opencode-desktop

	insinto /usr/share/applications
	doins usr/share/applications/@opencode-aidesktop-electron.desktop

	insinto /usr/share/icons
	doins -r usr/share/icons/hicolor
}

pkg_postinst() {
	if [[ -L /proc/self/ns/user ]] && unshare --user true >/dev/null 2>&1; then
		chmod 0755 "${EROOT}/opt/OpenCode/chrome-sandbox" || die
	else
		chmod 4755 "${EROOT}/opt/OpenCode/chrome-sandbox" || die
	fi

	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
