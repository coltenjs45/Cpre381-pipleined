#Written using Google Gemini, configured to fit our constraints

.data
    # Data storage for Store/Load tests
my_data: .word 0

.text
.globl main
main:
    # --- Setup ---
    la      x29, my_data    # Load address of data label into x29

    addi    x1, x0, 10
    addi    x2, x0, 5
    addi    x3, x0, 2
    addi    x5, x0, 5
    addi    x6, x0, 20
    addi    x7, x0, 4
    
    addi    x10, x0, 99
    sw      x10, 0(x29)     # Initialize Mem[x29] = 99

    # --- 1. Read After Write (RAW) ---
    addi    x2, x0, 30
    addi    x3, x0, 10
    add     x1, x2, x3
    sub     x4, x1, x5

    # --- 2. RAW – Non Consecutive ---
    add     x1, x2, x3
    and     x4, x6, x7
    sub     x3, x1, x2

    # --- 3. Cascading RAW Hazards ---
    add     x1, x2, x3
    and     x5, x1, x6
    sub     x4, x1, x5

    # --- 4. Load-Use ---
    lw      x1, 0(x29)
    add     x3, x1, x2

    # --- 5. Store-Load ---
    sw      x1, 0(x29)
    lw      x3, 0(x29)

    # --- Exit ---
    li      a7, 10
    wfi