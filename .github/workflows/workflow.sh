#!/bin/bash
# Env
cd ..
export WORKDIR=$(pwd)
export SOURCE=raspberrypi-kernel
export OUTPUT=openeuler
export ARCH=arm64
export CROSS_COMPILE=aarch64-linux-gnu-
export TARGET=shrink_defconfig

# Compile
cd ${WORKDIR}/${SOURCE}
make ${TARGET}
make -j4

# Collect
# kernel modules
make INSTALL_MOD_PATH=${WORKDIR}/${OUTPUT}/ modules_install
cp ${WORKDIR}/${SOURCE}/arch/${ARCH}/boot/Image ${WORKDIR}/${OUTPUT}/

# device tree binary
cp ${WORKDIR}/${SOURCE}/arch/${ARCH}/boot/dts/broadcom/*.dtb ${WORKDIR}/${OUTPUT}/
mkdir ${WORKDIR}/${OUTPUT}/overlays
cp ${WORKDIR}/${SOURCE}/arch/${ARCH}/boot/dts/overlays/*.dtb* ${WORKDIR}/${OUTPUT}/overlays/

# Finish
cd ${WORKDIR}
# size
touch $(du -d 0 ${OUTPUT} | awk '{print $1}').txt
# target_defconfig
cp ${WORKDIR}/${SOURCE}/arch/${ARCH}/configs/${TARGET} ${WORKDIR}/
# kernel
mv ${WORKDIR}/${OUTPUT} ${WORKDIR}/${OUTPUT}-$(date "+%s")
tar -cf ${WORKDIR}/${OUTPUT}.tar ${WORKDIR}/${OUTPUT}-*/
