#!/bin/bash
set -x

# 1. Megkeressük az MT7621 órajel-beállító fájlt (arch/mips/rt2880/init.c)
INIT_FILE=$(find . -path "*/arch/mips/rt2880/init.c" | head -n 1)
if [ -n "$INIT_FILE" ]; then
    echo "Talált init.c fájl: $INIT_FILE"
    grep -n -C 15 "880" "$INIT_FILE" || true
    
    # Csak a 880 MHz (0x2C -> 44*20=880) és 900 MHz (0x2D -> 45*20=900) szorzót írjuk át 0x32-re (50*20=1000 MHz)
    sed -i 's/0x2C/0x32/g' "$INIT_FILE"
    sed -i 's/0x2c/0x32/g' "$INIT_FILE"
    sed -i 's/0x2D/0x32/g' "$INIT_FILE"
    sed -i 's/0x2d/0x32/g' "$INIT_FILE"
    sed -i 's/880000000/1000000000/g' "$INIT_FILE"
    sed -i 's/900000000/1000000000/g' "$INIT_FILE"
fi
