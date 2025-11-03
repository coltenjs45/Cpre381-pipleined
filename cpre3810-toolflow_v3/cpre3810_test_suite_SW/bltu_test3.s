# Test 3: Stress-test values that are off by one and values that are equal in order to confirm comparison strictness.
# Uses only: addi, beq, bltu.

    .text
    .globl _start
_start:
    	addi a0, x0, 254      # a0 = 0x000000FE
    	addi a1, x0, 255      # a1 = 0x000000FF
    	addi a2, x0, 256      # a0 = 0x00000100
    	addi a3, x0, 255      # a1 = 0x000000FF

	## case 1: 0xFE < 0xFF
    	bltu a0, a1, OK1      # FE < FF true, EXPECT taken
		nop
    	beq  x0, x0, FAIL1    # not taken = fail case 1

OK1:
	##case 2: 0x100 < 0xFF

    	bltu a2, a3, FAIL2    # 0x100 < 0x0FF false, expect NOT taken
        # fall-through if correct
        
        ## Case 3: 123 < 123
    	bltu a1, a3, FAIL3    # 123 < 123 false, expect NOT taken

PASS:
    	#beq  x0, x0, PASS     # loop here if all cases pass
		wfi
FAIL1:
    	#beq  x0, x0, FAIL1    # loop here if 0xFE<0xFF true case fails
    	wfi
FAIL2:
    	#beq  x0, x0, FAIL2    # loop here if 0x100<0xFF false case fails
    	wfi
FAIL3:
    	#beq  x0, x0, FAIL3    # loop here if 123<123 false case fails
    	wfi
