.data

.text
.globl main

main:
    # Start Test

    # Load immediate into t0 = 0x00000FFF
    lui t0, 0x1
	nop
	nop
	nop
    addi t0, t0, -1
    nop
    nop
    nop                     

    # Use t0 in XORI
    xori t1, t0, -1         # Expected t1 = 0xFFFFF000
    nop
    nop
    nop                     

    # Use t1 in XORI
    xori t2, t1, -1         # Expected t2 = 0x00000FFF
    nop
    nop
    nop                     
    # Use t2 in XORI
    xori a0, t2, 1365       # Expected a0 = 0x00000AAA
    nop
    nop
    nop                     

    # Load immediate into a0 again = 0x00000FFF
    lui a0, 0x1
	nop
	nop
	nop
    addi a0, a0, -1
    nop
    nop
    nop                     

    # Use a0 in XORI with itself
    xori a0, a0, -1        

    wfi