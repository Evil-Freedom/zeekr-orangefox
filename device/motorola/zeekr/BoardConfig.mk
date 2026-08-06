#
# Copyright (C) 2024-2026 The OrangeFox Recovery Project
# SPDX-License-Identifier: GPL-3.0-or-later
#
# OrangeFox Recovery 设备配置 —— Motorola Razr 40 Ultra (zeekr)
# 平台: SM8475 (骁龙 8+ Gen1)，安卓 16 (OrangeFox 16.0)
#
# 注意：本文件为“自包含 recovery 配置”，刻意不继承
# device/motorola/sm8475-common 与 vendor/motorola/zeekr，
# 以避免引入 ROM 专属依赖。仅保留 recovery 真正需要的配置。
#

DEVICE_PATH := device/motorola/zeekr

# 允许 minimal manifest 构建
ALLOW_MISSING_DEPENDENCIES := true
BUILD_BROKEN_DUP_RULES := true
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true
BUILD_BROKEN_NINJA_USES_ENV_VARS += RTIC_MPGEN
BUILD_BROKEN_PLUGIN_VALIDATION := soong-libaosprecovery_defaults soong-libguitwrp_defaults soong-libminuitwrp_defaults soong-vold_defaults

# ===== 架构 =====
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_VARIANT := generic
TARGET_CPU_VARIANT_RUNTIME := generic

# ===== 平台 =====
TARGET_BOARD_PLATFORM := sm8475
TARGET_BOARD_PLATFORM_GPU := qcom-adreno730
QCOM_BOARD_PLATFORMS += sm8475

# ===== 内核（安卓16 源码内核，Linux 5.10）=====
# 内核仓库: https://github.com/LineageOS/android_kernel_motorola_sm8475
# 需 clone 到 kernel/motorola/sm8475
TARGET_KERNEL_SOURCE := kernel/motorola/sm8475
TARGET_KERNEL_ARCH := arm64
TARGET_KERNEL_HEADER_ARCH := arm64
# zeekr 的实际 defconfig 为 waipio 公共 defconfig + 追加片段
# 若内核仓库里片段路径不同，请按实际修改下面一行
TARGET_KERNEL_CONFIG := vendor/ext_config/moto-waipio-zeekr.config
BOARD_KERNEL_IMAGE_NAME := Image
BOARD_BOOT_HEADER_VERSION := 4
BOARD_KERNEL_PAGESIZE := 4096
BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOT_HEADER_VERSION)
BOARD_MKBOOTIMG_ARGS += --pagesize $(BOARD_KERNEL_PAGESIZE)
BOARD_RAMDISK_USE_LZ4 := true

# ===== A/B（虚拟 A/B）=====
AB_OTA_UPDATER := true
AB_OTA_PARTITIONS := \
    boot \
    init_boot \
    vendor_boot \
    dtbo \
    odm \
    product \
    system \
    system_ext \
    system_dlkm \
    vbmeta \
    vbmeta_system \
    vbmeta_vendor \
    vendor \
    vendor_dlkm

# ===== 校验启动 (AVB) =====
BOARD_AVB_ENABLE := true

# ===== 分区 =====
BOARD_PROPERTY_OVERRIDES_SPLIT_ENABLED := true
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 104857600

# ===== 动态分区 (super) =====
BOARD_SUPER_PARTITION_SIZE := 9487515648
BOARD_SUPER_PARTITION_GROUPS := qti_dynamic_partitions
BOARD_QTI_DYNAMIC_PARTITIONS_SIZE := 9483398144 # (SUPER - 4MiB)
BOARD_QTI_DYNAMIC_PARTITIONS_PARTITION_LIST := \
    system system_ext product vendor vendor_dlkm odm
BOARD_PARTITION_LIST := $(call to-upper, $(BOARD_QTI_DYNAMIC_PARTITIONS_PARTITION_LIST))
$(foreach p, $(BOARD_PARTITION_LIST), $(eval BOARD_$(p)IMAGE_FILE_SYSTEM_TYPE := erofs))
$(foreach p, $(BOARD_PARTITION_LIST), $(eval TARGET_COPY_OUT_$(p) := $(call to-lower, $(p))))
BOARD_VENDOR_DLKMIMAGE_FILE_SYSTEM_TYPE := ext4

