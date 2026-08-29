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
echo -e "${C_WHITE} YurOTS 0.9.4f - Script de Compilación para Ubuntu Linux  ${C_RESET}"
echo -e "${C_CYAN}==========================================================${C_RESET}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ARCH=$(uname -m)
echo -e "${C_YELLOW}[1/4]${C_RESET} Detectando arquitectura: ${C_WHITE}$ARCH${C_RESET}..."

echo -e "${C_YELLOW}[2/4]${C_RESET} Verificando dependencias del sistema..."
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

echo -e "${C_YELLOW}[3/4]${C_RESET} Verificando biblioteca Lua 5.0.3..."
if [ ! -f "/usr/local/lib/liblua.a" ] || [ ! -f "/usr/local/include/lua.h" ]; then
    echo -e "      ${C_BLUE}--> Compilando Lua 5.0.3 desde código fuente...${C_RESET}"
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
    echo -e "      ${C_GREEN}[OK] Lua 5.0.3 instalado con éxito en /usr/local.${C_RESET}"
else
    echo -e "      ${C_GREEN}[OK] Lua 5.0.3 ya está instalado en el sistema.${C_RESET}"
fi

# Navegar a la carpeta source del servidor
cd "$SCRIPT_DIR/source"

echo -e "${C_YELLOW}[4/4]${C_RESET} Compilando módulos de YurOTS..."
make clean
make -j"$(nproc)"

if [ -f "$SCRIPT_DIR/yurots" ]; then
    chmod +x "$SCRIPT_DIR/yurots"
    echo -e "${C_GREEN}==========================================================${C_RESET}"
    echo -e "${C_GREEN} [OK] ¡Compilación exitosa! Binario: ${C_WHITE}$SCRIPT_DIR/yurots${C_RESET}"
    echo -e " Para iniciar el servidor:"
    echo -e "   ${C_CYAN}cd $SCRIPT_DIR${C_RESET}"
    echo -e "   ${C_CYAN}./yurots${C_RESET}"
    echo -e "${C_GREEN}==========================================================${C_RESET}"
else
    echo -e "\033[1;31m==========================================================\033[0m"
    echo -e "\033[1;31m [ERROR] Falló la compilación del binario.\033[0m"
    echo -e "\033[1;31m==========================================================\033[0m"
    exit 1
fi
