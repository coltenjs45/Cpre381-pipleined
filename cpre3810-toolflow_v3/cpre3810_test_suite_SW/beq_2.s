.data
.text
.globl main
main:

#Load registers
    addi x2, x0, -7
    addi x3, x0, -7
    addi x5, x0, 2047
    addi x6, x0, 2047
    addi x8, x0, -2048
    addi x9, x0, -2048


# Test 1: Both zero (x0 register)
# Tests hardwired zero register boundary value.
    beq x0, x0, pass1
    nop
    addi x1, x0, -1

pass1:
# Test 2: Equal negative values
# Tests two's complement negative numbers.
    beq x2, x3, pass2
    nop
    addi x4, x0, -1

pass2:
# Test 3: Large positive values (boundary test)
# Tests upper range of operand values near max positive.
    beq x5, x6, pass3
    nop
    addi x7, x0, -1

pass3:
# Test 4: Large negative values (boundary test)
# Tests lower range of operand values near max negative.
    beq x8, x9, pass4
    nop
    addi x10, x0, -1

pass4:
    addi x11, x0, 1

end:
    wfi
    #j end
