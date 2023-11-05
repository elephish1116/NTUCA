.global __start

.text

__start:
  li a0, 5
  ecall
  call rec
  mv a1, a0
  j output

rec:
  # a0 == 0 || 1, return
  beqz a0, base_case
  addi t0, a0, -1
  beqz t0, base_case
  
  addi sp, sp, -8
  sw a0, 0(sp)
  sw ra, 4(sp)
  
  addi a0, a0, -1
  call rec
  lw t0, 0(sp) # t0 = n
  sw a0, 0(sp) # T(n-1)
  addi a0, t0, -2 # a0 = n-2
  call rec
  lw t0, 0(sp) # T(n-1)
  add t0, t0, t0
  add a0, t0, a0
  lw ra, 4(sp)
  # we don't need saved a0 anymore
  addi sp, sp, 8
  ret
  
base_case:
  ret
  
output:
  li a0, 1
  ecall
  li a0, 10
  ecall