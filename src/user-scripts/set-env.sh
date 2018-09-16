#!/bin/bash
# shellcheck disable=SC2034

#
# This script is responsible for setting up all the environment variables
# exactly the way they should be for building things with NDK. It will be
# sourced from other build scripts, but not run directly by Docker.
#

set -eu

echo "Current build dir size:"
du -sh "$BASE"

# Basic configuration
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$BASEDIR"

# Basic parameters
NDK_RELEASE=${NDK_RELEASE:-r17c}
NDK_MD5=a4b6b8281e7d101efd994d31e64af746
NDK_PLATFORM=${NDK_PLATFORM:-android-14}
NDK_TARGET=${NDK_TARGET:-arm-linux-androideabi}
NDK_TOOLCHAIN=${NDK_TOOLCHAIN:-arm-linux-androideabi-4.9}

NDK_DESC=$NDK_PLATFORM-$NDK_TOOLCHAIN
NDK="$HOME/.ndk/$NDK_PLATFORM/$NDK_TOOLCHAIN"
NDK_ADDON_SRC="$BASEDIR/build-$NDK_DESC"
NDK_ADDON_PREFIX="$NDK/sysroot/usr"

NDK_CC="$NDK_TARGET-clang"
NDK_CXX="$NDK_TARGET-clang++"
BUILD_CC=gcc
BUILD_ARCH=$($BUILD_CC -v 2>&1 | grep ^Target: | cut -f 2 -d ' ')

mkdir -p "$NDK_ADDON_SRC"
mkdir -p "${BASEDIR}/tarfiles"
TARDIR="${BASEDIR}/tarfiles"

function check_md5() {
  FILENAME="$1"
  MD5="$2"
  [ -e "${FILENAME}" ] || return 1;
  ACTUAL_MD5=$(md5sum "$FILENAME" | cut -f1 -d ' ')
  if [ ! "$ACTUAL_MD5" == "$MD5" ]; then
    >&2 echo "MD5 hash of $FILENAME did not match."
    >&2 echo "$MD5 =/= $ACTUAL_MD5"
    exit 1
  fi
}

# Add toolchain to path
export PATH="$NDK/bin":$PATH

# Download and configure the Android NDK toolchain
NDK_PATH="$HOME/android-ndk-$NDK_RELEASE"
