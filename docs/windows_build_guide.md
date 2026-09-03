# YurOTS 0.9.4f — Windows Build & Setup Guide

This guide provides step-by-step instructions for compiling and running **YurOTS 0.9.4f** on **Microsoft Windows (x86_64)** without affecting Linux environments.

---

## [ Table of Contents ]

1. [Prerequisites & Requirements](#prerequisites--requirements)
2. [Method 1: MinGW-w64 / MSYS2 Pipeline (Recommended)](#method-1-mingw-w64--msys2-pipeline-recommended)
3. [Method 2: CMake & Visual Studio Build](#method-2-cmake--visual-studio-build)
4. [Running the Server (start_windows.bat)](#running-the-server-start_windowsbat)
5. [Windows Firewall & Port Configuration](#windows-firewall--port-configuration)
6. [Troubleshooting & FAQ](#troubleshooting--faq)

---

## [ Prerequisites & Requirements ]

* **Operating System:** Windows 10 or Windows 11 (64-bit recommended)
* **Compiler:** MinGW-w64 GCC (8.x through 14.x) or MSVC (Visual Studio 2019/2022)
* **Required Libraries:**
  * `libxml2` (XML DOM parser for data files)
  * `Boost` (`libboost_regex`, `libboost_system`)
  * `Lua 5.0.3` (Scripting runtime)
  * `WinSock2` (`ws2_32.lib` / `wsock32.lib` — built into Windows)

---

## [ Method 1: MinGW-w64 / MSYS2 Pipeline (Recommended) ]

MSYS2 provides a native, modern MinGW-w64 GCC environment with precompiled packages.

### Step 1: Install MSYS2
* Download and run the installer from [msys2.org](https://www.msys2.org/), or install via Windows Terminal / PowerShell:
  ```powershell
  winget install MSYS2.MSYS2
  ```

### Step 2: Install Compiler & Dependencies
Open the **MSYS2 MINGW64** terminal (located at `C:\msys64\msys2_shell.cmd -mingw64` or in your Start Menu) and run:

```bash
pacman -Syu --needed mingw-w64-x86_64-gcc mingw-w64-x86_64-make mingw-w64-x86_64-boost mingw-w64-x86_64-libxml2
```

### Step 3: Add MinGW64 to Windows PATH (Optional)
To run `build_windows.bat` directly from Windows Command Prompt or by double-clicking:
* Add `C:\msys64\mingw64\bin` to your system `PATH` environment variable.
*(Note: `build_windows.bat` will automatically search and detect `C:\msys64\mingw64\bin` even if not in system PATH).*

### Step 4: Run Automated Build Script
Double-click `build_windows.bat` in the root folder, or execute in Command Prompt:

```cmd
build_windows.bat
```

Alternatively, compile manually from the `source/` folder:
```cmd
cd source
mingw32-make -f Makefile.windows -j4
```

Upon successful compilation, the executable `yurots.exe` will be generated in the root directory.

---

## [ Method 2: CMake & Visual Studio Build ]

If you prefer using CMake or Microsoft Visual Studio:

1. Open a terminal in the root repository folder.
2. Generate the build files:
   ```cmd
   cmake -B build -G "Visual Studio 17 2022" -A x64
   ```
   *(Or for MinGW Makefiles: `cmake -B build -G "MinGW Makefiles"`)*
3. Build the project:
   ```cmd
   cmake --build build --config Release
   ```

---

## [ Running the Server (start_windows.bat) ]

### 1. Configuration
Open [config.lua](file:///e:/Github/Yurots/config.lua) in your text editor (VS Code, Notepad++, etc.) and verify:

```lua
-- Can be numeric IP ("127.0.0.1" / "198.51.100.1") or domain ("your-server.ddns.net")
ip = "127.0.0.1"
port = "7171"
servername = "YurOTS"
```

### 2. Start the Engine
Double-click [start_windows.bat](file:///e:/Github/Yurots/start_windows.bat) or run from terminal:

```cmd
start_windows.bat
```

**Features of `start_windows.bat`:**
* Configures Windows console to UTF-8 (`chcp 65001`).
* Verifies existence of `yurots.exe` and `config.lua` before starting.
* **Auto-Restarter Protection:** If the server shuts down or encounters an unexpected crash, it automatically re-initializes after a 5-second grace period (press `Ctrl+C` to terminate).

---

## [ Windows Firewall & Port Configuration ]

To allow external players to connect to your Windows host:

1. Open **Windows Defender Firewall with Advanced Security**.
2. Click **Inbound Rules** -> **New Rule...**
3. Select **Port** -> **TCP** -> Specific local ports: `7171, 7172`.
4. Choose **Allow the connection** -> Check Domain, Private, and Public.
5. Name the rule `YurOTS Game Server` and click **Finish**.
6. Forward TCP ports **7171** and **7172** on your internet router pointing to your local machine's IPv4 address.

---

## [ Troubleshooting & FAQ ]

| Issue | Cause | Solution |
| :--- | :--- | :--- |
| `'g++' is not recognized` | Compiler is not in PATH. | Install MSYS2 MinGW64 and let `build_windows.bat` detect it, or add `C:\msys64\mingw64\bin` to PATH. |
| `Missing libxml2.dll / libboost...` | Runtime DLLs missing from PATH. | Copy the DLLs from `C:\msys64\mingw64\bin` to the root folder alongside `yurots.exe`, or keep `C:\msys64\mingw64\bin` in PATH. |
| `Unable to create server socket (2)!` | Port 7171 is already in use. | Ensure no other OTServ or application is occupying port 7171. |
| `Cannot find config.lua` | Script run from wrong directory. | Always run `start_windows.bat` from the repository root folder. |
