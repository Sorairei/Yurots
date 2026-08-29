#!/usr/bin/env bash
set -e

echo "=========================================================="
echo " YurOTS 0.9.4f - Script de Compilación para Ubuntu Linux  "
echo "=========================================================="

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ARCH=$(uname -m)
echo "[1/4] Detectando arquitectura: $ARCH..."

echo "[2/4] Instalando dependencias del sistema..."
sudo apt-get update -qq
sudo apt-get install -y \
    build-essential \
    g++ \
    make \
    libxml2-dev \
    libboost-dev \
    libboost-regex-dev \
    libboost-system-dev \
    libboost-thread-dev \
    wget \
    tar

echo "[3/4] Verificando e instalando biblioteca Lua 5.0.3..."
if [ ! -f "/usr/local/lib/liblua.a" ] || [ ! -f "/usr/local/include/lua.h" ]; then
    echo "Compilando Lua 5.0.3 desde código fuente..."
    TMP_DIR=$(mktemp -d)
    (
        cd "$TMP_DIR"
        wget -q https://www.lua.org/ftp/lua-5.0.3.tar.gz
        tar -zxf lua-5.0.3.tar.gz
        cd lua-5.0.3
        make MYCFLAGS="-fPIC -O2"
        sudo mkdir -p /usr/local/include /usr/local/lib
        sudo cp include/*.h /usr/local/include/
        sudo cp lib/liblua.a /usr/local/lib/
        sudo cp lib/liblualib.a /usr/local/lib/
        sudo ldconfig || true
    )
    rm -rf "$TMP_DIR"
    echo "Lua 5.0.3 instalado con éxito en /usr/local."
else
    echo "Lua 5.0.3 ya está instalado en el sistema."
fi

# Navegar a la carpeta source del servidor
cd "$SCRIPT_DIR/source"

echo "[4/4] Compilando YurOTS..."
make clean
make -j"$(nproc)"

if [ -f "$SCRIPT_DIR/yurots" ]; then
    chmod +x "$SCRIPT_DIR/yurots"
    echo "=========================================================="
    echo " [OK] ¡Compilación exitosa! Binario: $SCRIPT_DIR/yurots"
    echo " Para iniciar el servidor:"
    echo "   cd $SCRIPT_DIR"
    echo "   ./yurots"
    echo "=========================================================="
else
    echo "=========================================================="
    echo " [ERROR] Falló la compilación del binario."
    echo "=========================================================="
    exit 1
fi
