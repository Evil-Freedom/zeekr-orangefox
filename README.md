# zeekr (Motorola Razr 40 Ultra) OrangeFox Recovery 构建仓库

为 **Motorola Razr 40 Ultra（代号 zeekr，SM8475 / 骁龙 8+ Gen1）** 提供两套 OrangeFox Recovery 设备树 + GitHub Actions 云编译。

| 目标 | 代码基 | 内核 | 对应设备树 | 说明 |
|------|--------|------|-----------|------|
| **zeekr（安卓16 新版）** | OrangeFox `16.0`（**GitHub** `OrangeFox16/sync --branch 16.0`） | `lineage-23.2`（Linux 5.10） | `device/motorola/zeekr` | 面向安卓16 ROM |
| **zeekr14（老版复刻）** | OrangeFox `14.1`（GitLab `sync --branch 14.1`） | `lineage-21`（Linux 5.10） | `device/motorola/zeekr-14` | 复刻 V-3.1 世代（fox_14.1 代码基） |

> **重要声明**
> 老版 V-3.1（`Orangefox-V-3.1(zeekr).zip`）是成品刷机包，本仓库 **不含其二进制**。我们从其 ramdisk 逆向提取了真实分区表（`recovery.fstab`）、加密标志、屏幕密度等参数，据此编写老版设备树。两套设备树均**未实机编译验证**，首次构建需按报错微调（见文末清单）。

---

## 一、仓库结构

```
zeekr-orangefox-16/
├── .github/workflows/build-zeekr-ofox.yml   # GitHub Actions 云编译（双版本）
├── build_zeekr_ofox.sh                       # 本地一键编译脚本 [16|14|all]
├── device/
│   ├── motorola/zeekr/                       # 安卓16 新版设备树
│   └── motorola/zeekr-14/                    # 老版 (fox_14.1) 设备树
└── README.md
```

每个设备树目录包含：

| 文件 | 作用 |
|------|------|
| `AndroidProducts.mk` / `AndroidProducts14.mk` | lunch 目标声明 |
| `BoardConfig.mk` | 平台/内核/分区/加密/显示配置 |
| `device.mk` | recovery 基础二进制包 |
| `fox_zeekr.mk` / `fox_zeekr14.mk` | OrangeFox 专属配置 |
| `twrp_zeekr.mk` / `twrp_zeekr14.mk` | 产品定义（PRODUCT_NAME 等） |
| `recovery.fstab` | 分区表（**源自 V-3.1 实机提取**） |
| `vendorsetup.sh` | lunch 注入 FOX_* 环境变量 |
| `system.prop` | 最小系统属性 |

---

## 二、方式一：GitHub Actions 云编译（推荐）

1. 把本仓库推送到你的 GitHub：
   ```bash
   git init && git add . && git commit -m "zeekr OrangeFox device trees"
   git remote add origin https://github.com/<你的用户名>/<仓库名>.git
   git push -u origin main
   ```
2. 仓库页面 → **Actions** 页 → 左侧 **Build OrangeFox for zeekr** → **Run workflow** → 选择目标（`both` / `zeekr` / `zeekr14`）→ 运行。
3. 两个 job 并行：`安卓16 新版 OrangeFox (zeekr)` 与 `老版 OrangeFox (fox_14.1)`，每个独立同步约 40-80GB 源码。
4. 完成后在 **Actions 运行页底部**下载 `OrangeFox-zeekr-Android16` / `OrangeFox-zeekr-Legacy14` 两个 artifact。

> 首次同步源码耗时很长（1-2 小时），请耐心等待；`timeout-minutes` 已设为 6 小时。

---

## 三、方式二：本地 Linux 编译

环境：Ubuntu 22.04 / 24.04 x86_64，≥16GB RAM（建议 32GB），≥300GB 磁盘。

```bash
# 1. 安装依赖
sudo apt update
sudo apt install -y bc bison build-essential ccache curl flex g++-multilib \
  gcc-multilib git gnupg gperf imagemagick lib32ncurses-dev lib32readline-dev \
  lib32z1-dev liblz4-tool libncurses5-dev libsdl1.2-dev libssl-dev libxml2 \
  libxml2-utils lzop pngcrush rsync schedtool squashfs-tools xsltproc zip \
  zlib1g-dev python3 python3-pip openjdk-17-jdk repo

# 2. 一键编译（三选一）
bash build_zeekr_ofox.sh 16     # 安卓16 新版
bash build_zeekr_ofox.sh 14     # 老版 V-3.1 世代
bash build_zeekr_ofox.sh all    # 两个都编译
```

产物：`~/OrangeFox_16/fox/out/target/product/zeekr/` 与 `~/OrangeFox_14/fox/out/target/product/zeekr/` 下的 `OrangeFox-*.zip` 与 `recovery.img`。

> 若 `lunch` 找不到目标，尝试 `breakfast zeekr` 或改带版本标签的组合（如 `twrp_zeekr-bp2a-eng`）。

---

## 四、刷入

```bash
fastboot flash recovery out/target/product/zeekr/recovery.img
fastboot reboot recovery
# 进入 OrangeFox 后，再“刷入当前 OrangeFox”以固化
```

> ⚠️ 需解锁 bootloader。回锁/AVB 设备需移植原厂 vbmeta 再刷；操作前备份 `boot` / `vendor_boot` / `recovery` / `vbmeta`。

---

## 五、V-3.1 逆向依据（老版设备树参数来源）

从 `Orangefox-V-3.1(zeekr).zip` 的 `ramdisk-recovery.cpio` 提取的关键事实：

| 项目 | 实机值 |
|------|--------|
| 代码基 | `FOX_CODE_BASE=2024-01-29 (8932c8b1)` → 对应 fox_14.1 时代 |
| 构建日期 | `Fri 09 Feb 2024` |
| 分区 | A/B + 动态分区（super），独立 recovery 分区 |
| /data | f2fs，FBE `aes-256-xts` + metadata 加密（`wrappedkey_v0`） |
| 屏幕密度 | `ro.sf.lcd_density=420` |
| 屏幕 | 外屏 1056×1066（Razr 40 Ultra 外屏） |
| fstab | 完整分区表见 `recovery.fstab`（boot/dtbo/vendor_boot/vbmeta*/recovery/logo/misc/system*/vendor*/metadata/固件等） |

---

## 六、常见需调整项（首编必查）

1. **内核 defconfig**：`BoardConfig.mk` 中 `TARGET_KERNEL_CONFIG := vendor/ext_config/moto-waipio-zeekr.config` 为猜测值，需按 `kernel/motorola/sm8475/arch/arm64/configs/` 实际路径修正；必要时拆成 `基础defconfig 片段.config` 两段。
2. **亮度节点**：`TW_BRIGHTNESS_PATH` 需按实机 `/sys/class/backlight/*` 调整。
3. **Recovery UI**：两套树均用 TWRP 默认 UI；若自定义，在 `recovery_ui/` 实现后取消 `device.mk` 中相关注释。
4. **FOX 屏幕参数**：`OF_SCREEN_W/H` 等为参考值，按显示效果微调。
5. **super 大小**：`9487515648` 取自 zeekr LOS 参数，若固件不同需同步修改 `BoardConfig.mk` 与 `fox_*.mk` 的 `OF_DYNAMIC_FULL_SIZE`。
6. **老版宏兼容**：`fox_14.1` 代码基不含安卓16 时代的新宏（如 KSU），已在 `zeekr-14/vendorsetup.sh` 中移除；若编译报未知宏错误，同样处理。

---

## 七、参考资源

- OrangeFox 官方构建文档：https://wiki.orangefox.tech/en/dev/building
- OrangeFox 同步仓库：https://gitlab.com/OrangeFox/sync （分支 14.1 / 12.1）
- OrangeFox 16 同步仓库：https://github.com/OrangeFox16/sync （分支 16.0）
- zeekr 内核：https://github.com/LineageOS/android_kernel_motorola_sm8475 （lineage-21 / lineage-23.2）
- zeekr LineageOS 23 设备树：https://github.com/AmeChanRain/device_motorola_zeekr

---

## 八、风险

自定义 recovery 有变砖风险，需解锁 bootloader。操作前备份原厂分区，并确认已解锁。作者不对任何设备损坏负责。
