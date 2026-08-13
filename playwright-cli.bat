@echo off
rem 转发到 playwright-cli.cmd
call "%~dp0playwright-cli.cmd" %*
exit /b %errorlevel%
