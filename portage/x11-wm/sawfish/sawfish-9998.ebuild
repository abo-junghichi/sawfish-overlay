# 2024-07-05 Abo Junghichi
# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools elisp-common strip-linguas xdg-utils

DESCRIPTION="Extensible window manager using a Lisp-based scripting language"
HOMEPAGE="https://sawfish.fandom.com/wiki/Main_Page"

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/SawfishWM/sawfish.git"
else
	SRC_URI="https://github.com/SawfishWM/sawfish/archive/refs/heads/master.zip -> ${P}.zip"
	S="${WORKDIR}/${PN}-master"
	KEYWORDS="~alpha amd64 ~ia64 ppc ~ppc64 sparc x86"
fi

LICENSE="GPL-2 Artistic-2"
SLOT="0"
IUSE="emacs kde nls xinerama"

RDEPEND="
	>=dev-libs/librep-0.92.1
	>=x11-libs/rep-gtk-0.90.7
	x11-libs/gdk-pixbuf-xlib
	>=x11-libs/gdk-pixbuf-2.42.0:2
	>=x11-libs/gtk+-2.24.0:2
	x11-libs/libICE
	x11-libs/libXext
	x11-libs/libXft
	x11-libs/libXrender
	x11-libs/libXtst
	x11-libs/pango[X]
	emacs? ( >=app-editors/emacs-23.1:* )
	kde? ( kde-frameworks/kdelibs4support )
	nls? ( sys-devel/gettext )
	xinerama? ( x11-libs/libXinerama )
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

DOCS=(
	AUTHORS ChangeLog CONTRIBUTING doc/AUTOSTART doc/KEYBINDINGS doc/OPTIONS
	doc/XSettings MAINTAINERS NEWS README README.IMPORTANT TODO
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	set -- \
		$(use_with kde kde5session) \
		$(use_with xinerama) \
		--with-gdk-pixbuf \
		--without-kde4session \
		--disable-static

	if ! use nls; then
		# Use a space because configure script reads --enable-linguas=""
		# as "install everything". Don't use --disable-linguas, because
		# that means --enable-linguas="no", which means "install
		# Norwegian translations".
		set -- "$@" --enable-linguas=" "
	elif [[ "${LINGUAS+set}" == "set" ]]; then
		strip-linguas -i po
		set -- "$@" --enable-linguas=" ${LINGUAS} "
	else
		set -- "$@" --enable-linguas=""
	fi

	econf "$@"
}

src_compile() {
	default
	use emacs && elisp-compile sawfish.el
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
	find "${ED}/usr/share/man" -name '*.gz' -exec gunzip {} \; || die

	if use emacs; then
		elisp-install ${PN} sawfish.{el,elc}
		elisp-site-file-install "${FILESDIR}"/50${PN}-gentoo.el
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
	xdg_icon_cache_update
}

pkg_postrm() {
	use emacs && elisp-site-regen
	xdg_icon_cache_update
}
