    .data
    .text
    .globl main
main:
    # Load immediates first
    addi x1, x0, 5        # x1=5 (available after 3 instr)
    addi x2, x0, 3        # x2=3 (available after 3 instr)
    addi x4, x0, 42       # x4=42 (available after 3 instr)
    
    # 3 gaps before using x1
    nop
    nop
    nop
    
    # Now x1 is available from WB
    add x1, x1, x1        # x1=x1+x1=10 (reads x1 - safe)
    add x0, x4, x3        # try to write to x0 (reads x4 - safe)
    add x5, x0, x0        # x5=x0+x0=0 (independent)
    
    # 3 gaps before using new x1 value
    nop
    nop
    nop
    
    # Now new x1 is available
    add x2, x1, x2        # x2=10+3=13 (reads x1, x2 - safe)
    addi a7, x0, 93       # Independent
    nop
    
    # 3 gaps before using x2
    nop
    nop
    nop
    
    # Now x2 is available
    add x3, x2, x2        # x3=13+13=26 (reads x2 - safe)
    
    wfi
