.data
# File
promptFilename:	.asciiz "Enter the location of the dictionary file.\n"
badFilename:	.asciiz "File does not exist. Try again.\n"
fileName:	.asciiz ""	# Name of dictionary file
inputSize:	.word	1024	# Maximum length of input filename
fileBuffer:	.space	1024	# Reserve 1024 bytes for the file buffer

# Pictures
picture: 	.asciiz "_______\n|   |  \\|\n        |\n        |\n        |  ",
			"\n        |\n        |\n        |\n       ---\n",
			"_______\n|   |  \\|\n    O   |\n        |\n        |  ",
			"\n        |\n        |\n        |\n       ---\n",
			"_______\n|   |  \\|\n    O   |\n    |   |\n    |   |  ",
			"\n        |\n        |\n        |\n       ---\n",
			"_______\n|   |  \\|\n    O   |\n   \\|   |\n    |   |  ",
			"\n        |\n        |\n        |\n       ---\n",
			"_______\n|   |  \\|\n    O   |\n   \\|/  |\n    |   |  ",
			"\n        |\n        |\n        |\n       ---\n",
			"_______\n|   |  \\|\n    O   |\n   \\|/  |\n    |   |  ",
			"\n   / \\  |\n        |\n        |\n       ---\n",

clearScreen:	.asciiz "[2J"
underscore:  	.asciiz "_"
sampleword:  	.asciiz "s _ s t _ m d"

#Word bank
Word1:		.asciiz "jazz"
Word2:		.asciiz "strenghts"
Word3:		.asciiz "gypsy"
Word4:		.asciiz "rhythmic"
Word5:		.asciiz "cognac"
Word6:		.asciiz "jukebox"
Word7:		.asciiz "sprightly"
Word8:		.asciiz "asthma"
Word9:		.asciiz "orphan"
Word10:		.asciiz "months"
Word11:		.asciiz "czar"
Word12:		.asciiz "depths"
Word13:		.asciiz "geniuses"
Word14:		.asciiz "withhold"
Word15:		.asciiz "powwow"
Word16:		.asciiz "bookkeeper"
Word17:		.asciiz "kamikaze"
Word18:		.asciiz "fettuccine"
Word19:		.asciiz "quagmire"
Word20:		.asciiz "mannequin"
Word21:		.asciiz "caribou"
Word22:		.asciiz "nymph"
Word23:		.asciiz "skiing"
Word24:		.asciiz "queueing"
Word25:		.asciiz "symphony"
Word26:		.asciiz "crypt"
Word27:		.asciiz "wintry"
Word28:		.asciiz "twelfth"
Word29:		.asciiz "sequoia"
Word30:		.asciiz "gauntlet"
Word31:		.asciiz "zoology"
Word32:		.asciiz "unscrupulous"
Word33:		.asciiz "tympani"
Word34:		.asciiz "furlough"
Word35:		.asciiz "coffee"
Word36:		.asciiz "papaya"
Word37:		.asciiz "brouhaha"
Word38:		.asciiz "impromptu"
Word39:		.asciiz "cyclists"
Word40:		.asciiz "plateaued"
Word41:		.asciiz "cushion"
Word42:		.asciiz "alfalfa"
Word43:		.asciiz "jambalaya"
Word44:		.asciiz "ukulele"
Word45:		.asciiz "anchovy"
Word46:		.asciiz "messiah"
Word47:		.asciiz "buoyed"
Word48:		.asciiz "rendezvous"
Word49:		.asciiz "paprika"
Word50:		.asciiz "catchphrase"

Words:		.word	Word1, Word2, Word3, Word4, Word5, Word6, Word7, Word8, Word9, Word10, Word11, Word12, Word13, Word14, Word15, Word16, Word17, Word18, Word19, Word20, Word21, Word22, Word23, Word24, Word25, Word26, Word27, Word28, Word29, Word30, Word31, Word32, Word33, Word34, Word35, Word36, Word37, Word38, Word39, Word40, Word41, Word42, Word43, Word44, Word45, Word46, Word47, Word48, Word49, Word50

