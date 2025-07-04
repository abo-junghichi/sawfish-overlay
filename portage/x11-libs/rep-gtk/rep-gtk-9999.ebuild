# 2025-07-05 Abo Junghichi
# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="GTK+/libglade/GNOME bindings for the librep Lisp environment"
HOMEPAGE="http://sawfish.wikia.com/wiki/Main_Page"

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/SawfishWM/rep-gtk.git"
else
	SRC_URI="https://github.com/SawfishWM/rep-gtk/archive/refs/heads/master.zip -> ${P}.zip"
	S="${WORKDIR}/${PN}-master"
	KEYWORDS="~alpha amd64 ~ia64 ppc ~ppc64 sparc x86"
fi

LICENSE="GPL-2"
SLOT="gtk-2.0"
IUSE="examples"

RDEPEND=">=dev-libs/librep-0.90.5
	>=dev-libs/glib-2.6:2
	>=x11-libs/gtk+-2.24.0:2
	>=x11-libs/gdk-pixbuf-2.23:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	app-arch/xz-utils"

DOCS=( AUTHORS ChangeLog README README.gtk-defs README.guile-gtk TODO )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	append-cflags -Wno-incompatible-pointer-types

	econf \
		--libdir=/usr/$(get_libdir) \
		--disable-static
}

src_install() {
	default
	use examples && dodoc -r examples
	find "${D}" -name '*.la' -exec rm -f {} + || die "la file removal failed"
}
