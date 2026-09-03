@echo off
setlocal enabledelayedexpansion

:: ==============================================================================
:: YurOTS 0.9.4f - Server Launcher & Auto-Restarter
:: ==============================================================================

chcp 65001 >nul 2>&1
title YurOTS 0.9.4f Server Console

set SCRIPT_DIR=%~dp0
cd /d "%SCRIPT_DIR%"

echo ==========================================================
echo    YurOTS 0.9.4f - Server Launcher (Windows)
echo ==========================================================
echo.

:: 1. Verify executable exists
if not exist "%SCRIPT_DIR%yurots.exe" (
    echo [ERROR] Binary 'yurots.exe' was not found!
    echo Please compile the server first by running:
    echo   build_windows.bat
    echo.
    pause
    exit /b 1
)

:: 2. Verify config.lua exists
if not exist "%SCRIPT_DIR%config.lua" (
    echo [ERROR] Configuration file 'config.lua' was not found in root directory!
    echo.
    pause
    exit /b 1
)

:: 3. Server Execution Loop with Auto-Restarter
:server_loop
echo [%TIME%] Starting YurOTS Server Engine...
echo ==========================================================
echo.

"%SCRIPT_DIR%yurots.exe"

set EXIT_CODE=%ERRORLEVEL%
echo.
echo ==========================================================
echo [%TIME%] Server process terminated with exit code: %EXIT_CODE%
echo ==========================================================
echo.
echo Restarting server in 5 seconds... Press Ctrl+C to stop.
timeout /t 5 /nobreak >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    :: Fallback if timeout command is restricted
    ping 127.0.0.1 -n 6 >nul 2>&1
)

goto server_loop
