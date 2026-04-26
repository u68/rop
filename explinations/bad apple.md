# Bad apple

Yes, bad apple can fit entirely in a single rop chain, the only downside is that it is at 1fps and 8x6 and will take a year to type in manually, therefore it is very impractical and is more of a funny demonstration of the capabilities of rop.

Inside `bad_apple.asm` is a very simple video player that uses a special gadget at line 30.

If you look at the disas of the gadget, it looks a bit strange:

```
	mov r0, 0                      ; 0335E | 0000
	st r0, [draw_mode]             ; 03360 | 9011 811C
	mov sp, er14                   ; 03364 | A1EA
	pop xr12                       ; 03366 | FC2E
	pop pc                         ; 03368 | F28E```

The use of this gadget is for it to effectivly be a bunch of NOP instructions until 0:3366 is called, as when you call an odd number, it gets rounded down, so 335E - 3365 all do exactly the same thing, but when you call 3366, it will no longer jump to er14, and will instead pop xr12 and continue on.

This can be used to create simple for loops (although limited to like 8 iterations) which is perfect for this case.

By looping and then incrementing the address that we are calling, we can make it so we escape the loop after a certain amount of iterations, all the loop does is take a byte from the frame pointer (not to be confused with er14), load that byte, and write it to F810 + (i*16), and then once the loop has finished, it will reset the incremented gadget and goto the start, resetting the write adderss pointer back to F810.