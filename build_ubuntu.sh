#!/usr/bin/env bash
set -e

# Colores ANSI
C_RESET="\033[0m"
C_CYAN="\033[1;36m"
C_GREEN="\033[1;32m"
C_YELLOW="\033[1;33m"
C_BLUE="\033[1;34m"
C_WHITE="\033[1;37m"

echo -e "${C_CYAN}==========================================================${C_RESET}"
echo -e "${C_WHITE}   YurOTS 0.9.4f - Build Script for Ubuntu Linux          ${C_RESET}"
echo -e "${C_CYAN}==========================================================${C_RESET}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ARCH=$(uname -m)
echo -e "${C_YELLOW}[1/4]${C_RESET} Detecting architecture: ${C_WHITE}$ARCH${C_RESET}..."

echo -e "${C_YELLOW}[2/4]${C_RESET} Verifying system dependencies..."
sudo apt-get update -qq
sudo apt-get install -y -qq \
    build-essential \
    g++ \
    make \
    libxml2-dev \
    libboost-dev \
    libboost-regex-dev \
    libboost-system-dev \
    libboost-thread-dev \
    wget \
    tar > /dev/null

echo -e "${C_YELLOW}[3/4]${C_RESET} Verifying Lua 5.0.3 library..."
if [ ! -f "/usr/local/lib/liblua.a" ] || [ ! -f "/usr/local/include/lua.h" ]; then
    echo -e "      ${C_BLUE}--> Compiling Lua 5.0.3 from source...${C_RESET}"
    TMP_DIR=$(mktemp -d)
    (
        cd "$TMP_DIR"
        wget -q https://www.lua.org/ftp/lua-5.0.3.tar.gz
        tar -zxf lua-5.0.3.tar.gz
        cd lua-5.0.3
        make -s MYCFLAGS="-fPIC -O2"
        sudo mkdir -p /usr/local/include /usr/local/lib
        sudo cp include/*.h /usr/local/include/
        sudo cp lib/liblua.a /usr/local/lib/
        sudo cp lib/liblualib.a /usr/local/lib/
        sudo ldconfig || true
    )
    rm -rf "$TMP_DIR"
    echo -e "      ${C_GREEN}[OK] Lua 5.0.3 successfully installed in /usr/local.${C_RESET}"
else
    echo -e "      ${C_GREEN}[OK] Lua 5.0.3 is already installed on the system.${C_RESET}"
fi

# Navigate to source directory
cd "$SCRIPT_DIR/source"

echo -e "${C_YELLOW}[4/4]${C_RESET} Compiling YurOTS modules..."
make clean
make -j"$(nproc)"

if [ -f "$SCRIPT_DIR/yurots" ]; then
    chmod +x "$SCRIPT_DIR/yurots"
    echo -e "${C_GREEN}==========================================================${C_RESET}"
    echo -e "${C_GREEN} [OK] Build successful! Binary: ${C_WHITE}$SCRIPT_DIR/yurots${C_RESET}"
    echo -e " To start the server:"
    echo -e "   ${C_CYAN}cd $SCRIPT_DIR${C_RESET}"
    echo -e "   ${C_CYAN}./yurots${C_RESET}"
    echo -e "${C_GREEN}==========================================================${C_RESET}"
else
    echo -e "\033[1;31m==========================================================\033[0m"
    echo -e "\033[1;31m [ERROR] Binary compilation failed.\033[0m"
    echo -e "\033[1;31m==========================================================\033[0m"
    exit 1
fi
