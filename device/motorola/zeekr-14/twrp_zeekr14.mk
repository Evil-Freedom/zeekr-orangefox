#
# Copyright (C) 2024 The OrangeFox Recovery Project
# SPDX-License-Identifier: GPL-3.0-or-later
#

# 基础产品配置
$(call inherit-product, $(SRC_TARGET_DIR)/product/base.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/compression.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

# TWRP 公共配置
$(call inherit-product, vendor/twrp/config/common.mk)

# 电话基础
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# 设备专属 recovery 配置
$(call inherit-product, device/motorola/zeekr-14/device.mk)

# 必须等于设备目录名 zeekr-14：构建系统按
# find device -path '*/$(TARGET_DEVICE)/BoardConfig.mk' 定位板级配置，
# 写成 zeekr 会找不到而报 Invalid lunch combo。
PRODUCT_DEVICE := zeekr-14
PRODUCT_NAME := twrp_zeekr14
PRODUCT_BRAND := motorola
PRODUCT_MODEL := motorola razr 40 ultra
PRODUCT_MANUFACTURER := motorola

PRODUCT_GMS_CLIENTID_BASE := android-motorola

PRODUCT_BUILD_PROP_OVERRIDES += \
    DeviceProduct=zeekr_g \
    TARGET_DEVICE=zeekr

BUILD_FINGERPRINT := motorola/zeekr_g/zeekr_g:14/UP1A.231005.007/release-keys

# 主题
TW_STATUS_ICONS_ALIGN := center
