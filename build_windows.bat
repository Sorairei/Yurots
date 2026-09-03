@echo off
setlocal enabledelayedexpansion

:: ==============================================================================
:: YurOTS 0.9.4f - Windows Automated Build Script
:: ==============================================================================

chcp 65001 >nul 2>&1
title YurOTS 0.9.4f - Windows Build System

echo ==========================================================
echo    YurOTS 0.9.4f - Automated Windows Build Pipeline
echo ==========================================================
echo.

set SCRIPT_DIR=%~dp0
set MAKE_CMD=

:: 1. Search for g++ in PATH or common installation directories
where g++ >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [*] Checking common MinGW-w64 / MSYS2 installation paths...
    if exist "C:\msys64\mingw64\bin\g++.exe" (
        set "PATH=C:\msys64\mingw64\bin;%PATH%"
        echo [OK] Found MinGW64 in C:\msys64\mingw64\bin
    ) else if exist "C:\msys64\ucrt64\bin\g++.exe" (
        set "PATH=C:\msys64\ucrt64\bin;%PATH%"
        echo [OK] Found UCRT64 in C:\msys64\ucrt64\bin
    ) else if exist "C:\MinGW\bin\g++.exe" (
        set "PATH=C:\MinGW\bin;%PATH%"
        echo [OK] Found MinGW in C:\MinGW\bin
    ) else (
        echo.
        echo [ERROR] No C++ compiler (g++) found in PATH or standard directories.
        echo.
        echo Please install MinGW-w64 via MSYS2 or WinLibs:
        echo   1. Install MSYS2 from https://www.msys2.org/
        echo   2. Open MSYS2 MINGW64 terminal and run:
        echo      pacman -S --needed mingw-w64-x86_64-gcc mingw-w64-x86_64-make mingw-w64-x86_64-boost mingw-w64-x86_64-libxml2
        echo   3. Add C:\msys64\mingw64\bin to your Windows PATH.
        echo.
        pause
        exit /b 1
    )
)

:: 2. Detect Make utility (mingw32-make or make)
where mingw32-make >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    set MAKE_CMD=mingw32-make
) else (
    where make >nul 2>&1
    if %ERRORLEVEL% EQU 0 (
        set MAKE_CMD=make
    ) else (
        echo [ERROR] Neither 'mingw32-make' nor 'make' was found.
        echo Please ensure mingw-w64-make is installed.
        pause
        exit /b 1
    )
)

:: 3. Display environment info
echo [1/3] Build Environment:
for /f "tokens=*" %%v in ('g++ --version ^| findstr /i "g++"') do echo       Compiler: %%v
echo       Make Tool: %MAKE_CMD%
echo       CPU Cores: %NUMBER_OF_PROCESSORS% threads
echo.

:: 4. Navigate and Compile
echo [2/3] Compiling YurOTS modules...
cd /d "%SCRIPT_DIR%source"

%MAKE_CMD% -f Makefile.windows clean
%MAKE_CMD% -f Makefile.windows -j%NUMBER_OF_PROCESSORS%

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ==========================================================
    echo  [ERROR] Compilation failed. Check the error log above.
    echo ==========================================================
    echo If missing headers/libraries (boost, libxml2, lua), install them via:
    echo   pacman -S mingw-w64-x86_64-boost mingw-w64-x86_64-libxml2
    echo.
    cd /d "%SCRIPT_DIR%"
    pause
    exit /b 1
)

:: 5. Verification
cd /d "%SCRIPT_DIR%"
if exist "%SCRIPT_DIR%yurots.exe" (
    echo.
    echo ==========================================================
    echo  [OK] Build successful! Binary: %SCRIPT_DIR%yurots.exe
    echo ==========================================================
    echo.
    echo To start the server, simply run:
    echo   start_windows.bat
    echo.
) else (
    echo [ERROR] Expected binary 'yurots.exe' was not found in root directory.
    pause
    exit /b 1
)

pause
