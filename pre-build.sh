#!/bin/bash
set -x

INIT_FILE="padavan-ng/trunk/linux-3.4.x/arch/mips/rt2880/init.c"
if [ -f "$INIT_FILE" ]; then
    # Lecseréljük a PLL900 feltételes blokkot egy feltétel nélküli 1000 MHz-es PLL beállításra:
    # fbdiv = ((reg >> 4) & 0x7F) + 1  -> 1000 MHz-hez fbdiv = 50 kell -> ((reg >> 4) & 0x7F) = 49 (0x31)
    # 0x31 << 4 = 0x310, az alsó 4 bit megtartásával (reg & ~0x7F0) | (0x31 << 4)
    sed -i 's/#if defined(CONFIG_RALINK_MT7621_PLL900)/#if 1/g' "$INIT_FILE"
    sed -i 's/if ((reg & 0xff) != 0xc2) {/if (((reg >> 4) \& 0x7F) != 0x31) {/g' "$INIT_FILE"
    sed -i 's/reg &= ~(0xff);/reg \&= ~(0x7F << 4);/g' "$INIT_FILE"
    sed -i 's/reg |=  (0xc2);/reg |= (0x31 << 4);/g' "$INIT_FILE"
fi
