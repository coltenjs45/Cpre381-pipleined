

    lui  t0, 0x80000  
    nop 
    nop 
    nop 
    addi t0, t0, -1  
    addi t1, x0, -1
    nop 
    nop 
    nop
    sub  t2, t0, t1	
    xori t3, t1, -1	
    nop
    nop
    nop
    addi t3, t3, 1	
    nop
    nop
    nop	
    add  t4, t0, t3
    nop 
    nop
    nop
    xor  t5, t2, t4	
    lui  t0, 0x80000
    addi t1, x0, 1
    nop
    nop
    nop
    sub  t2, t0, t1       
    xori t3, t1, -1
    nop
    nop
    nop
    addi t3, t3, 1
    nop
    nop
    nop
    add  t4, t0, t3  
    nop
    nop
    nop       
    xor  t5, t2, t4
    lui  t0, 0x80000
    lui  t1, 0x80000
    nop
    nop
    nop
    sub  t2, t0, t1	
    xori t3, t1, -1
    nop
    nop
    nop
    addi t3, t3, 1  
    nop
    nop
    nop        
    add  t4, t0, t3
    nop
    nop
    nop
    xor  t5, t2, t4
    lui  t0, -1234
    nop 
    nop 
    nop 
    addi t0, t0, -1234

    lui  t1, 1234
    nop
    nop
    nop

    addi t1, t1, 1234
    nop
    nop
    nop
    sub  t2, t0, t1

    xori t3, t1, -1
    nop
    nop
    nop

    addi t3, t3, 1
    nop
    nop
    nop
    add  t4, t0, t3
    nop
    nop
    nop
    xor  t5, t2, t4

    wfi