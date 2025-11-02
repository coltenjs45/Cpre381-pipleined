.data

.text
.globl main

main:

    # Start Test
    lui t0, 0xFFFFF       
	nop
	nop
	nop
    addi t0, t0, -1        
    nop
    lui t0, 0xFFFFF
	nop
	nop
	nop
    addi t0, t0, 0x000   
    nop
    nop
    nop                    
    xori a0, t0, -1
    lui t0, 0xAAAAA
	nop
	nop
	nop
    addi t0, t0, -1366    
    nop
    nop
    nop                    
    xori a0, t0, 0x555     
    lui t0, 0x80000
	nop
	nop
	nop
    addi t0, t0, 0x000     
    nop
    nop
    nop                   
    xori a0, t0, -1        
    lui t0, 0x0
	nop
	nop
	nop
    addi t0, t0, 0x00F    
    nop
    nop
    nop                    
    xori a0, t0, 0x00F     
    wfi