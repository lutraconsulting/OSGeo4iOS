#!/bin/bash

# version of your package
# NOTE: if changed, update also qgis's recipe
VERSION_gdal=2.2.3

# dependencies of this recipe
#DEPS_gdal=(iconv sqlite3 geos libtiff postgresql expat)
DEPS_gdal=(geos libtiff postgresql expat)

# url of the package
URL_gdal=http://download.osgeo.org/gdal/$VERSION_gdal/gdal-${VERSION_gdal}.tar.gz

# md5 of the package
MD5_gdal=4099b7d4efebdd3b0411ed3b9a18a8b2

# default build path
BUILD_gdal=$BUILD_PATH/gdal/$(get_directory $URL_gdal)

# default recipe path
RECIPE_gdal=$RECIPES_PATH/gdal

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_gdal() {
  cd $BUILD_gdal

  # check marker
  if [ -f .patched ]; then
    return
  fi

  try cp $ROOT_PATH/.packages/config.sub $BUILD_gdal
  try cp $ROOT_PATH/.packages/config.guess $BUILD_gdal

  touch .patched
}

function shouldbuild_gdal() {
  # If lib is newer than the sourcecode skip build
  if [ $BUILD_PATH/gdal/build-$ARCH/.libs/libgdal.a -nt $BUILD_gdal/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_gdal() {
  try rsync -a $BUILD_gdal/ $BUILD_PATH/gdal/build-$ARCH/
  try cd $BUILD_PATH/gdal/build-$ARCH

  push_arm

  export LDFLAGS="${LDFLAGS} -liconv"
  export CFLAGS="${CFLAGS} -Wno-error=implicit-function-declaration"

  try ${BUILD_PATH}/gdal/build-$ARCH/configure \
    --prefix=$STAGE_PATH \
    --host=${TOOLCHAIN_PREFIX} \
    --with-sqlite3=$SYSROOT \
    --with-geos=$STAGE_PATH/bin/geos-config \
    --with-pg=no \
    --with-expat=$STAGE_PATH \
    --disable-shared

  try $MAKESMP
  try make install &> install.log

  pop_arm
}

# function called after all the compile have been done
function postbuild_gdal() {
  LIB_ARCHS=`lipo -archs ${STAGE_PATH}/lib/libgdal.a`
  if [[ $LIB_ARCHS != *"$ARCH"* ]]; then
    error "Library was not successfully build for ${ARCH}"
    exit 1;
  fi
}
