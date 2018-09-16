#!/bin/bash

. set-env.sh
####################################################################################################

echo Preparing the Android NDK toolchain in $NDK
"$NDK_PATH/build/tools/make_standalone_toolchain.py" --api="$NDK_API" \
  --arch="$NDK_ARCH" --install-dir="$NDK"

#TMP hack, fake pthread library for ghc linker
pushd "$NDK_ADDON_PREFIX/lib"
ln -s libcharset.a libpthread.a
popd

rm -f ${BASH_SOURCE[0]}
