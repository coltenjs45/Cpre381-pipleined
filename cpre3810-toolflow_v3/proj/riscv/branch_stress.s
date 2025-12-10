.text
    .globl main
main:
    # x2 = flag
    # x3 = work counter
    # x4 = loop counter
    # x1 = return address (used by jal)
    # x10 = final result

    li  x2, 0          # flag = 0
    li  x3, 0          # work = 0
    li  x4, 1000     # iterations

loop_top:
    # Branch alternates every iteration
    beq x2, x0, branch_zero    # if flag == 0 → branch

    # ------------ branch_not_zero path (fall-through) ------------
    addi x3, x3, 1             # work++
    xori x2, x2, 1             # toggle flag
    jal  x1, loop_check        # unconditional jump

branch_zero:
    # ------------ branch_zero path -------------------------------
    addi x3, x3, 2             # slightly different work
    xori x2, x2, 1             # toggle flag
    jal  x1, loop_check

loop_check:
    addi x4, x4, -1            # decrement iterations
    bnez x4, loop_top          # loop again

    mv   x10, x3               # result into a0
    wfi

