#!/bin/bash

. set-env.sh
####################################################################################################

NDK_TAR_FILE=android-ndk-${NDK_RELEASE}-linux-x86_64.zip
NDK_TAR_PATH="${TARDIR}/${NDK_TAR_FILE}"

echo Downloading the Android NDK $NDK_RELEASE
curl -o "${TARDIR}/${NDK_TAR_FILE}" http://dl.google.com/android/repository/${NDK_TAR_FILE} 2>&1
check_md5 "$NDK_TAR_PATH" "$NDK_MD5"

rm -f ${BASH_SOURCE[0]}
