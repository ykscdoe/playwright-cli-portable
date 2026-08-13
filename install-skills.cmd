@echo off
setlocal
:: ============================================================
::  将 playwright-cli 技能安装到当前项目的 .claude/skills
::  用法: 在项目根目录运行 install-skills.cmd
::  该脚本路径需指向本包: %~dp0
:: ============================================================

echo 正在安装 playwright-cli 技能到当前目录的 .claude/skills ...
call "%~dp0playwright-cli.cmd" install --skills
echo.
echo 完成。技能已安装到: %CD%\.claude\skills\playwright-cli
echo 若使用 VS Code / Agents，可运行: %~dp0playwright-cli.cmd install --skills=agents
pause
