.data
debugstr:	.asciiz "Debug Split\n"

.text
main:	
	jal	volumeVoice
	jal 	rightSound
	jal	debug
	jal	volumeVoice
	jal	wrongSound
	jal	debug
	jal	volumeVoice
	jal	winSound
	
	li	$v0, 10
	syscall

debug:
	li	$v0, 4
	la	$a0, debugstr
	syscall
	jr	$ra

volumeVoice:
	li	$a2, 0	# instrument ID
	li	$a3, 127# volume
	li	$v0, 33
	jr	$ra
	
rightSound:
	li	$a0, 69
	li	$a1, 250
	syscall

	li	$a0, 79
	li	$a1, 250
	syscall

	li	$a0, 89
	li	$a1, 250
	syscall
	
	jr $ra

wrongSound:

	li	$a0, 89
	li	$a1, 250
	syscall

	li	$a0, 79
	li	$a1, 250
	syscall
	
	li	$a0, 69
	li	$a1, 250
	syscall

	jr $ra

winSound:

	li	$a0, 69
	li	$a1, 250
	syscall

	li	$a0, 79
	li	$a1, 250
	syscall
	
	li	$a0, 89
	li	$a1, 250
	syscall

	li	$a0, 79
	li	$a1, 250
	syscall

	li	$a0, 89
	li	$a1, 250
	syscall

	li	$a0, 99
	li	$a1, 250
	syscall

	li	$a0, 89
	li	$a1, 250
	syscall

	li	$a0, 99
	li	$a1, 250
	syscall

	li	$a0, 109
	li	$a1, 250
	syscall

	li	$a0, 119
	li	$a1, 250
	syscall

	li	$a0, 120
	li	$a1, 250
	syscall


	jr $ra