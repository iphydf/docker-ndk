# vim:ft=dockerfile
FROM ubuntu:16.04
MAINTAINER Iphigenia Df "iphydf@gmail.com"

#
# Install required packages
#
RUN apt-get update && apt-get -y install \
 autoconf \
 automake \
 autopoint \
 c2hs \
 cabal-install \
 ca-certificates \
 curl \
 ghc \
 git \
 libtool \
 llvm-3.7 \
 p7zip-full \
 pkg-config \
 python \
 texinfo \
 unzip \
 zlib1g-dev

# Create a new user 'androidbuilder'
COPY root-scripts/create-androidbuilder-user.sh /root/
RUN /root/create-androidbuilder-user.sh

# Log-in to the new user
USER androidbuilder
ENV HOME /home/androidbuilder

# Set the working directory
ENV BASE $HOME/build

# The adding of the patches happens later in the Docker build, just before the
# patched code is built
RUN mkdir -p $BASE/patches

COPY user-scripts/set-env.sh $BASE/

WORKDIR $BASE

#
# Start preparing the environment.
#

ENV \
 NDK_API=21 \
 NDK_ARCH=x86_64 \
 NDK_PLATFORM=android-21 \
 NDK_TOOLCHAIN=x86_64-4.9 \
 NDK_TARGET=x86_64-linux-android \
 NDK_ABI=x86_64-linux-android \
 ARCH_OPTS=

COPY user-scripts/download-ndk.sh \
     user-scripts/install-ndk.sh \
     user-scripts/create-ndk-standalone-toolchain.sh \
     user-scripts/cleanup-ndk.sh \
     $BASE/
RUN ./download-ndk.sh \
 && ./install-ndk.sh \
 && ./create-ndk-standalone-toolchain.sh \
 && ./cleanup-ndk.sh

WORKDIR $HOME

#
# Now to add add some PATHs
#
ENV \
 PATH=$HOME/.cabal/bin:$HOME/.ndk/$NDK_PLATFORM/$NDK_TOOLCHAIN/bin:$PATH \
 PLATFORM_PREFIX=$HOME/.ndk/$NDK_PLATFORM/$NDK_TOOLCHAIN
