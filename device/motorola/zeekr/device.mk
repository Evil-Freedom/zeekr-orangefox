#
# Minimal recovery device.mk —— Motorola Razr 40 Ultra (zeekr)
# 仅供 OrangeFox Recovery 构建使用，不要继承完整 LineageOS ROM 的 device.mk
#

# ===== Recovery / TWRP 基础二进制 =====
PRODUCT_PACKAGES += \
    recovery \
    twrp \
    libtwrp \
    busybox \
    bash \
    flash_image \
    fsck.f2fs \
    mkfs.f2fs \
    mount.f2fs \
    e2fsck \
    mke2fs \
    tune2fs \
    resize2fs \
    sgdisk \
    parted \
    mount.exfat \
    fsck.exfat \
    mkfs.exfat

# ===== EROFS 工具 =====
# BoardConfig 已把 system/vendor/product/odm/system_ext 声明为 erofs
# (安卓15起只读分区默认格式)，没有这几个工具 recovery 挂不上也修不了这些分区。
PRODUCT_PACKAGES += \
    fsck.erofs \
    dump.erofs \
    mkfs.erofs

# ===== 设备专属 recovery UI（可选）=====
# 如果你在 recovery_ui/ 下实现了 Board 类，取消下面两行注释；
# 若使用 TWRP 默认 UI，则保持注释，并在编译报错“找不到 librecovery_ui_zeekr”时删除这两行。
# TARGET_RECOVERY_DEVICE_MODULES += librecovery_ui_zeekr
# PRODUCT_PACKAGES += librecovery_ui_zeekr

# ===== 主题 =====
TW_THEME := portrait_hdpi
