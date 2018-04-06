# Maintainer: Kamil Cukrowski <kamilcukrowski@gmail.com>

pkgname=ccan-git
pkgver=unknown
pkgrel=1
epoch=1
pkgdesc="Chosen modules from The C Code Archive Network"
arch=('i686' 'x86_64')
url="http://ccodearchive.net/"
license=('custom')
groups=('')
depends=('')
#makedepends=('')
#optdepends=('')
source=("ccancopy::git+https://github.com/rustyrussell/ccan" Makefile CMakeLists.txt)
md5sums=('SKIP' 'SKIP' 'SKIP')

prepare() {
	cat <<EOF
------------------------------------------------------------------------------
Modules in the C Code Archive Network are distributed under different licenses
See /usr/share/licenses/ccan/module_name/LICENSE for license of a particular module
------------------------------------------------------------------------------
EOF
}

build() {
	ln -fs ccancopy ccan
	cmake -H. -BBuild -DCMAKE_INSTALL_PREFIX=/usr
	make -CBuild
}

package() {
	make -CBuild DESTDIR="$pkgdir" install
	pushd ccan/ccan 2>/dev/null
	for i in */LICENSE; do
		i=$(dirname $i)
		install -Dm644 $i/LICENSE "$pkgdir/usr/share/licenses/ccan/$i/LICENSE"
	done
	popd 2>/dev/null
}
