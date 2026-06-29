#!/bin/bash
# ONE 一键安装脚本
# 用法: curl -sL https://raw.githubusercontent.com/whoishzp/one-app/main/install.sh | bash
set -e

APP_NAME="ONE"
INSTALL_DIR="/Applications"
REPO="whoishzp/one-app"
TMP_DMG="/tmp/ONE-install.dmg"
VOLUME_NAME=""

echo "🚀 正在安装 ${APP_NAME}..."

# 获取最新版本下载地址
echo "▶ 查找最新版本..."
DOWNLOAD_URL=$(curl -sL "https://api.github.com/repos/${REPO}/releases/latest" \
  | grep "browser_download_url.*\.dmg" \
  | head -1 \
  | cut -d '"' -f 4)

if [ -z "${DOWNLOAD_URL}" ]; then
  echo "❌ 无法获取下载地址，请检查网络连接"
  exit 1
fi

VERSION=$(echo "${DOWNLOAD_URL}" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
echo "  最新版本: v${VERSION}"

# 下载
echo "▶ 下载中..."
curl -sL "${DOWNLOAD_URL}" -o "${TMP_DMG}"

# 挂载 DMG
echo "▶ 挂载安装包..."
MOUNT_OUTPUT=$(hdiutil attach "${TMP_DMG}" -nobrowse -quiet 2>&1)
VOLUME_PATH=$(echo "${MOUNT_OUTPUT}" | grep "/Volumes/" | awk -F'\t' '{print $NF}' | head -1)

if [ -z "${VOLUME_PATH}" ]; then
  VOLUME_PATH=$(ls -d /Volumes/ONE* 2>/dev/null | head -1)
fi

if [ -z "${VOLUME_PATH}" ] || [ ! -d "${VOLUME_PATH}/${APP_NAME}.app" ]; then
  echo "❌ 挂载失败或未找到 ${APP_NAME}.app"
  hdiutil detach "${VOLUME_PATH}" -quiet 2>/dev/null || true
  rm -f "${TMP_DMG}"
  exit 1
fi

# 关闭正在运行的 ONE
if pgrep -x "${APP_NAME}" > /dev/null 2>&1; then
  echo "▶ 关闭正在运行的 ${APP_NAME}..."
  killall "${APP_NAME}" 2>/dev/null || true
  sleep 1
fi

# 安装
echo "▶ 安装到 ${INSTALL_DIR}..."
rm -rf "${INSTALL_DIR}/${APP_NAME}.app"
cp -R "${VOLUME_PATH}/${APP_NAME}.app" "${INSTALL_DIR}/${APP_NAME}.app"

# 去除隔离属性
echo "▶ 去除安全限制..."
xattr -cr "${INSTALL_DIR}/${APP_NAME}.app" 2>/dev/null || true

# 清理
echo "▶ 清理临时文件..."
hdiutil detach "${VOLUME_PATH}" -quiet 2>/dev/null || true
rm -f "${TMP_DMG}"

echo ""
echo "✅ ${APP_NAME} v${VERSION} 安装完成！"
echo ""

# 启动（curl | bash 时 stdin 非终端，跳过交互直接启动）
if [ -t 0 ]; then
  read -p "是否立即启动 ${APP_NAME}？[Y/n] " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Nn]$ ]]; then
    open "${INSTALL_DIR}/${APP_NAME}.app"
  fi
else
  echo "▶ 正在启动 ${APP_NAME}..."
  open "${INSTALL_DIR}/${APP_NAME}.app"
fi
