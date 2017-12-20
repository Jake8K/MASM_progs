TITLE Program 05: Random Number Generator     (Program05.asm)

; Author: Jacob Karcz  karczj@oregonstate.edu               Date: 11.18.2016  ;bc == my b-day, not bc i'm a slacker
; Course: CS271-400               
; Assignment ID:  Program 05                                Date Due: 11.20.2016
;
; Description: This program generates and displays random numbers. Specifically:
;              1. Displays the program title and programmer's name.
;              2. Gets the array size from the user and verifies request to be within [min = 10,,, max = 200]
;              3. Generates the requested number of random integers between [lo = 100 ... hi = 999]
;                 sotring them in consecutive elements of the array
;              4. Displays the unsorted array, 10 numbers per line
;              5. Sorts array in descending order
;              6. calculates and displays the (rounded) median value of the array
;              7. Displays the sorted array       
;
;              *Extra Credit
;                   1) When printing, array is organized into columns instead of rows
;                   2) Sorting algorithm is recursive
;                   3) Other (windows dialogue box to continue, macros, colorful text, cool procs)
;
;---------------------------------------------------------------------------------------------------------------

INCLUDE Irvine32.inc

     ; CONSTANTS
     MAX       equ       <200>
     MIN       equ       <10>
     HI        equ       <999>
     LO        equ       <100>

.data

     ; VARIABLES
     randRay   DWORD     200 DUP(?)
     arrSize   DWORD     ?
     

     ;STRINGS

     ;intro & greeting strings
     intro     BYTE     "CS271 Project 5: Random Number Generator by Jacob Karcz", 13, 10
               BYTE     "     **EC1: Sorting algorithm is recursive", 13, 10
               BYTE     "     **EC2: implemented MACROs", 13, 10
               BYTE     "     **EC3: Used a Windows dialogue box to implement continue until user quits loop", 13, 10
               BYTE     "     **EC4: Used colorful text", 13, 10
               BYTE     "     **EC5: Created PROCS to change text color and print an Apple", 0

     ;data collection strings
     instruct  BYTE     "This program creates a set of random numbers, between 10 and 200,", 13, 10
               BYTE     "based on your input, then it organizes them in descending order and", 13, 10
               BYTE     "calculates the median value. Enjoy.", 0
     prompt    BYTE     "Total number of random digits to generate: ", 0
     error     BYTE     "Number out of range, try again...", 13, 10, 13, 10, 0  

     ;tittles
     srtd      BYTE     "Sorted Array:", 13, 10, 0
     unsrtd    BYTE     "Unsorted Array:", 13, 10, 0
     med       BYTE     "Median Value: ", 0
    

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
               BYTE     "              Happy Thanksgiving!", 13, 10, 0
 
     dTitle    BYTE     "Extra Credit Message:", 0
     msg       BYTE     "Wanna have another go?", 0

;*******************************************************************************************************





.code
main PROC

     ;intro
     push      OFFSET intro
     push      OFFSET instruct
     call      introduction
redo:
     ;get number from user
     push      OFFSET error
     push      OFFSET prompt
     push      OFFSET arrSize
     call      getData   

     ;fill array w random #s
     call      randomize
     push      LO
     push      HI
     push      arrSize
     push      OFFSET randRay
     call      fillArray

     ;display unsorted array
     call      yellowText
     push      OFFSET unsrtd
     push      arrSize
     push      OFFSET randRay
     call      displayArray
     call      crlf
     call      crlf

     ;sort Array
     push      arrSize
     push      OFFSET randRay
     ;call      mergeSort
     ;call      quickSort
     call      bubbleSort
     ;call      quickSort
     

     ;display median
     call      greenText
     push      OFFSET med
     push      arrSize
     push      OFFSET randRay
     call      displayMedian   
     call      crlf 

     ;display sorted array
     call      purpleText
     call      crlf
     push      OFFSET srtd
     push      arrSize
     push      OFFSET randRay
     call      displayArray
     call      crlf
     call      crlf

     ;message with loop
     mov       eax, 1000
     call      delay
     mov       ebx, OFFSET dTitle
     mov       edx, OFFSET msg
     call      msgboxAsk
     cmp       eax, IDYES      ;6 is yes, 7 is no
     je        redo


     ;closing
     push      OFFSET app3
     push      OFFSET app2
     push      OFFSET app1
     call      apple

     ;exit to OS
	exit	

main ENDP






;*******************************************************************************************************

;*******************************************************************************************************
;----------------------------------------------- PROCEDURES --------------------------------------------
;*******************************************************************************************************
printString    MACRO string
     mov       edx, string
     call      writeString
ENDM

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
;Procedure to get a number from the user within the specified range
;receives: variable passed by reference at [ebp + 8], prompt at [ebp + 12], error message at [ebp + 16]
;returns: the variable at [ebp + 8] is initialized to a valid value
;preconditions: MIN and MAX defined as global constants
;registers changed: none 
;*******************************************************************************************************
getData PROC  

     ;setup stack frame and push registers
     push      ebp
     mov       ebp, esp
     push      edx
     push      eax

     getNumber:
     call      blueText
     printString [ebp + 12] ;prompt
     call      greenText
     call      readInt
     call      CrLf

     ;data validation
     cmp       eax, MIN
     jl        invalid
     cmp       eax, MAX
     jle       valid

invalid:
     call      redText
     printString [ebp + 16]
     jmp       getNumber

valid:
     mov       edx, [ebp + 8]
     mov       [edx], eax
     
     pop       eax
     pop       edx
     pop       ebp

     ret 12
getData ENDP

;*******************************************************************************************************
;fillArray
;Procedure to fill an array with random integers between in the range of [ebp + 20] and [ebp + 16]
;receives: starting address of DWORD array at [ebp + 8] 
;          array size at [ebp + 12]
;          upper limit of random number range at [ebp + 16] 
;          lower limit (>=0) at [ebp + 20]
;returns: an aray with the specified number of elements (size) filled with random numbers in spc'd range
;preconditions: the array has been declared to be large enough to hold requested data
;registers changed: none
;*******************************************************************************************************
fillArray PROC
     push      ebp
     mov       ebp, esp
     push      eax
     push      ebx
     push      ecx
     push      edx
     push      esi
     push      edi


     ;setup loop
     mov       ecx, [ebp + 12]     ;arrSize
     mov       edi, [ebp + 8]      ;randRay OFFSET
     mov       edx, [ebp + 16]     ;HI
     inc       edx
     mov       esi, [ebp + 20]     ;LO
     sub       edx, esi            
     mov       ebx, 0
     

     fill:
          mov       eax, edx
          call      randomRange
          add       eax, esi        
          mov       [edi + ebx], eax
          add       ebx, 4         
          loop      fill       


     pop       edi
     pop       esi
     pop       edx
     pop       ecx
     pop       ebx
     pop       eax
     pop       ebp

     ret 16
fillArray ENDP

;*******************************************************************************************************
;displayArray
;Procedure to print an array
;receives: the array's offset at [ebp + 8]
;          the array size (or elements to print) at [ebp + 12]
;         a title string's offset at [ebp + 16]
;returns: an array prints to the screen with 10 numbers per row
;preconditions: the array and size variables have been declared and initialized
;registers changed: none
;*******************************************************************************************************
displayArray PROC

     push      ebp
     mov       ebp, esp
     push      esi
     push      ecx
     push      edx

     mov       esi, [ebp + 8]  ;array OFFSET
     mov       ecx, [ebp + 12] ;arraySize
     printString [ebp + 16]    ;title
     mov       edx, 1          ;column

     printLoop:
          ;printArray
          mov       eax, [esi]
          call      writeDec
          mov       eax, 9
          call      writeChar
          add       esi, 4

          ;track columns
          cmp       edx, 10
          jl        sameLine
          call      crlf
          mov       edx, 0
          sameLine:
          inc       edx
          loop      printLoop

     pop       edx
     pop       ecx
     pop       esi
     pop       ebp


     ret  12
displayArray ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;bubbleSort
;Procedure to sort an array in descending order
;receives: the array's offset at [ebp + 8]
;          the array size (or elements to sort) at [ebp + 12]
;returns: the array is now sorted in descending order
;preconditions: the array and array size have been declared and initialized
;registers changed: none
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

bubbleSort PROC
     push      ebp
     mov       ebp, esp
     push      eax
     push      ecx
     push      edx
     push      esi

     mov       ecx, [ebp + 12] ; arraySize
     dec       ecx
     mov       edx, [ebp + 8]  ;array offset

     outLoop:
          mov       esi, edx
          push      ecx

     swapLoop:
          mov       eax, [esi]
          cmp       [esi + 4], eax
          jl        noSwap
          xchg      eax, [esi + 4]
          mov       [esi], eax
 ;         push      [esi]
 ;         push      [esi + 4]
 ;         pop       [esi]
 ;         pop       [esi + 4]
     noSwap:
          add       esi, 4
          loop      swapLoop

          pop       ecx
          loop      outLoop

     pop       esi
     pop       edx
     pop       ecx
     pop       eax
     pop       ebp

ret 8

ret
bubbleSort ENDP

;*******************************************************************************************************
;quickSort
;Procedure to sort an array in descending order, this one sets up for recursive algorithm (quickRecursive)
;receives: the array's offset at [ebp + 8]
;          the array size (or elements to sort) at [ebp + 12]
;returns: the array is now sorted in descending order
;preconditions: the array and array size have been declared and initialized
;registers changed: none
;code credit: Miguel Casillas (miguelcasillas.com)
;*******************************************************************************************************
quickSort PROC
     push      ebp
     mov       ebp, esp
     push      eax
     push      ebx
     push      esi
     push      edi
     push      ecx

     ;setup the registers for quickSort
     mov       esi, [ebp+8]        ;load array offset
     mov       eax, [ebp + 12]     ;arraySize
     mov       ecx, 4    
     mul       ecx                 ;mul arraySize * 4
     mov       ecx, eax            ;ecx == last address of array

     xor       eax, eax            ;eax == "low index, starts @ 0
     mov       ebx, ecx            ;ebx == 'high index,' starts @ arraySize*4

     ;call recursive function to sort
     call QuickRecursive
     
     ;return
     pop       ecx
     pop       edi
     pop       esi
     pop       ebx
     pop       eax
     pop       ebp      

     ret  8
quickSort ENDP

;*******************************************************************************************************
;Recursive QuickSort Function
;Procedure to sort an array in descending order
;receives: the array's offset at [ebp + 8]
;          the array size (or elements to sort) at [ebp + 12]
;returns: the array is now sorted in descending order
;preconditions: the array and array size have been declared and initialized
;               call QuickSort which will seup the registers for this algorithm and call it
;registers changed: none
;code credit: Miguel Casillas (miguelcasillas.com)
;*******************************************************************************************************
QuickRecursive      PROC

     ;if lowindex >= highIndex, done
     cmp       eax, ebx
     jge       PostIf

     push      eax                           ; lowIndex, i
     push      ebx                           ; highIndex, j
     add       ebx, 4                        ; j = high + 1

     mov       edi, [esi + eax]              ; pivot = array[lowIndex]

     mainLoop:
          iIncreaseLoop:
              add        eax, 4              ; i++
              
              cmp        eax, ebx            ; if i >= j
              jge        End_iIncreaseLoop 

              cmp        [esi + eax], edi    ; if array[i] >= pivot
              jge        End_iIncreaseLoop                                
              jmp        iIncreaseLoop

          End_iIncreaseLoop:

          jDecreaseLoop:
               
               sub       ebx, 4              ; j--
               cmp       [esi + ebx], edi    ; if array[j] <= pivot
               jle       End_jDecreaseLoop                                 
               jmp       jDecreaseLoop

          End_jDecreaseLoop:

          cmp       eax, ebx                 ;if i >= j
          jge       EndMainLoop              ;don't swap, exit main loop

          push      [esi + eax]              ; else
          push      [esi + ebx]              ; swap i & j
          pop       [esi + eax]
          pop       [esi + ebx]

          jmp       MainLoop                 ;restart @ mainLoop

     EndMainLoop:

     pop       edi                           ;restore high index to edi
     pop       ecx                           ;restore lowIndex to ecx
     
     cmp       ecx, ebx                      ;if lowIndex == j
     je        EndSwap                       ;don't swap

     ;swap elements
     push      [esi + ecx]                   ;else
     push      [esi + ebx]                   ;swap lowIndex w j
     pop       [esi + ecx]
     pop       [esi + ebx]

     EndSwap:

     mov       eax, ecx                      ;eax == lowIndex

     push      edi                           ;save highIndex
     push      ebx                           ;save j

     sub       ebx, 4                        ;set ebx == j-1 

     call      QuickRecursive                ;quickSort(array, lowIndex, j-1)

     pop       eax                           ;restore j into eax
     add       eax, 4                        ;set eax == j+1 

     pop       ebx                           ;restore highIndex to ebx

     call      QuickRecursive                ;quickSort(array, j+1, highIndex)

     PostIf:

ret

QuickRecursive ENDP


;*******************************************************************************************************
;mergeSort
;Procedure to sort an array in descending order, this one sets up for recursive algorithm and calls it
;receives: the array's offset at [ebp + 8]
;          the array size (or elements to sort) at [ebp + 12]
;returns: the array is now sorted in descending order
;preconditions: the array and array size have been declared and initialized
;registers changed: none
;code credit: Miguel Casillas (miguelcasillas.com)
;*******************************************************************************************************
mergeSort PROC
     push      ebp
     mov       ebp, esp
     push      eax
     push      ebx
     push      esi
     push      edi
     push      ecx

     ;setup the registers for quickSort
     mov       edi, esp            ;edi == newArr loc
     ;mov       esi, [ebp + 8]        ;load array offset
     mov       eax, [ebp + 12]     ;arraySize
     mov       ecx, 4    
     mul       ecx                 ;mul arraySize * 4
     mov       eax, 4              ;add cushion

     sub       esp, eax            ;make space for array on stack
     mov       esi, esp            ;esi points to start of resulting array
     
     push      [ebp + 8]           ;@array
     push      0
     push      [ebp + 12]
     push      esi
     call      merge
     
     ;return
     mov       esp, edi
     pop       ecx
     pop       edi
     pop       esi
     pop       ebx
     pop       eax
     pop       ebp      

     ret  8
mergeSort ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;mergeSort recursive
;Procedure to sort an array in descending order
;receives: the array's offset at [ebp + 8]
;          the array size (or elements to sort) at [ebp + 12]
;returns: the array is now sorted in descending order
;preconditions: the array and array size have been declared and initialized
;               call mergeSort which will seup the registers for this algorithm and call it
;registers changed: none
;code credit: Miguel Casillas (miguelcasillas.com)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
merge PROC
	;push	ebp				; these two lines done by OS
	;mov	ebp, esp		;
	LOCAL	left:DWORD
	LOCAL	right:DWORD
	LOCAL	i:DWORD
	LOCAL	len:DWORD
	LOCAL	dist:DWORD
	LOCAL	r:DWORD
	LOCAL	l:DWORD			; l and r are to the positions in the left and right subarrays
	push	eax
	push	ebx
	push	edi
	push	ecx
	push	edx
	push	esi

	; ebp + 8 = @result 
	; ebp + 12 = right
	; ebp + 16 = left
	; ebp + 20 = @arr

	mov		edi, [ebp+20]			; store @arr in edi
	mov		esi, [ebp+8]			; store @result in esi
	mov		eax, [ebp+12]
	mov		right, eax				; store right
	mov		eax, [ebp+16]
	mov		left, eax				; store left 
	mov		l, eax					; l = left

; base case: one element (if r == l+1, return)
	add		eax, 1				; add 1 to left (in eax)
	cmp		eax, right
	je		LeaveProc			; if left+1 = right, exit
	
	; else
	; set len = right - left
	mov		eax, right
	sub		eax, left			; right - left in eax
	mov		len, eax			; length = right - left

	; set dist = right - left / 2
	mov		ebx, 2				; ebx = 2
	mov		edx, 0
	div		ebx					; eax = (right - left) / 2
	mov		dist, eax			; dist = (right - left) / 2

	; set r = left + mid_distance
	mov		ebx, left				; ebx = left
	add		ebx, eax				; ebx = left + dist
	mov		r, ebx					; r = left + dist 

; sort each subarray
	; push parameters for first call
	push	[ebp+20]				; @arr
	push	left					; left
	push	r						;left + dist
	push	[ebp+8]					; @result
	call	merge					; recursive call on left subarray (from 0  -> midpoint)

	; push parameters for second call
	push	[ebp+20]				; @arr
	push	r						; left + dist
	push	right					; right
	push	[ebp+8]					; @result
	call	merge					; recursive call on right subarray (from midpoint -> max)


; merge arrays together
	; Check to see if any elements remain in the left array; 
	; if so, we check if there are any elements left in the right array; 
	; if so, we compare them.  
	; Otherwise, we know that the merge must use take the element from the left array
	
	mov		i, 0								; i = 0
	BeginFor:
	;-------------------------------------------
	; for(i = 0; i < len; i++)
		mov ebx, i
		mov		eax, len
		cmp		i, eax								; compare i to len
		jge		LeaveFor							; if i >= len, exit for-loop

		;if (l < left + dist) AND (r == right || max(arr[l], arr[r]) == arr[l])
			; if l >= r
			mov		eax, left
			add		eax, dist						; eax = left + dist
			cmp		l, eax							; compare l to left+dist
			jge		FromRight

			; if here, first part is true, now check second part
			; (r == right || max(arr[l], arr[r]) == arr[l])
			; if either one is true, whole thing is true, and go to FromLeft
			; (r == right)
			; edi ->arr
			; esi ->result

			; check: (max(arr[l], arr[r]) == arr[l])
				; find max(arr[l], arr[r])
				mov		eax, l
				mov		ebx, 4
				mul		ebx
				mov		ecx, eax								; ecx = l * 4
				mov		eax, r
				mul		ebx
				mov		edx, eax								; edx = r * 4

				mov		eax, [edi+ecx]							; arr[l] in eax
				mov		ebx, [edi+edx]							; arr[r] in ebx
				cmp		eax, ebx
				jge		LeftMax									; if left >= right
				RightMax:										; arr[r] > arr[l]
					mov		eax, [edi+edx]
				LeftMax:										;arr[l] >= arr[r]
																; eax = max already																
				; is max == arr[l]?
				cmp		eax, [edi+ecx]
				je		FromLeft								; if true, FromLeft
																; else check second condition

			; check: r == right
				mov		eax, r
				mov		ebx, right
				cmp		eax, ebx
				je		FromLeft
				; if this isnt true, then second condition is false, so whole condition is false
				; go to FromRight
				jmp		FromRight

		FromLeft:
				;result[i] = arr[l];
				mov		eax, l
				mov		ebx, 4
				mul		ebx										; eax = l * 4
				mov		ecx, [edi+eax]							; move arr[l] to ecx

				mov		eax, i
				mul		ebx										; eax = i * 4
				mov		[esi+eax], ecx							; result[i] = arr[l]
				;l++;
				add		l, 1
				jmp		ContinueFor

			;else
		FromRight:
				;result[i] = arr[r];
				mov		eax, r
				mov		ebx, 4
				mul		ebx										; eax = r * 4
				mov		ecx, [edi+eax]							; move arr[r] to ecx

				mov		eax, i
				mul		ebx										; eax = i * 4
				mov		[esi+eax], ecx							; result[i] = arr[r]
				mov		ebx, [esi+eax]

				;r++;
				add		r, 1

	ContinueFor:
		add		i, 1
		jmp		BeginFor
	; end for-loop
	;-------------------------------------------
	LeaveFor:
	
		mov		eax, left
		mov		i, eax				; i = left
		mov		l, eax        ;lf
		mov		ebx, right
		mov		r, ebx        ;rt
		mov eax, [esi]
	For2:
	;-------------------------------------------
	; Copy the sorted subarray back to the input
	; for(i = left; i < right; i++) 
		mov		eax, i
		cmp		eax, right
		jge		Leave2			; if i >= right, leave loop

		; arr[i] = result[i - left];
				mov		eax, i
				sub		eax, left					; eax = i - left
				mov		ebx, 4
				mul		ebx							; eax = 4 * (i - left)
				mov		ecx, eax					; ecx = 4 * (i - left)
				mov		eax, i
				mul		ebx							; eax = 4 * i
				mov		edx, eax					; edx = 4 * i
								
				mov		eax, [esi+ecx]				;eax = result[i - left]
				mov		[edi+edx], eax				;arr[i] = result[i - left]	
					
		add		i, 1
		jmp		For2
	;-------------------------------------------
	Leave2:

LeaveProc:
	pop		esi
	pop		edx
	pop		ecx
	pop		edi
	pop		ebx
	pop		eax
	ret		16					; remove 4 parameters from stack
     
merge ENDP
;*******************************************************************************************************
;exchangeInts
;procedure to swap the last 2 elements passed to the system stack
;receives: value 1 at [ebp + 8]
;          value 2 at [ebp + 12]
;returns: the values have now been swapped in the system stack, pop carefully
;preconditions: the 2 values have been pushed onto the stack
;registers changed: none
;*******************************************************************************************************
exchangeInts PROC
     push      ebp
     mov       ebp, esp
     push      eax
     push      edx

     mov       edx, [ebp + 12]
     mov       eax, [ebp + 8]
     mov       [ebp + 12], eax
     mov       [ebp + 8], edx


     pop       edx
     pop       eax
     pop       ebp

     ret
exchangeInts ENDP
;*******************************************************************************************************
;displayMedian
;Procedure to calculate the median value of a sorted array and print it to the screen
;receives: the array's offset at [ebp + 8]
;          the array size at [ebp + 12]
;returns: prints the median value of the array
;preconditions: the array and array size have been declared, initialized, and the array is sorted
;registers changed: none
;*******************************************************************************************************
displayMedian PROC

     push      ebp
     mov       ebp, esp
     push      eax
     push      ebx
     push      edx
     push      esi

     mov       esi, [ebp + 8]  ;array at esi
     mov       eax, [ebp + 12] ; arraySize
     printString [ebp + 16]
     test      eax, 1          ;LSB set if the value is odd -> ZF set if its even
     jnz       oddArray
     cdq
     mov       ebx, 2
     div       ebx
     mov       ebx, 4 
     mul       ebx     
     add       esi, eax
     mov       eax, [esi]
     add       eax, [esi - 4]
     mov       ebx, 2
     cdq
     div       ebx
     jmp       ready

     
     oddArray:
     cdq
     mov       ebx, 2
     div       ebx
     mov       ebx, 4 
     mul       ebx     
     add       esi, eax
     mov       eax, [esi]



     ready:
     call      writeDec       

     pop       esi
     pop       edx
     pop       ebx
     pop       eax
     pop       ebp

ret 12
displayMedian ENDP



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
     printString [ebp + 8]
     printString [ebp + 12]
     printString [ebp + 16]
     call      crlf
     pop       edx
     pop       eax
     pop       ebp

     ret 12
apple ENDP



END main