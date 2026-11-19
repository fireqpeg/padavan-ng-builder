#!/bin/bash

# Kernel config módosítása a DIR-860L-hez (900MHz/880MHz kikapcsolása, ha van)
KCONFIG="padavan-ng/trunk/configs/boards/DLINK/DIR-860L/kernel-3.4.x.config"
if [ -f "$KCONFIG" ]; then
    sed -i 's/CONFIG_RALINK_MT7621_CPU_880MHZ=y/# CONFIG_RALINK_MT7621_CPU_880MHZ is not set/g' "$KCONFIG"
    sed -i 's/CONFIG_RALINK_MT7621_CPU_900MHZ=y/# CONFIG_RALINK_MT7621_CPU_900MHZ is not set/g' "$KCONFIG"
fi

# MT7621 órajel-szorzó (PLL) átírása 880/900 MHz-ről 1000 MHz-re a kernel forráskódjában
INIT_FILE="padavan-ng/trunk/linux-3.4.x/arch/mips/rt2880/init.c"
if [ -f "$INIT_FILE" ]; then
    # Ha van 900MHz-es opció, azt is 1000-re húzzuk, és az alap 880-at is 1000-re állítjuk
    sed -i 's/cpu_clock = 880000000;/cpu_clock = 1000000000;/g' "$INIT_FILE"
    sed -i 's/cpu_clock = 900000000;/cpu_clock = 1000000000;/g' "$INIT_FILE"
    # PLL regiszter szorzó beállítása 1000 MHz-hez (40MHz XTAL esetén 0x31 -> 50 * 20MHz = 1000MHz)
    sed -i 's/reg |= (0x2B << 4);/reg |= (0x31 << 4);/g' "$INIT_FILE"
    sed -i 's/reg |= (0x2C << 4);/reg |= (0x31 << 4);/g' "$INIT_FILE"
fi
