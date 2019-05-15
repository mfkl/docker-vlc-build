#!/bin/bash

git clone https://github.com/videolan/vlc && cd vlc

export arch="x86"
#export arch="x64"
export HOST_COMPILER="i686-w64-mingw32"
#export HOST_COMPILER="x86_64-w64-mingw32"

export PATH="/opt/gcc-$HOST_COMPILER/bin:$PATH"
export USE_FFMPEG=1

cd extras/tools
./bootstrap && make -j4
export PATH=`pwd`/build/bin:$PATH
cd ../../

mkdir -p contrib/$arch && cd contrib/$arch
../bootstrap --host=$HOST_COMPILER
make -j8 fetch
make -j4

cd ../../
export PKG_CONFIG_LIBDIR=`pwd`/contrib/$HOST_COMPILER/lib/pkgconfig
export PATH=`pwd`/contrib/$HOST_COMPILER/bin:`pwd`/contrib/bin:$PATH

./bootstrap
mkdir $arch && cd $arch
../extras/package/win32/configure.sh --host=$HOST_COMPILER --enable-debug --disable-qt --disable-skins2 --disable-vlc
make -j4

make package-win-common