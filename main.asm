.data
# File
promptFilename:	.asciiz "Enter the location of the dictionary file.\n"
badFilename:	.asciiz "File does not exist. Try again.\n"
fileName:	.asciiz ""	# Name of dictionary file
inputSize:	.word	1024	# Maximum length of input filename
fileBuffer:	.space	1024	# Reserve 1024 bytes for the file bufrandomNext

theWord:	.space	24	# THE WORD


# Pictures
picture: 	.asciiz "_______\n|   |  \\|\n        |\n        |\n        |  ",
			"\n        |\n        |\n        |\n       ---\n",
			"_______\n|   |  \\|\n    O   |\n        |\n        |  ",
			"\n        |\n        |\n        |\n       ---\n",
			"_______\n|   |  \\|\n    O   |\n    |   |\n        |  ",
			"\n        |\n        |\n        |\n       ---\n",
			"_______\n|   |  \\|\n    O   |\n    |   |\n    |   |  ",
			"\n        |\n        |\n        |\n       ---\n",
			"_______\n|   |  \\|\n    O   |\n   \\|   |\n    |   |  ",
			"\n        |\n        |\n        |\n       ---\n",
			"_______\n|   |  \\|\n    O   |\n   \\|/  |\n    |   |  ",
			"\n        |\n        |\n        |\n       ---\n",
			"_______\n|   |  \\|\n    O   |\n   \\|/  |\n    |   |  ",
			"\n   /    |\n        |\n        |\n       ---\n",
			"_______\n|   |  \\|\n    O   |\n   \\|/  |\n    |   |  ",
			"\n   / \\  |\n        |\n        |\n       ---\n",

clearScreen:	.asciiz "[2J"
underscore:  	.asciiz "_"

Length:		.word	13

#String
Welcome:	.asciiz "Welcome to Hangman!\n"
Yes:		.asciiz "Yes!\n"
No:		.asciiz "No!\n"
already:	.asciiz "You already guessed that letter.\n"

Guess:		.asciiz "Guess a letter.\n"
rightWord:	.asciiz "The correct word was: "
NewLine:	.asciiz "\n"

lose:		.asciiz "You Lose!\n"
win:		.asciiz "You Win!\n"
Goodbye:	.byte		#addresses?

Guessed:	.space	32	#guessed letters

GuessSoFar:	.space	24 	#s _ s t e _ d
.text

###############################################################################
# Begin program
.text
main:
	li	$v0, 4
	la	$a0, Welcome
	syscall

	jal 	openFile
	jal	randomGenerator
	li 	$s0, 0		# $s0 will hold the number of turns taken.
	jal 	runGame

#----------------------------------------------------------
incorrectInput:	# File did not exist
	li 	$v0, 4			# 4 is function code for printing a string
	la 	$a0, badFilename	# Load string into a0
	syscall 			# Print the message
	
#	Open the file in filename in read mode
#	Read the first word of the file
openFile:
getFileName:			# Get file path from user
	# Display prompt
	li 	$v0, 4			# 4 is function code for printing a string
	la 	$a0, promptFilename	# Load string into a0
	syscall				# Print the prompt

	# Get user input
	li 	$v0, 8		# 8 is function code for reading a string
	la 	$a0, fileName	# Load fileName into a0
	lw 	$a1, inputSize	# Load contents of inputSize into a1
	syscall			# Input now stored in fileName

sanitizeFileName:		# Fix the input
	li 	$t0, 0       	#loop counter
	lw 	$t1, inputSize	#loop end

clean:
	beq 	$t0, $t1, openFRead
	lb 	$t3, fileName($t0)
	bne 	$t3, 0x0a, t0PlusPlus	# We are not at newline
	sb 	$zero, fileName($t0)	# Null-terminate fileName
	j	openFRead
t0PlusPlus:
	addi 	$t0, $t0, 1
	j 	clean

openFRead:	# Open file for reading
	li 	$v0, 13		# 13 is function code for opening a file
	la 	$a0, fileName	# fileName is the name of the file
	li 	$a1, 0		# Open for reading (flags are 0: read, 1: write)
	li 	$a2, 0		# ignore the mode
	syscall			# file descriptor returned in v0
	move 	$a0, $v0	# Store the file descriptor in a0
		
checkFileValidity:	# Make sure the file opened correctly
	li 	$t0, -1				# Set t0 = -1
	beq 	$a0, $t0, incorrectInput	# If descriptor = -1, then jump back and re-get input

readFile:					# Read from the file itself
	li	$v0, 14				# 14 is the function code for reading a file
	la	$a1, fileBuffer			# Read into fileBuffer
	li	$a2, 1024			# Read no more than 1024 bytes
	syscall

