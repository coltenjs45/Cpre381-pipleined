.data
byte_data: .byte 0xAB, 0xCD, 0xEF, 0x12, 0xCD, 0xEF, 0x12   # same 4 bytes
result:    .word 0                         # to store loaded value

.text
.globl main
main:
    lasw t0, byte_data      # load base address
    lasw t2, result      # load base address
    nop
    nop

    lbu  t1, 4(t0)         # load third byte (0xEF) unsigned
    nop
    nop
    nop

    sw t1, 0(t2)      # store loaded value
    wfi                   # end / wait for interrupt

