# Paint

The concept is simple, take a keycode from `getkeycode`, add a number to it so the lowest keycode becomes a 0, and use it as an inddex to a jump table to perform various tasks.

The downside is that just about any invalid key is almost garunteed to crash.

How it works:

When you press up, it will add 0xFF00 to the cursor position, down will add 0x0100, right will add 0x0001 and left will add 0xFFFF.

When `mode` is pressed, it takes that position into er0, and calls `set_pixel` and then render, and that is basically it.