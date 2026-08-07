#!/system/bin/sh
# 内核模块由 TW_LOAD_VENDOR_MODULES 从 ramdisk 的 /vendor/lib/modules 统一加载，
# 这里不再从 /vendor_dlkm 重复 insmod：recovery 阶段 vendor_dlkm 未必挂得上，
# 且原脚本里的 touchscreen_mmi.ko / sx937x_sar.ko 在这台机器上并不存在。

# 挂载 modem 分区供固件加载（ADSP / 触摸固件都要读这里）
mkdir /firmware
SLOT=$(getprop ro.boot.slot_suffix)
mount /dev/block/bootdevice/by-name/modem$SLOT /firmware -O ro

# 让驱动走 sysfs 回退路径取固件，再拉起 ADSP（PMIC/电量需要）
echo "1" > /proc/sys/kernel/firmware_config/force_sysfs_fallback
echo "1" > /sys/kernel/boot_adsp/boot
exit 0
