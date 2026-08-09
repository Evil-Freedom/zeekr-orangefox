#
# Copyright (C) 2023 The Android Open Source Project
# Copyright (C) 2023 SebaUbuntu's TWRP device tree generator
#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/motorola/zeekr

# For building with minimal manifest
ALLOW_MISSING_DEPENDENCIES := true

# A/B
AB_OTA_UPDATER := true
BOARD_BUILD_SYSTEM_ROOT_IMAGE := false
AB_OTA_PARTITIONS += \
    boot \
    dtbo \
    product \
    system \
    system_ext \
    recovery \
    vbmeta \
    vbmeta_system \
    vendor \
    vendor_dlkm \
    vendor_boot

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-2a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := generic
TARGET_CPU_VARIANT_RUNTIME := kryo385

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-2a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := generic
TARGET_2ND_CPU_VARIANT_RUNTIME := kryo385

# Audio
AUDIO_FEATURE_ENABLED_DLKM := true
AUDIO_FEATURE_ENABLED_DTS_EAGLE := false
AUDIO_FEATURE_ENABLED_GEF_SUPPORT := true
AUDIO_FEATURE_ENABLED_HW_ACCELERATED_EFFECTS := false
AUDIO_FEATURE_ENABLED_INSTANCE_ID := true
AUDIO_FEATURE_ENABLED_LSM_HIDL := true
AUDIO_FEATURE_ENABLED_PAL_HIDL := true
AUDIO_FEATURE_ENABLED_PROXY_DEVICE := true
BOARD_SUPPORTS_SOUND_TRIGGER := true
BOARD_USES_ALSA_AUDIO := true
TARGET_USES_QCOM_MM_AUDIO := true
USE_CUSTOM_AUDIO_POLICY := 1

SOONG_CONFIG_NAMESPACES += android_hardware_audio
SOONG_CONFIG_android_hardware_audio += \
        run_64bit
SOONG_CONFIG_android_hardware_audio_run_64bit := true

# Bootloader
TARGET_NO_BOOTLOADER := false
TARGET_USES_UEFI := true
TARGET_USES_REMOTEPROC := true

# Build
BUILD_BROKEN_DUP_RULES := true
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true
# Android 16(及更高)的 soong sandbox 把源码树挂成只读，ccache 写临时文件
# (哪怕放在 RUNNER_TEMP，只要与源码树同分区) 就会撞 "Read-only file system"。
# 这是 AOSP 官方提供的标准开关：构建期间将整个源码树声明为可写。
BUILD_BROKEN_SRC_DIR_IS_WRITABLE := true

# Display
# 内屏物理分辨率 1080x2640（pOLED 144Hz）。TWRP 图形栈用它决定 framebuffer 尺寸，
# 缺失会导致 recovery 界面拉伸或触摸坐标错位。
TARGET_SCREEN_WIDTH := 1080
TARGET_SCREEN_HEIGHT := 2640
TARGET_SCREEN_DENSITY := 400
TARGET_USES_COLOR_METADATA := true
TARGET_USES_DISPLAY_RENDER_INTENTS := true
TARGET_USES_GRALLOC4 := true
TARGET_USES_HWC2 := true
TARGET_GRALLOC_HANDLE_HAS_RESERVED_SIZE := true
TARGET_GRALLOC_HANDLE_HAS_CUSTOM_CONTENT_MD_RESERVED_SIZE := false

# DRM
TARGET_ENABLE_MEDIADRM_64 := true

# Init
TARGET_INIT_VENDOR_LIB := //$(DEVICE_PATH):libinit_zeekr
TARGET_RECOVERY_DEVICE_MODULES := libinit_zeekr

# Kernel
TARGET_PREBUILT_KERNEL := $(DEVICE_PATH)/prebuilt/kernel
BOARD_BOOT_HEADER_VERSION := 4
BOARD_KERNEL_BASE := 0x00000000
BOARD_KERNEL_CMDLINE += printk.devkmsg=on
BOARD_KERNEL_CMDLINE += firmware_class.path=/data/vendor/param/firmware
#BOARD_KERNEL_CMDLINE += androidboot.selinux=permissive
BOARD_BOOTCONFIG += androidboot.hardware=qcom
BOARD_BOOTCONFIG += androidboot.memcg=1
BOARD_BOOTCONFIG += androidboot.usbcontroller=a600000.dwc3
BOARD_KERNEL_IMAGE_NAME := Image
BOARD_KERNEL_PAGESIZE := 4096
BOARD_KERNEL_SEPARATED_DTBO := true
BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOT_HEADER_VERSION)
BOARD_RAMDISK_USE_LZ4 := true
BOARD_USES_GENERIC_KERNEL_IMAGE := true
TARGET_KERNEL_SOURCE := kernel/motorola/sm8475
TARGET_KERNEL_CONFIG := \
    gki_defconfig \
    vendor/waipio_GKI.config \
    vendor/ext_config/moto-waipio.config \
    vendor/ext_config/moto-waipio-gki.config \
    vendor/ext_config/lineage-moto-waipio.config
KERNEL_LTO := none

# Partitions
BOARD_FLASH_BLOCK_SIZE := 262144 # (BOARD_KERNEL_PAGESIZE * 64)
BOARD_SUPER_PARTITION_GROUPS := qti_dynamic_partitions
BOARD_QTI_DYNAMIC_PARTITIONS_PARTITION_LIST := system system_ext product vendor vendor_dlkm
BOARD_QTI_DYNAMIC_PARTITIONS_SIZE := 9122611200
BOARD_SUPER_PARTITION_SIZE := 9126805504
BOARD_BOOTIMAGE_PARTITION_SIZE := 100663296
BOARD_KERNEL-GKI_BOOTIMAGE_PARTITION_SIZE := $(BOARD_BOOTIMAGE_PARTITION_SIZE)
BOARD_VENDOR_BOOTIMAGE_PARTITION_SIZE := 100663296
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 104857600
BOARD_SYSTEMIMAGE_PARTITION_TYPE := ext4
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := f2fs
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
# BOARD_USES_METADATA_PARTITION 已移至下方 Crypto 段统一声明，避免两处重复定义
TARGET_COPY_OUT_VENDOR := vendor

