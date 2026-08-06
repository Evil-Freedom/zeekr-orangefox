#!/usr/bin/env bash
#
# zeekr OrangeFox 一键编译（本地 Linux）—— 支持双版本
#
# 用法:
#   bash build_zeekr_ofox.sh [16|14|all]
#     16   = 安卓16 新版 (fox_16.0, 默认)
#     14   = 老版复刻 (fox_14.1, V-3.1 世代)
#     all  = 两个都编译
#
set -e

TARGET="${1:-16}"
KERNEL_REPO="https://github.com/LineageOS/android_kernel_motorola_sm8475.git"
KERNEL_DIR="kernel/motorola/sm8475"
DEVICE_TREE_SRC="$(cd "$(dirname "$0")" && pwd)/device"

build_one() {
  local BRANCH="$1"      # 16.0 | 14.1
  local WORK="$2"        # 工作目录
  local DEVICE_DIR="$3"  # device 子目录名 (zeekr | zeekr-14)
  local KERNEL_BR="$4"   # lineage-23.2 | lineage-21
  local LUNCH="$5"       # twrp_zeekr | twrp_zeekr14
  local SYNC_REPO="${6:-https://gitlab.com/OrangeFox/sync.git}"  # 16.0 必须传 GitHub 源

  echo "=================================================="
  echo " [zeekr] OrangeFox $BRANCH 编译开始"
  echo " 工作目录: $WORK  同步源: $SYNC_REPO"
  echo "=================================================="

  mkdir -p "$WORK"
  if [ ! -d "$WORK/sync/.git" ]; then
    git clone "$SYNC_REPO" "$WORK/sync"
  fi
  cd "$WORK/sync"
  ./orangefox_sync.sh --branch "$BRANCH" --path "$WORK/fox"

  cd "$WORK/fox"
  test -f build/envsetup.sh || { echo "❌ build/envsetup.sh 不存在，源码同步失败"; ls -la "$WORK/fox" | head -30; exit 1; }
  if [ ! -d "$KERNEL_DIR" ]; then
    mkdir -p kernel/motorola
    git clone --depth=1 --branch "$KERNEL_BR" "$KERNEL_REPO" "$KERNEL_DIR"
  fi

  rm -rf "device/motorola/$DEVICE_DIR"
  mkdir -p device/motorola
  cp -r "$DEVICE_TREE_SRC/motorola/$DEVICE_DIR" "device/motorola/$DEVICE_DIR"

  source build/envsetup.sh
  lunch "${LUNCH}-eng"
  mka recoveryimage

  echo "=================================================="
  echo " [zeekr] OrangeFox $BRANCH 编译完成"
  echo " 产物: $WORK/fox/out/target/product/zeekr/"
  echo "=================================================="
}

case "$TARGET" in
  # 注意：16.0 分支的同步源是 GitHub 的 OrangeFox16/sync；14.1 是 GitLab 的 OrangeFox/sync
  16)   build_one "16.0" "$HOME/OrangeFox_16"  "zeekr"    "lineage-23.2" "twrp_zeekr"   "https://github.com/OrangeFox16/sync.git" ;;
  14)   build_one "14.1" "$HOME/OrangeFox_14"  "zeekr-14" "lineage-21"   "twrp_zeekr14" "https://gitlab.com/OrangeFox/sync.git" ;;
  all)  build_one "16.0" "$HOME/OrangeFox_16"  "zeekr"    "lineage-23.2" "twrp_zeekr"   "https://github.com/OrangeFox16/sync.git"
        build_one "14.1" "$HOME/OrangeFox_14"  "zeekr-14" "lineage-21"   "twrp_zeekr14" "https://gitlab.com/OrangeFox/sync.git" ;;
  *)    echo "用法: bash $0 [16|14|all]"; exit 1 ;;
esac