closeFile:					# Because we're good people
	li	$v0, 16
	syscall
	
	jr 	$ra				# Return to caller
	
#	End openFile
#------------------------------------------------------------------------

#------------------------------------------------------------------------
#	Get a random word
#	We know there are exactly 50 words.

randomGenerator:
	li	$v0, 30		# 30 is the function code for getting epoch time
	syscall			# Low-order 32-bits are in $a0.  High-order are in $a1

	li	$v0, 40		# 40 is the function code for setting the random seed
	move	$a1, $a0	# Put the part of the time that actually changes every second in $a0
	li	$a0, 0		# Random generator 0
	syscall			# Random generator is now randomly seeded

	li	$v0, 42		# 42 is the function code for
	li	$a1, 50		# Our random number will be 0<=num<50
	li	$a0, 0		# 0 is my favorite random number generator
	syscall			# We now have a random number in $a0

getRandomWord:
	la	$t1, fileBuffer		# First character of our fileBuffer
	li	$t0, 0			# Counter begins with 0
	la	$t2, theWord		# The Word

getRandomWordLoop:
	lb	$t3, 0($t1)		# Load the fileBuffer's character
	addi	$t1, $t1, 1		# Next character
	beq     $t3, 0x0a, randomNext	# We are at newline
	beq	$t0, $a0, rAddLetter	# Add the letter to the word
	j	getRandomWordLoop

randomNext:
	beq     $t0, $a0, finalizeWord	# Null-terminate the word
	addi	$t0, $t0, 1		# Increment our counter
	j getRandomWordLoop

rAddLetter:
	sb	$t3, 0($t2)		# Put the letter into the word
	addi	$t2, $t2, 1		# Next letter of the word
	j	getRandomWordLoop

finalizeWord:
	li	$t3, 0x00
	sb	$t3, 0($t2)		# Null-terminate theWord

	jr	$ra

#	End getRandomWord
#------------------------------------------------------------------------
	
runGame:
	jal 	promptChar 		#Ask for a character
	move 	$a2, $v0
	jal	clearTerm
	la 	$a1, theWord 			# We need to replace theWord with the proper word
	la 	$a0, Guessed
	jal 	updateGuess 			# make sure we have not previously guessed this
	bne 	$v0, $0, alreadyGuessed 	# Continue as if it was a correct answer
	la 	$a3, GuessSoFar
	jal 	generateWordToDisplay 		# Will return _ _ _ A _ B _ C
	jal 	strContains 		# test for correctness
	beq 	$v0, $0, doesNotContain

	# So it was a correct guess
	la	$a0, Yes
	li	$v0, 4
	syscall
	j	wordDoesContain

alreadyGuessed:
	la	$a0, already			# "You have already guessed the letter"
	li	$v0, 4
	syscall

wordDoesContain: 				#correct
	jal 	drawMan
	j 	runGame

doesNotContain: 				#possibly incorrect
	la	$a0, No
	li	$v0, 4
	syscall

	addiu 	$s0, $s0, 1  			#Increment incorrect guesses
	jal 	drawMan
	beq 	$s0, 7, outOfGuesses
	j 	runGame

clearTerm:
	li 	$v0, 11 			# Print a character
	li 	$a0, 0x1b  			# Ascii escape
	syscall

	li 	$v0, 4 				# Print a string
	la 	$a0, clearScreen 		# Ascii escape sequence to clear screen
	syscall
	jr	$ra	

drawMan:			# Expects $s0 to hold the number of turns taken.
	li 	$t1, 93 			# Each hangman guy is exactly 93 characters long
	mul 	$t0, $s0, $t1 			# Multiply it by the current number of moved used
	li 	$v0, 4 				# Print a string
	la 	$a0, picture 			# top half of the hangman picture
	addu 	$a0, $a0, $t0 			# plus our offset for the number of moves taken
	syscall
	addi 	$t2, $a0, 50 			# Calculate the bottom half of our hangman picture, save it in temp.
	
	la 	$a0, GuessSoFar 		# Print the current status of the word
	syscall

	move 	$a0, $t2 			# Get back the bottom half of our hangman picture from temp
	syscall
	jr 	$ra

outOfGuesses:
	li	$v0, 4				# 4 is the function code for print string
	la	$a0, lose			# "You Lose!\n"
	syscall

	la	$a0, rightWord			# "The correct words was"
	syscall

	la	$a0, theWord			# The proper word
	syscall

Exit:
	li	$v0, 10				# 10 is the function code for terminate
	syscall

