.data

.text
.globl main

main:

    # Start Test
    xori a0, zero, 2047
    addi a0, zero, 0            
    lui t0, 0xFFFFF
	nop
	nop
	nop
    addi t0, t0, -1           
    nop
    nop
    nop                  
    xori a0, t0, -2048     
    addi a0, zero, 0
    nop
    nop
    nop              
    xori a0, zero, 0x7FF  
    addi a0, zero, 0             
    xori a0, zero, -2048  

    wfi

