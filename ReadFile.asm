.data
fileName:	.ascii 	""	# filename for input
filePrompt:   .asciiz "Please enter the input file name: "
endLine:.asciiz "\n"	# Newline character
buffer: .space 1024		# Buffer of 1024 bytes

.text
getFileName:	# Prompt for name of word file
	# Display prompt
	li $v0, 4
	la $a0, filePrompt
    syscall
	# Get user input
	li	$v0, 8
	la	$a0, fileName
	li	$a1, 21
	syscall		# Store up to 21 characters as "file"
	

readFile:	# Read the file
	# Open file for reading
	li   $v0, 13       # system call for open file
	la   $a0, fileName     # input file name
	li   $a1, 0        # flag - 0 for reading
	li   $a2, 0        # mode is ignored
	syscall            # open a file 
	move $s0, $v0      # save the file descriptor in $s0

	# Read from the file just opened into $s1
	li		$v0, 14			# system call for reading from file
	move	$a0, $s0		# file descriptor 
	la		$a1, buffer		# address of buffer from which to read
	li		$a2, 1024		# buffer length
	syscall            # read from file

end:	# Close the file in $s0 and end the program
	# Close file
	jal fileClose

	# Syscall to end program
    li $v0, 10
    syscall

fileClose:	# Close the file in $s0
    li   $v0, 16       # system call for close file
    move $a0, $s0      # file descriptor to close
    syscall            # close file
	jr $ra	# return to caller
