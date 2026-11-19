#!/bin/bash
set -x

INIT_FILE="padavan-ng/trunk/linux-3.4.x/arch/mips/rt2880/init.c"
if [ -f "$INIT_FILE" ]; then
    # Kiírjuk a naplóba az órajel-számítás körüli sorokat
    grep -n -C 10 "CPU/OCP/SYS" "$INIT_FILE" || true
    
    # Csak a konkrét órajel-értékeket (880000000 / 900000000) írjuk át 1000000000-re (1000 MHz),
    # és a PLL szorzó maszkot csak ott módosítjuk, ahol a regiszterbit-eltolás (<< 4) szerepel!
    sed -i 's/880000000/1000000000/g' "$INIT_FILE"
    sed -i 's/900000000/1000000000/g' "$INIT_FILE"
    sed -i 's/(0x2C << 4)/(0x32 << 4)/g' "$INIT_FILE"
    sed -i 's/(0x2c << 4)/(0x32 << 4)/g' "$INIT_FILE"
    sed -i 's/(0x2D << 4)/(0x32 << 4)/g' "$INIT_FILE"
    sed -i 's/(0x2d << 4)/(0x32 << 4)/g' "$INIT_FILE"
fi
