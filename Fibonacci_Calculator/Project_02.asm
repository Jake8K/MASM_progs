TITLE Program 2: Calculate a Fibonacci Sequence     (Project_02.asm)

; Author: Jacob Karcz  karczj@oregonstate.edu               Date: 10.12.2016
; Course: CS271-400               
; Assignment ID:  Project 02                                Date Due: 10.16.2016
;
; Description: The program introduces the objective of the program, then prompts the user for their name and personally greets them.
;              It then explains the purpose of the program, as well as the limitations and prompts for a number (N).
;              The program then calculates and prints out the fibonacci sequence to the Nth term, before saying
;              goodbye to the user by name and terminating.
;              It was a lot of fun to make, so I hope you like it too.

INCLUDE Irvine32.inc

     ; CONSTANTS
     MAX       equ       <46>
     MIN       equ       <1>


.data


     ; strings
     ECi1      BYTE     "EC1: The numbers are aligned into columns", 0
     ECi2a     BYTE     "EC2: Incredible things happen... colorful text, arithematic in various formats, eax is pushed/popped, the program repeats, ", 0
     ECi2b     BYTE     "     there's a pretty cool picture, the program pauses, the program slows down, and it even has a popup window!", 0
     intro     BYTE     "CS271 Project 2: Fibonacci Calculator by Jacob Karcz", 0
     getName   BYTE     "I'm going to calculate some Fibonacci numbers for you, but first... what is your name?", 0
     greetng1  BYTE     "Hi ",0
     greetng2  BYTE     "! Pleasure to make your acquaintance!", 0
     intro0    BYTE     "Now let's get started...", 0
     intro1    BYTE     "OK, ", 0
     intro2    BYTE     ", the way this works is that you will give me a number between 1 and 46.", 0
     intro3    BYTE     "I will then calculate all the Fibonacci numbers from 0 to the number in the sequence that you have chosen.", 0
     intro4    BYTE     "For extra credit, I'll even line them up in columns and do something incredible. Just for you...", 0
     prompt    BYTE     "So, what is your number? How many Fibonacci numbers do you want in your sequence?", 0
     wrngN1    BYTE     "I thought we talked about this ", 0
     wrngN2    BYTE     ", the number MUST be between 1 and 46... Why don't you try again.", 0
     fNstr1    BYTE     "The Fibonacci numbers to the ", 0
     fNstr2    BYTE     " th number are: ", 0
     sumStr    BYTE     "The sum of all the numbers in this sequence is  ", 0
     sumHex    BYTE     "The sum of the numbers in hexadecimal format is ", 0
     sumBin    BYTE     "The sum of the numbers in binary format is      ", 0
     bye1      BYTE     "Goodbye ", 0
     bye2      BYTE     "! It was a pleasure to serve you!", 0
     EC1       BYTE     "For Extra Credit 1, the sequence columns and rows are aligned.", 0
     EC2       BYTE     "For Extra Credit 2, the text is colorful! I spared you the ugliness of a spastic background...", 0
     EC3       BYTE     "I've added up the Fibonacci numbers in your sequence(s) in dec, bin, and hex formats!", 0
     ECA       BYTE     "As a bonus, I drew out the symbol for incredible. I hope it helps.", 0
     EC4       BYTE     "I used the waitMsg procedure to pause the program!", 0
     EC5       BYTE     "... I wanted to display the Fibonacci sequence generated in reverse...", 0
     EC6       BYTE     "That would have been cool, but isn't that all still pretty incredible, ", 0
     EC7       BYTE     "!?!?", 0
     app01     BYTE     "                    #", 0
     app0      BYTE     "                  ###", 0
     app1      BYTE     "                ####", 0
     app2      BYTE     "                ### ", 0
     app3      BYTE     "        #######    #######", 0
     app4      BYTE     "      ######################", 0
     app5      BYTE     "     #####################", 0
     app6      BYTE     "     ####################", 0    
     Appc      BYTE     "     ####################", 0
     app8      BYTE     "     #####################", 0
     app9      BYTE     "      ######################", 0
     app10     BYTE     "       ####################", 0
     app11     BYTE     "        #################", 0
     app12     BYTE     "          ####     #####", 0
     again     BYTE     "Wanna have another go? If yes, enter y", 0
     dTitle    BYTE     "Extra Credit Message:", 0
     msg       BYTE     "Wasn't that Incredible?", 0



     ;generic variables
     userName  BYTE     33 DUP(0)
     column    DWORD    1
     elmnt     DWORD    1
     useNum    DWORD    ?
     tmpNum    DWORD    ?
     thisNum   DWORD    ?
     fibSum    DWORD    0
     choice    BYTE     ?





.code
main PROC

