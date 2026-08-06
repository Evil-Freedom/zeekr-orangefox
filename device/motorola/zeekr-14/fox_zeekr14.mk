#
#	This file is part of the OrangeFox Recovery Project
#	Copyright (C) 2024 The OrangeFox Recovery Project
#
#	OrangeFox is free software: you can redistribute it and/or modify
#	it under the terms of the GNU General Public License as published by
#	the Free Software Foundation, either version 3 of the License, or
#	any later version.
#
#	Please maintain this if you use this script or any part of it
#

# ================================================================
# zeekr-14 (Motorola Razr 40 Ultra) —— OrangeFox 老版本设备配置
# 目标：复刻 V-3.1 世代（fox_14.1 代码基 / 安卓13/14 时代）的橙狐
# 代码基: OrangeFox fox_14.1 (gitlab.com/OrangeFox/sync --branch 14.1)
# 内核:   lineage-21 (安卓14, Linux 5.10)
# ================================================================

# ===== 维护者 =====
OF_MAINTAINER := YourName

# ===== 屏幕与 UI（外屏 1056x1066，密度 420）=====
OF_SCREEN_W := 1056
OF_SCREEN_H := 1066
OF_STATUS_H := 110
OF_STATUS_INDENT_LEFT := 60
OF_STATUS_INDENT_RIGHT := 60
OF_OPTIONS_LIST_NUM := 6
OF_USE_GREEN_LED := 0

# ===== 分区与备份 =====
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
