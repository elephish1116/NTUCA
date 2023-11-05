.globl __start

.rodata
    division_by_zero: .string "division by zero"

.text
__start:
    # Read first operand
    li a0, 5
    ecall
    mv s0, a0
    # Read operation
    li a0, 5
    ecall
    mv s1, a0
    # Read second operand
    li a0, 5
    ecall
    mv s2, a0
###################################
#  TODO: Develop your calculator  #
#                                 #
###################################
    beq s1, x0, addition
    li t1, 1
    beq s1, t1, subtraction
    addi t1, t1, 1
    beq s1, t1, multiplication
    addi t1, t1, 1
    beq s1, t1, division
    addi t1, t1, 1
    beq s1, t1, minimum
    addi t1, t1, 1
    beq s1, t1, power
    addi t1, t1, 1
    beq s1, t1, factorial
#power counter
    li t0, 0
    
addition:
    add s3, s0, s2
    beq x0, x0, output
    
subtraction:
    sub s3, s0, s2
    beq x0, x0, output
    
multiplication:
    mul s3, s0, s2
    beq x0, x0, output

division:
    beq s2, x0, division_by_zero_except
    div s3, s0, s2
    beq x0, x0, output
    
minimum:
    slt x5, s2, s0
    beq x5, x0, s0_smaller
    add s3, s2, x0
    beq x0, x0, output
s0_smaller:
    add s3, s0, x0
    beq x0, x0, output
    
power:
    add x6, s0, x0
    addi s3, x0, 1
    loop:
        beq t0, s2, output
        mul s3, s3, s1
        addi t0, t0, 1
        jal x0, loop
    
factorial:
    addi s3, x0, 1
    addi x5, x0, 1
    loop2:
        blt s0, x5, output
        mul s3, s0, s3
        addi s0, s0, -1
        jal x0, loop2
output:
    # Output the result
    li a0, 1
    mv a1, s3
    ecall

exit:
    # Exit program(necessary)
    li a0, 10
    ecall

division_by_zero_except:
    li a0, 4
    la a1, division_by_zero
    ecall
    jal zero, exit