#----------------------------------------------------------
#	prompt character
promptChar:
	addi 	$sp, $sp, -12		# Allocate
	sw 	$ra, 0($sp)		# Store old ra
	sw 	$a0, 4($sp)		# Store old a0
	sw 	$s0, 8($sp)		# Store old s0
	
	li	$v0, 4			# 4 is the function code for printing a string
	la	$a0, Guess 		# Guess a character
	syscall

	li 	$v0, 12			# read string syscall
	syscall				# v0 contains a character
	
	move 	$s0, $v0		# Character saved temporarily
	
	la 	$a0, NewLine
	jal 	print			# Print new line
	jal 	print			# Print new line
	
	move 	$v0, $s0		# Character back in return register
	
	lw	$ra, 0($sp)		# Load old ra
	lw 	$a0, 4($sp)		# Load old a0
	lw 	$s0, 8($sp)		# Load old s0
	addi 	$sp, $sp, 12		# Deallocate
	jr 	$ra			# Return
	
#	end prompt character
#----------------------------------------------------------

#----------------------------------------------------------
#	check to see if a string contains a given character

strContains:
	addi 	$sp, $sp, -4	#allocate 4 bytes
	sw 	$a1, 0($sp)	#store old a0
	li 	$v0, 0		#set $v0 to 0 or false

strContainsIter:
	lb 	$t0, 0($a1)			#load character in from string
	beq 	$t0, $0, strContainsIterBrk	#stop loop if end of string is reached
	beq 	$t0, $a2, charFound		#branch if character matches
	addi 	$a1, $a1, 1			#increment string address to continue scanning
	j 	strContainsIter			#jump to top of loop
	
charFound:
	li 	$v0, 1		#if character found return value = 1

strContainsIterBrk:
	lw 	$a1, 0($sp)	#load old a0
	addi 	$sp, $sp, 4	#deallocate
	jr 	$ra		#return

#	end character check
#----------------------------------------------------------
	
#----------------------------------------------------------
#	guessed letter

updateGuess:
	addi 	$sp, $sp, -8			#allocate 4 bytes
	sw 	$a1, 0($sp)			#store old a0
	sw 	$a0, 4($sp)			#store old a1
	li 	$v0, 0 				#Whether or not it was found

updateGuessIter:
	lb $t0, 0($a0)				#load character from string
	beq $t0, $0, updateGuessIterBrk		#stop loop if its the end on string
	bne $t0, $a2, charNotInWord		#branch if character doens match
	li $v0, 1

charNotInWord:
	addi $a0, $a0, 1			#increment guessed buffer
	#addi $a2, $a2, 1			#increment string position
	j updateGuessIter
	
updateGuessIterBrk:
	sb $a2, 0($a0)				#store passed character in position
	lw $a0, 4($sp)				#load old a1
	lw $a1, 0($sp)				#load old a0
	addi $sp, $sp, 8			#deallocate
	jr $ra					#return
	
#	end guessed letter
#----------------------------------------------------------

#----------------------------------------------------------
#	print string

print:
	li 	$v0, 4	#print string
	syscall
	
	jr 	$ra

#	end print string
#----------------------------------------------------------

#----------------------------------------------------------
#	print number

printNum:
	li 	$v0, 1	#print number
	syscall
	
	jr 	$ra

#	end print number
#----------------------------------------------------------


generateWordToDisplay:
	addi 	$sp, $sp, -12		#allocate 4 bytes
	sw 	$a0, 0($sp)		#store old a0
	sw 	$a1, 4($sp)		#store old a1
	sw 	$a3, 8($sp)
	li 	$v0, 0 			#Whether or not it was found
	move 	$t1, $a0
	lb 	$t3, underscore

generateWordToDisplayLoop:
	lb 	$t2, 0($a1)				# Fully correct word
	lb 	$t0, 0($a0) 				# Every guessed letter
	beq 	$t0, $0, generateWordToDisplayEOW 	# stop loop if its the end on string
	beq 	$t0, $t2, addLetter 			# if one of our guesses is correct
generateWordToDisplayLoopContinue:
	sb 	$t3, 0($a3)
	addi 	$a0, $a0, 1
	j 	generateWordToDisplayLoop

addLetter:
	move 	$t3, $t2
	j 	generateWordToDisplayLoopContinue

generateWordToDisplayEOW:
	addi 	$a3, $a3, 1 			# go to the next location in our word to display
	move 	$a0, $t1 			# go to the beginning of our guessed letters
	addi 	$a1, $a1, 1 			# go to the next letter in our fully correct word
	lb 	$t5, 0($a1)
	lb 	$t3, underscore
	beq	$t5, $0 generateWordToDisplayEND
	j 	generateWordToDisplayLoop

generateWordToDisplayEND:
	lw 	$a3, 8($sp)
	lw 	$a1, 4($sp)	#load old a1
	lw 	$a0, 0($sp)	#load old a0
	addi 	$sp, $sp, 12	#deallocate
	jr 	$ra		#return
