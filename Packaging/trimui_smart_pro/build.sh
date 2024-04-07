#!/usr/bin/env bash
set -euo pipefail

declare -r PACKAGING_DIR=`cd -- "$(dirname "$0")" >/dev/null 2>&1; pwd -P`
declare -r CFLAGS="-O3 -marm -mtune=cortex-a35 -march=armv8-a -Wall"
#declare -r LDFLAGS="-lSDL -lmi_sys -lmi_gfx -s -lSDL -lSDL_image"
declare -r BUILD_DIR="build-trimui-smart-pro"

main() {
	# ensure we are in devilutionx root
	cd "$PACKAGING_DIR/../.."

	rm -f "$BUILD_DIR/CMakeCache.txt"
	cmake_configure -DCMAKE_BUILD_TYPE=Release
	cmake_build
	package_trimui
}

cmake_configure() {
	cmake -S. -B"$BUILD_DIR" \
		-DTARGET_PLATFORM=trimui_smart_pro \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_TOOLCHAIN_FILE="${PACKAGING_DIR}/toolchainfile.cmake" \
		-DBUILD_TESTING=OFF \
		"$@"
}

cmake_build() {
	cmake --build "$BUILD_DIR" -j $(getconf _NPROCESSORS_ONLN)
}

prepare_trimui_skeleton() {
	rm -fr $BUILD_DIR/TrimUI
	mkdir -p $BUILD_DIR/TrimUI

	# copy basic skeleton
	cp -rf  Packaging/trimui_smart_pro/skeleton_TrimUI/* $BUILD_DIR/TrimUI

	# ensure devilutionx asset dir
	mkdir -p $BUILD_DIR/TrimUI/Apps/DevilutionX/assets
}

package_trimui() {
	prepare_trimui_skeleton
	# copy assets
	cp -rf $BUILD_DIR/assets/* $BUILD_DIR/TrimUI/Apps/DevilutionX/assets
	# copy executable
	cp -f $BUILD_DIR/devilutionx $BUILD_DIR/TrimUI/Apps/DevilutionX/devilutionx

	rm -f $BUILD_DIR/devilutionx-trimui-smart-pro.zip

	cd $BUILD_DIR/TrimUI
	zip -r ../devilutionx-trimui-smart-pro.zip .
	cd "$PACKAGING_DIR/../.."
}

main
