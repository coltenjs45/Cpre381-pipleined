.data
.text
.globl main
main:
#check if the jump and link put correct value in the return register
    lui  t1, 0x00400
    addi t0, x0, 0
    nop
    nop
    addi t1, t1, 0x02C     
    
    jal  t0, Target #the function we want to test
    nop

Target:
    nop
    nop
    beq  t1,t0, End
    nop
    addi t3,t3,8
End:
    wfi