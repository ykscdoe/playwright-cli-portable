#!/usr/bin/env bash
# ============================================================
#  将 playwright-cli 技能安装到当前项目的 .claude/skills
#  用法: 在项目根目录运行 bash /path/to/install-skills.sh
# ============================================================
set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "正在安装 playwright-cli 技能到当前目录的 .claude/skills ..."
"$SCRIPT_DIR/playwright-cli.sh" install --skills
echo ""
echo "完成。技能已安装到: $(pwd)/.claude/skills/playwright-cli"
echo "若使用 Agents，可运行: $SCRIPT_DIR/playwright-cli.sh install --skills=agents"
