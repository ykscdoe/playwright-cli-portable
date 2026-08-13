@echo off
setlocal enabledelayedexpansion

:: ============================================================
::  playwright-cli-portable 便携安装脚本 (Windows)
::  用法: install.cmd [目标目录]
:: ============================================================

set "SCRIPT_DIR=%~dp0"

:: 目标安装目录 (默认 C:\playwright-cli-portable)
if "%~1"=="" (
    set "INSTALL_DIR=C:\playwright-cli-portable"
) else (
    set "INSTALL_DIR=%~1"
)

echo.
echo ==============================================
echo   Playwright 便携版安装程序 (CLI + MCP + 扩展)
echo ==============================================
echo.
echo 安装目录: %INSTALL_DIR%
echo.

:: 检测 Node.js
set "NODE="
for /f "delims=" %%i in ('where node 2^>nul') do (
    if "!NODE!"=="" set "NODE=%%i"
)
if "%NODE%"=="" (
    echo [错误] 未找到 Node.js。请先安装 Node.js 18+。
    echo 下载地址: https://nodejs.org/
    pause
    exit /b 1
)
echo Node.js: %NODE%
"%NODE%" --version

:: 创建目标目录
if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"

:: 复制整个包 (含 node_modules, extension, skills, rules)
echo.
echo 正在复制文件...
xcopy /E /I /Y /Q "%SCRIPT_DIR%*" "%INSTALL_DIR%\" >nul 2>&1
if errorlevel 1 (
    echo [错误] 复制失败，请以管理员身份运行。
    pause
    exit /b 1
)
echo 文件复制完成。

:: 添加到 PATH (可选)
echo.
set /p ADD_PATH="是否将包目录添加到系统 PATH? (y/n): "
if /i "%ADD_PATH%"=="y" (
    setx PATH "%INSTALL_DIR%;%PATH%" >nul 2>&1
    if errorlevel 1 (
        echo [警告] 添加 PATH 失败，请以管理员身份运行。
    ) else (
        echo 已添加到 PATH (新终端窗口生效)。
    )
)

echo.
echo ==============================================
echo   安装完成!
echo ==============================================
echo.
echo 使用方法:
echo   %INSTALL_DIR%\playwright-cli.cmd --help
echo   %INSTALL_DIR%\mcp.cmd --extension        (MCP 服务器)
echo.
echo 在项目目录安装技能:
echo   cd 你的项目目录
echo   %INSTALL_DIR%\install-skills.cmd
echo.
echo Chrome 扩展: 打开 chrome://extensions -> 开发者模式 -> 加载已解压的扩展程序
echo   选择目录: %INSTALL_DIR%\extension
echo.
pause
