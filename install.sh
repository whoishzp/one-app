#!/bin/bash
# ONE 一键安装脚本
# 用法: curl -sL https://raw.githubusercontent.com/whoishzp/one-app/main/install.sh | bash
set -e

APP_NAME="ONE"
INSTALL_DIR="/Applications"
REPO="whoishzp/one-app"
TMP_DMG="/tmp/ONE-install.dmg"
API_RESP="/tmp/ONE-api-resp.json"
API_HEADERS="/tmp/ONE-api-headers.txt"

echo "🚀 正在安装 ${APP_NAME}..."

# 获取最新版本下载地址
echo "▶ 查找最新版本..."
HTTP_CODE=$(curl -sL -w '%{http_code}' \
  -D "${API_HEADERS}" \
  -o "${API_RESP}" \
  "https://api.github.com/repos/${REPO}/releases/latest" 2>/dev/null || echo "000")

if [ "${HTTP_CODE}" = "000" ]; then
  echo "❌ 网络连接失败，无法访问 GitHub API"
  echo "   请检查网络连接后重试"
  rm -f "${API_RESP}" "${API_HEADERS}"
  exit 1
fi

if [ "${HTTP_CODE}" = "403" ] || [ "${HTTP_CODE}" = "429" ]; then
  echo "❌ GitHub API 限流（HTTP ${HTTP_CODE}）"
  echo ""
  # 提取限流信息
  LIMIT=$(grep -i 'x-ratelimit-limit:' "${API_HEADERS}" 2>/dev/null | tr -d '\r' | awk '{print $2}')
  REMAINING=$(grep -i 'x-ratelimit-remaining:' "${API_HEADERS}" 2>/dev/null | tr -d '\r' | awk '{print $2}')
  RESET=$(grep -i 'x-ratelimit-reset:' "${API_HEADERS}" 2>/dev/null | tr -d '\r' | awk '{print $2}')
  MSG=$(grep -o '"message":"[^"]*"' "${API_RESP}" 2>/dev/null | head -1 | cut -d'"' -f4)

  [ -n "${LIMIT}" ] && echo "   Rate Limit:     ${REMAINING:-0} / ${LIMIT}"
  if [ -n "${RESET}" ]; then
    if command -v date >/dev/null 2>&1; then
      RESET_TIME=$(date -r "${RESET}" '+%H:%M:%S' 2>/dev/null || date -d "@${RESET}" '+%H:%M:%S' 2>/dev/null || echo "")
      if [ -n "${RESET_TIME}" ]; then
        echo "   限额重置时间:  ${RESET_TIME}"
      else
        echo "   限额重置时间:  unix ${RESET}"
      fi
    fi
  fi
  [ -n "${MSG}" ] && echo "   错误信息:       ${MSG}"
  echo ""
  echo "💡 解决方法："
  echo "   1. 等几分钟后重试"
  echo "   2. 直接下载 ZIP 安装包："
  echo "      https://github.com/${REPO}/releases/latest"
  rm -f "${API_RESP}" "${API_HEADERS}"
  exit 1
fi

if [ "${HTTP_CODE}" != "200" ]; then
  echo "❌ GitHub API 请求失败（HTTP ${HTTP_CODE}）"
  MSG=$(grep -o '"message":"[^"]*"' "${API_RESP}" 2>/dev/null | head -1 | cut -d'"' -f4)
  [ -n "${MSG}" ] && echo "   错误信息: ${MSG}"
  echo ""
  echo "   响应摘要:"
  head -c 500 "${API_RESP}" 2>/dev/null | head -5
  echo ""
  echo "💡 请稍后重试，或直接下载："
  echo "   https://github.com/${REPO}/releases/latest"
  rm -f "${API_RESP}" "${API_HEADERS}"
  exit 1
fi

# 200 OK — 解析 DMG 下载链接
DOWNLOAD_URL=$(grep "browser_download_url.*\.dmg" "${API_RESP}" | head -1 | cut -d '"' -f 4)

if [ -z "${DOWNLOAD_URL}" ]; then
  echo "❌ 未找到 DMG 安装包（API 正常但 Release 中无 .dmg 文件）"
  TAG=$(grep -o '"tag_name":"[^"]*"' "${API_RESP}" 2>/dev/null | head -1 | cut -d'"' -f4)
  [ -n "${TAG}" ] && echo "   最新 Release: ${TAG}"
  echo ""
  echo "💡 请前往 Releases 页面手动下载："
  echo "   https://github.com/${REPO}/releases/latest"
  rm -f "${API_RESP}" "${API_HEADERS}"
  exit 1
fi

rm -f "${API_RESP}" "${API_HEADERS}"

VERSION=$(echo "${DOWNLOAD_URL}" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
echo "  最新版本: v${VERSION}"

# 下载
echo "▶ 下载中（${DOWNLOAD_URL##*/}）..."
curl -L --progress-bar "${DOWNLOAD_URL}" -o "${TMP_DMG}"
echo ""

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
