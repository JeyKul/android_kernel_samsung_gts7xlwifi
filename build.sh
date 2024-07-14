#!/bin/bash
case $MODEL in 

gts7xlwifi)
  KERNEL_DEFCONFIG=gts7xlwifi_eur_open_defconfig
  SOC=865
  ;;

  esac

FUNC_EXPORT(){
  export START=$PWD 
  export CLANG_PATH=$PWD/toolchain/llvm-arm-toolchain-ship/10.0/bin
  export PATH=$CLANG_PATH:$PATH
  #export PATH=$PWD/toolchain/gcc/linux-x86/aarch64/:$PATH
  #export PATH=$PWD/toolchain/prebuilts/gas/linux-x86:$PATH
  export CROSS_COMPILE=$PWD/toolchain/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin/aarch64-linux-androidkernel-
  export CLANG_TRIPLE=$PWD/toolchain/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin/aarch64-linux-android-
  export CC=$CLANG_PATH/clang
#  export LLVM=1
#  export LLVM_IAS=1
  export ARCH=arm64
  export ABI=aarch64
  export CFLAGS="-Wno-error"
  export CXXFLAGS="-Wno-error"
}

FUNC_KERNEL(){
  cd kernel

  #rm -rf modules.old 2>/dev/null
  #mv modules modules.old 2>/dev/null

  make gts7xlwifi_eur_open_defconfig
  make -s -j20 ANDROID_ABI=arm64-v8a
}


# Variables
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
#Compile kernel:
[ ! -d "$PARENT_DIR/out" ] && mkdir $PARENT_DIR/out
  make -j20 -C $(pwd) O=$PARENT_DIR/out $KERNEL_MAKE_ENV ARCH=arm64 CROSS_COMPILE=$BUILD_CROSS_COMPILE REAL_CC=$KERNEL_LLVM_BIN CLANG_TRIPLE=$CLANG_TRIPLE CFP_CC=$KERNEL_LLVM_BIN $DEFCONFIG_NAME
  make -j20 -C $(pwd) O=$PARENT_DIR/out $KERNEL_MAKE_ENV ARCH=arm64 CROSS_COMPILE=$BUILD_CROSS_COMPILE REAL_CC=$KERNEL_LLVM_BIN CLANG_TRIPLE=$CLANG_TRIPLE CFP_CC=$KERNEL_LLVM_BIN



# MAIN FUNCTION
rm -rf ./build.log
(
  START_TIME=$(date +%s)

  #FUNC_EXPORT
  #FUNC_KERNEL

  END_TIME=$(date +%s)

  let "ELAPSED_TIME=$END_TIME-$START_TIME"
  echo "Total compile time was $ELAPSED_TIME seconds"

) 2>&1 | tee -a ./build.log
