TITLE Program 06B: Combinations (nCr) Problem Generator     (Program06B.asm)

; Author: Jacob Karcz  karczj@oregonstate.edu               Date: 11.25.2016  
; Course: CS271-400               
; Assignment ID:  Program 06B                                Date Due: 12.04.2016
;
; Description: This program generates combination problems and keeps a running score. First it generates 
;               a set of n elements {3...12} with r combinations {1...n}, then it prompts the user for 
;               the number of possible combinations possible, given r & n. Finally, it checks if user is right.
;                   - Calculations use the formula [ n! / (r!(n-r)!) ]. 
;                   - The factorial calculation is recursive.
;                   - User’s numeric input is read as a string & converted to numeric form. 
;                        * If the user enters non-digits, an error message should be displayed.      
;
;              *Extra Credit
;                   1) Number each problem and keep score
;                   2) Continue implemented with a windows yes/no message, + lots of colors, macros, and extra procs
;
;---------------------------------------------------------------------------------------------------------------

INCLUDE Irvine32.inc

     ; CONSTANTS
     N_MAX       equ       <12>
     N_MIN       equ       <3>
     R_LO        equ       <1>

.data

     ; VARIABLES
     numString BYTE      33 DUP(0)
     numSize   DWORD     ?
     numInt    DWORD     ?
     numFloat  REAL8     ?

     one       REAL8     1.0
     n         DWORD     ?
     nFact     DWORD     ?
     r         DWORD     ?
     rFact     DWORD     ?
     n_r       DWORD     ?
     n_rFact   DWORD     ?
     answer    DWORD     ?
     right     DWORD     0
     wrong     DWORD     0
     probNum   DWORD     0
     

     ;STRINGS

     ;intro & greeting strings
     intro     BYTE     "CS271 Project 6B: nCr Combination Problem Generator by Jacob Karcz", 13, 10
               BYTE     "     **EC1: Problems are numbered", 13, 10
               BYTE     "     **EC2: Program keeps score and reports it at the end", 13, 10
               BYTE     "     **EC3: Used a Windows dialogue box to implement continue until user quits loop", 13, 10
               BYTE     "     **EC4: Implemented colorful text procs", 13, 10
               BYTE     "     **EC5: used extra macros", 0

     ;data collection strings
     instruct  BYTE     "This program will generate combinations problems for you to answer,", 13, 10
               BYTE     "based on your input, I will tell you if you're right or wrong and ", 13, 10
               BYTE     "keep score. Enjoy.", 13, 10, 0
     pTitle1   BYTE     "Problem number ", 0
     pTitle2   BYTE     ":", 13, 10, 0
     Nprompt   BYTE     "Number of elements in the set:     ", 0
     Rprompt   BYTE     "Number of elements to choose from: ", 0
     prompt    BYTE     "How many possible combinations exist?   ", 0
     error     BYTE     "User input error, try again.", 13, 10, 13, 10, 0  
     answer1   BYTE     "There are ", 0
     answer2   BYTE     " possible combinations of ", 0
     answer3   BYTE     " items in a set of ", 0
     answer4   BYTE     " items.", 13, 10, 0
     rghtStr   BYTE     "That answer is correct!", 13, 10, 0
     wrngStr   BYTE     "That answer is incorrect... ", "Good thing you're practicing!", 13, 10, 0
     score1    BYTE     "Your score:    correct: ", 0
     score2    BYTE     "     incorrect: ", 0
     fCombs    BYTE     "Total Number of Combinations Attempted: ", 0
     fRight    BYTE     "Number of Combinations Correct: ", 0
     fWrong    BYTE     "Number of Combinations Incorrect: ", 0
     fSuccess  BYTE     "Combinations Success Rate: ", 0    

     ;closing strings
     bye1      BYTE     "Goodbye ", 0
     bye2      BYTE     "! It was a pleasure to serve you!", 0

     ;extra strings
     app1      BYTE     "                         #", 13, 10
               BYTE     "                       ###", 13, 10
               BYTE     "                     ####", 13, 10
               BYTE     "                     ### ", 13, 10
               BYTE     "             #######    #######", 13, 10
               BYTE     "           ######################", 13, 10, 0
     app2      BYTE     "          #####################", 13, 10 
               BYTE     "          ####################", 13, 10    
               BYTE     "          ####################", 13, 10
               BYTE     "          #####################", 13, 10
               BYTE     "           ######################", 13, 10, 0
     app3      BYTE     "            ####################", 13, 10
               BYTE     "             #################", 13, 10
               BYTE     "               ####     #####", 13, 10
               BYTE     "         ..............................", 13, 10
               BYTE     "              Happy Holidays!", 13, 10, 0
 
     dTitle    BYTE     "Another Problem?", 0
     msg       BYTE     "Would you like to solve another combination?", 0

;*******************************************************************************************************





.code
main PROC

     ;intro
     push      OFFSET intro
     push      OFFSET instruct
     call      introduction ;ret 8
redo:
     ;showProblem
     call      randomize
     push      OFFSET pTitle2
     push      OFFSET probNum
     push      OFFSET pTitle1
     push      OFFSET Nprompt
     push      OFFSET Rprompt
     push      N_MIN
     push      N_MAX
     push      R_LO
     push      OFFSET r
     push      OFFSET n
     call      showProblem ;ret 4*8 = 32

     ;get answer from user
     push      OFFSET numInt
     push      OFFSET error
     push      OFFSET prompt
     push      OFFSET numSize
     push      OFFSET numString
     call      getData        ;ret 4*5 = 20
     call      crlf
     call      crlf

     ;compute combinations
     push      OFFSET n_rFact
     push      OFFSET rFact
     push      OFFSET nFact
     push      n
     push      r
     push      OFFSET answer
     call      combinations ;ret 4*6 = 24

     ;results
     push      OFFSET score1
     push      OFFSET score2
     push      OFFSET right
     push      OFFSET wrong
     push      OFFSET wrngStr
     push      OFFSET rghtStr
     push      OFFSET answer4
     push      OFFSET answer3
     push      OFFSET answer2
     push      OFFSET answer1
     push      n
     push      r
     push      numInt
     push      answer
     call     showResults ;ret 56
     

    

     ; again?
     mov       eax, 500
     call      delay
     mov       ebx, OFFSET dTitle
     mov       edx, OFFSET msg
     call      msgboxAsk
     cmp       eax, IDYES      ;6 is yes, 7 is no
     je        redo

     ;score
     push      OFFSET fCombs
     push      OFFSET fRight
     push      OFFSET fWrong
     push      OFFSET fSuccess
     push      right
     push      wrong
     push      probNum
     call      showScore


     ;closing
     push      OFFSET app3
     push      OFFSET app2
     push      OFFSET app1
     call      apple

     ;exit to OS
	exit	

main ENDP




;*******************************************************************************************************
;----------------------------------------------- MACROS --------------------------------------------
;*******************************************************************************************************

;************************
;MACRO to print a string
;params: string to print
;************************
printString    MACRO string
     push      edx
     mov       edx, string
     call      writeString
     pop       edx
ENDM


;************************
;MACRO to print a number
;params: number to print
;************************
printNum     MACRO number
     push      eax
     mov       eax, number
     call      writeDec
     pop       eax
ENDM


;*************************************
;MACRO to get a string input from user
;params: referende  of string variable, reference of DWORD to save string length, prompt for user
;*************************************************************************************************
getString    MACRO dest, counter, promt
     push      eax
     push      ebx
     push      edx
   
     mov       edx, promt
     call      greenText
     call      writeString
     mov       edx, dest
     mov       ecx, 32
     call      whiteText
     call      readString
     mov       counter, eax

     pop       edx
     pop       ebx
     pop       eax
ENDM

;**********************************************************************
;MACRO to convert a string to an unsigned int (DWORD), or display error
;params: the string to convert, memory offset to save number, the string length, error message
;*********************************************************************************************
transNum   MACRO string, digit, strLngth, err
     push      eax
     push      ebx
     push      ecx
     push      edx
     push      esi
     push      edi

     cld       ;fwd
     mov       esi, string
     mov       ecx, strLngth
     mov       ebx, 10 ;multiplier
     mov       edi, 0  ;accumulator
     

     cmp       ecx, 32
     jg        invalid

     convertNum:

          mov       eax, edi
          mul       ebx
          mov       edi, eax


          xor       eax, eax       ;clear register
          lodsb     ;al, string[i]
          sub       48, al
          cmp       al, 9
          jg        invalid
          cmp       al, 0
          jl        invalid
          add       edi, al
          loop      convertNum
          jmp       done

          invalid:
               mov       ecx, strLngth
               mov       edi, string
               mov       eax, 0
               rep stosb
               printString err
               jmp       doGetString
     done:
     mov       digit, edi

     pop       edi
     pop       esi
     pop       edx
     pop       ecx
     pop       ebx
     pop       eax
