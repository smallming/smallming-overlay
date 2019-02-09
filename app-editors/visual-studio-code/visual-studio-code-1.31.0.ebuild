# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit desktop

DESCRIPTION="Lightweight but powerful source code editor"
HOMEPAGE="https://code.visualstudio.com"
BASE_URI="https://vscode-update.azurewebsites.net/${PV}"
SRC_URI="
	x86? ( ${BASE_URI}/linux-ia32/stable ->  ${P}-x86.tar.gz )
	amd64? ( ${BASE_URI}/linux-x64/stable -> ${P}-amd64.tar.gz )
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libsecret"
RESTRICT="bindist mirror strip"

DEPEND="
	>=media-libs/libpng-1.2:*
	>=x11-libs/gtk+-2.24:*
	x11-libs/cairo
	gnome-base/gconf
	x11-libs/libXtst
"

RDEPEND="
	${DEPEND}
	net-print/cups
	x11-libs/libnotify
	x11-libs/libXScrnSaver
	dev-libs/nss
	libsecret? ( app-crypt/libsecret[crypt] )
"

pkg_setup(){
	use amd64 && S="${WORKDIR}/VSCode-linux-x64" || S="${WORKDIR}/VSCode-linux-ia32"
}

src_install(){
	dodir "/opt/${PN}"

	# deliberately use cp to retain permissions
	cp -R * "${ED}/opt/${PN}"

	dosym "../../opt/${PN}/bin/code" "/usr/bin/code"

	doicon "${ED}/opt/${PN}/resources/app/resources/linux/code.png"
	make_desktop_entry "code" "Visual Studio Code" "code" "TextEditor;IDE;Development" "StartupNotify=true"

	insinto "/usr/share/licenses/${PN}"
	newins "resources/app/LICENSE.txt" "LICENSE"
}
