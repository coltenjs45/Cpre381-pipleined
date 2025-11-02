# and_3.s - hazard free for 5-stage no forwarding
.data
.text
.globl main
main:
    lui t0, 0xFFFFF       # t0=0xFFFFF000
    lui t1, 0xF0F0F       # t1=0xF0F0F000
    nop
    nop
    nop
    # Now t0 and t1 are available
    and t2, t0, t1        # t2=0xF0F0F000 (reads t0, t1 - safe)
    lui t1, 0x0F0F0       # t1=0x0F0F0000
    nop
    
    nop
    nop
    nop
    # Now t0 and new t1 are available
    and t2, t0, t1        # t2=0x0F0F0000 (reads t0, t1 - safe)
    
    wfi
