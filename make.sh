#!/bin/bash
echo "Setting Up Environment"
echo ""
export CROSS_COMPILE=/media/neel/e839799c-2f22-4a36-9068-b6584358d51f/neel/toolchain/gcc-linaro-7.5.0/bin/aarch64-linux-gnu-
export ARCH=arm64
export ANDROID_MAJOR_VERSION=q
export PLATFORM_VERSION=10.0.0
export USE_CCACHE=1
#export this to name your kernel, you need to disable the localversion from defconfig to use this
#export CONFIG_LOCALVERSION=PRISH Q J701X
clear
echo "Select"
echo "1 = Clean Build"
echo "2 = Start Build"
echo "3 = AIK+ZIP"
echo "4 = Anykernel"
echo "5 = Exit"
read n
#clear

if [ $n -eq 1 ]; then

make clean && make mrproper
rm ./arch/arm64/boot/Image
rm ./arch/arm64/boot/Image.gz
rm ./Image
rm ./dtb
rm ./arch/arm64/boot/dtb
rm ./arch/arm64/boot/dts/*.dtb
rm ./AIK/split_img/boot.img-dt
rm ./AIK/split_img/boot.img-zImage
rm ./Anykernel/Image
rm ./Anykernel/dtb
#clear
fi

if [ $n -eq 2 ]; then
rm ./arch/arm64/boot/Image
rm ./arch/arm64/boot/Image.gz
rm ./Image
rm ./dtb
rm ./arch/arm64/boot/dtb
rm ./arch/arm64/boot/dts/*.dtb
rm ./AIK/split_img/boot.img-dt
rm ./AIK/split_img/boot.img-zImage
rm ./Anykernel/Image
rm ./Anykernel/dtb
#clear
echo "=========="
echo "Building DTB"
echo "=========="
make goku_defconfig
DTS=arch/arm64/boot/dts
make exynos7870-j7velte_sea_open_00.dtb exynos7870-j7velte_sea_open_01.dtb exynos7870-j7velte_sea_open_03.dtb
./tools/dtbtool $DTS/ -o ./arch/arm64/boot/dtb
echo "Cleanup DTB"
rm ./arch/arm64/boot/dts/*.dtb
echo "============="
echo "Building zImage"
echo "============="
make goku_defconfig
make -j64
echo "Kernel Compiled"
echo ""
cp -r ./arch/arm64/boot/Image ./AIK/split_img/boot.img-zImage
cp -r ./dtb ./AIK/split_img/boot.img-dt
cp -r ./arch/arm64/boot/Image ./Anykernel/Image
cp -r ./arch/arm64/boot/dtb ./Anykernel/dtb
#clear
fi

if [ $n -eq 3 ]; then
echo "============="
echo "MAKING FLASHABLE ZIP"
echo "============="
rm ./AIK/split_img/boot.img-dt
rm ./AIK/split_img/boot.img-zImage
cp -r ./arch/arm64/boot/Image ./Image
cp -r ./arch/arm64/boot/Image ./AIK/split_img/boot.img-zImage
cp -r ./arch/arm64/boot/dtb ./AIK/split_img/boot.img-dt
./AIK/repackimg.sh
cp -r ./AIK/image-new.img ./ZIP/NEEL/nxt/boot.img
cd ZIP
./neel.sh
cd ..
cp -r ./ZIP/kernel.zip ./kernel_p_J7VELTE.zip
#clear
fi

if [ $n -eq 4 ]; then
echo "============="
echo "ADDING IN ANYKERNEL"
echo "============="
cp -r ./arch/arm64/boot/Image ./AK/Image
cp -r ./arch/arm64/boot/dtb ./AK/dtb
cd AK
./test.sh
cd ..
cp -r ./AK/kernel.zip ./kernel_p_J7VELTE.zip
#clear
fi

if [ $n -eq 5 ]; then
exit
fi


