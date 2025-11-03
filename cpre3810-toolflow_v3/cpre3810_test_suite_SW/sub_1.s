
addi x1, x0, 60     # load test values
addi x2, x0, 120 
addi x3, x0, -60     # load test values
addi x4, x0, -120     
nop
sub x1, x1, x2     # perform test
nop
sub x3, x3, x4     # perform test
wfi               

