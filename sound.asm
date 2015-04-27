.text
main:
	jal rightGuess
	jal wrongGuess
	
	li	$v0, 10
	syscall

rightGuess:
	li	$v0, 33
	li	$a0, 69
	li	$a1, 250
	li	$a2, 1
	li	$a3, 127
	syscall

	li	$v0, 33
	li	$a0, 100
	li	$a1, 250
	li	$a2, 1
	li	$a3, 127
	syscall

	li	$v0, 33
	li	$a0, 150
	li	$a1, 250
	li	$a2, 1
	li	$a3, 127
	syscall
	
	jr $ra

wrongGuess:
	li	$v0, 33
	li	$a0, 150
	li	$a1, 250
	li	$a2, 1
	li	$a3, 127
	syscall

	li	$v0, 33
	li	$a0, 100
	li	$a1, 250
	li	$a2, 1
	li	$a3, 127
	syscall

	li	$v0, 33
	li	$a0, 69
	li	$a1, 250
	li	$a2, 1
	li	$a3, 127
	syscall

	jr $ra


