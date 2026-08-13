#!/usr/bin/env pwsh
# ============================================================
#  一键配置 VS Code 的 MCP (playwright-extension)
#  1. 备份现有 %APPDATA%\Code\User\mcp.json
#  2. 合并 playwright-extension 服务器条目
#  3. 提示填入 PLAYWRIGHT_MCP_EXTENSION_TOKEN (可选)
# ============================================================
$ErrorActionPreference = 'Stop'
$PackageDir = Split-Path -Parent $MyInvocation.MyCommand.Path | Split-Path -Parent
$McpPath = Join-Path $env:APPDATA 'Code\User\mcp.json'

if (-not (Test-Path $McpPath)) {
    New-Item -ItemType Directory -Path (Split-Path $McpPath) -Force | Out-Null
    $mcp = [pscustomobject]@{ servers = [pscustomobject]@{} }
} else {
    $mcp = Get-Content $McpPath -Raw | ConvertFrom-Json
    if ($null -eq $mcp.servers) {
        $mcp | Add-Member -NotePropertyName 'servers' -NotePropertyValue ([pscustomobject]@{}) -Force
    }
    # 备份
    $backup = "$McpPath.bak-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
    Copy-Item $McpPath $backup
    Write-Host "已备份旧配置: $backup"
}

$token = Read-Host "输入扩展状态页的 PLAYWRIGHT_MCP_EXTENSION_TOKEN (可留空跳过，连接时手动批准)"
$envBlock = @{}
if ($token) { $envBlock['PLAYWRIGHT_MCP_EXTENSION_TOKEN'] = $token }

$server = [pscustomobject]@{
    command = Join-Path $PackageDir 'mcp.cmd'
    args    = @('--extension')
    env     = $envBlock
    type    = 'stdio'
}
$mcp.servers | Add-Member -NotePropertyName 'playwright-extension' -NotePropertyValue $server -Force

$mcp | ConvertTo-Json -Depth 10 | Set-Content $McpPath -Encoding UTF8
Write-Host "已写入 MCP 配置: $McpPath"
Write-Host "请在 VS Code 中执行 'MCP: 重新加载服务器' (或重启 VS Code) 生效。"
