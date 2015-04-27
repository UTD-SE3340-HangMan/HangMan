.data
# File
	Prompt_Filename:	.asciiz "Enter the location of the dictionary file.\n"
	Incorrect_Filename:	.asciiz "File does not exist. Try again.\n"
	fileName:			.asciiz ""		# Name of dictionary file
	inputSize:			.word	1024	# Maximum length of input filename
	fileBuffer:			.space	1024	# Reserve 1024 bytes for the file buffer

# Pictures
picture: .asciiz 	"_______\n|   |  \\|\n        |\n        |\n        |  ",
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

clearScreen: .asciiz "[2J"

sampleword:  .asciiz "s _ s t _ m d"

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
Guess_The_Word:	.asciiz "Guess the word."
Yes:		.asciiz "Yes! "
No:			.asciiz "No! "

Guess:		.asciiz "Guess a letter.\n"
Correct_Word:	.asciiz "The correct word was:\n"
NewLine:	.asciiz "\n"

Goodbye:	.byte	#addresses?

Guessed:	.space	32	#guessed letters


###############################################################################
# Begin program
.text
main:
	jal openFile
	jal init
	jal runGame

#----------------------------------------------------------
incorrectInput:	# File did not exist
	li $v0, 4		# 4 is function code for printing a string
	la $a0, Incorrect_Filename	# Load string into a0
	syscall # Print the message
	
#	Open the file in filename in read mode
#	Read the first word of the file
openFile:
	getFileName:	# Get file path from user
		# Display prompt
		li $v0, 4			# 4 is function code for printing a string
		la $a0, Prompt_Filename	# Load string into a0
		syscall	# Print the prompt
		
		# Get user input
		li $v0, 8			# 8 is function code for reading a string
		la $a0, fileName	# Load fileName into a0
		lw $a1, inputSize	# Load contents of inputSize into a1
		syscall				# Input now stored in fileName

		sanitizeFileName:	# Fix the input
    		li $t0, 0       #loop counter
    		lw $t1, inputSize      #loop end
		clean:
			beq $t0, $t1, openFile_Read
			lb $t3, fileName($t0)
			bne $t3, 0x0a, increment_t0
			sb $zero, fileName($t0)
			increment_t0:
				addi $t0, $t0, 1
				j clean

	openFile_Read:	# Open file for reading
		li $v0, 13			# 13 is function code for opening a file
		la $a0, fileName	# fileName is the name of the file
		li $a1, 0			# Open for reading (flags are 0: read, 1: write)
		li $a2, 0			# ignore the mode
		syscall	# file descriptor returned in v0
		move $s7, $v0			# Store the file descriptor in s7
		
#	printFileName:	# Print the entered file name
#		li $v0, 4			# 4 is function code for printing a string
#		la $a0, fileName	# load fileName into a0
#		syscall	# Print the filename
		
#	displayFileDescriptor:	# Show the file descriptor
#		li $v0, 1			# 1 is function for printing an int
#		move $a0, $s7			# set a0 = s7 = file descriptor
#		syscall
		
	checkFileValidity:	# Make sure the file opened correctly
		li $t0, -1			# Set t0 = -1
		beq $s7, $t0, incorrectInput	# If descriptor = -1, then jump back and re-get input

	jr $ra	# Return to caller
	
#	End openFile
#------------------------------------------------------------------------

init:
	li $s0, 0		# $s0 will hold the number of turns taken.
	jr $ra
	
runGame:
	# get input
	# test for correctness
	# if incorrect:
	jal drawMan
	beq $s0, 5, outOfGuesses
	addiu $s0, $s0, 1
	li $v0, 32 		#sleep
	li $a0, 500 	#for 500 ms
	syscall
	j runGame

drawMan:			# Expects $s0 to hold the number of turns taken.
	
	li $v0, 11 		# Print a character
	li $a0, 0x1b  	# Ascii excape
	syscall

	li $v0, 4 				# Print a string
	la $a0, clearScreen 	# Ascii escape sequence to clear screen
	syscall

	li $t1, 93 				# Each hangman guy is exactly 93 characters long
	mul $t0, $s0, $t1 		# Multiply it by the current number of moved used
	li $v0, 4 				# Print a string
	la $a0, picture 		# top half of the hangman picture
	addu $a0, $a0, $t0 		# plus our offset for the number of moves taken
	syscall
	addi $t2, $a0, 50 		# Calculate the bottom half of our hangman picture, save it in temp.
	
	la $a0, sampleword 		# Print the current status of the word
	syscall

	move $a0, $t2 			# Get back the bottom half of our hangman picture from temp
	syscall
	jr $ra

outOfGuesses:
	#:(

#----------------------------------------------------------
#	prompt character
prompt_Character:
	addi $sp, $sp, -12		#allocate 
	sw $ra, 0($sp)			#store old ra
	sw $a0, 4($sp)			#store old a0
	sw $s0, 8($sp)			#store old s0
	
	addi $v0, $0, 12		#print string syscall
	syscall				#v0 contains a character
	
	move $s0, $v0			#character saved temporarily
	
	la $a0, NewLine			
	jal print			#print new line
	jal print			#print new line
	
	move $v0, $s0			#character back in return register
	
	sw $ra, 0($sp)			#load old ra
	sw $a0, 4($sp)			#load old a0
	sw $s0, 8($sp)			#load old s0
	addi $sp, $sp, 12		#deallocate
	jr $ra				#return
	
#	end prompt character
#----------------------------------------------------------

#----------------------------------------------------------
#	check to see if a string contains a given character

string_Contains:
	addi $sp, $sp, -4			#allocate 4 bytes

	sw $a0, 0($sp)				#store old a0
	
	and $v0, $v0, $0			#set $v0 to 0 or false

string_Contains_Loop:
	lb $t0, 0($a0)				#load character in from string
	beq $t0, $0, string_Contains_Loop_End	#stop loop if end of string is reached
	beq $t0, $a1, char_Found		#branch if character matches
	addi $a0, $a0, 1			#increment string address to continue scanning
	j string_Contains_Loop			#jump to top of loop 
	
char_Found:
	addi $v0, $0, 1				#if character found return value = 1

string_Contains_Loop_End:
	lw $a0, 0($sp)				#load old a0
	addi $sp, $sp, 4			#deallocate
	jr $ra					#return 

#	end character check
#----------------------------------------------------------
	
#----------------------------------------------------------
#	guessed letter

guessed_Update:
	addi $sp, $sp, -8			#allocate 4 bytes

	sw $a0, 0($sp)				#store old a0
	sw $a1, 4($sp)				#store old a1

guessed_Update_Loop:
	lb $t0, 0($a1)				#load character from string
	beq $t0, $0, guessed_Update_Loop_End	#stop loop if its the end on string
	bne $t0, $a2, char_Not_Found		#branch if character doens match
	sb $a2, 0($a0)				#store passed characher in position

char_Not_Found:
	addi $a0, $a0, 1			#increment guessed buffer
	addi $a1, $a1, 1			#increment string position
	j guessed_Update_Loop
	
guessed_Update_Loop_End:
	lw $a1, 4($sp)				#load old a1
	lw $a0, 0($sp)				#load old a0
	addi $sp, $sp, 8			#deallocate
	jr $ra					#return
	
#	end guessed letter
#----------------------------------------------------------

#----------------------------------------------------------
#	print string

print:
	addi $v0, $0, 4				#print string
	syscall
	
	jr $ra

#	end print string
#----------------------------------------------------------

#----------------------------------------------------------
#	print number

print_num:
	addi $v0, $0, 1				#print number
	syscall
	
	jr $ra

#	end print number
#----------------------------------------------------------