ENDM



;*******************************************************************************************************
;----------------------------------------------- PROCEDURES --------------------------------------------
;*******************************************************************************************************

;*******************************************************************************************************
;introduction
;Procedure to introduce the program and the programmer name, and describe the program
;receives: program intro at [ebp + 12]
;          program description at [ebp + 8]
;returns: printed statements to the screen
;preconditions: push strings to stack at [ebp + 8] and [ebp + 12]
;registers changed: none
;*******************************************************************************************************
introduction PROC

     push      ebp
     mov       ebp, esp
     push      edx

     ; display title,  developer, and extra credit
     call      greyText
     printString [ebp + 12]
     call      CrLf
     call      CrLf
     call      whiteText
     printString [ebp + 8]
     call      crlf
     call      crlf

     pop       edx
     pop       ebp

     ret 8
introduction ENDP

;*******************************************************************************************************
;getData
;Procedure to get a number from the user, as a string, and convert it to a DWORD unsigned int
;receives: 
;         address of DWORD integer to be stored at [ebp + 24]
;         error message string at [ebp + 20]
;         prompt string at [ebp + 16]
;         address of variable to store string's length at [ebp + 12]
;         address of variable to store the numerical string at [ebp + 8]
;returns: all variables are initialized, the DWORD int at [ebp + 24] is valid
;preconditions: Irvine32 Library included
;registers changed: none 
;*******************************************************************************************************
getData PROC  

     ;setup stack frame and push registers
     push      ebp
     mov       ebp, esp
     pushad


     doGetString:
     call      blueText
     getString [ebp + 8], [ebp + 12], [ebp + 16]               ;dest, counter, prompt
;     transNum  [ebp + 8], [ebp + 24], [ebp + 12], [ebp + 20]  ;string, digit, strLngth, error       


     ;setup for string to int conversion
     cld                           ;fwd
     mov       esi, [ebp + 8]      ;numberString
     mov       ecx, [ebp + 12]     ;stringLength
     mov       ebx, 10             ;multiplier
     mov       edi, 0              ;accumulator

     cmp       ecx, 10             ; >32-bits 
     jg        invalid

     convertNum:

          ;to next order of magnitude
          mov       eax, edi
          mul       ebx
          mov       edi, eax

          ;reset for next digit
          xor       eax, eax       ;clear register
          lodsb                    ;al, string[i]
          sub       al, 48

          ;error-checking
          cmp       al, 9
          jg        invalid
          cmp       al, 0
          jl        invalid

          ;add latest number to result
          add       edi, eax
          loop      convertNum
          jmp       conversionComplete
  
          invalid:
               ;clearString
               mov       ecx, [ebp + 12] ;string length
               mov       edi, [ebp + 8]  ;string
               mov       eax, 0
               rep stosb
               call      redText
               printString [ebp + 20] ;error
               jmp       doGetString
    
     conversionComplete:
     mov       eax, [ebp + 24]
     mov       [eax], edi
;     mov       eax, numInt
;     call      writeDec

     
     popad
     pop       ebp

     ret 20
getdata ENDP

