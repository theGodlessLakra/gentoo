# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
# (needed due to CMAKE_BUILD_TYPE != Gentoo)
CMAKE_MIN_VERSION=3.7.0-r1
inherit cmake-multilib git-r3 llvm

DESCRIPTION="C++ runtime stack unwinder from LLVM"
HOMEPAGE="https://github.com/llvm-mirror/libunwind"
SRC_URI=""
EGIT_REPO_URI="https://git.llvm.org/git/libunwind.git
	https://github.com/llvm-mirror/libunwind.git"
EGIT_BRANCH="release_60"

LICENSE="|| ( UoI-NCSA MIT )"
SLOT="0"
KEYWORDS=""
IUSE="debug +static-libs"

RDEPEND="!sys-libs/libunwind"
# LLVM 4 required for llvm-config --cmakedir
DEPEND=">=sys-devel/llvm-4"

# least intrusive of all
CMAKE_BUILD_TYPE=RelWithDebInfo

multilib_src_configure() {
	local libdir=$(get_libdir)

	local mycmakeargs=(
		-DLLVM_LIBDIR_SUFFIX=${libdir#lib}
		-DLIBUNWIND_ENABLE_ASSERTIONS=$(usex debug)
		-DLIBUNWIND_ENABLE_STATIC=$(usex static-libs)
	)

	cmake-utils_src_configure
}

multilib_src_install() {
	cmake-utils_src_install

	# install headers like sys-libs/libunwind
	doheader "${S}"/include/*.h
}
