.data
    .text
    .globl main
main:
    # Start doubling sequence
    addi x1, x0, 1        # x1=1
    addi a7, x0, 93       # Load a7 early (independent)
    nop
    nop
    
    # Double x1 30 times to get 1<<30
    # Each add needs result from previous, so 3 NOPs between each
    add x1, x1, x1        # x1=2
    nop
    nop
    nop
    add x1, x1, x1        # x1=4
    nop
    nop
    nop
    add x1, x1, x1        # x1=8
    nop
    nop
    nop
    add x1, x1, x1        # x1=16
    nop
    nop
    nop
    add x1, x1, x1        # x1=32
    nop
    nop
    nop
    add x1, x1, x1        # x1=64
    nop
    nop
    nop
    add x1, x1, x1        # x1=128
    nop
    nop
    nop
    add x1, x1, x1        # x1=256
    nop
    nop
    nop
    add x1, x1, x1        # x1=512
    nop
    nop
    nop
    add x1, x1, x1        # x1=1024
    nop
    nop
    nop
    add x1, x1, x1        # x1=2048
    nop
    nop
    nop
    add x1, x1, x1        # x1=4096
    nop
    nop
    nop
    add x1, x1, x1        # x1=8192
    nop
    nop
    nop
    add x1, x1, x1        # x1=16384
    nop
    nop
    nop
    add x1, x1, x1        # x1=32768
    nop
    nop
    nop
    add x1, x1, x1        # x1=65536
    nop
    nop
    nop
    add x1, x1, x1        # x1=131072
    nop
    nop
    nop
    add x1, x1, x1        # x1=262144
    nop
    nop
    nop
    add x1, x1, x1        # x1=524288
    nop
    nop
    nop
    add x1, x1, x1        # x1=1048576
    nop
    nop
    nop
    add x1, x1, x1        # x1=2097152
    nop
    nop
    nop
    add x1, x1, x1        # x1=4194304
    nop
    nop
    nop
    add x1, x1, x1        # x1=8388608
    nop
    nop
    nop
    add x1, x1, x1        # x1=16777216
    nop
    nop
    nop
    add x1, x1, x1        # x1=33554432
    nop
    nop
    nop
    add x1, x1, x1        # x1=67108864
    nop
    nop
    nop
    add x1, x1, x1        # x1=134217728
    nop
    nop
    nop
    add x1, x1, x1        # x1=268435456
    nop
    nop
    nop
    add x1, x1, x1        # x1=536870912
    nop
    nop
    nop
    add x1, x1, x1        # x1=1073741824 (1<<30)
    nop
    nop
    nop
    
    # Copy and perform final operations
    add x2, x1, x0        # x2=x1
    nop
    nop
    nop
    add x3, x1, x2        # x3=(1<<31)
    nop
    nop
    nop
    add x4, x3, x3        # x4=wrap around to 0
    nop
    nop
    nop
    add x5, x4, x0        # x5=0
    add x6, x3, x0        # x6=x3 (reads x3 - safe after 3 nops)
    
    wfi