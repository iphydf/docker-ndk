#!/bin/bash

. set-env.sh
####################################################################################################

NDK_TAR_FILE=android-ndk-${NDK_RELEASE}-linux-x86_64.zip
NDK_TAR_PATH="${TARDIR}/${NDK_TAR_FILE}"

echo Unpacking the Android NDK $NDK_RELEASE
7z x "$NDK_TAR_PATH" "-o$HOME" | grep -v '^Extracting' 2>&1
rm "$NDK_TAR_PATH"

rm -f ${BASH_SOURCE[0]}