# ===== 文件系统 =====
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := f2fs
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true

# ===== 加密（Motorola SM8475 FBE）=====
BOARD_USES_METADATA_PARTITION := true
BOARD_USES_QCOM_FBE_DECRYPTION := true
TW_INCLUDE_CRYPTO := true
TW_INCLUDE_CRYPTO_FBE := true
TW_INCLUDE_FBE_METADATA_DECRYPT := true
TW_USE_FSCRYPT_POLICY := 2

# ===== Recovery 基础 =====
BOARD_EXCLUDE_KERNEL_FROM_RECOVERY_IMAGE := true
TARGET_RECOVERY_PIXEL_FORMAT := "RGBX_8888"
TW_INCLUDE_FASTBOOTD := true
TW_SKIP_ADDITIONAL_FSTAB := true
TARGET_RECOVERY_UI_MARGIN_HEIGHT := 90

# ===== 工具 =====
TW_INCLUDE_LIBRESETPROP := true
TW_INCLUDE_LPDUMP := true
TW_INCLUDE_LPTOOLS := true
TW_INCLUDE_REPACKTOOLS := true
TW_INCLUDE_RESETPROP := true

# ===== TWRP 显示（内屏 1080x2400 竖屏）=====
# 亮度节点需按实机 sysfs 调整，下面为常用猜测值
TW_BRIGHTNESS_PATH := "/sys/class/backlight/panel0-backlight/brightness"
TW_DEFAULT_BRIGHTNESS := 1023
TW_MAX_BRIGHTNESS := 2047
TW_THEME := portrait_hdpi
TW_NO_SCREEN_BLANK := true
TW_SCREEN_BLANK_ON_BOOT := true
TARGET_USES_VULKAN := true

# ===== TWRP 文件系统支持 =====
RECOVERY_SDCARD_ON_DATA := true
TARGET_USES_MKE2FS := true
TW_ENABLE_FS_COMPRESSION := true
TW_INCLUDE_FUSE_EXFAT := true
TW_INCLUDE_FUSE_NTFS := true
TW_INCLUDE_NTFS_3G := true
TW_NO_EXFAT_FUSE := true

# ===== 调试 =====
TARGET_USES_LOGD := true
TWRP_INCLUDE_LOGCAT := true
TARGET_RECOVERY_DEVICE_MODULES += debuggerd
TARGET_RECOVERY_DEVICE_MODULES += strace
RECOVERY_BINARY_SOURCE_FILES += $(TARGET_OUT_EXECUTABLES)/debuggerd
RECOVERY_BINARY_SOURCE_FILES += $(TARGET_OUT_EXECUTABLES)/strace

# ===== 版本 =====
PLATFORM_VERSION := 16
PLATFORM_VERSION_LAST_STABLE := $(PLATFORM_VERSION)
PLATFORM_SECURITY_PATCH := 2025-05-01
VENDOR_SECURITY_PATCH := $(PLATFORM_SECURITY_PATCH)
BOOT_SECURITY_PATCH := $(PLATFORM_SECURITY_PATCH)
TW_DEVICE_VERSION := Motorola_Razr_40_Ultra

# ===== 其它 TWRP 配置 =====
TARGET_RECOVERY_QCOM_RTC_FIX := true
TW_EXCLUDE_APEX := true
TW_EXCLUDE_DEFAULT_USB_INIT := true
TW_DEFAULT_LANGUAGE := en
TW_EXTRA_LANGUAGES := true
TW_USE_TOOLBOX := true
TW_INCLUDE_ZSTD := true
TW_INPUT_BLACKLIST := "hbtp_vm"

# ===== 引入 OrangeFox 配置 =====
-include $(DEVICE_PATH)/fox_zeekr.mk
