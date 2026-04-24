home:
	set lr
	xr0 = 0x80FE, 0x0000
	[er0] = r2
	er0 = 0x8105
    [er0] = r2
	er0 = 0x8226
	[er0] = r2
	buffer_clear
	xr0 = adr_of [-352] home, adr_of home
	memcpy, pop er0
	0x0100
main_run:
	getkeycode
	set lr
	r1 = 0
	er2 = 0xFF20
	er0 += er2
	er2 = adr_of jmptbl
	load_table
	er10 = adr_of jadr
	[er10] = er8,pop qr8
	0x80E0
	0x30303030
jadr:
	0x3030
	sp = er14,pop er14
jmptbl:
	adr_of [-2] up
	adr_of [-2] down
	adr_of [-2] right
	adr_of [-2] left
	adr_of [-2] paint

up:
	er2 = 0xFF00
	goto cnt
down:
	er2 = 0x0100
	goto cnt
right:
	er2 = 0x0001
	goto cnt
left:
	er2 = 0xFFFF
cnt:
	[er8] += er2,pop xr8
	0x30303030
	goto restore
paint:
	er2 = 0x80E0
	er0 = [er2], r2 = 9
	set_pixel
	render
restore:
	set lr
	xr0 = adr_of length, 0x01, 0x00
	[er0] = er2
	qr0 = 0x0100, adr_of [-352] home, adr_of home, 0x30, 0x30
	0x6CD6
length:
	0x000E
	0x3030
	goto main_run
end:
