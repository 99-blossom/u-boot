#!/usr/bin/env bash
sudo -v
set -e

make O=out CROSS_COMPILE=aarch64-linux-gnu- -j$(nproc)

gzip -9 -f -k out/u-boot.bin
echo "bootopt=64S3,32N2,64N2 androidboot.init_fatal_reboot_target=recovery buildvariant=userdebug" > AIK/split_img/boot.img-cmdline
cp out/u-boot.bin.gz AIK/split_img/boot.img-kernel

(cd AIK && sudo ./repackimg.sh)

if [ "$1" = "-flash" ]; then
    fastboot flash boot AIK/image-new.img && fastboot reboot
fi
