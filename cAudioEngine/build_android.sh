#!/bin/sh
SOURCE_DIR=`pwd`
BUILD_DIR=${BUILD_DIR:-$SOURCE_DIR/andriod}
BUILD_TYPE=${BUILD_TYPE:-release}
rm -rf $BUILD_DIR/$BUILD_TYPE
mkdir -p $BUILD_DIR/$BUILD_TYPE
cd "$BUILD_DIR/$BUILD_TYPE"
cmake -DCMAKE_BUILD_TYPE=$BUILD_TYPE -DENABLED_ANDROID_BUILD=ON -DCAUDIO_STATIC=1 $SOURCE_DIR
DIR=$SOURCE_DIR
SRCDIR=$BUILD_DIR/$BUILD_TYPE
cd "$SRCDIR"
NDK=/opt/ndk9
NDKABI=19
NDKVER=$NDK/toolchains/arm-linux-androideabi-4.8
NDKP=$NDKVER/prebuilt/windows/bin/arm-linux-androideabi-
NDKF="--sysroot $NDK/platforms/android-$NDKABI/arch-arm"
# Android/ARM, armeabi (ARMv5TE soft-float), Android 2.2+ (Froyo)
DESTDIR=$DIR/prebuilt/android/armeabi
rm -rf $DESTDIR
mkdir -p $DESTDIR
make clean
make HOST_CC="gcc -m32" CROSS=$NDKP TARGET_SYS=Linux TARGET_FLAGS="$NDKF"
if [ -f $SRCDIR/cAudio/libcAudio.a ]; then
    mv $SRCDIR/cAudio/libcAudio.a $DESTDIR/libcAudio.a
fi;
if [ -f $SRCDIR//DependenciesSource/libogg-1.2.2/libOgg.a ]; then
    mv $SRCDIR//DependenciesSource/libogg-1.2.2/libOgg.a $DESTDIR/libOgg.a
fi;
if [ -f $SRCDIR/DependenciesSource/libvorbis-1.3.2/libVorbis.a ]; then
    mv $SRCDIR/DependenciesSource/libvorbis-1.3.2/libVorbis.a $DESTDIR/libVorbis.a
fi;
if [ -f $SRCDIR/Plugins/mp3Decoder/libcAp_mp3Decoder.a ]; then
    mv $SRCDIR/Plugins/mp3Decoder/libcAp_mp3Decoder.a $DESTDIR/libcAp_mp3Decoder.a
fi;
# Android/ARM, armeabi-v7a (ARMv7 VFP), Android 4.0+ (ICS)
NDKARCH="-march=armv7-a -mfloat-abi=softfp -Wl,--fix-cortex-a8"
DESTDIR=$DIR/prebuilt/android/armeabi-v7a
rm -rf $DESTDIR
mkdir -p $DESTDIR
make clean
make HOST_CC="gcc -m32" CROSS=$NDKP TARGET_SYS=Linux TARGET_FLAGS="$NDKF $NDKARCH"

if [ -f $SRCDIR/cAudio/libcAudio.a ]; then
    mv $SRCDIR/cAudio/libcAudio.a $DESTDIR/libcAudio.a
fi;
if [ -f $SRCDIR//DependenciesSource/libogg-1.2.2/libOgg.a ]; then
    mv $SRCDIR//DependenciesSource/libogg-1.2.2/libOgg.a $DESTDIR/libOgg.a
fi;
if [ -f $SRCDIR/DependenciesSource/libvorbis-1.3.2/libVorbis.a ]; then
    mv $SRCDIR/DependenciesSource/libvorbis-1.3.2/libVorbis.a $DESTDIR/libVorbis.a
fi;
if [ -f $SRCDIR/Plugins/mp3Decoder/libcAp_mp3Decoder.a ]; then
    mv $SRCDIR/Plugins/mp3Decoder/libcAp_mp3Decoder.a $DESTDIR/libcAp_mp3Decoder.a
fi;
make clean
