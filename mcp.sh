#!/usr/bin/env bash
# ============================================================
#  @playwright/mcp 服务器启动器 (Linux / macOS)
#  供 MCP 客户端 (Claude Code 等) 使用：
#    { "command": "/path/to/playwright-cli-portable/mcp.sh", "args": ["--extension"] }
# ============================================================
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
MCP_JS="$SCRIPT_DIR/node_modules/@playwright/mcp/cli.js"

# 指向包内浏览器支持二进制 (ffmpeg/winldd)，离线免下载
export PLAYWRIGHT_BROWSERS_PATH="$SCRIPT_DIR/browsers"

# 禁用更新检查 (离线环境避免联网请求)
export NO_UPDATE_NOTIFIER=1

NODE="$(command -v node || true)"
if [ -z "$NODE" ]; then
    echo "[错误] 未找到 Node.js，请安装 Node.js 18+ (https://nodejs.org)"
    exit 1
fi

exec "$NODE" "$MCP_JS" "$@"
