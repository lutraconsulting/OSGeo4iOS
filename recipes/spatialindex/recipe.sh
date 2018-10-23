#!/bin/bash

# version of your package
VERSION_spatialindex=1.8.5

# dependencies of this recipe
DEPS_spatialindex=()

# url of the package
URL_spatialindex=http://download.osgeo.org/libspatialindex/spatialindex-src-${VERSION_spatialindex}.tar.bz2

# md5 of the package
MD5_spatialindex=3303c47fd85aa17e64ef52ebec212762

# default build path
BUILD_spatialindex=$BUILD_PATH/spatialindex/$(get_directory $URL_spatialindex)

# default recipe path
RECIPE_spatialindex=$RECIPES_PATH/spatialindex

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_spatialindex() {
  cd $BUILD_spatialindex

  # check marker
  if [ -f .patched ]; then
    return
  fi

  try cp $ROOT_PATH/.packages/config.sub $BUILD_spatialindex
  try cp $ROOT_PATH/.packages/config.guess $BUILD_spatialindex

  try patch -p1 < $RECIPE_spatialindex/patches/spatialindex.patch

  touch .patched
}

function shouldbuild_spatialindex() {
  # If lib is newer than the sourcecode skip build
  if [ $BUILD_PATH/spatialindex/build-$ARCH/.libs/libspatialindex.a -nt $BUILD_spatialindex/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_spatialindex() {
  try mkdir -p $BUILD_PATH/spatialindex/build-$ARCH
  try cd $BUILD_PATH/spatialindex/build-$ARCH

  push_arm

  CXXFLAGS="${CXXFLAGS} -I${BUILD_spatialindex}/include" \
  try $BUILD_spatialindex/configure --prefix=$STAGE_PATH --host=${TOOLCHAIN_PREFIX} --disable-shared
  try $MAKESMP
  try make install

  pop_arm
}

# function called after all the compile have been done
function postbuild_spatialindex() {
  LIB_ARCHS=`lipo -archs ${STAGE_PATH}/lib/libspatialindex.a`
  if [[ $LIB_ARCHS != *"$ARCH"* ]]; then
    error "Library was not successfully build for ${ARCH}"
    exit 1;
  fi
}
