# Testiing sign-extension: expect t1 = 0xFFFFFF80

    .text
    .globl main
main:
    lui   t0, 0x10010       
    lb    t1, 0(t0)     
    addi  t1, t1, 10    
    wfi
    .data
    .word 0x00000080        
