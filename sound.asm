.text
main:	
	jal	volumeVoice
	jal rightGuess
	
	li	$v0, 10
	syscall

volumeVoice:
	li	$a2, 0	# instrument ID
	li	$a3, 127# volume
	li	$v0, 33
	jr	$ra
	
rightGuess:
	li	$a0, 69
	li	$a1, 350
	syscall

	li	$a0, 79
	li	$a1, 350
	syscall

	li	$a0, 89
	li	$a1, 350
	syscall
	
	jr $ra