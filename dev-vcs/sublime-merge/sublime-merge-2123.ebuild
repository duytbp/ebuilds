# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop wrapper xdg

MY_PN=${PN/-/_}

DESCRIPTION="Git client from the makers of Sublime Text"
HOMEPAGE="https://www.sublimemerge.com/"
SRC_URI="amd64? ( https://download.sublimetext.com/${MY_PN}_build_${PV}_x64.tar.xz )"
S="${WORKDIR}/${MY_PN}-x64-tar"

LICENSE="Sublime"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="bindist mirror strip"

RDEPEND="
	dev-libs/glib:2
	sys-libs/glibc
	x11-libs/gtk+:3
	x11-libs/libX11
"

QA_PREBUILT="*"

src_install() {
	insinto /opt/${MY_PN}
	doins -r Packages Icon

	exeinto /opt/${MY_PN}
	doexe sublime_merge crash_handler ssh-askpass-sublime git-credential-sublime

	make_wrapper smerge "/opt/${MY_PN}/sublime_merge --fwdargv0 \"\$0\""

	domenu sublime_merge.desktop

	local size
	for size in 16 32 48 128 256; do
		doicon --size ${size} Icon/${size}x${size}/${PN}.png
	done
}
