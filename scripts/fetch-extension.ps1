#!/usr/bin/env pwsh
# ============================================================
#  重新下载并解包 Playwright Chrome 扩展 (官方商店版)
#  用法: powershell -ExecutionPolicy Bypass -File fetch-extension.ps1
#  输出: 本包目录下 extension/  (可直接"加载已解压的扩展程序")
# ============================================================
$ErrorActionPreference = 'Stop'
$PackageDir = Split-Path -Parent $MyInvocation.MyCommand.Path | Split-Path -Parent
$ExtId = 'mmlmfjhmonkocbjadbfplnigmagldckm'   # Playwright Extension 商店 ID
$CrxUrl = "https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=122.0.0.0&x=id%3D$ExtId%26installsource%3Dondemand%26uc"

Write-Host '下载 Playwright Extension (Chrome Web Store)...'
$crx = Join-Path $PackageDir 'pw-ext.crx'
Invoke-WebRequest -Uri $CrxUrl -OutFile $crx -TimeoutSec 90 -UseBasicParsing

$bytes = [System.IO.File]::ReadAllBytes($crx)
$magic = [System.Text.Encoding]::ASCII.GetString($bytes[0..3])
if ($magic -ne 'Cr24') { throw "非 CRX 文件: $magic" }
$headerSize = [BitConverter]::ToUInt32($bytes, 8)
$zipOffset = 12 + $headerSize
Write-Host "CRX 有效 (header=$headerSize, zip@$zipOffset)"

$zip = Join-Path $PackageDir 'pw-ext.zip'
[System.IO.File]::WriteAllBytes($zip, $bytes[$zipOffset..($bytes.Length - 1)])

$extDir = Join-Path $PackageDir 'extension'
if (Test-Path $extDir) { Remove-Item $extDir -Recurse -Force }
New-Item -ItemType Directory -Path $extDir | Out-Null
Expand-Archive -Path $zip -DestinationPath $extDir -Force

Remove-Item $crx, $zip -ErrorAction SilentlyContinue
$ver = (Get-Content (Join-Path $extDir 'manifest.json') | Select-String '"version"' | Select-Object -First 1).ToString().Trim()
Write-Host "完成: extension/ ($ver)"
Write-Host "下一步: chrome://extensions -> 开发者模式 -> 加载已解压的扩展程序 -> 选择 $extDir"
