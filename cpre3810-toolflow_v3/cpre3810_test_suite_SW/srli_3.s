
    lui x5, 0xFFFFF # 31 is the largest imm value for this instruction - testing as imm edge case
    nop
    nop
    nop
    srli x5, x5, 31 # value is 0x00000001 and not 0x00000000 because 31 is the largest imm value possible
    wfi               

