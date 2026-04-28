#org 0x8430
home:
	xr0 = 0x87d0, 0x0300
	memzero
	set lr
	xr0 = adr_of [-364] main_run, adr_of main_run
	memcpy, pop er0
	0x0150
	set lr
main_run:
	
	er0 = adr_of kkode
	getscancode_nodelay
	set lr
	er0 = adr_of key_switch
	er2 = 0x0000 
	ea = er0, [ea] |= r3, pop er4
	0x3030
	pop er0
kkode:
	0x3030
	r1 |= r0, [8100] = r1
	r0 = r1
	r1 = 0
	ea_switchcase
	r0 = [ea] # r0 now holds the index into the jumptable
	r1 = 0
	er2 = adr_of [-27] up
	er0 += er2
	er2 = er0, er0 += er4 # idc about er0 now
	er0 = adr_of jadr
	[er0] = er2
	er8 = 0x80E0 # address for up down right left to right to
	er2 = 0x80E0 # address of coord for setting pixel to write to
	pop er14
jadr:
	0x3030 # ting ting
	jpop er14

	adr_of [-2] cnt
up:
	er2 = 0xFF00
	jpop er14

	adr_of [-2] cnt
down:
	er2 = 0x0100
	jpop er14
	
	adr_of [-2] cnt
right:
	er2 = 0x0001
	jpop er14

	adr_of [-2] cnt
left:
	er2 = 0xFFFF
	jpop er14

	adr_of [-2] cnt
adjp:
	er8 = adr_of [-364] second
	er2 = 0x0005
	jpop er14

adjm:
	er8 = adr_of [-364] second
	er2 = 0xFFFB

cnt:
	[er8] += er2,pop xr8
	0x30303030
	er0 = 0x0808
	delay
	goto restore
p3:
	er0 = [er2], r2 = 9
	set_pixel # same as p1, nothing special
	er2 = 0x80E0
p2:
	er0 = [er2], r2 = 9
	er2 = 0x2000
	er0 += er2 # make y position go out of bounds into our own second screen buffer
	goto spix
p1:
	er0 = [er2], r2 = 9
spix:
	set_pixel_unbound
rend:
	er0 = 0x0010 # adjust this, pwm stuff
	delay
	render
	pop er0
second:
	0x0040 # adjust this, pwm stuff
	delay
	er0 = 0x8950
	render er0
	0x3030303030303030
	0x30303030

restore:
	set lr
	xr0 = adr_of length, 0x01, 0x00
	[er0] = er2
	qr0 = 0x0150, adr_of [-364] main_run, adr_of main_run, 0x30, 0x30
	0x6CD6
length:
	0x000E
	0x3030
	goto main_run
key_switch:
	0x84 # up
	0x19

	0x48 # down
	0x25

	0x88 # right
	0x31

	0x44 # left
	0x3D

	0x05 # 3
	0x81

	0x03 # 2
	0x8F
	
	0x01 # 1
	0xA7

	0x09 # +
	0x49

	0x11 # -
	0x59

	0x00 # default
	0xAF
end: