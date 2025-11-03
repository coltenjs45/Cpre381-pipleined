
    # --- Case 1: 120 - 60 ---
    addi x1, x0, 120
    addi x2, x0, 60
    nop
    nop
    nop
    sub x1, x1, x2

    # --- Case 2: large values (7FAB0 - 6E9A1) ---
    lui x3, 0x7FAB0
    nop
    nop
    nop
    addi x4, x0, 11
    lui x4, 0x6E9A1
    nop
    nop
    nop
    sub x3, x3, x4

    # --- Case 3: 120 - (-60) ---
    addi x1, x0, 120
    addi x2, x0, -60
    nop
    nop
    nop
    sub x1, x1, x2

    # --- Case 4: 7FAB0 - EE9A1 ---
    addi x3, x0, 0
    lui x3, 0x7FAB0
    nop
    nop
    nop
    addi x4, x0, 11
    lui x4, 0xEE9A1
    nop
    nop
    nop
    sub x3, x3, x4

    # --- Case 5: -120 - 60 ---
    addi x1, x0, -120
    addi x2, x0, 60
    nop
    nop
    nop
    sub x1, x1, x2

    # --- Case 6: -120 - (-60) ---
    addi x1, x0, -120
    addi x2, x0, -60
    nop
    nop
    nop
    sub x1, x1, x2

    wfi        

