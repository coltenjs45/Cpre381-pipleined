

.data
.text
.globl main

main:
# Start Test

#data setup
# Initial Value: 0xFFFF0000
lui t0, 0xFFFF0
nop
nop
nop
addi t0, t0, 0x000 # t0 = 0xFFFF0000

#test 1, shift amount zero
add t2, zero,zero
nop
nop
nop
srl t1, t0, t2
lui t3, 0xFFFF
nop
nop
nop
bne t3, t1, test_fail
nop

#test 2, shift amount 1
addi t2, zero,1
nop
nop
nop
srl t1, t0, t2
lui t3, 0x7FFF8
nop
nop
nop
bne t3, t1, test_fail
nop

#test 3, shift amount 31 (maximum)
addi t2, zero, 31
nop
nop
nop

srl t1, t0, t2
addi t3, zero, 1
nop
nop
nop
bne t3, t1, test_fail
nop

#test 4, shift amount 32 (ignored bits)
addi t2, zero,32
nop
nop
nop
srl t1, t0, t2
lui t3, 0xFFFF
nop
nop
nop
bne t3, t1, test_fail
nop

test_pass:
addi t5, x0, 1 # t5 = 1 (PASS)
j exit

test_fail:
addi t5, x0, 2 # t5 = 2 (FAIL)

exit:
wfi

