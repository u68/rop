# Greyscale Paint

This is similar to the normal paint program, but instead of using `getkeycode` it uses `getscancode_nodelay`, teh syntax is it takes er0 as a pointer to write the scan code which consists of 2 bytes, to make those 2 bytes useful, I "compress" them into 1 byte by doing some basic bitwise arithmatic operations:

```
    r1 |= r0, [8100] = r1
	r0 = r1```

Then it uses an ea switchcase gadget, you may recognize it as a CWX gadget, but the difference on es plus is taht this gadget is 8 bit (whereas CWX is 16 bit) that si why I needed to compress the byte.

How ea switchase works:

It takes r0, and then goes through data at pointer ea, if it matches, it will stop (and if it comes across a 0 byte it stops), then we take the data at [ea] and use that as an offset to jump, completely making a jump table obselete.

The rest of the logic stays relatively the same with some minor optimizations.

How the greyscale engine works:

A poor mans implementation of PWM is really simple, render one buffer for a bit, and the other for a bit, and switch between them rapidly, abusing the duration it takes for a pixel to fully power on/off.