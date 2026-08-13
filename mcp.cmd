@echo off
setlocal
rem ============================================================
rem  @playwright/mcp 服务器启动器 (Windows cmd)
rem  供 VS Code mcp.json 使用：
rem    { "command": "C:\\...\\playwright-cli-portable\\mcp.cmd", "args": ["--extension"] }
rem ============================================================

set "SCRIPT_DIR=%~dp0"
set "MCP_JS=%SCRIPT_DIR%node_modules\@playwright\mcp\cli.js"

rem 指向包内浏览器支持二进制 (ffmpeg/winldd)，离线免下载
set "PLAYWRIGHT_BROWSERS_PATH=%SCRIPT_DIR%browsers"

rem 禁用更新检查 (离线环境避免联网请求)
set "NO_UPDATE_NOTIFIER=1"

rem 查找 node
set "NODE="
for /f "delims=" %%i in ('where node 2^>nul') do (
    if not defined NODE set "NODE=%%i"
)
if not defined NODE (
    echo [错误] 未找到 Node.js，请安装 Node.js 18+ 详见 https://nodejs.org
    exit /b 1
)

"%NODE%" "%MCP_JS%" %*
exit /b %errorlevel%
