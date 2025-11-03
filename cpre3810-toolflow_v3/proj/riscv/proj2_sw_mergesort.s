.data
array:      .word 64, 34, 25, 12, 22, 11, 90, 88, 45, 50, 23, 36, 18, 77, 30, 40
array_size: .word 16
temp:       .space 64          # Temporary array for merging (16 * 4 bytes)

.text
.globl main

main:
    lui a0, 0x10010         # Load address of array
    lui sp, 0x7FFFF         # Initialize stack pointer (no hazard - different reg)
    addi a1, x0, 16         # Load array size (a1 = 16)
    nop
    addi a0, a0, 0x000      # Finish loading array address (no hazard - 1 cycle gap)
    addi a2, x0, 0          # Left index = 0
    addi sp, sp, -12        # Adjust stack (no hazard - 1 cycle gap)
    nop
    nop
    addi a3, a1, -1         # Right index = size - 1 (2 NOPs after a1 write)
    nop
    nop
    
    jal ra, mergesort       # Call mergesort
    nop
    nop
    nop
    
    # Exit program
    addi a7, x0, 10
    nop
    nop
    jal program_end

# mergesort(array, size, left, right)
# a0 = array address, a1 = array size, a2 = left, a3 = right
mergesort:
    bge a2, a3, mergesort_base_return  # if left >= right, return
    nop

    addi sp, sp, -20
    nop
    nop
    nop

    sw ra, 16(sp)
    sw s0, 12(sp)           # Save left
    sw s1, 8(sp)            # Save right
    sw s2, 4(sp)            # Save mid
    sw s3, 0(sp)            # Save array addr
    
    sub t0, a3, a2          # t0 = right - left
    addi s0, a2, 0          # s0 = left
    addi s1, a3, 0          # s1 = right
    nop
    srli t0, t0, 1          # t0 = (right - left) / 2
    addi s3, a0, 0          # s3 = array address
    nop
    add s2, s0, t0          # s2 = mid
    nop
    nop
    
    nop
    nop
    nop
    nop

    addi a0, s3, 0          # Prepare args for left half
    nop
    nop
    nop
    nop
    addi a2, s0, 0
    nop
    nop
    nop
    nop
    addi a3, s2, 0          # a3 = mid
    nop
    nop
    nop
    nop

    jal ra, mergesort       # Sort left half
    nop
    nop
    nop
    
    # Sort right half: mergesort(array, size, mid+1, right)
    nop
    nop
    nop
    nop

    addi a0, s3, 0
    nop
    nop
    nop
    nop
    addi a3, s1, 0
    nop
    nop
    nop
    nop
    addi a2, s2, 1          # left = mid + 1
    nop
    nop
    nop
    nop
    
    jal ra, mergesort
    nop
    nop
    nop

    # Merge the two halves
    nop
    nop
    nop
    nop

    addi a0, s3, 0
    nop
    nop
    nop
    nop
    addi a2, s0, 0          # left
    nop
    nop
    nop
    nop
    addi a3, s2, 0          # mid
    nop
    nop
    nop
    nop
    addi a4, s1, 0          # right
    nop
    nop
    nop
    nop

    jal ra, merge
    nop
    nop
    nop

mergesort_end:
    lw ra, 16(sp)
    nop
    nop
    lw s0, 12(sp)
    nop
    nop
    lw s1, 8(sp)
    nop
    nop
    lw s2, 4(sp)
    nop
    nop
    lw s3, 0(sp)
    nop
    nop
    addi sp, sp, 20
    nop
    nop
    jalr x0, ra, 0
    nop
    nop
    nop

mergesort_base_return:
    jalr x0, ra, 0              # Just return, don't touch stack
    nop
    nop
    nop

# merge(array, left, mid, right)
# a0 = array, a1 = size, a2 = left, a3 = mid, a4 = right
merge:
    addi sp, sp, -32
    sw ra, 28(sp)
    sw s0, 24(sp)           # i (left pointer)
    sw s1, 20(sp)           # j (right pointer)
    sw s2, 16(sp)           # k (temp array index)
    sw s3, 12(sp)           # array address
    sw s4, 8(sp)            # left
    sw s5, 4(sp)            # mid
    sw s6, 0(sp)            # right
    
    addi s3, a0, 0          # Save array address
    addi s4, a2, 0          # Save left
    addi s5, a3, 0          # Save mid
    addi s6, a4, 0          # Save right
    addi s0, a2, 0          # i = left
    lui t6, 0x10010         # Load temp array address
    nop
    nop
    addi s1, a3, 1          # j = mid + 1
    addi s2, a2, 0          # k = left
    addi t6, t6, 68         # temp offset = 16*4 + 4 = 68 bytes
    nop
    nop

merge_loop:
    bgt s0, s5, copy_right  # if i > mid, copy remaining right
    nop
    nop
    nop
    
    bgt s1, s6, copy_left   # if j > right, copy remaining left
    nop
    nop
    nop
    
    # Load array[i]
    slli t0, s0, 2          # t0 = i * 4
    nop
    nop
    add t0, s3, t0          # t0 = &array[i]
    nop
    nop
    lw t1, 0(t0)            # t1 = array[i]
    
    # Load array[j]
    slli t0, s1, 2          # t0 = j * 4
    nop
    nop
    add t0, s3, t0          # t0 = &array[j]
    nop
    nop
    lw t2, 0(t0)            # t2 = array[j]
    nop
    nop

    # Compare
    blt t1, t2, store_left
    nop
    jal x0, store_right_elem
    nop
    
store_right_elem:
    slli t0, s2, 2          # Calculate temp[k] address
    addi s1, s1, 1          # j++
    nop
    nop
    nop
    add t0, t6, t0
    addi s2, s2, 1          # k++
    nop
    sw t2, 0(t0)            # temp[k] = array[j]

    jal x0, merge_loop
    nop
    nop
    nop

store_left:
    slli t0, s2, 2
    addi s0, s0, 1          # i++
    nop
    nop
    nop
    add t0, t6, t0
    addi s2, s2, 1          # k++
    nop
    sw t1, 0(t0)            # temp[k] = array[i]

    jal x0, merge_loop
    nop
    nop
    nop

copy_left:
    bgt s0, s5, copy_back   # if i > mid, done copying
    nop
    nop
    nop
    
    slli t0, s0, 2
    nop
    nop
    add t0, s3, t0
    nop
    nop
    lw t1, 0(t0)            # t1 = array[i]
    
    slli t0, s2, 2
    addi s0, s0, 1          # i++
    nop
    nop
    add t0, t6, t0
    addi s2, s2, 1          # k++
    nop
    sw t1, 0(t0)            # temp[k] = array[i]
    
    jal x0, copy_left
    nop
    nop
    nop

copy_right:
    bgt s1, s6, copy_back   # if j > right, done copying
    nop
    nop
    nop
    
    slli t0, s1, 2
    nop
    nop
    add t0, s3, t0
    nop
    nop
    lw t1, 0(t0)            # t1 = array[j]
    
    slli t0, s2, 2
    addi s1, s1, 1          # j++
    nop
    nop
    add t0, t6, t0
    addi s2, s2, 1          # k++
    nop
    sw t1, 0(t0)            # temp[k] = array[j]
    
    jal x0, copy_right
    nop
    nop
    nop

copy_back:
    addi t0, s4, 0          # t0 = left
    nop
    nop
    nop

copy_back_loop:
    bgt t0, s6, merge_end   # if index > right, done
    nop
    nop
    nop
    
    slli t1, t0, 2
    nop
    nop
    nop
    add t2, t6, t1          # t2 = &temp[index]
    nop
    nop
    nop
    lw t3, 0(t2)            # t3 = temp[index]
    
    add t2, s3, t1          # t2 = &array[index]
    addi t0, t0, 1          # index++
    nop
    nop
    sw t3, 0(t2)            # array[index] = temp[index]
    
    jal x0, copy_back_loop
    nop
    nop
    nop

merge_end:
    lw ra, 28(sp)
    nop
    nop
    lw s0, 24(sp)
    nop
    nop
    lw s1, 20(sp)
    nop
    nop
    lw s2, 16(sp)
    nop
    nop
    lw s3, 12(sp)
    nop
    nop
    lw s4, 8(sp)
    nop
    nop
    lw s5, 4(sp)
    nop
    nop
    lw s6, 0(sp)
    nop
    nop
    addi sp, sp, 32
    nop
    nop
    jalr x0, ra, 0
    nop
    nop
    nop
    
program_end:
    wfi