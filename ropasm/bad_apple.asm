org 0x85ba
home:
    er14 = adr_of [-4] loop

loop:
    er2 = adr_of fptr
    er0 = [er2], r2 = 9
    r0 = [er0]
    r2 = r0

    er0 = adr_of fptb
    er8 = [er0]
    er0 = er8
    
    [er0] = r2

    er8 = adr_of fptb
    er2 = 0x0010
    [er8] += er2, pop xr8
    adr_of wloop
    0x3030
    er2 = 0x0001
    [er8] += er2, pop xr8
    adr_of fptr
    0x3030
    er2 = 0x0001
    [er8] += er2, pop xr8
    0x30303030
wloop:
    call 0x03360 # repeat while 5E < 66
    0x3030
    adr_of [-2] loop
    
    er0 = adr_of wloop
    er2 = 0x3360
    [er0] = er2

    er0 = adr_of fptb
    er2 = 0xf810
    [er0] = er2

	set lr
	er0 = 0x1818
	delay

	jpop er14
fptb:
    0xf810
fptr:
    adr_of [2] fptr
$result.extend(bytes.fromhex(open('../bad_apple.hex','r').read().strip()))
end:
