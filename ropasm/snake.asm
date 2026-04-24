#org 0x829A
home:
	xr0 = 0x8A56, adr_of main_run
	memcpy, pop er0
	0x034C
	set lr
	goto reset
main_run:
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

	er2, er4, er6 = 0, er8 = 0x0100
	ea_switchcase
	r2 = [ea], r0++ if r2 # r2 now holds the byte that will get added to snake_head as a "compacted" value
	er8 = 0x8130 # Doesn't really matter where, it is the fact that er2 has the final amount so I can skip loading it again
	er0 = adr_of last_move
	[er0] = r2
	[er8] += er2, pop xr8
	0x30303030
	
	er10 = er2 #backup er2

	er2 = 0x8950 # load head address address
	er0 = [er2], r2 = 9 # load head address
	
	er2 = er10, pop qr8 #restore er2
	0x3030303030303030
	r0++ # store to one higher, because memcpy will move it down into position
	[er0] = r2 # store head position into head +1

	xr0 = 0x8953, 0x8954 # shift it all down by 1
	memcpy, pop er0
	0x0100 #the whole board has a max of 256 cells, so I can hardcode it easily, and this is restored later in the rop
	#if lr isn't set, every rt gadget will technically end in a pop er0

	set lr

	# check for collision

	er0 = 0x8953 # address of where the snake is stored (-1)
	er2, er4, er6 = 0, er8 = 0x0100
	ea = er0, [ea] |= r3, pop er4
    0x0000

    er2 = 0x8950 # address of where the address of the head is stored
    er0 = [er2], r2 = 9
    r0 = [er0] # load the head of the snake

	er2, er4, er6 = 0, er8 = 0x0100
    ea_switchcase # go through the whole snake to see if the position is already existing (collision)
	r2 = [ea], r0++ if r2

    # check if r2 = 0

    er4 - er2_ne,r0 = 0|r0 = 1
    xr12 = adr_of jtable, adr_of [-2] reset # died
    bl er12[r0<<1]
	# lr needs to be set because it now is just junk

	set lr



	# check if apple touched

	er2 = 0x8950 # address of where the address of the head is stored
    er0 = [er2], r2 = 9
    r0 = [er0] # load the head of the snake
    r1 = 0
	er2 = er0, er0 += er4 # er0 doesn't matter rn
	er0 = adr_of aer4
	[er0] = er2
	er0 = 0x8A54 # address of where the apple position is stored
    r0 = [er0] # load the apple position
    r1 = 0
	er2 = er0, er0 += er4 # er0 doesn't matter rn
	pop er4
aer4:
	0x3030
	er4 - er2_ne,r0 = 0|r0 = 1
    xr12 = adr_of jtable, adr_of [-2] cont # apple
    bl er12[r0<<1]
	# lr needs to be set because it now is just junk
    set lr

	er0 = 0x8130
	r0 = [er0]

	er2 = er0, er0 += er4
	
	er10 = er2 #backup er2

	er2 = 0x8950 # load head address address
	er0 = [er2], r2 = 9 # load head address
	
	er2 = er10, pop qr8 #restore er2
	0x8950
	0x303030303030
	r0++ # store to one higher, because memcpy will move it down into position
	[er0] = r2 # store head position into head +1
	er2 = 1, r0 = 1
	[er8] += er2, pop xr8
	0x30303030




gen_apple:
	er0 = 0xF00D # gen new apple when apple touched
	r0 = [er0]
	r2 = r0
	er0 = 0x8A54
	[er0] = r2




cont:
    set lr
	er0 = 0x8A54 # render apple
	r0 = [er0]
	r1 = r0, font_size = 7
	r0 >>= 4 # decompress
	r1 &= 15, [8000] = r1

	er2 = er0, pop er8 # instead of drawing a big square, draw a 🙾
	0x3030
	er0 += er2
	er2 = 0x0020
	er0 += er2
	er8 = er0
	set_pixel
	er2 = 0x0101
	er0 = er8
	er0 += er2
	set_pixel

render_loop:
    set lr
    er2 = 0x8950 # address of where the address of the head is stored
    er0 = [er2], r2 = 9
    pop er2
modifier:
    0x0000 # 0 as start, and then it will decrement to offset loading the head
    er0 += er2

    er2 = er0, er0 += er4 # save for later
    er0 = adr_of sver0
    [er0] = er2
    er0 = er2, pop er8
    0x3030

    r0 = [er0] # load the head of the snake

render_r0:
    r1 = r0, font_size = 7
	r0 >>= 4 # decompress
	r1 &= 15, [8000] = r1

	er2 = er0, pop er8
	0x3030
	er0 += er2
	er2 = 0x0020
	er0 += er2

    er4 = 0, er6 = 0, er8 = 0x0100 # set pixel pushes and pops er4, so setting the lsb of r4 to 0 fixes it
	er8 = er0
	set_pixel
	er0 = er8
	r0++
	set_pixel
	er0 = er8
	er2 = 0xFF00
	er0 -= er2
	er8 = er0
	set_pixel
	er0 = er8
	r0++
	set_pixel

    er8 = adr_of modifier # decrement modifier
    er2 = 0xFFFF
    [er8] += er2, pop xr8
    0x30303030

    # loop here, from snake_head, down to snake to render it all
    pop er2
sver0:
    0x3030
    #check if er0 == start of snake
    er4 = 0x8953
    er4 - er2_ne,r0 = 0|r0 = 1
    xr12 = adr_of jtable, adr_of [-2] render_loop
    bl er12[r0<<1]
    # modifier is reset on restore
	set lr

	er0 = 0x8A54
	r0 = [er0]
	r1 = r0, font_size = 7
	r0 >>= 4 # decompress
	r1 &= 15, [8000] = r1

	er2 = er0, pop er8
	0x3030
	er0 += er2
	er2 = 0x0020
	er0 += er2

	er8 = er0
	set_pixel
	er2 = 0x0101
	er0 = er8
	er0 += er2
	set_pixel

	set lr, render

	er0 = 0x1818 # delay
	delay
	buffer_clear

	
restore: # nerdy restore stuff
	set lr
	xr0 = adr_of length, 0x01, 0x00
	[er0] = er2
	qr0 = 0x034C, 0x8A56, adr_of main_run, 0x30, 0x30
	0x6CD6 # memcpy magic
length:
	0x0064
	0x3030
	goto main_run

reset:
	set lr
	xr0 = 0x8954, 0x0100 # clear board
    memzero
	xr0 = 0x87D0, 0x0180 # clear screen
    memzero
	set lr
	xr0 = 0x8954, 0x22, 0x32 # init board with a bit of stuff
	[er0] = er2
	xr0 = 0x8956, 0x42, 0x52
	[er0] = er2
	xr0 = 0x8130, 0x0052 # the current head pos ish thing
	[er0] = er2
	xr0 = 0x8950, 0x8957 # init snake head
	[er0] = er2
	goto gen_apple

key_switch:
0x84 # up
0xFF

0x48 # down
0x01

0x44 # left
0xF0

0x88 # right
0x10

0x00 # default
last_move:
0x10 # this will be the direction the snake starts moving in 

jtable: # both collision checking and key checking share the same table
    0x1138 # jpop er14 1:1138H
    0x113D # pop pc  1:113CH (I did +1 so the eapple subroutine can use it as a seg 1 gadget, 3C would be seg 0 (junk))


end:
