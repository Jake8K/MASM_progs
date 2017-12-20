TITLE Program Template     (Project_1.asm)

; Author: Jacob Karcz  
; Course / Project ID  CS271 / Project01               Date: 10.04.2016
; Description: 

INCLUDE Irvine32.inc

; (insert constant definitions here)

.data

     ;VARIABLE DEFINITIONS

     intro01   BYTE      "Program 1, Integer Arithemetic.   By Jacob Karcz", 0
     intro02   BYTE      "You will enter 2 numbers and this program will display the sum, ", 0
     intro03   BYTE      "difference, product, quotient, and remainder.", 0
     prompt1   BYTE      "Please enter two whole numbers, be sure that the second number is smaller than the first", 0
     prompt2   BYTE      "Number, First: ", 0
     prompt3   BYTE      "Number, Second: ", 0

     num1      DWORD     ?
     num2      DWORD     ?
     float1    REAL4     ?
     float2    REAL4     ?
     sum       DWORD     ?
     diff      DWORD     ?
     prod      DWORD     ?
     quot      WORD      ?
     rem       WORD      ?
     fQuot     REAL4     ?
     intPart   DWORD     ?
     frcPart   DWORD     ?
     scaleUp   REAL4     1000.
     scaleDown DWORD     1000

     sumRes1   BYTE      "The sum of ", 0
     sumRes2   BYTE      " and ", 0
     sumRes3   BYTE      " is ", 0
     subRes1   BYTE      "The difference of ", 0
     subRes2   BYTE      " and ", 0
     subRes3   BYTE      " is ", 0
     mulRes1   BYTE      "The product of ", 0
     mulRes2   BYTE      " and ", 0
     mulRes3   BYTE      " is ", 0
     divRes1   BYTE      "The integer quotient of ", 0
     divRes2   BYTE      " divided by ", 0
     divRes3   BYTE      " is ", 0
     divRes4   BYTE      " remainder ", 0
     FdivRes1  BYTE      "The decimal quotient of ", 0

     EC_loop   BYTE      "Would you like to try it with different numbers? Enter y for yes", 0
     choice    BYTE      ?
     goodBye   BYTE      "Thanks for playing, good-bye!", 0
   

.code
main PROC

     ;INTRODUCTION

     ;Display your name and program title on the output screen.
          mov  edx, OFFSET intro01
          call WriteString
          call CrLf

     ;Display instructions for the user.
          mov  edx, OFFSET intro02
          call WriteString
          call CrLf
          mov  edx, OFFSET intro03
          call WriteString
          call CrLf
          call CrLf

redo: 

     ;GET DATA

     ;Prompt the user to enter two numbers.
          mov  edx, OFFSET prompt1
          call WriteString
          call CrLf
          call CrLf

     ;prompt for first number
          mov  edx, OFFSET prompt2  
          call WriteString
          call ReadInt
          mov  num1, eax

     ;prompt for second number
          mov  edx, OFFSET prompt3  
          call WriteString
          call ReadInt
          mov  num2, eax
          call CrLf

     ;Validate the second number to be less than the first
          cmp  eax, num1
          jg   redo



     ;CALCULATIONS

     ;Calculate the sum
          mov  eax, num1
          add  eax, num2
          mov  sum, eax

     ;Calculate the difference
          mov  eax, num1
          sub  eax, num2
          mov  diff, eax

     ;Calculate the product
          mov  eax, num1
          mov  ebx, num2
          mul  ebx
          mov  prod, eax

     ;Calculate the  (integer) quotient and remainder
          mov  eax, num1
          mov  ebx, num2
          div  ebx
          mov  quot, ax
          mov  rem, dx


     ;Display the Results

     ;Addition Intro
          mov  edx, OFFSET sumRes1
          call WriteString
          mov  eax, num1
          call WriteDec
          mov  edx, OFFSET sumRes2
          call WriteString
          mov  eax, num2
          call WriteDec
          mov  edx, OFFSET sumRes3
          call WriteString
     ;Addition Results
          mov  eax, sum
          call WriteDec
          call CrLf

     ;Subtraction Intro
          mov  edx, OFFSET subRes1
          call WriteString
          mov  eax, num1
          call WriteDec
          mov  edx, OFFSET subRes2
          call WriteString
          mov  eax, num2
          call WriteDec
          mov  edx, OFFSET subRes3
          call WriteString
     ;Subtraction Results
          mov  eax, diff
          call WriteDec
          call CrLf

     ;Multiplication Intro
          mov  edx, OFFSET mulRes1
          call WriteString
          mov  eax, num1
          call WriteDec
          mov  edx, OFFSET mulRes2
          call WriteString
          mov  eax, num2
          call WriteDec
          mov  edx, OFFSET mulRes3
          call WriteString
     ;Multiplication Results
          mov  eax, prod
          call WriteDec
          call CrLf

     ;Division (integer) Intro
          mov  edx, OFFSET divRes1
          call WriteString
          mov  eax, num1
          call WriteDec
          mov  edx, OFFSET divRes2
          call WriteString
          mov  eax, num2
          call WriteDec
          mov  edx, OFFSET divRes3
          call WriteString
     ;Division (integer) Results
          mov  ax, quot
          call WriteDec
     ;Modulus Intro
          mov  edx, OFFSET divRes4
          call WriteString
     ;Modulus Results
          mov  ax, rem
          call WriteDec
          call CrLf

     ;EC: Calculate and display the quotient as a floating-point number rounded to nearest .001

     ;Calculate Fractional Division:
          ; convert ints to floats, push to stack
          fild num1
          fild num2

          ;pop both values, divide them, push quotient
          fdiv st(1), st(0)
          fstp fQuot
          fstp fQuot

          ;multiply the quotient by 1000, round the integer
          fld       fQuot
          fld       scaleUp
          fmul
          frndint
          fistp     intPart

          ;setup for integer division
          mov  edx, 0
          mov  eax, intPart
          cdq
          mov  ebx, 1000

          ;store the number as the quotient and fractional
          div  ebx
          mov  intPart, eax
          mov  frcPart, edx


     ;Display:
     ;Division (fractional) Intro
          mov  edx, OFFSET FdivRes1
          call WriteString
          mov  eax, num1
          call WriteDec
          mov  edx, OFFSET divRes2
          call WriteString
          mov  eax, num2
          call WriteDec
          mov  edx, OFFSET divRes3
          call WriteString

     ;Division (fractional) Results
          ;part 1 - The quotient
          mov  eax, intPart
          call WriteDec
          mov  al, '.'
          call WriteChar

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
          mov  eax, frcPart
          call WriteDec
          call CrLf
          call CrLf


;EC: REPEAT UNTIL USER QUITS

     ;prompt the user
          mov  edx, OFFSET EC_loop
          call WriteString
          call CrLf
     ;calculate conditional jump
          call ReadChar
          mov  choice, al
          call CrLf
          call CrLf
          cmp  choice, 'y'
          je   redo
          cmp  choice, 'Y'
          je   redo

     ;SAY GOODBYE

     ;Display a terminating message.
          mov edx, OFFSET goodBye
          call WriteString
          call CrLf
    

	     exit	; exit to operating system
     main ENDP

     ; (insert additional procedures here)

     END main
