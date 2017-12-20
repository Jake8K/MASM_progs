TITLE Program 3: Negative Integer Arithmetic     (Program03.asm)

; Author: Jacob Karcz  karczj@oregonstate.edu               Date: 10.24.2016
; Course: CS271-400               
; Assignment ID:  Project 03                                Date Due: 10.30.2016

; Description: This program involves integer arithmetic and data validation. Specifically it:
;              1. Displays the program title and programmer's name.
;              2. Gets the user's name and greets the user.
;              3. Displays instructions for the user.
;              4. Repeatedly prompts the user to enter a number and validates the number to be in [-100, -1]
;                 (includsive). It counts and accumulates the valid user numbers until a non-negative number
;                 is entered. The non-negative number is discarded.
;              5. Calculates the (rounded integer) average of the negative numbers.
;              6. Displays:
;                   i.   the number of negative numbers entered.
;                          *note: if no negative numbers were entered, displays a special message and skip to iv
;                   ii.  the sum of the negative numbers entered
;                   iii. the average, rounded to the nearest integer (i.e. -20.5 rounds to -20)
;                   iv:  a parting message (with the user's name).
;
;              *Extra Credit
;              1) Number the lines during user input.
;              2) Calculate and display the average as a floating-point number, rounded to the nearest .001
;              3) Do something astoundingly creative. (loop until user quits, colors, use time delay, popup message!, implement procedures!, tried to display in hex and bin...)

INCLUDE Irvine32.inc


;constants
MIN       EQU		<-100>
MAX	     equ		<-1>

.data

     ; VARIABLES
     userName  BYTE     33 DUP(0)
     count     DWORD    ?
     sum       DWORD    ?
     avg       DWORD    ?
     floater   REAL4    ?
     intPart   DWORD    ?
     frcPart   DWORD    ?
     aThousand REAL4    1000.
     converter DWORD    -1
     choice    BYTE     ?

     ;STRINGS

     ;intro & data collection
     EC1       BYTE     "     **EC1: Number the lines during user input.", 0
     EC2       BYTE     "     **EC2: Display the average as a floating-point number, rounded to the nearest .001.", 0
     EC3       BYTE     "     **EC3: Do something astoundingly creative: ", 0
     EC4       BYTE     "            implemented procedures! popup y/n message (w responses)! time delay! colors! loop until user quits!", 0
     intro     BYTE     "CS271 Project 3: Negative Number Arithmetic by Jacob Karcz", 0
     getName   BYTE     "I'm going to ask you to input some negative numbers... but first, what is your name?", 0
     greetng1  BYTE     "Hi ",0
     greetng2  BYTE     "! Pleasure to meet you!", 0
     intro0    BYTE     "Now let's get started...", 0
     intro1    BYTE     "OK, ", 0
     intro2    BYTE     ", the way this works is that you will enter numbers between -100 and -1 ", 0
     intro3    BYTE     "(seperated by enter key). Don't forget the negative sign (-) in front of your numbers! ", 0
     intro4    BYTE     "Once I read anything greater than or equal to 0 you will no longer be able to enter more ", 0
     intro5    BYTE     "numbers. I will then display the sum and average of your selections.", 0
     intro6    BYTE     "OK, lets do this!", 0
     prompt    BYTE     "Enter numbers between -100 and -1 (seperated by enter key). Enter a number greater than 0 when finished.", 0
     
     ;results strings
     posNum    BYTE     "OK, now that you've finished entering numbers...", 0
     noVal     BYTE     "No valid data entered... ", 0
     noRes     BYTE     "calculations discarded.", 0
     numcnt    BYTE     "Total number of negative numbers entered:  ", 0
     sumStr    BYTE     "Sum of all  numbers in decimal format:    ", 0
     sumHex    BYTE     "Sum of all numbers in hexadecimal format: ", 0
     sumBin    BYTE     "Sum of all numbers in binary format:      ", 0
     intAvg    BYTE     "Average rounded to nearest integer:       ", 0
     floatAvg  BYTE     "Average rounded to nearest .001:          ", 0

     ;closing strings
     bye1      BYTE     "Goodbye ", 0
     bye2      BYTE     "! It was a pleasure to serve you!", 0
     yesVote   BYTE     "Sweet! I hope you make the right democratic choice...", 0
     noVote    BYTE     "You really should get out there and vote (for Hillary)!", 0
     app01     BYTE     "                         #", 0
     app0      BYTE     "                       ###", 0
     app1      BYTE     "                     ####", 0
     app2      BYTE     "                     ### ", 0
     app3      BYTE     "             #######    #######", 0
     app4      BYTE     "           ######################", 0
     app5      BYTE     "          #####################", 0
     app6      BYTE     "          ####################", 0    
     Appc      BYTE     "          ####################", 0
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

	;INTRO
          call      introduction
	     call      greeting


	;GET DATA
     redo:
          ;setup variables
          mov       count, 1
          mov       sum, 0

          ;ask for a number
          mov       eax, lightGreen
          call      setTextColor
          mov       edx, OFFSET prompt
          call      writeString
          call      CrLf

     nxtNum:
          ;collect data
          mov       eax, lightGreen
          call      setTextColor
          mov       eax, count
          call      writeDec
          mov       al, 9
          call      writeChar
          mov       eax, white
          call      setTextColor
          call      readInt

          ;validate number [-100, -1]
          ;cmp       eax, MAX
          jns       endCollect
          cmp       eax, MIN
          jl        nxtNum

          ;add it up
          inc       count
          add       eax, sum
          mov       sum, eax
          jmp       nxtNum

     endCollect:
          call      CrLf
          cmp       count, 1
          je        wrong
    
	
     ;REPORT RESULTS
          call      countSum
          call      roundAvg
	     call      fracAvg


          wrong:
               ;no negative values entered
               cmp       sum, 0
               jne       looperz
               mov       eax, lightRed
               call      setTextColor
               mov       edx, OFFSET noVal
               call      writeString
               mov       eax, 1000
               call      delay
               mov       edx, OFFSET noRes
               call      writeString
               call      CrLf
               call      CrLf

     looperz:
          ;loop back to getdata
               ;prompt the user
               mov       eax, lightCyan
               call      setTextColor
               mov       edx, OFFSET again
               call      WriteString
               call      CrLf

               ;calculate conditional jump
               call      ReadChar
               mov       choice, al
               call      CrLf
               call      CrLf
               cmp       choice, 'y'
               je        redo
               cmp       choice, 'Y'
               je        redo

     ;THE END
          call      goodBye
          mov       eax, 500
          call      delay
          call      apple


     ;exit to OS
	exit	

