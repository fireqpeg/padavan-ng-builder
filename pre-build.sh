#!/bin/bash
set -x

# 1. Megkeressük a DIR-860L kernel config fájlját, bárhol is van a mapparendszerben
KCONFIG=$(find . -path "*DIR-860L/kernel*.config" | head -n 1)
if [ -n "$KCONFIG" ]; then
    echo "Talált kernel config: $KCONFIG"
    sed -i 's/CONFIG_RALINK_MT7621_CPU_880MHZ=y/# CONFIG_RALINK_MT7621_CPU_880MHZ is not set/g' "$KCONFIG"
    sed -i 's/CONFIG_RALINK_MT7621_CPU_900MHZ=y/# CONFIG_RALINK_MT7621_CPU_900MHZ is not set/g' "$KCONFIG"
fi

# 2. Megkeressük az MT7621 órajel-beállító fájlt (arch/mips/rt2880/init.c)
INIT_FILE=$(find . -path "*/arch/mips/rt2880/init.c" | head -n 1)
if [ -n "$INIT_FILE" ]; then
    echo "Talált init.c fájl: $INIT_FILE"
    grep -n -C 15 "880" "$INIT_FILE" || true
    # Átírjuk a 880 és 900 MHz-es értékeket és a PLL szorzót 1000 MHz-re
    sed -i 's/880000000/1000000000/g' "$INIT_FILE"
    sed -i 's/900000000/1000000000/g' "$INIT_FILE"
    sed -i 's/0x2B/0x31/g' "$INIT_FILE"
    sed -i 's/0x2C/0x31/g' "$INIT_FILE"
    sed -i 's/0x2b/0x31/g' "$INIT_FILE"
    sed -i 's/0x2c/0x31/g' "$INIT_FILE"
fi
