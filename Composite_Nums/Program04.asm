TITLE Program 04: Composite Number Generator     (Program04.asm)

; Author: Jacob Karcz  karczj@oregonstate.edu               Date: 10.28.2016
; Course: CS271-400               
; Assignment ID:  Program 04                                Date Due: 11.06.2016

; Description: This program calculates and displays composite numbers. Specifically:
;              1. Displays the program title and programmer's name.
;              2. Gets the user's name and greets the user. Then displays instructions for the user.
;              3. Prompts the user to enter a number (n) greater than 1 (upper limit of 400 is used when printing)
;                   i. validates the n to be greater than 1, if out of range, the user is prompted again
;                      until a valid value is entered
;              4. Calculates and displays composites all of the composite numbers up to (and including) the nth composite
;                   i. results are printed 10 numbers per line, in aligned columns, 400 numbers per "page"
;              5. Program displays a farewell message
;
;              *Extra Credit
;                   1) Output columns are aligned
;                   2) program displays a maximum of 400 numbers per"page," 
;                      then displays "push any key to continue..." before continueing

INCLUDE Irvine32.inc

     ; constants
     MAX       equ       <400>
     MIN       equ       <0>

.data

     ; VARIABLES
     userName  BYTE     33 DUP(0)
     

     ;STRINGS

     ;intro & greeting strings
     intro     BYTE     "CS271 Project 4: Composite Number Generator by Jacob Karcz", 0
     EC1       BYTE     "     **EC1: Input is algined.", 0
     EC2       BYTE     "     **EC2: Display more composites in multiple 'pages'", 0
     EC3       BYTE     "     **EC3: Check against prime divisors", 0
     getName   BYTE     "We'll get started soon... but first, what is your name?", 0
     greetng1  BYTE     "Hi ",0
     greetng2  BYTE     "! Pleasure to meet you!", 0
     intro0    BYTE     "Now let's get started...", 0
     intro1    BYTE     "OK, ", 0
     intro2    BYTE     ", you will enter a number (n) greater than 1 and I will display a list of n composite numbers.", 0

     ;data collection strings
     instruct  BYTE     "Enter Enter the number of composites to calculate and display (lists over 400 will display on multiple pages).", 0
     prompt    BYTE     "Your choice: ", 0
     error     BYTE     "Number out of range, try again...", 0
    

     ;closing strings
     bye1      BYTE     "Goodbye ", 0
     bye2      BYTE     "! It was a pleasure to serve you!", 0

     ;extra strings
     app01     BYTE     "                         #", 0
     app0      BYTE     "                       ###", 0
     app1      BYTE     "                     ####", 0
     app2      BYTE     "                     ### ", 0
     app3      BYTE     "             #######    #######", 0
     app4      BYTE     "           ######################", 0
     app5      BYTE     "          #####################", 0
     app6      BYTE     "          ####################", 0    
     App7      BYTE     "          ####################", 0
     app8      BYTE     "          #####################", 0
     app9      BYTE     "           ######################", 0
     app10     BYTE     "            ####################", 0
     app11     BYTE     "             #################", 0
     app12     BYTE     "               ####     #####", 0
     app13     BYTE     "         ..............................", 0
     app14     BYTE     "            There's a better way...", 0
     again     BYTE     "Wanna have another go? If yes, enter y", 0
     dTitle    BYTE     "Extra Credit Message:", 0
     msg       BYTE     "Are you planning on voting?", 0

;*******************************************************************************************************





.code
main PROC

     ;intro
     call      introduction
     call      greeting

     ;get number from user
     mov       ecx, OFFSET prompt
     mov       edx, OFFSET instruct
     call      getData

     ;display composite list
     call      showComposites

     ;closing
     call      goodBye
     call      apple

	exit	; exit to operating system
main ENDP







;*******************************************************************************************************

;*******************************************************************************************************
;----------------------------------------------- PROCEDURES --------------------------------------------
;*******************************************************************************************************

;*******************************************************************************************************
;Procedure to introduce the program and the programmer name
;receives: nothing
;returns: printed statements to the screen
;preconditions: define strings: intro, EC1, EC2, and EC3
;registers changed: none
;*******************************************************************************************************
introduction PROC

     push      edx

     ; display title,  developer, and extra credit
     call      greyText
     mov       edx, OFFSET intro
     call      writeString
     call      CrLf
     mov       edx, OFFSET EC1
     call      writeString
     call      CrLf
     mov       edx, OFFSET EC2
     call      writeString
     call      CrLf
     mov       edx, OFFSET EC3
     call      writeString
     call      CrLf
     call      CrLf

     pop       edx

     ret
introduction ENDP

