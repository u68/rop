ROP is not easy, but like just practice, then you will understand with no problem.

Everything is on the stack.

When pop pc executes, you take 4 bytes at the address of sp, and jump to it in this format:

(4 bytes) ab cd ef gh -> f:cdab (e, g and h can be anything)

lets say it is

34 12 31 30 then it means 1:1234

it will then jump to that address in rom, so if 1:1234 has pop er0 and then pop pc, then it will take 2 bytes at sp, and then basically do what we did before (pop pc)

for stuff with RT, it is slightly more complicated.

When Bl is executed, LR is set to the address after the BL call, so if you have this in the rom

0:2244H  BL 1:1234H
0:2248H  pop pc

and then do this:

44 22 30 30

bl will execute, and lr will be set to 0:2248H (pop pc)

When RT is executed, it goes to LR

so after we did that BL thing, RT is equivilent to POP PC


The whole premise of ROP is to chain a bunch of pre-existing pieces of code, string them together and idk play games I gues.

For more technical stuff, I reccomend you just read the nx u8 instruciton manual
