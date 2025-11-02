.data
.text
.globl main
main:

#Load registers
    addi x1, x0, 1
    addi x2, x0, 1
    addi x4, x0, 0
    addi x5, x0, 2

# Test 1: Forward branch
# Tests PC-relative forward offset calculation.
    nop                     #Get x2 loaded
    beq x1, x2, target
    nop
    addi x3, x0, -1

target:
# Test 2: Backward branch (loop)
# Tests negative PC offset for loop behavior.

loop:
    addi x4, x4, 1
    nop
    nop
    nop
    beq x4, x5, done
    nop
    beq x0, x0, loop
    nop

done:
    addi x6, x0, 1

end:
    wfi
    #j end
