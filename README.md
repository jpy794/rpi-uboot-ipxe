## Description

A script to generate SD card image that will boot iPXE on Raspberry Pi 3B+. The image consists of rpi3b+ firmware, u-boot.bin and snp.efi.

## Usage

``` shell
# Build the image
./build.sh
# Flash to SD card
dd if=sdcard.img of=/dev/sdX bs=1M
```

## Acknowledgments

- [Raspberry Pi Documentation - The config.txt file](https://www.raspberrypi.com/documentation/computers/config_txt.html#what-is-config-txt)
- [GitHub - mhomran/u-boot-rpi3-b-plus: A detailed guide for building and booting a 64-bit kernel on raspberry pi 3 b+ using u-boot.](https://github.com/mhomran/u-boot-rpi3-b-plus)
- [iSCSI booting with U-Boot and iPXE — Das U-Boot unknown version documentation](https://u-boot.readthedocs.io/en/v2021.04/uefi/iscsi.html)
- [Boot using iPXE | netboot.xyz](https://netboot.xyz/docs/booting/ipxe)