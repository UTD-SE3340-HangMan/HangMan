#Hangman

##Features
* Multiple dictionaries
  * An easy dictionary with common english words.
  * A more challenging dictionary with difficult words.
  * Add your own 50-word dictionary.
* ANSI escape sequences for terminal emulators.
  * Windows 2000 and higher do not run natively on MIPS machines.  Were this game to run on real hardware, it would likely be run from a terminal emulator on Linux or some other POSIX-complient system.
  * Thus, our Hangman supports color codes and escape sequences for any terminals which support ANSI escape codes, as defined in the ISO/IEC 6429 standard.
* Play multiple games without quitting.
  * Whether you win or lose, the game asks if you want to play again, and chooses a new random word, seeded with the current time.  However, the file will not be read again, saving valuable disk-access time.
* Case-insensitive and validated input.
  * Your guesses will be converted to lowercase and checked to make sure they are alphabetical characters.
* SmartGuessing.
  * If you guess the same letter twice, Hangman will warn you, and won't count it against your turns.
* No Modifications Required.
  * Hangman runs in stock, unmodified MARS.  No need for a custom installation.

##Limitations
* Custom dictionaries must be exactly 50 words long.
  * To maintain speed and simplicity, instead of reading the custom dictionary twice, the game assumes a dictionary size of 50.
* Running on terminals that do not support the ISO/IEC 6429 standard (such as MARS' built-in console) may parse escape characters incorrectly, and could result in artifacts.
  * These artifacts will not affect gameplay.
  * Mars has a command-line mode, which allows the program to be run from your console.  Simply run `java -jar /path/to/Mars.jar ./main.asm` from a modern terminal emulator.
  * The University of Texas at Dallas provides open labs with MobaXTerm installed, which will run this program without issues.
* Program crashes if you simply press `ENTER` for your guess, instead of inserting a character.
  * This is an issue with syscall 12, for reading a character.  If no character is given, it crashes the program.

##How To Use
1. Launch the program from a modern terminal emulator, using the command `java -jar /path/to/Mars.jar ./main.asm`.
2. Choose your dictionary file.  For the default installation, this will either be `easy.txt` or `hard.txt`.  Both absolute and relative paths are supported.
3. Start guessing letters.  After each guess, you will be alerted as to whether or not your guess was correct, or if you have already guessed that character.
  * If your guess was correct, the word displayed beside the hangman will update with your new character(s).
  * If your guess was incorrect, another part of the hangman's body will appear.
4. If you guess all the letters correctly, you'll see that you won.  Otherwise, you will lose and the correct word will be displayed.
5. After the game, type `y` to play a new game, or `n` to quit.
