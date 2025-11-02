.data
.text
.globl main
main:
#Load all registers
addi x1, x0, 5
addi x2, x0, 5
addi x4, x0, 3
addi x5, x0, 9
addi x7, x0, 42


# Test 1: Equal small positive values
# Tests basic beq functionality with common case values.
beq x1, x2, pass1
nop
addi x3, x0, -1

pass1:
# Test 2: Unequal values (don't branch)
# Tests beq correctly falls through when values differ.
beq x4, x5, error
nop
addi x6, x0, 1

# Test 3: Same register compared to itself
# Tests edge case of self-comparison (always equal).
beq x7, x7, pass2
nop
addi x8, x0, -1

pass2:
    addi x9, x0, 1

end:
    wfi
   # j end

error:
    wfi
    #addi x31, x0, -1
    #j end