main ENDP

;PROC Modules

;************************************************************************************************************
;Procedure to introduce the program, prints program name, programmer name, and extra credit
;receives: nothing
;returns: printed statement
;preconditions: strings containing intro and EC statements defined in .data
;registers changed: edx holds a string
;************************************************************************************************************
introduction PROC

; display title,  developer, and extra credit
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
     mov       edx, OFFSET EC4
     call      writeString
     call      CrLf
     call      CrLf

     ret
introduction ENDP

;************************************************************************************************************
;Procedure to get user name, greet user, and explain the program
;receives: nothing
;returns: the user name stored in userName, printed greeting/intro statements
;preconditions: userName string declared and other relevant strings defined in .data
;registers changed: eax will hold a color, edx will hold a string
;************************************************************************************************************
greeting PROC

;getName
	mov       eax, lightCyan
     call      setTextColor
     mov       edx, OFFSET getName
     call      writeString
     call      CrLf
     call      CrLf
     mov       eax, white
     call      setTextColor
     mov       edx, OFFSET userName  ;variable to hold name
     mov       ecx, 32               ;maxChars for userName, saving a 0 in spot 32
     call      readString
     call      CrLf

	;greeting
     mov       eax, lightCyan
     call      setTextColor
     mov       edx, OFFSET greetng1
     call      writeString
     mov       edx, OFFSET userName
     call      writeString
     mov       edx, OFFSET greetng2
     call      writeString
     call      CrLf
     call      CrLf

     ;instructions
     mov       eax, lightmagenta
     call      setTextColor
     mov       edx, OFFSET intro1
     call      writeString
     mov       edx, OFFSET userName
     call      writeString
     mov       edx, OFFSET intro2
     call      writeString
     call      CrLf
     mov       edx, OFFSET intro3
     call      writeString
     call      CrLf
     mov       edx, OFFSET intro4
     call      writeString
     call      CrLf
     mov       edx, OFFSET intro5
     call      writeString
     call      CrLf
     mov       edx, OFFSET intro6
     call      writeString
     call      CrLf
     call      CrLf

     ret
greeting ENDP

;************************************************************************************************************
;Procedure to print the number of items on the list and the sum of their values (pre-calculated)
;receives: the appropriate strings and the variables count and sum
;returns: printed statements with the count and sum (if not negative, sum is displayed in dec, bin, and hex)
;preconditions: a sum and a count
;registers changed: eax holds the sum, edx holds a string
;************************************************************************************************************
countSum PROC

     ;introString
     mov       eax, lightGreen
     call      setTextColor
     mov       edx, OFFSET posNum
     call      writeString
     call      CrLf
     call      CrLf

     ;reportCount
     mov       eax, yellow
     call      setTextColor
     mov       edx, OFFSET numcnt
     call      writeString
     dec       count
     mov       eax, count
     call      writeDec
     call      CrLf

	;report the sum
     mov       edx, OFFSET sumStr
     call      writeString
     mov       eax, sum
     call      writeInt
     call      CrLf
     cmp       eax, 0
     jl        negInts

     ;in hex
     mov       edx, OFFSET sumHex
     call      writeString
     call      writeHex
     call      CrLf

     ;in binary
     mov       edx, OFFSET sumBin
     call      writeString
     call      writeBin
     call      CrLf
     call      CrLf
