home:
    xr0 = 0x80E0, 0xF000
    [er0] = er2
    buffer_clear
    set lr
    xr0 = 0x8950, adr_of main_run
    memcpy, pop er0
    0x0242
main_run:
    set lr
    er0 = adr_of kkode
    getscancode_nodelay
    set lr
    xr0 = adr_of key_switch, 0x0000 
    ea = er0, [ea] |= r3, pop er4
    0x3030
    pop er0
kkode:
    0x3030
    r1 |= r0, [8100] = r1
    r0 = r1
    ea_switchcase
    r0 = [ea] # r0 now holds the index into the jumptable
    r1 = 0
    er2 = adr_of [-27] up
    er0 += er2
    er2 = er0, pop er8
    0x80E0 # address for up down right left to right to change address
    er0 = adr_of jadr
    [er0] = er2
    pop er14
jadr:
    0x3030 # ting ting
    jpop er14

    adr_of [-2] mcont
up:
    er2 = 0x0010
    jpop er14

    adr_of [-2] mcont
down:
    er2 = 0xFFF0
    jpop er14

    adr_of [-2] mcont
left:
    er0 = 0x0515
    delay
    er2 = 0xFFFF
    jpop er14
    
right:
    er0 = 0x0515
    delay
    er2 = 0x0001
mcont:
    [er8] += er2, pop xr8
    0x30303030
gtcont:
    goto cont

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

cont:
    er2 = 0x80E1
    r0 = [er2]
    hex_byte
    er2 = er0, er0 += er4
    er0 = 0x8080
    [er0] = er2
    er2 = 0x80E0
    r0 = [er2]
    hex_byte
    er2 = er0, er0 += er4
    er0 = 0x8082
    [er0] = er2
    xr0 = 0x0101, 0x8080
    line_print_small
    
    set lr

    er2 = 0x80E0
    er0 = [er2], r2 = 9
    r0 = [er0]

    hex_byte
    [8020] = er0
    xr0 = 0x0808, 0x8020
    line_print_small
    set lr, render
restore:
    xr0 = adr_of length, 0x01, 0x00
    [er0] = er2
    qr0 = 0x0242, 0x8950, adr_of main_run, 0x30, 0x30
    0x6CD6
length:
    0x001C
    0x3030
    
    goto main_run

key_switch:
    0x84 # up
    0x19

    0x48 # down
    0x25

    0x44 # left
    0x31

    0x88 # right
    0x45

    0x41 # =
    0x67

    0x00 # default (cont)
    0x5D

key_mod:
    0x60
    0x0A

    0xF6
    0x0B

    0x09
    0x0C

    0xA0
    0x0D

    0xA1
    0x0E

    0xA2
    0x0F

    0x00
curk:
    0x00
