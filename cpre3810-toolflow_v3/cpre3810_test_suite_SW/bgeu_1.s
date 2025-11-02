.data

.text
.globl main

main:

#Load Registers
	li x1, 100
	li x2, 100
	li t0, 0 	# count of test that result in no branch to (total be 3 if functioning correctly)
	nop
	nop

# rs1 = rs2 - VALID
	bgeu x1, x2, test1
	nop
	addi t0, t0, 1

test1:
	addi x1, x1, 1
	nop
	nop
	nop
# rs1 > rs2 - VALID
	bgeu x1, x2, test2
	nop
	addi t0, t0, 1

test2:
	addi x2, x2, 2
	nop
	nop
	nop
# rs1 < rs2 - NOT VALID
	bgeu x1, x2, test3
	nop
	addi t0, t0, 1

test3:
# signed difference - VALID (branch unsigned - rs1 > rs2)
	li x1, -1 
	nop
	nop
	nop
	bgeu x1, x2, test4
	nop
	addi t0, t0, 1

test4:
# signed difference -  NOT VALID (branch unsigned - rs1 < rs2)
	li x1, 100 
	li x2, -1
	nop
	nop
	nop
	bgeu x1, x2, test5
	nop
	addi t0, t0, 1

test5:
# max unsigned value eqauility -   VALID (branch unsigned - rs1 = rs2)
	li x1, 4095 
	li x2, 4095
	nop
	nop
	nop
	bgeu x1, x2, test7
	nop
	addi t0, t0, 1

test7:
# 0 vs max unsigned value eqauility - NOT VALID (rs1 < rs2)
	li x1, 0
	nop
	nop
	nop
	bgeu x1, x2, end
	nop
	addi t0, t0, 1

end:
	wfi
#	j end