;*******************************************************************************************************
;Procedure to get the user's name and greet the user
;receives: nothing
;returns: the userName is initialized with the user's name
;preconditions: uninitialized string userName
;               define strings: getName, greeting1, greeting2, intro1, intro2
;registers changed: EDX holds the userName string
;*******************************************************************************************************
greeting PROC
     
     ;getName
	call      blueText
     mov       edx, OFFSET getName
     call      writeString
     call      CrLf
     call      CrLf
     call      whiteText
     mov       edx, OFFSET userName
     mov       ecx, 32
     call      readString
     call      CrLf

	;greeting
	call      blueText
     mov       edx, OFFSET greetng1
     call      writeString
     mov       edx, OFFSET userName
     call      writeString
     mov       edx, OFFSET greetng2
     call      writeString
     call      CrLf
     call      CrLf

     ;instructions
     call      purpleText
     mov       edx, OFFSET intro1
     call      writeString
     mov       edx, OFFSET userName
     call      writeString
     mov       edx, OFFSET intro2
     call      writeString
     call      CrLf
     call      CrLf

     ret
greeting ENDP

;*******************************************************************************************************
;Procedure to get a number from the user
;receives: an instruction string in EDX and a prompt in ECX
;returns: the number in EAX
;preconditions: none
;registers changed: EAX holds the user's number 
;*******************************************************************************************************
getData PROC
     
     ;if not first attempt, skip to prompt
     cmp       eax, MIN
     jle       getNum

     ;instruct
     call      blueText
     call      writeString
     call      CrLf

     getNum:
     mov       edx, ecx
     call      yellowText
     call      writeString
     call      whiteText
     call      readInt
     call      CrLf

     call      validate

     ret
getData ENDP

;*******************************************************************************************************
;Procedure to validate user's data is greater than MIN
;receives: a number to validate in EAX
;returns: nothing, prints error message and calls getData if the number is out of range
;preconditions: a number to validate in EAX
;               a global constant MIN
;               define string: error
;registers changed: none
;*******************************************************************************************************
validate PROC
     
     ;data validation
     push      edx
     cmp       eax, MIN
     jg        valid

     ;number invalid
     call      redText
     mov       edx, OFFSET error
     call      writeString
     call      CrLf
     call      getData

valid:
     pop       edx

     ret
validate ENDP

;*******************************************************************************************************
;Procedure to calculate and display composite numbers
;receives: the total number of composite numbers to print in EAX
;returns: The requested composites printed, 400 per "page" in algined columns
;preconditions: the number of composites to print in eax
;registers changed: none
;*******************************************************************************************************
showComposites PROC

     ;save used registers
     push      eax       ;holds the number current number to print
     push      ebx       ;tracks printed numbers
     push      ecx       ;loop counter
     push      edx       ;remainder checking
     push      esi       ;columns
     push      ebp       ;used for formatting divisions

     ;initialize registers
     mov       ecx, eax  ;initialize loop
     mov       ebx, 1    ;initialize count 
     mov       eax, 4    ;n starts at 4
     mov       esi, 1    ;track columns


     print:
          call      greenText
          call      isComposite
          call      writeDec

          ;format output
          push      eax
          push      edx
          mov       eax, 9
          call      writeChar
          mov       ebp, 10
          mov       eax, esi
          cdq
          div       ebp
          cmp       edx, 0
          jne       sameLine
          call      CrLf
     sameLine:
          inc       esi
          mov       ebp, MAX
          mov       eax, ebx
          cdq
          div       ebp
          cmp       edx, 0
          jne       noWait
          call      CrLf
          call      greyText
          call      waitMsg
          call      CrLf
          call      CrLf
     noWait:
          pop       edx
          pop       eax
          inc       eax
          inc       ebx

          loop      print

     call      CrLf

     ;restore registers
     pop       ebp
     pop       esi
     pop       edx
     pop       ecx
     pop       ebx
     pop       eax

     ret
showComposites ENDP

;*******************************************************************************************************
;Procedure to test whether a number is composite
;receives: a number to test in eax
;returns: the next valid composite number (inclusive of number passed in eax)
;preconditions: a number to test in eax, isComposite PROC, and Irvine-32 library included
;registers changed: eax, if the number passed was not a composite
;*******************************************************************************************************
isComposite PROC

     ;Registers used
     ;EAX - receives the current number to test and returns the next number to print (INC EAX IN showComps)
     ;EDX - used in division
     ;ESI - accumulator holding factors for division

     ;save registers
     push      edx
     push      esi


tryAgain:
     ;(re)initialize esi
     mov       esi, 2   

     ;test current number
     testLoop:
          push      eax            ;save EAX
          cdq
          div       esi
          pop       eax            ;restore EAX
          cmp       edx, 0
          je        foundComposite
          inc       esi
          cmp       esi, eax
          jl        testLoop
 
          inc       eax            ;move to next number
          jmp       tryAgain

     foundComposite:
          ;restore registers
          pop       esi
          pop       edx

     ret
