#!/usr/bin/env pwsh
# ============================================================
#  playwright-cli 启动器 (PowerShell)
# ============================================================
param([Parameter(ValueFromRemainingArguments = $true)][string[]]$Arguments)

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$CliJs = Join-Path $ScriptDir 'node_modules\@playwright\cli\playwright-cli.js'

# 指向包内浏览器支持二进制 (ffmpeg/winldd)，离线免下载
$env:PLAYWRIGHT_BROWSERS_PATH = Join-Path $ScriptDir 'browsers'

# 禁用更新检查 (离线环境避免联网请求)
$env:NO_UPDATE_NOTIFIER = '1'

$node = (Get-Command node -ErrorAction SilentlyContinue).Source
if (-not $node) { Write-Error '未找到 Node.js，请安装 Node.js 18+'; exit 1 }

& $node $CliJs @Arguments
exit $LASTEXITCODE
