.data
byte_data: .byte 0xAB, 0xCD, 0xEF, 0x12   # 4 bytes
result:    .word 0                         # to store loaded value

.text
.globl main
main:
    lasw t0, byte_data      # load base address
    lasw t2, result
    nop
    nop

    lbu  t1, 0(t0)         # load first byte (0xAB) unsigned
    nop
    nop
    nop
    
    sw t1, 0(t2)      # store loaded value
    wfi                   # end / wait for interrupt

