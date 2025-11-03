
    lui x5, 0xFF
    nop
    nop
    nop
    srli x6, x5, 0  # place unshifted value into new reg
    nop
    nop
    nop
    srli x5, x6, 4 # place x6 back into x5 shifted by 4
    #x5 should be 0x0000ff00
    #x5 should be 0x000ff000
  
    wfi               

