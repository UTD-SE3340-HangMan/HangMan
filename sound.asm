.data
debugstr:		.asciiz "Debug Split\n"

	.text
main:
	jal 	rightSound
	jal	debug
	jal	wrongSound
	jal	debug
	jal	winSound
	jal 	debug
	jal	loseSound

	li	$v0, 10
	syscall

debug:
	li	$v0, 4
	la	$a0, debugstr
	syscall

	li	$v0, 32
	li	$a0, 1000
	syscall

	jr	$ra

rightSound:
	li	$a2, 0	# instrument ID
	li	$a3, 127# volume
	li	$v0, 33

	li	$a0, 55
	li	$a1, 100
	syscall

	li	$v0, 32
	li	$a0, 65
	syscall

	li	$a2, 0	# instrument ID
	li	$a3, 127# volume
	li	$v0, 33

	li	$a0, 60
	li	$a1, 100
	syscall

	jr $ra

wrongSound:
	li	$a2, 0	# instrument ID
	li	$a3, 127# volume
	li	$v0, 33

	li	$a0, 60
	li	$a1, 100
	syscall

	li	$v0, 32
	li	$a0, 65
	syscall

	li	$a2, 0	# instrument ID
	li	$a3, 127# volume
	li	$v0, 33

	li	$a0, 55
	li	$a1, 100
	syscall

	jr $ra

winSound:
	li	$a2, 0	# instrument ID
	li	$a3, 127# volume
	li	$v0, 33

	li	$a0, 69
	li	$a1, 100
	syscall

	li	$a0, 75
	li	$a1, 100
	syscall

	li	$a0, 89
	li	$a1, 100
	syscall

	li	$a0, 78
	li	$a1, 250
	syscall

	li	$a0, 85
	li	$a1, 100
	syscall

	li	$a0, 90
	li	$a1, 250
	syscall

	li	$a0, 85
	li	$a1, 250
	syscall

	li	$a0, 90
	li	$a1, 250
	syscall

	li	$a0, 94
	li	$a1, 500
	syscall

	jr $ra

loseSound:
	li	$a2, 0	# instrument ID
	li	$a3, 127# volume
	li	$v0, 33

	li	$a0, 55
	li	$a1, 500
	syscall

	li	$a0, 54
	li	$a1, 500
	syscall

	li	$a0, 51
	li	$a1, 500
	syscall

	li	$a0, 50
	li	$a1, 1500
	syscall

	jr	$ra