;********************************************************************************************************
;showProblem
;Procedure to generate an nCr combinations problem
;receives: 
;         OFFSET of part 2 of the problem header at [ebp + 44] 
;         OFFSET of the problem number at [ebp + 40]
;         OFFSET OFFSET of part 1 of the problem header at [ebp + 36]
;              ie "Problem # " x ":"
;         OFFSET of string to introduce n at [ebp + 32]
;         OFFSET of string to introduce r at [ebp + 28]
;         MINIMUM possible value of n at [ebp + 24]
;         MAXIMUM possible value of n at [ebp + 20]
;         MINIMUM possible value of r at [ebp + 16]
;         OFFSET of r at [ebp + 12]
;         OFFSET of n [ebp + 8]
;returns: prints a problem to solve with n initialized between MIN and MAX and r between min and n
;preconditions: problem number initialized to 0 when program starts
;registers changed: none
;********************************************************************************************************
showProblem PROC

     push      ebp
     mov       ebp, esp
     push      eax
     push      ebx
     push      ecx
     push      edx
    
    ;generate n
         mov        eax, [ebp + 20]
         mov        ebx, [ebp + 24]
         sub        eax, ebx
         inc        eax
         call       randomRange
         add        eax, ebx
         mov        ebx, [ebp + 8]
         mov        [ebx], eax

    ;generate r
         call       randomRange ;eax holds n (max already)
         inc        eax         ;now r is btn 1 and n
         mov        ebx, [ebp + 12]
         mov        [ebx], eax

    ;prompt user
         call       purpleText
         printString [ebp + 36]
         mov        ebx, [ebp + 40]
         mov        eax, [ebx]
         inc        eax
         mov        [ebx], eax
         printNum   eax
         printString [ebp + 44]
         call       blueText
         printString [ebp + 32]
         mov        ebx, [ebp + 8]
         mov        eax, [ebx]
         call       writeDec
         call       crlf
         printString [ebp + 28]
         mov        ebx, [ebp + 12]
         mov        eax, [ebx]
         call       writeDec
         call       crlf


     pop       edx
     pop       ecx
     pop       ebx
     pop       eax
     pop       ebp

     ret 32

showProblem ENDP


;********************************************************************************************************
;combinations
;Procedure to solve the nCr combination problem
;receives: 
;         offset of variable to hold (n-r)! at [ebp + 28]
;         offset of variable to hold r! at [ebp + 24]
;         offset of variable to hold n! at [ebp + 20]
;         n at [ebp + 16]
;         r at [ebp + 12]
;         offset of variable to hold result of combination at [ebp + 8]
;returns: n!, r!, (n-r)!, and nCr are calculated and saved to their respective variables
;preconditions: n and r are initialized
;registers changed: none
;********************************************************************************************************
combinations PROC

     push      ebp
     mov       ebp, esp
     pushad

     ;calculate (n-r)!
     mov        ebx, [ebp + 12] ;r
     mov        eax, [ebp + 16] ;n
     sub        eax, ebx        ;{n-r)
     push       eax
     push       [ebp + 28]     ;(n-r)! 
     call       factorial

     ;calculate r!
     push      [ebp + 12] ;r 
     push      [ebp + 24] ;r!     
     call      factorial 
         
     ;calculate n!
     push      [ebp + 16] ;n
     push      [ebp + 20] ;n!
     call      factorial

     ;calculate nCr
     mov       ebx, [ebp + 28] ;(n-r)!
     mov       eax, [ebx]
     mov       ebx, [ebp + 24] ;r!
     mul       DWORD PTR [ebx]
     mov       ecx, eax        ;ecx = r!(n-r)!
     mov       ebx, [ebp + 20] ;n!
     mov       eax, [ebx]
     cdq
     div       ecx
     mov       ebx, [ebp + 8]
     mov       [ebx], eax      
     
     popad          
     pop       ebp

    ret 24         ;STICKING HERE

combinations ENDP


;********************************************************************************************************
;factorial
;Procedure to recursively calculate the factorial of a number passed
;receives: 
;         number to factorialize at [ebp + 12] (n)
;	     offset of variable to hold factorial at [ebp + 8]  (n!)
;returns: the result of n! is stored in the variable passed by reference at [ebp + 8]
;preconditions: [ebp + 12] holds an unsingned int
;registers changed: none
;********************************************************************************************************
factorial PROC

     push      ebp
     mov       ebp, esp
     push      eax
     push      ebx
     push      ecx
     push      esi

     mov       eax, [ebp + 12] ;number
	mov       ebx, [ebp + 8]  ;result
	cmp       eax, 0
	ja        startAlgorithm 

     ;base case
	mov       esi, [ebp + 8]
	mov       eax, 1
	mov       [esi], eax
	jmp       quit

     startAlgorithm:
          ;setup recursive factorial of eax
          dec       eax
          push      eax
          push      ebx

          call      factorial
     
          ;compute recursive factorial on stack frames
          mov       esi, [ebp + 8] ;result
          mov       ebx, [esi]     ;value of @result
          mov       eax, [ebp + 12]
          mul       ebx            ;n * (n-1)
          mov       [esi], eax     ;save result

     
     quit:

     pop       esi
     pop       ecx
     pop       ebx
     pop       eax
     pop       ebp

     ret 8

