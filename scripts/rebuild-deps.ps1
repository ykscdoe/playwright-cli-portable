#!/usr/bin/env pwsh
# ============================================================
#  重新打包/更新 vendor 依赖 (开发者用)
#  联网时运行：更新 @playwright/cli 和 @playwright/mcp 到最新
#  用法: powershell -ExecutionPolicy Bypass -File rebuild-deps.ps1
# ============================================================
$ErrorActionPreference = 'Stop'
$PackageDir = Split-Path -Parent $MyInvocation.MyCommand.Path | Split-Path -Parent
Set-Location $PackageDir

Write-Host '更新依赖到最新版本...'
npm install @playwright/cli@latest @playwright/mcp@latest --save --no-audit --no-fund

Write-Host ''
Write-Host '验证版本:'
node node_modules/@playwright/cli/playwright-cli.js --version
Write-Host '依赖更新完成。'
