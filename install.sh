#!/usr/bin/env bash
# ============================================================
#  playwright-cli-portable 便携安装脚本 (Linux / macOS)
#  用法: bash install.sh [目标目录]
# ============================================================
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
INSTALL_DIR="${1:-$HOME/playwright-cli-portable}"

echo ""
echo "=============================================="
echo "  Playwright 便携版安装程序 (CLI + MCP + 扩展)"
echo "=============================================="
echo ""
echo "安装目录: $INSTALL_DIR"

# 检测 Node.js
NODE=""
for cmd in node nodejs; do
    if command -v "$cmd" &>/dev/null; then
        NODE="$(command -v "$cmd")"
        break
    fi
done
if [ -z "$NODE" ]; then
    echo "[错误] 未找到 Node.js。请先安装 Node.js 18+。"
    exit 1
fi
echo "Node.js: $NODE"
"$NODE" --version

# 创建目标目录并复制
mkdir -p "$INSTALL_DIR"
echo ""
echo "正在复制文件..."
cp -r "$SCRIPT_DIR"/. "$INSTALL_DIR"/
echo "文件复制完成。"

# 给启动器加可执行权限
chmod +x "$INSTALL_DIR"/playwright-cli.sh "$INSTALL_DIR"/mcp.sh

# 链接到 /usr/local/bin (可选)
echo ""
read -p "是否将 playwright-cli 链接到 /usr/local/bin? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if [ -w /usr/local/bin ]; then
        ln -sf "$INSTALL_DIR/playwright-cli.sh" /usr/local/bin/playwright-cli
        echo "已链接到 /usr/local/bin/playwright-cli"
    else
        sudo ln -sf "$INSTALL_DIR/playwright-cli.sh" /usr/local/bin/playwright-cli
        echo "已链接到 /usr/local/bin/playwright-cli"
    fi
fi

echo ""
echo "=============================================="
echo "  安装完成!"
echo "=============================================="
echo ""
echo "使用方法:"
echo "  $INSTALL_DIR/playwright-cli.sh --help"
echo "  $INSTALL_DIR/mcp.sh --extension     (MCP 服务器)"
echo ""
echo "在项目目录安装技能:"
echo "  cd 你的项目目录 && bash $INSTALL_DIR/install-skills.sh"
echo ""
echo "Chrome 扩展: 打开 chrome://extensions -> 开发者模式 -> 加载已解压的扩展程序"
echo "  选择目录: $INSTALL_DIR/extension"
