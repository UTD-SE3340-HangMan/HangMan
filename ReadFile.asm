.data 
ifile:	.asciiz	"words.txt"      # filename of input
buffer:	.space	1024

.text
# Open a file for reading
li		$v0, 13     # system call for open file
la		$a0, ifile	# Store fileName in a0
li		$a1, 0      # Open for reading
syscall				# open a file (file descriptor returned in $v0)
move 	$a0, $v0	# save the file descriptor in a0

#read from file
li		$v0, 14       # system call for read from file
la		$a1, buffer   # address of buffer to which to read
li		$a2, 1024     # hardcoded buffer length
syscall	# read from file



# Close the file 
li		$v0, 16		# system call for close file
move	$a0, $s6	# file descriptor to close
syscall			# close file
# Exit program
li		$v0, 10	# Exit code
syscall			# Exits cleanly