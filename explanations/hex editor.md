This rop uses a combination of getscancode_nodelay and getkeycode

I will focus on the edit part for this explanation.

The code for editing a byte is as follows:

```
enter_hex:
    er0 = 0x0A00
    delay
enter_hex2:
    getkeycode
    set lr
    r2 = r0
    er0 = adr_of ser0
    [er0] = r2
    er0 = adr_of curk
    [er0] = r2

    xr0 = adr_of key_mod, 0x0000 
    ea = er0, [ea] |= r3, pop er4
    0x3030
    pop er0
ser0:
    0x0000
    ea_switchcase
    r2 = [ea], r0++ if 255
    pop er0
wadr:
    0x8164
    [er0] = r2

    xr0 = adr_of enter_hex2, 0xb45e
    [er0] = er2
    er0 = adr_of [2] enter_hex2
    [er0] = er2
    xr0 = adr_of wadr, 0x8165
    [er0] = er2
    pop er2, er8, er0 = er2
    0x0001
    adr_of [-4] ej
    [er8] += er2, pop xr8
    0x30303030
    er14 = adr_of [-2] enter_hex2
    jpop er14
ej:
    0x3030

    er2 = 0x8164
    er0 = [er2], r2 = 9
    r1 = hex_byte_reverse, [8100] = r1
    r2 = r1, er14++
    er0 = 0x80E0
    er8 = [er0]
    er0 = er8
    [er0] = r2
```

First, it does a delay becuase teh getscancode right before wont stop getkeycode from taking in = as an input so you have time to release the key.

Second, it takes the keycode, and writes it to the default case of the key modifier (curk), and in the key modifier, it takes all the hex keys from baseN mode, but as comp mode characters, and has the proper hex ABCDEF value.

0x60 (-)
0x0A

0xF6 °'"
0x0B

0x09 hyp
0x0C

0xA0 sin
0x0D

0xA1 cos
0x0E

0xA2 tan
0x0F

And it wrote to the default case since the normal numbers are 0x30 - 0x39, (the lower nibble is the important part and doesnt need correcting)

Then it writes this key to a buffer, and increments the jump gadget, when that jump gadget gets called a third time, it no longer becomes mov sp, er14, pop er14, it becomes pop er14, and will just continue.

Then it runs a "reverse_hex_byte" gadget, this takes the lower nibble of 2 bytes and puts it into r1, and then we write it to the address.

Simple right?
