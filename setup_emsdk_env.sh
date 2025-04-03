#!/bin/bash

set -e

export SYSROOT=`pwd`/sysroot

$MAMBA_EXE create -n ems -c conda-forge python=3.12 cmake pyodide-build rsync
eval "$($MAMBA_EXE shell activate ems --shell=bash)"
mkdir build_env && cd build_env
wd=$(pwd)
mkdir -p $SYSROOT

export PYODIDE_EMSCRIPTEN_VERSION=$(pyodide config get emscripten_version)
export SIDE_MODULE_CXXFLAGS=$(pyodide config get cxxflags)
export SIDE_MODULE_CFLAGS=$(pyodide config get cflags)
export SIDE_MODULE_LDFLAGS=$(pyodide config get ldflags)
export PLATFORM_TRIPLET=wasm32-emscripten
git clone https://github.com/emscripten-core/emsdk.git
cd emsdk
./emsdk install ${PYODIDE_EMSCRIPTEN_VERSION}
./emsdk activate ${PYODIDE_EMSCRIPTEN_VERSION}
source emsdk_env.sh
cd $wd

wget https://github.com/boostorg/boost/releases/download/boost-1.84.0/boost-1.84.0.tar.gz
tar zxf boost-1.84.0.tar.gz && cd boost-1.84.0 && \
./bootstrap.sh --prefix=${SYSROOT}
# https://github.com/emscripten-core/emscripten/issues/17052
# Without this, boost outputs WASM modules not static library archives as an output.
# I don't understand why... the jam file used by boost is quite hard to understand.
printf "using clang : emscripten : emcc : <archiver>emar <ranlib>emranlib <linker>emlink ;" | tee -a ./project-config.jam
./b2 variant=release toolset=clang-emscripten link=static threading=single \
  --with-date_time --with-filesystem --with-python --with-headers --with-serialization \
  --with-system --with-regex --with-chrono --with-random --with-program_options --disable-icu \
  cxxflags="$SIDE_MODULE_CXXFLAGS -fexceptions -DBOOST_SP_DISABLE_THREADS=1" \
  cflags="$SIDE_MODULE_CFLAGS -fexceptions -DBOOST_SP_DISABLE_THREADS=1" \
  linkflags="-fpic $SIDE_MODULE_LDFLAGS" \
  --layout=system -j1 --prefix=${SYSROOT} \
  install
cd $wd
rsync -av ${SYSROOT} ${EMSDK}/upstream/emscripten/cache
