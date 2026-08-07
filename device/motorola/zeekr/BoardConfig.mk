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

# ===== 内核（预编译，取自真机 boot.img）=====
# 不从源码编译内核：recovery 只需要能起来的内核，而 prebuilt/ 里这颗与
# recovery/root/vendor/lib/modules 下的 .ko 是同一次编译产出的，版本天然匹配。
# 换成源码编译的 lineage-23.2 内核，那批 .ko 会因 vermagic 不符而全部拒载 ——
# msm_drm.ko 加载不上就是黑屏。顺带省掉 CI 里 30-60 分钟的内核编译。
TARGET_PREBUILT_KERNEL := $(DEVICE_PATH)/prebuilt/kernel
BOARD_KERNEL_IMAGE_NAME := Image
BOARD_BOOT_HEADER_VERSION := 4
BOARD_KERNEL_PAGESIZE := 4096
BOARD_KERNEL_CMDLINE += printk.devkmsg=on
BOARD_KERNEL_CMDLINE += firmware_class.path=/data/vendor/param/firmware
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

# 动态分区 product 级开关：OrangeFox 要求 PRODUCT_USE_DYNAMIC_PARTITIONS=true 才允许
# OF_ENABLE_ALL_PARTITION_TOOLS，否则 bootable/recovery/orangefox.mk:485 报
# "requires dynamic partitions; quitting"。zeekr 是 super 分区(9GB)设备，本就动态分区。
PRODUCT_USE_DYNAMIC_PARTITIONS := true

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
# 安卓15起 FBE 默认使用硬件包裹密钥(wrapped key)，不开这项 A16 的 /data 解不开
TW_INCLUDE_CRYPTO_WRAPPED_KEY := true

# ===== Recovery 基础 =====
# 不能开 BOARD_EXCLUDE_KERNEL_FROM_RECOVERY_IMAGE：
# 摩托 A/B 机型保留了独立 recovery 分区（fox_zeekr.mk 里
# OF_AB_DEVICE_WITH_RECOVERY_PARTITION := 1 也印证了这点），
# 不带内核的 recovery.img 刷进去起不来。
TARGET_RECOVERY_PIXEL_FORMAT := "RGBX_8888"

# 加载 recovery/root/vendor/lib/modules 下的驱动，顺序即依赖顺序。
# 不开这项就没有 msm_drm.ko（显示）和 goodix/stmicro（触摸）—— 黑屏且没触摸。
# 只列 recovery 真正需要、且文件确实存在的 19 个；原厂 modules.load 里
# 另外 283 个属于 vendor_dlkm，recovery 阶段挂不到那个分区，列了只会刷失败日志。
TW_LOAD_VENDOR_MODULES := "q6_notifier_dlkm.ko spf_core_dlkm.ko gpr_dlkm.ko adsp_loader_dlkm.ko q6_pdr_dlkm.ko snd_event_dlkm.ko msm_drm.ko mmi_annotate.ko mmi_info.ko bm_adsp_ulog.ko mmi_charger.ko mmi_relay.ko sensors_class.ko sx937x_multi.ko stmicro_mmi.ko goodix_brl_mmi.ko qti_glink_charger.ko mmi_sys_temp.ko qpnp_adaptive_charge.ko"
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
