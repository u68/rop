# Snake

This is by far the most complex rop chain I have written to this day.

I was initially attempting to translate the CWX snake rop into esp, but it is too different and I practically had to make it from scratch.

Renderer:

Since snake required the snake itself to be stored as a byte array, I needed to make a custom renderer, and with no `drawbitmap` I found this to be a bit challenging.

My concept was to start from the head address, and walk down to the tail, rendering each byte as I go.

Due to ea swithcase being 8 bit, all the positions had to fit within 1 byte each, so I was forced to make the board 16x16 and store each position as 0xXY, then I would "decompress" this byte to get a position, multiply it by 2, add an offset, and draw a pixel 4 times to make a 2x2 pixel.

```
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
	buffer_clear```

The rest of the logic was similar to logic that of snake, and for collision checking, using the ea switchase gadget on the snake with the head position, and if it returns a non 0 byte, then it means that position already exists (collision).

For apple detection, a simple conditional with the head position is good enough.

For RNG for apple generation, I used the SFR `0xF00D` as it is funny and counts up fast.