#!/bin/sh

OUT_IMG=sdcard.img
MNT_DIR=mnt

OUT_DIR=$1

if [ -z $OUT_DIR ]
then
    echo usage: ./build-img.sh OUT_DIR
    exit 1
fi

dd if=/dev/zero of=$OUT_IMG bs=1M count=32
LOOP=`losetup -f`
losetup $LOOP $OUT_IMG 
# Start at 0G to make sure that --align takes effect
# Seems that FAT32 won't boot, use FAT16 instead
parted --align optimal $LOOP mklabel msdos mkpart primary fat16 0G 100%
LOOP_PART=${LOOP}p1
mkfs.fat -F 16 $LOOP_PART
mkdir -p $MNT_DIR 
mount $LOOP_PART $MNT_DIR 
cp -r $OUT_DIR/* $MNT_DIR
umount $LOOP_PART
losetup -d $LOOP
