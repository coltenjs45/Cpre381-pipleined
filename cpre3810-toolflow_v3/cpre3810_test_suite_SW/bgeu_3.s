.data

.text
.globl main

main:

#Load Registers
    addi t1, zero, -2
    addi t2, zero, -1
    addi t3, zero, -1
    nop
# Reason: Large Number Comparison : Unsigned Comparison / Ensuring the bgeu can handle large unsigned number correctly.

# Case 1: t0 = 0xFFFFFFFF, t1 = 0xFFFFFFFE [Reason for: should branch because t0 is one more than t1] / Proves we are using unsigned arithmetic, can handle large numbers, and it works with the greater than part of bgeu.
    bgeu t0, t1, skipOne
    nop
    addi t5, zero, 2

skipOne: # the value of t2 should be zero after this runs, the branch should skip the addi t2 line

# Case 2: t0 & t1 = 0xFFFFFFFF [Reason for: should branch because t0 = t1] / Proves we are using unsigned arithmetic, can handle large numbers, and it works with the equals part of bgeu.
    bgeu t2, t3, skipTwo
    nop
    addi t5, zero, 2

skipTwo: # the value of t3 should be 0x00000000 after this runs, the branch should skip the addi t3 line

# Case 3: t0 = 0xFFFFFFFE, t1 = 0xFFFFFFFF [Reason for: should NOT branch because t0 is one less than t1] / Proves we are using unsigned arithmetic, can handle large numbers, and it works with the less than part of bgeu.
    bgeu t1, t2, skipThree

    addi t5, zero, 2

skipThree:

end:
    wfi
#j end
