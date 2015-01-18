#!/bin/sh
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

SRCDIR=$DIR/src
cd "$SRCDIR"

NDK=/opt/android-ndk-r9d
NDKABI=19
NDKVER=$NDK/toolchains/arm-linux-androideabi-4.8
NDKP=$NDKVER/prebuilt/windows-x86_64/bin/arm-linux-androideabi-
NDKF="--sysroot $NDK/platforms/android-$NDKABI/arch-arm"

# Android/ARM, armeabi (ARMv5TE soft-float), Android 2.2+ (Froyo)
DESTDIR=$DIR/prebuilt/android/armeabi
rm "$DESTDIR"/*.a
make clean
make HOST_CC="gcc -m32" CROSS=$NDKP TARGET_SYS=Linux TARGET_FLAGS="$NDKF"

if [ -f $SRCDIR/src/libluajit.a ]; then
    mv $SRCDIR/src/libluajit.a $DESTDIR/libluajit.a
fi;

# Android/ARM, armeabi-v7a (ARMv7 VFP), Android 4.0+ (ICS)
NDKARCH="-march=armv7-a -mfloat-abi=softfp -Wl,--fix-cortex-a8"
DESTDIR=$DIR/prebuilt/android/armeabi-v7a
rm "$DESTDIR"/*.a
make clean
make HOST_CC="gcc -m32" CROSS=$NDKP TARGET_SYS=Linux TARGET_FLAGS="$NDKF $NDKARCH"

if [ -f $SRCDIR/src/libluajit.a ]; then
    mv $SRCDIR/src/libluajit.a $DESTDIR/libluajit.a
fi;



make clean
