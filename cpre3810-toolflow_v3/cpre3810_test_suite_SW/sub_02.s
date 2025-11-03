
    .text
    .globl main
main:

#-------------------------------------------------------
# --- Case 1: rd == rs1 ---
#-------------------------------------------------------
# Write after read on rs1

    # a=42 and b=-17
    addi t0, x0, 42
    addi t1, x0, -17

    # Test
    # Save originals (since rd will overwrite t0)
    addi s0, x0, 42	# save a
    addi s1, x0, -17         # save b
    nop
    sub  t0, t0, t1
    nop

    # Expected
    xori t3, s1, -1
    nop
    nop
    nop
    addi t3, t3, 1
    nop
    nop
    nop
    add  t4, s0, t3
    nop
    nop
    nop
    xor  t5, t0, t4          # should be 0


    # a=1000 and b=333
    addi t0, x0, 1000
    addi t1, x0, 333
    nop

    # Test
    addi s0, x0, 1000        # save a
    addi s1, x0, 333         # save b
    sub  t1, t0, t1
    nop
    nop

    # Expected
    xori t3, s1, -1
    nop
    nop
    nop
    addi t3, t3, 1
    nop
    nop
    nop
    add  t4, s0, t3
    
    # Check
    nop
    nop
    nop
    xor  t5, t1, t4          # should be 0


    addi s0, x0, -123        # a
    nop
    nop
    nop

    sub  t2, s0, s0          # t2 = a - a

    # Expected
    addi t4, x0, 0           # 0
    nop
    nop
    nop
    # Check
    xor  t5, t2, t4          # should be 0

    # a=-1 and b=7
    addi t0, x0, -1
    addi t1, x0, 7
    nop
    nop
    nop
    # Test
    sub  x0, t0, t1	# Try to write result 

    # Expected 
    addi t4, x0, 0
    nop
    nop
    nop
    # Check that x0 is still 0
    xor  t5, x0, t4 
    wfi
