#!/bin/bash

SECONDS=0
KERNEL_DIR=$(pwd)
DEVICE="$1"
TOOLCHAIN_DIR="$2"
OUT_DIR="out/$DEVICE"
AK3_DIR="$KERNEL_DIR/AnyKernel3"

# ===== Colors =====
GREEN='\033[0;32m'; RED='\033[0;31m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'

# ===== Environment =====
export PATH="$TOOLCHAIN_DIR/bin:$PATH"
export CC="ccache clang"
export ARCH=arm64
export LLVM=1
export LLVM_IAS=1
export CROSS_COMPILE=aarch64-linux-gnu-
export CROSS_COMPILE_ARM32=arm-linux-gnueabi-
export PLATFORM_VERSION=11
export KCFLAGS="-Wno-error=pointer-to-enum-cast -Wno-error=int-conversion -Wno-unused-variable -Wno-unused-function"

DEFCONFIG="vendor/kona-perf_defconfig \
           vendor/samsung/kona-sec-common.config \
           vendor/samsung/${DEVICE}.config \
           vendor/not/ksu.config \
           vendor/not/localversion.config"
           
git submodule update --init --recursive

# ===== Toolchain bootstrap =====
if ! [ -d "$TOOLCHAIN_DIR" ]; then
    echo -e "${YELLOW}Clang not found! Downloading...${NC}"
    mkdir -p "$TOOLCHAIN_DIR"
    ASSET_URL=$(curl -fsSL https://api.github.com/repos/Neutron-Toolchains/clang-build-catalogue/releases/latest |
                jq -r '.assets[] | select(.name | endswith(".tar.zst")) | .browser_download_url' | head -n1)
    [ -z "$ASSET_URL" ] && echo -e "${RED}Failed to find toolchain release!${NC}" && exit 1
    curl -L "$ASSET_URL" | tar --zstd -x -C "$TOOLCHAIN_DIR" --strip-components=1 || exit 1
    echo -e "${GREEN}Clang ready!${NC}"
fi

# ===== Clean build =====
rm -rf "$OUT_DIR"
mkdir -p "$OUT_DIR"

# ===== Build kernel =====
echo -e "${YELLOW}Building with defconfigs: $DEFCONFIG${NC}"
make O="$OUT_DIR" ARCH=arm64 $DEFCONFIG
make O="$OUT_DIR" ARCH=arm64 olddefconfig

echo -e "\n${YELLOW}Starting compilation...${NC}\n"
make -j$(nproc) O="$OUT_DIR" Image.gz-dtb
make -j$(nproc) O="$OUT_DIR" Image
make -j$(nproc) O="$OUT_DIR" dtbs
make -j$(nproc) O="$OUT_DIR" dtbo.img

# ===== Handle DTBs =====
DTB_FILES=$(find "$OUT_DIR/arch/arm64/boot/dts" -name "*.dtb" | sort)
if [ -n "$DTB_FILES" ]; then
    echo -e "${BLUE}Concatenating DTBs...${NC}"
    cat $DTB_FILES > "$OUT_DIR/dtb"
    echo -e "${GREEN}dtb generated successfully!${NC}"
else
    echo -e "${YELLOW}No DTB files found, skipping dtb concatenation.${NC}"
fi

# ===== Handle DTBO =====
DTBO_FILES=$(find "$OUT_DIR/arch/arm64/boot/dts/samsung/$DEVICE" -name "*.dtbo")
if [ -n "$DTBO_FILES" ]; then
    echo -e "${BLUE}Building dtbo.img...${NC}"
    chmod +x "$KERNEL_DIR/tools/mkdtimg"
    "$KERNEL_DIR/tools/mkdtimg" create "$OUT_DIR/dtbo.img" --page_size=4096 ${DTBO_FILES}
    echo -e "${GREEN}dtbo.img created successfully!${NC}"
else
    echo -e "${YELLOW}No DTBO files found for $DEVICE.${NC}"
fi

build_boot() {
    echo "-----------------------------------------------"
    echo "Building boot.img..."
    echo "-----------------------------------------------"
    MKBOOTIMG="$(pwd)/mkbootimg/mkbootimg.py"
    OUT_KERNEL="$(pwd)/out/${DEVICE}/arch/arm64/boot/Image"
    DTB_OUT="$(pwd)/out/${DEVICE}/dtb"
    CMDLINE="console=null androidboot.hardware=qcom androidboot.memcg=1 lpm_levels.sleep_disabled=1 video=vfb:640x400,bpp=32,memsize=3072000 msm_rtb.filter=0x237 service_locator.enable=1 androidboot.usbcontroller=a600000.dwc3 swiotlb=2048 printk.devkmsg=on firmware_class.path=/vendor/firmware_mnt/image loop.max_part=7"
    BASE="0x00000000"
    KOFFSET="0x00008000"
    ROFFSET="0x02000000"
    SECOFFSET="0x00000000"
    DTBOFFSET="0x01f00000"
    TAGSOFFSET="0x01e00000"
    BOARD="SRPUB26A012"
    PAGESZ="4096"
    RAMDISK="$(pwd)/boot/ramdisk"
    MONTH="$(date +%Y-%m)"

    $MKBOOTIMG \
        --header_version 2 \
        --kernel "$OUT_KERNEL" \
        --ramdisk "$RAMDISK" \
        --dtb "$DTB_OUT" \
        --cmdline "$CMDLINE" \
        --header_version 2 \
        --base "$BASE" \
        --kernel_offset "$KOFFSET" \
        --ramdisk_offset "$ROFFSET" \
        --second_offset "$SECOFFSET" \
        --dtb_offset "$DTBOFFSET" \
        --tags_offset "$TAGSOFFSET" \
        --board "$BOARD" \
        --pagesize "$PAGESZ" \
        --os_version 16.0.0 \
        --os_patch_level "$MONTH" \
        --output boot.img
   
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}boot.img created successfully!${NC}"
    else
        echo -e "${RED}Failed to create boot.img${NC}"
    fi     
}

build_boot