negInts:


     ret
countSum ENDP
;************************************************************************************************************
;Procedure to find the average of a negative sum rounded to the nearest integer and print the results.
;receives: nothing at the moment (future: string in EDX, sum in EAX, count in ECX)
;returns: a printed message with the rounded negative integer division results
;preconditions: a string intAvg, a count variable, and a 32-bit variable called sum 
;registers changed: EAX holds the quotient, EDX holds the positive value of the remainder
;************************************************************************************************************
roundAvg PROC

	;calculate & report rounded average
     mov       edx, OFFSET intAvg
     call      writeString
     mov       eax, sum
     cdq
     idiv      count
     
     ;round up/down
     imul      edx, converter     
     add       edx, edx
     cmp       edx, count
     jle       noRound
     dec       eax
noRound:
     call      writeInt
     call      CrLf
     sub       edx, edx

     ret
roundAvg ENDP

;************************************************************************************************************
;Procedure to find the average of a negative sum rounded to the nearest .001 and print the results.
;receives: nothing at the moment (future: string in EDX, sum in EAX, count in ECX)
;returns: a printed message with the negative integer division results rounded to nearest .001
;preconditions: a string floatAvg, a count variable, and a 32-bit variable called sum 
;registers changed: EAX holds the quotient result, EDX holds the fractional result
;************************************************************************************************************
fracAvg PROC

;report floating-point average
     mov       edx, OFFSET floatAvg
     call      writeString

     ; convert ints to floats, push to stack
     finit
     fild      sum

     ;pop both values, divide them, push quotient
     fidiv     count
     fst       floater
 
     ;multiply the quotient by 1000, round the integer
     fld       floater
     fld       aThousand
     fmul
     frndint
     fistp     intPart

     ;integer division
     mov  edx, 0
     mov  eax, intPart
     cdq
     mov  ebx, 1000
   
     ;store the number as the quotient and fractional
     idiv  ebx
     mov  intPart, eax
     mov  frcPart, edx

     ;Division (fractional) Results

     ;part 1 - The quotient
     mov  eax, intPart
     call writeInt
     mov  al, '.'
     call WriteChar

     mov  eax, frcPart                  ;CONVERT frcPart to unsigned!
     imul converter
     mov  frcPart, eax

     ;part 2 - The conditional .001 accuracy
     cmp  frcPart, 100
     jge  noZeroes
     mov  al, '0'
     call WriteChar

     cmp  frcPart, 10
     jge  noZeroes
     mov  al, '0'
     call WriteChar

noZeroes:
     ;part 3 - The Fractional Faction
     mov  eax, frcPart                  ;CONVERT frcPart to unsigned!
     call WriteDec                 
     call CrLf
     call CrLf

     ret
fracAvg ENDP

;************************************************************************************************************
;Procedure to say goodbye to the user and open up a yes/no message box with dTitle and msg strings
;receives: defined strings, bye1, bye2, userName, dTitle, msg
;returns: nothing
;preconditions: the strings bye1, bye2, username, dTitle, and msg
;registers changed: none
;************************************************************************************************************
goodBye PROC
     
     ;save registers
     push      eax
     push      ebx
     push      edx

     ;say goodBye
     mov       eax, lightMagenta
     call      setTextColor
     mov       edx, OFFSET bye1
     call      writeString
     mov       edx, OFFSET userName
     call      writeString
     mov       edx, OFFSET bye2
     call      writeString
     call      CrLf
     call      CrLf

     ;open a msgBox and do stuff!
     mov       ebx, OFFSET dTitle
     mov       edx, OFFSET msg
     call      msgBoxAsk
     cmp       eax, 6
     je        cool
     cmp       eax, 7
     je        notCool
cool:
     call      blueText
     mov       edx, OFFSET yesVote
     call      writeString
     call      CrLf
     jmp       done

notCool:
     call      redText
     mov       edx, OFFSET noVote
     call      writeString
     call      CrLf
done: 
     call      CrLf

     ;restore registers
     pop       edx
     pop       ebx
     pop       eax


     ret
goodBye ENDP

;************************************************************************************************************
;Procedure to print an apple!
;receives: nothing
;returns: prints a white apple logo!
;preconditions: the strings holding the apple logo lines defined...
;registers changed: None!
;************************************************************************************************************
apple PROC

     ;Apple == bestest
     push      eax
     push      edx
     mov       eax, white
     call      setTextColor
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
     mov       edx, OFFSET appc
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
     call      CrLf
     call      CrLf
     call      CrLf
     pop       edx
     pop       eax

     ret
apple ENDP

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

END main