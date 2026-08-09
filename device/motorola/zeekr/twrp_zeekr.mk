#
# Copyright (C) 2023 The Android Open Source Project
# Copyright (C) 2023 SebaUbuntu's TWRP device tree generator
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/base.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/gsi_keys.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/updatable_apex.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota.mk)

# Inherit some common TWRP stuff.
$(call inherit-product, vendor/twrp/config/common.mk)

# Inherit from zeekr device
$(call inherit-product, device/motorola/zeekr/device.mk)

PRODUCT_DEVICE := zeekr
PRODUCT_NAME := twrp_zeekr
PRODUCT_BRAND := motorola
PRODUCT_MODEL := motorola razr 40 ultra
PRODUCT_MANUFACTURER := motorola

PRODUCT_GMS_CLIENTID_BASE := android-motorola

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRIVATE_BUILD_DESC="zeekr_gu-user 13 T2TV33.45-83-2 b6410-dddbd9 release-keys"

BUILD_FINGERPRINT := motorola/zeekr_g/msi:13/T1TZ33M.3-62-45/fc8bb:user/release-keys
