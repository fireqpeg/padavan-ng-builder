#!/bin/bash
INIT_FILE="padavan-ng/trunk/linux-3.4.x/arch/mips/rt2880/init.c"
if [ -f "$INIT_FILE" ]; then
    sed -n '480,680p' "$INIT_FILE"
fi
