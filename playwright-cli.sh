#!/usr/bin/env bash
# ============================================================
#  playwright-cli 启动器 (Linux / macOS)
#  用法: ./playwright-cli.sh <参数>   或加入 PATH 后直接 playwright-cli
# ============================================================
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CLI_JS="$SCRIPT_DIR/node_modules/@playwright/cli/playwright-cli.js"

# 指向包内浏览器支持二进制 (ffmpeg/winldd)，离线免下载
export PLAYWRIGHT_BROWSERS_PATH="$SCRIPT_DIR/browsers"

# 禁用更新检查 (离线环境避免联网请求)
export NO_UPDATE_NOTIFIER=1

NODE="$(command -v node || true)"
if [ -z "$NODE" ]; then
    echo "[错误] 未找到 Node.js，请安装 Node.js 18+ (https://nodejs.org)"
    exit 1
fi

exec "$NODE" "$CLI_JS" "$@"
