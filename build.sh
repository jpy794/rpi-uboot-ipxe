#!/bin/sh

BUILD_DIR=`pwd`

UBOOT_TGT=rpi_3_b_plus_defconfig
UBOOT_DIR=$BUILD_DIR/u-boot
UBOOT_BIN=$UBOOT_DIR/u-boot.bin

FW_DIR=$BUILD_DIR/firmware
FW_PREFIX=boot
FW_LIST=(
    bootcode.bin
    start.elf
    fixup.dat
)
CONFIG_TXT=$BUILD_DIR/config.txt

IPXE_TGT=bin-arm64-efi/snp.efi
IPXE_DIR=$BUILD_DIR/ipxe
IPXE_EMBED=$BUILD_DIR/embed.ipxe
IPXE_EFI=$IPXE_DIR/src/$IPXE_TGT

OUT_DIR=$BUILD_DIR/output

# fetch submodules
git submodule init
git submodule update

# build u-boot
make -C $UBOOT_DIR ARCH=arm CROSS_COMPILE=aarch64-linux-gnu- $UBOOT_TGT
make -C $UBOOT_DIR ARCH=arm CROSS_COMPILE=aarch64-linux-gnu- -j`nproc`

# build ipxe
cp $BUILD_DIR/ipxe-config/* $IPXE_DIR/src/config/local/
make -C $IPXE_DIR/src CROSS_COMPILE=aarch64-linux-gnu- $IPXE_TGT EMBED=$IPXE_EMBED -j`nproc`

# copy firmware, u-boot, ipxe to output
mkdir -p $OUT_DIR
rm -rf $OUT_DIR/*
cp $UBOOT_BIN $OUT_DIR/u-boot.bin
$UBOOT_DIR/tools/mkimage -A arm -T script -d $BUILD_DIR/boot.cmd $OUT_DIR/boot.scr

mkdir -p $OUT_DIR/efi/tools
cp $IPXE_EFI $OUT_DIR/efi/tools/snp.efi

mkdir -p $OUT_DIR/overlays
for i in ${FW_LIST[@]}
do
    cp $FW_DIR/$FW_PREFIX/$i $OUT_DIR/$i
done
cp $CONFIG_TXT $OUT_DIR/config.txt

# generate image
echo generating sdcard image...
sudo ./build-img.sh $OUT_DIR &> /dev/null