;EC - do something INCREDIBLE - call waitMSG, setTextColor, add up the fibs, display fibs backwards
;EC - display numbers in aligned columns

     ;intro color
     mov       eax, lightGray
     call      setTextColor

     ;INTRODUCTION

     ; display title,  developer, and extra credit
     mov       edx, OFFSET intro
     call      writeString
     call      CrLf
     mov       edx, OFFSET ECi1
     call writeString
     call      CrLf
     mov       edx, OFFSET ECi2a
     call      writeString
     call      CrLf
     mov       edx, OFFSET ECi2b
     call      writeString
     call      CrLf
     call      CrLf



     ; get user name
     mov       eax, lightGreen
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

     ; greet user
     mov       eax, lightMagenta
     call      setTextColor
     mov       edx, OFFSET greetng1
     call      writeString
     mov       edx, OFFSET userName
     call      writeString
     mov       edx, OFFSET greetng2
     call      writeString
     call      CrLf
     call      CrLf



     ;USER INSTRUCTION

     ; introduce the program
     mov       eax, lightCyan
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
     call      CrLf

     ;waitMsg
     mov       eax, white
     call      setTextColor
     call      waitMsg             ; press any key to continue
     call      CrLf
     call      CrLf

redo:
     ;GET USER DATA

     getData:
          ; get user input
          mov       eax, lightCyan
          call      setTextColor
          mov       edx, OFFSET prompt
          call      writeString
          call      CrLf
          mov       eax, white
          call      setTextColor
          call      readInt
          mov       useNum, eax

          ; validate input
          cmp       eax, MAX
          ja        wrongNum
          cmp       eax, MIN
          jb        wrongNum
          jmp       Fibonacci

     wrongNum:
          mov       eax, lightRed
          call      setTextColor
          mov       edx, OFFSET wrngN1
          call      writeString
          mov       edx, OFFSET userName
          call      writeString
          mov       edx, OFFSET wrngN2
          call      writeString
          call      CrLf
          jmp       getData


     ;CALCULATE & DISPLAY FIBONACCI NUMBERS

     Fibonacci:

          ; setup the loop
          mov       eax, lightGreen
          call      setTextColor
          call      CrLf     
          mov       eax, 0              ;first # in seq
          mov       ebx, 1              ;second # in seq
          mov       ecx, useNum         ;Nth term
          mov       fibsum, 0
          mov       elmnt, 1
          mov       column, 1


          ;calculate/print loop
          fibLOOP:

               ; print current number
               call      writeDec       
               push      eax                 ;save the current #
               mov       al, 9               ;use ASCII tab to align
               inc       elmnt
               cmp       elmnt, 38           ;fix misalignment
               jge       skipSpace
               call      writeChar

          skipSpace:
               call      writeChar
               call      writeChar
               pop       eax                 ;put the current # back in EAX         
               add       fibsum, eax         ;add it to the running sum
               inc       column
               cmp       column, 5
               jle       calc

               call      CrLf                ;newLine
               mov       column, 1

          calc:
               ; calculate next number
               mov       tmpNum, eax         ;save the previous #
               add       eax, ebx            ;calculate the Fibonacci #
               mov       ebx, tmpNum         ;save previous # to EBX
               LOOP      fibLOOP

               call      CrLf
               call      CrLf


          ; display the sum of the numbers
          ;in int
          mov       eax, yellow
          call      setTextColor
          mov       edx, OFFSET sumStr
          call      writeString
          mov       eax, fibSum
          call      writeDec
          call      CrLf

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

     ;DO IT AGAIN?

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


     ;FAREWELL...

     ; say goodbye
     mov       eax, lightGreen
     call      setTextColor
     mov       edx, OFFSET bye1
     call      writeString
     mov       edx, OFFSET userName
     call      writeString
     mov       edx, OFFSET bye2
     call      writeString
     call      CrLf
     call      CrLf

     ;delay
     mov       eax, 2000
     call      delay

     ;Apple == bestest
     mov       eax, white
     call      setTextColor

     ;prints an apple (literally, incredible!)
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
     call      CrLf
     call      CrLf

     ;delay
     mov       eax, 2000
     call      delay

     ;print Extra Credit Msgs
     mov       eax, lightMagenta
     call      setTextColor
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
     mov       edx, OFFSET EC5
     call      writeString
     call      CrLf
     mov       edx, OFFSET EC6
     call      writeString
     mov       edx, OFFSET userName
     call      writeString
     mov       edx, OFFSET EC7
     call      writeString
     call      CrLf
     mov       edx, OFFSET ECA
     call      writeString
     call      CrLf
     call      CrLf

     mov       eax, lightCyan
     call      setTextColor

     ;delay
     mov       eax, 3000
     call      delay

     ;open a msgBox!
     mov       ebx, OFFSET dTitle
     mov       edx, OFFSET msg
     call      msgBoxAsk


	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