Length:		.word	13

#String
Welcome:	.asciiz "Welcome to Hangman"
guessPrompt:	.asciiz "Guess the word."
Yes:		.asciiz "Yes! "
No:			.asciiz "No! "

Guess:		.asciiz "Guess a letter.\n"
rightWord:	.asciiz "The correct word was:\n"
NewLine:	.asciiz "\n"

Goodbye:	.byte		#addresses?

Guessed:	.space	32	#guessed letters

GuessSoFar:	.space	24 	#s _ s t e _ d
.text

###############################################################################
# Begin program
.text
main:
	jal 	openFile
	jal 	init
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
	bne 	$t3, 0x0a, t0PlusPlus
	sb 	$zero, fileName($t0)

t0PlusPlus:
	addi 	$t0, $t0, 1
	j 	clean

openFRead:	# Open file for reading
	li 	$v0, 13		# 13 is function code for opening a file
	la 	$a0, fileName	# fileName is the name of the file
	li 	$a1, 0		# Open for reading (flags are 0: read, 1: write)
	li 	$a2, 0		# ignore the mode
	syscall			# file descriptor returned in v0
	move 	$s7, $v0	# Store the file descriptor in s7
		
checkFileValidity:	# Make sure the file opened correctly
	li 	$t0, -1				# Set t0 = -1
	beq 	$s7, $t0, incorrectInput	# If descriptor = -1, then jump back and re-get input

	jr 	$ra				# Return to caller
	
#	End openFile
#------------------------------------------------------------------------

init:
	li 	$s0, 0		# $s0 will hold the number of turns taken.
	jr 	$ra
	
runGame:
	jal 	promptChar 		#Ask for a character
	move 	$a2, $v0
	la 	$a1, Word50 			# We need to replace Word50 with the proper word
	la 	$a0, Guessed
	jal 	updateGuess 			# make sure we have not previously guessed this
	bne 	$v0, $0, wordDoesContain 	# Continue as if it was a correct answer
	la 	$a3, GuessSoFar
	jal 	generateWordToDisplay 		# Will return _ _ _ A _ B _ C
	jal 	strContains 		# test for correctness
	beq 	$v0, $0, doesNotContain

wordDoesContain: 				#correct
	jal 	drawMan
	j 	runGame

doesNotContain: 				#possibly incorrect
	# if incorrect:
	addiu 	$s0, $s0, 1  			#Increment incorrect guesses
	jal 	drawMan
	beq 	$s0, 5, outOfGuesses
	j 	runGame

drawMan:			# Expects $s0 to hold the number of turns taken.
	
	li 	$v0, 11 			# Print a character
	li 	$a0, 0x1b  			# Ascii escape
	syscall

	li 	$v0, 4 				# Print a string
	la 	$a0, clearScreen 		# Ascii escape sequence to clear screen
	syscall

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
	#:(

#----------------------------------------------------------
#	prompt character
promptChar:
	addi 	$sp, $sp, -12		#allocate
	sw 	$ra, 0($sp)		#store old ra
	sw 	$a0, 4($sp)		#store old a0
	sw 	$s0, 8($sp)		#store old s0
	
	li 	$v0, 12			#print string syscall
	syscall				#v0 contains a character
	
	move 	$s0, $v0		#character saved temporarily
	
	la 	$a0, NewLine
	jal 	print			#print new line
	jal 	print			#print new line
	
	move 	$v0, $s0		#character back in return register
	
	lw	$ra, 0($sp)		#load old ra
	lw 	$a0, 4($sp)		#load old a0
	lw 	$s0, 8($sp)		#load old s0
	addi 	$sp, $sp, 12		#deallocate
	jr 	$ra			#return
	
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
