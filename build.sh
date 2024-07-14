#!/bin/bash
case $MODEL in 

gts7xlwifi)
  KERNEL_DEFCONFIG=gts7xlwifi_eur_open_defconfig
  SOC=865
  ;;

  esac

FUNC_EXPORT(){
DIR=`readlink -f .`;
PARENT_DIR=`readlink -f ${DIR}/..`;

DEFCONFIG_NAME=gts7xlwifi_eur_open_defconfig
CHIPSET_NAME=kona
VARIANT=gts7xlwifi
ARCH=arm64


BUILD_CROSS_COMPILE=$DIR/toolchain/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin/aarch64-linux-android-
KERNEL_LLVM_BIN=$DIR/toolchain/llvm-arm-toolchain-ship/10.0/bin/clang
CLANG_TRIPLE=aarch64-linux-gnu-
KERNEL_MAKE_ENV="DTC_EXT=$(pwd)/tools/dtc CONFIG_BUILD_ARM64_DT_OVERLAY=y LOCALVERSION=-${VERSION}"

DTS_DIR=$PARENT_DIR/out/arch/$ARCH/boot/dts
}

FUNC_KERNEL(){

  #rm -rf modules.old 2>/dev/null
  #mv modules modules.old 2>/dev/null

  make -j20 -C $(pwd) O=$PARENT_DIR/out $KERNEL_MAKE_ENV ARCH=arm64 CROSS_COMPILE=$BUILD_CROSS_COMPILE REAL_CC=$KERNEL_LLVM_BIN CLANG_TRIPLE=$CLANG_TRIPLE CFP_CC=$KERNEL_LLVM_BIN $DEFCONFIG_NAME
  make -j20 -C $(pwd) O=$PARENT_DIR/out $KERNEL_MAKE_ENV ARCH=arm64 CROSS_COMPILE=$BUILD_CROSS_COMPILE REAL_CC=$KERNEL_LLVM_BIN CLANG_TRIPLE=$CLANG_TRIPLE CFP_CC=$KERNEL_LLVM_BIN

}


# MAIN FUNCTION
rm -rf ./build.log
(
  START_TIME=$(date +%s)

  FUNC_EXPORT
  FUNC_KERNEL

  END_TIME=$(date +%s)

  let "ELAPSED_TIME=$END_TIME-$START_TIME"
  echo "Total compile time was $ELAPSED_TIME seconds"

) 2>&1 | tee -a ./build.log