# Platform
# zeekr 实际平台为 sm8475 (骁龙 8+ Gen1, Waipio)。
# 注意：taro 是 SM8450 (骁龙 8 Gen1) 的平台代号，与 zeekr 不符。
# 但 OrangeFox 16.0 的 vendor/twrp 配置中硬编码引用 taro，
# 且 SM8475 与 SM8450 共享 Adreno 730 GPU、相同 SMMU/ACPI 表，
# 实际 recovery 构建不区分两者。保持 taro 以兼容 OF 上游。
TARGET_BOARD_PLATFORM := taro
TARGET_BOOTLOADER_BOARD_NAME := taro
QCOM_BOARD_PLATFORMS += taro

# Properties
TARGET_SYSTEM_PROP += $(DEVICE_PATH)/system.prop

# Recovery
TARGET_RECOVERY_QCOM_RTC_FIX := true
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888
TARGET_RECOVERY_DEVICE_DIRS += $(DEVICE_PATH)
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/recovery/root/system/etc/recovery.fstab
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true
RECOVERY_SDCARD_ON_DATA := true

# Verified Boot
BOARD_AVB_ENABLE := true
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flags 3
BOARD_AVB_RECOVERY_KEY_PATH := external/avb/test/data/testkey_rsa4096.pem
BOARD_AVB_RECOVERY_ALGORITHM := SHA256_RSA4096
BOARD_AVB_RECOVERY_ROLLBACK_INDEX := 1
BOARD_AVB_RECOVERY_ROLLBACK_INDEX_LOCATION := 1
BOARD_AVB_VBMETA_SYSTEM := product system system_ext
BOARD_AVB_VBMETA_SYSTEM_KEY_PATH := external/avb/test/data/testkey_rsa4096.pem
BOARD_AVB_VBMETA_SYSTEM_ALGORITHM := SHA256_RSA4096
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX_LOCATION := 2

# Crypto —— Android 16 FBE v2 硬件级解密
TW_INCLUDE_CRYPTO := true
TW_INCLUDE_CRYPTO_FBE := true
TW_INCLUDE_FBE_METADATA_DECRYPT := true
BOARD_USES_QCOM_FBE_DECRYPTION := true
TW_USE_FSCRYPT_POLICY := 2
TW_FIX_DECRYPTION_ON_DATA_MEDIA := true

# 高通 TEE 阻塞等待开关：这是解密超时与 keymint 段错误的根因治理项。
# 不开启时 keymint/gatekeeper 会在 QSEECom listener 尚未注册完成时就发起 TEE 调用，
# 拿到空的 handle 后解引用 -> SIGSEGV；或一直等到 vold 超时 -> 报“密码错误”。
# 开启后 keymaster/keymint 客户端会阻塞直到 qseecomd 就绪再继续。
TARGET_KEYMASTER_WAIT_FOR_QSEE := true
WAIT_FOR_QSEECOM := true

# BinderFS：Android 12+ 的 recovery 中 servicemanager/keystore2/AIDL HAL 全部走 binder，
# 必须有 /dev/binderfs 提供 binder 设备节点，否则 servicemanager 起不来，AIDL 链整条断掉。
TARGET_USES_BINDERFS := true

# metadata 分区承载 FBE v2 的 metadata_encryption 密钥目录，解密第一步就要读它
BOARD_USES_METADATA_PARTITION := true

# TWRP Configuration
TW_DEVICE_VERSION := zeekr
TW_THEME := portrait_hd
TW_INPUT_BLACKLIST := "hbtp_vm"
TW_INCLUDE_REPACKTOOLS := true
TW_INCLUDE_RESETPROP := true
TW_INCLUDE_LIBRESETPROP := true
TW_INCLUDE_NTFS_3G := true
TW_BACKUP_EXCLUSIONS := /data/fonts
TW_NO_SCREEN_BLANK := true
TW_BRIGHTNESS_PATH := "/sys/class/backlight/panel0-backlight/brightness"
TW_MAX_BRIGHTNESS := 16380
TW_DEFAULT_BRIGHTNESS := 16380
TW_FRAMERATE := 120
TW_HAS_EDL_MODE := true
TW_CUSTOM_CPU_TEMP_PATH := /sys/class/thermal/thermal_zone39/temp
TW_EXCLUDE_DEFAULT_USB_INIT := true
TARGET_USE_CUSTOM_LUN_FILE_PATH := /config/usb_gadget/g1/functions/mass_storage.0/lun.%d/file
TW_SUPPORT_INPUT_AIDL_HAPTICS := true
TW_SUPPORT_INPUT_AIDL_HAPTICS_FIX_OFF := true
TW_INCLUDE_FASTBOOTD := true
TW_NO_FLASH_CURRENT_TWRP := true
TW_EXCLUDE_APEX := true
TW_USE_SERIALNO_PROPERTY_FOR_DEVICE_ID := true

# Debug flags
TWRP_INCLUDE_LOGCAT := true
TARGET_USES_LOGD := true

# Namespace definition for librecovery_updater
SOONG_CONFIG_NAMESPACES += ufsbsg
SOONG_CONFIG_ufsbsg += ufsframework
SOONG_CONFIG_ufsbsg_ufsframework := bsg