factorial ENDP

;********************************************************************************************************
;showResults
;Procedure to display the results of the nCr calculation, tell the user is right/wrong, and keep score
;receives: 
;             OFFSET of score string part 1 at [ebp + 60]
;             OFFSET of score string part 2 at [ebp + 56]
;             OFFSET of total right guesses at [ebp + 52]
;             OFFSET of total wrong guesses at [ebp + 48]
;             OFFSET of wrong answer string at [ebp + 44]
;             OFFSET of right answer string at [ebp + 40]
;             OFFSET of answer string part 4 at   [ebp + 36]
;             OFFSET of answer string part 3 at   [ebp + 32]
;             OFFSET of answer string part 2 at   [ebp + 28]
;             OFFSET of answer string part 1 at  [ebp + 24]
;             n at [ebp + 20]
;             r at [ebp + 16]
;             user's guess at [ebp + 12]
;             nCr result at [ebp + 8]
;returns: a printed message to the screen with the results and right and wrong counts updated accordingly
;preconditions: all variables initialized
;registers changed: none
;********************************************************************************************************
showResults PROC
     push      ebp
     mov       ebp, esp
     pushad


     call yellowText
     printString [ebp + 24]
     printNum    [ebp + 8]
     printString [ebp + 28]
     printNum    [ebp + 16]
     printString [ebp + 32]
     printNum    [ebp + 20]
     printString [ebp + 36]

     mov       eax, [ebp + 8] ;answer
     mov       ebx, [ebp + 12] ;userGuess
     cmp       eax, ebx
    ; cdq
    ; div       ebx
     jnz       wrongLabel

     rightLabel:
     call      blueText
     printString [ebp + 40]
     mov       ebx, [ebp + 52]
     mov       eax, [ebx]
     inc       eax
     mov       [ebx], eax
     jmp       reportScore

     wrongLabel:
     call      redText
     printString [ebp + 44]
     mov       ebx, [ebp + 48]
     mov       eax, [ebx]
     inc       eax
     mov       [ebx], eax


     reportScore:
     call      purpleText
     printString [ebp + 60]
     mov       ebx, [ebp + 52]
     printNum  [ebx]
     printString [ebp + 56]
     mov       ebx, [ebp + 48]
     printNum  [ebx]
     call      crlf
     call      crlf
     call      crlf
     call      crlf


     popad
     pop       ebp

     ret 56
showResults ENDP

;********************************************************************************************************
;showScore
;Procedure to show the user's stats at the end of the game
;receives: 
;         OFFSET of string introducing the total number of combinations at [ebp + 32]
;         OFFSET of string introducing the number of right answers at [ebp + 28]
;         OFFSET of string introducing the number of wrong answers at [ebp + 24]
;         OFFSET of string introducing the user's success rate at [ebp + 20]
;         number right at [ebp + 16]
;         number wrong at [ebp + 12]
;         total number of attempts at [ebp + 8]
;     
;returns: the user's totals printed to screen 
;preconditions: variables initialized
;registers changed: none
;********************************************************************************************************
showScore PROC
     push      ebp
     mov       ebp, esp
     push      eax
     push      edx

     call greyText
     printString [ebp + 32]
     call blueText
     printNum    [ebp + 8]
     call crlf
     call greyText
     printString [ebp + 28]
     call greenText
     printNum    [ebp + 12]
     call crlf
     call greyText
     printString [ebp + 24]
     call redText
     printNum    [ebp + 16]
     call crlf
   ;  printString [ebp + 20]
   ;  mov        eax, [ebp + 16]
   ;  mov       ebx, [ebp + 8]
   ;  cdq
   ;  div       ebx
   ;  printNum    edx
     call crlf

     pop       edx
     pop       eax
     pop       ebp
     ret
showScore ENDP



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
     push      ebp
     mov       ebp, esp
     push      eax
     push      edx
     call      whiteText
     call      crlf
     call      crlf
     printString [ebp + 8]
     printString [ebp + 12]
     printString [ebp + 16]
     call      crlf
     call      greyText
     pop       edx
     pop       eax
     pop       ebp

     ret 12
apple ENDP

END main