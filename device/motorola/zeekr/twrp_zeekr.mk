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
$(call inherit-product, device/motorola/zeekr/device.mk)

PRODUCT_DEVICE := zeekr
PRODUCT_NAME := twrp_zeekr
PRODUCT_BRAND := motorola
PRODUCT_MODEL := motorola razr 40 ultra
PRODUCT_MANUFACTURER := motorola

PRODUCT_GMS_CLIENTID_BASE := android-motorola

PRODUCT_BUILD_PROP_OVERRIDES += \
    DeviceProduct=zeekr_g

BUILD_FINGERPRINT := motorola/zeekr_g/zeekr_g:16/BP2A.250605.015/release-keys

# 主题
TW_STATUS_ICONS_ALIGN := center