isComposite ENDP

;*******************************************************************************************************
;Procedure to say goodbye to the user upon program completion
;receives: nothing
;returns: prints goodbye message
;preconditions: define strings: bye1, userName, and bye2
;registers changed: none
;*******************************************************************************************************
goodBye PROC

     push      edx

     ;say goodBye
     call      purpleText
     call      CrLf
     mov       edx, OFFSET bye1
     call      writeString
     mov       edx, OFFSET userName
     call      writeString
     mov       edx, OFFSET bye2
     call      writeString
     call      CrLf
     call      CrLf

     pop       edx

     ret
goodBye ENDP





;***********************************   other procedures   ********************************
;
;
;********************************************************************************************************
;Procedure to make the text green
;receives: nothing
;returns: nothing, sets text color to green
;preconditions: Irvine-32 Library
;registers changed: none
;********************************************************************************************************
greenText PROC
     push      eax
     mov       eax, 10
     call      setTextColor
     pop       eax

     ret
greenText ENDP

;********************************************************************************************************
;Procedure to make the text blue
;receives: nothing
;returns: nothing, sets text color to blue
;preconditions: Irvine-32 Library
;registers changed: none
;********************************************************************************************************
blueText PROC
     push      eax
     mov       eax, 11
     call      setTextColor
     pop       eax

     ret
blueText ENDP

;********************************************************************************************************
;Procedure to make the text purple
;receives: nothing
;returns: nothing, sets text color to purple
;preconditions: Irvine-32 Library
;registers changed: none
;********************************************************************************************************
purpleText PROC
     push      eax
     mov       eax, 13
     call      setTextColor
     pop       eax

     ret
purpleText ENDP

;********************************************************************************************************
;Procedure to make the text white
;receives: nothing
;returns: nothing, sets text color to white
;preconditions: Irvine-32 Library
;registers changed: none
;********************************************************************************************************
whiteText PROC
     push      eax
     mov       eax, 15
     call      setTextColor
     pop       eax

     ret
whiteText ENDP

;********************************************************************************************************
;Procedure to make the text grey
;receives: nothing
;returns: nothing, sets text color to grey
;preconditions: Irvine-32 Library
;registers changed: none
;********************************************************************************************************
greyText PROC
     push      eax
     mov       eax, 7
     call      setTextColor
     pop       eax

     ret
greyText ENDP

;********************************************************************************************************
;Procedure to make the text red
;receives: nothing
;returns: nothing, sets text color to red
;preconditions: Irvine-32 Library
;registers changed: none
;********************************************************************************************************
redText PROC
     push      eax
     mov       eax, 12
     call      setTextColor
     pop       eax

     ret
redText ENDP

;********************************************************************************************************
;Procedure to make the text yellow
;receives: nothing
;returns: nothing, sets text color to yellow
;preconditions: Irvine-32 Library
;registers changed: none
;********************************************************************************************************
yellowText PROC
     push      eax
     mov       eax, 14
     call      setTextColor
     pop       eax

     ret
yellowText ENDP

;************************************************************************************************************
;Procedure to print an apple!
;receives: nothing
;returns: prints a white apple logo!
;preconditions: the strings holding the apple logo lines defined... (app01, app0, app1... app14)
;registers changed: None!
;************************************************************************************************************
apple PROC

     ;Apple == bestest
     push      eax
     push      edx
     call      whiteText
     mov       edx, OFFSET app01
     call      writeString
     call      CrLf
     mov       edx, OFFSET app0
     call      writeString
     call      CrLf
     mov       edx, OFFSET app1
     call      writeString
     call      CrLf
     mov       edx, OFFSET app2
     call      writeString
     call      CrLf
     mov       edx, OFFSET app3
     call      writeString
     call      CrLf
     mov       edx, OFFSET app4
     call      writeString
     call      CrLf
     mov       edx, OFFSET app5
     call      writeString
     call      CrLf
     mov       edx, OFFSET app6
     call      writeString
     call      CrLf
     mov       edx, OFFSET app7
     call      writeString
     call      CrLf
     mov       edx, OFFSET app8
     call      writeString
     call      CrLf
     mov       edx, OFFSET app9
     call      writeString
     call      CrLf
     mov       edx, OFFSET app10
     call      writeString
     call      CrLf
     mov       edx, OFFSET app11
     call      writeString
     call      CrLf
     mov       edx, OFFSET app12
     call      writeString
     call      CrLf
     mov       edx, OFFSET app13
     call      writeString
     call      CrLf
     mov       edx, OFFSET app14
     call      writeString
     call      greyText
     call      CrLf
     call      CrLf
     call      CrLf
     pop       edx
     pop       eax

     ret
apple ENDP



END main