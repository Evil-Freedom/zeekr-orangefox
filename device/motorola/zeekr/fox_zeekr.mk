#
#	This file is part of the OrangeFox Recovery Project
#	Copyright (C) 2025-2026 The OrangeFox Recovery Project
#
#	OrangeFox is free software: you can redistribute it and/or modify
#	it under the terms of the GNU General Public License as published by
#	the Free Software Foundation, either version 3 of the License, or
#	any later version.
#
#	Please maintain this if you use this script or any part of it
#

# ===== 维护者信息（请改成你自己的名字）=====
OF_MAINTAINER := YourName
# 屏幕与 UI（Razr 40 Ultra 外屏 1056x1066，密度 420；以下为参考值，需按实机微调）
OF_SCREEN_W := 1056
OF_SCREEN_H := 1066
OF_STATUS_H := 110
OF_STATUS_INDENT_LEFT := 60
OF_STATUS_INDENT_RIGHT := 60
OF_OPTIONS_LIST_NUM := 6
OF_USE_GREEN_LED := 0

# ===== OrangeFox 通用开关 =====
OF_USE_TWRP_RECOVERY_IMAGE_BUILDER := 1
FOX_VARIANT := omni
OF_SUPPORT_ALL_BLOCK_DEVICES := 1

# ===== 分区与备份工具 =====
OF_ENABLE_ALL_PARTITION_TOOLS := 1
OF_WORKAROUND_BACKUP_BUG := 1
OF_USE_AIDL_BOOT_CONTROL := 1
OF_FORCE_DATA_FORMAT_F2FS := 1
OF_UNBIND_SDCARD_F2FS := 1
OF_WIPE_METADATA_AFTER_DATAFORMAT := 1
OF_DYNAMIC_FULL_SIZE := 9487515648
OF_DISPLAY_FORMAT_FILESYSTEMS_DEBUG_INFO := 1
OF_FORCE_PREBUILT_KERNEL := 0
OF_NO_RELOAD_AFTER_DECRYPTION := 1
OF_NO_TREBLE_COMPATIBILITY_CHECK := 1
OF_AB_DEVICE_WITH_RECOVERY_PARTITION := 1
OF_RECOVERY_AB_FULL_REFLASH_RAMDISK := 1
OF_ENABLE_FRP_ADDON := 1

# ===== 压缩 =====
OF_USE_LZ4_COMPRESSION := 1
OF_ENABLE_FS_COMPRESSION := 1
