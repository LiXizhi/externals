#!/bin/sh
SOURCE_DIR=`pwd`

#set config path
NDK="/opt/android-ndk-r9d"
CMAKE_TOOLCHAIN_ROOT="/opt/android-cmake"
ANDROID_ABI="armeabi"
ANDROID_NATIVE_API_LEVEL="android-9"
DESTDIR="$SOURCE_DIR/prebuilt/android/${ANDROID_ABI}"
Boost_INCLUDE_DIR_input="/opt/ParaEngine-Git/Mobile/trunk/ParaCraftMobile/frameworks/runtime-src/external/boost/boost_1_55_0"
rm -rf $DESTDIR
mkdir -p $DESTDIR

#build cAudioEngine
BUILD_DIR="${SOURCE_DIR}/android"
rm -rf $BUILD_DIR
mkdir $BUILD_DIR
cd $BUILD_DIR


#cmake
cmake   -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_ROOT}/android.toolchain.cmake      \
        -DANDROID_NDK=${NDK}                                                        \
        -DCMAKE_BUILD_TYPE=Release                                                  \
        -DANDROID_ABI=${ANDROID_ABI}                                                \
        -DANDROID_NATIVE_API_LEVEL=${ANDROID_NATIVE_API_LEVEL}                      \
        -DASSIMP_ENABLE_BOOST_WORKAROUND=OFF                                        \
        -DASSIMP_BUILD_STATIC_LIB=ON                                                \
        -DBUILD_SHARED_LIBS=OFF                                                     \
        -DBUILD_ON_ANDROID=TRUE                                                     \
        -DBoost_INCLUDE_DIR_input=${Boost_INCLUDE_DIR_input}                        \
        ..

make
if [ -f $BUILD_DIR/code/libassimp.a ]; then
    mv $BUILD_DIR/code/libassimp.a $DESTDIR/libassimp.a
fi;