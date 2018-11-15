	.text
	.extern	malloc
	.extern	free
	.global	main
main:
	@ Print prompt
	ldr	r1,=theStringIsPrompt
	bl	printf
	
	@ Print the specified string.
	ldr	r1,=str1
	bl	printf
	bl	endl

	@ Print prompt
	ldr	r1,=strLenPrompt
	bl	printf

	@ Get the length of the specified string.
	ldr	r1,=str1
	bl	String_length

	@ Print the length of the specified string. 
	mov	r0,r9
	bl	v_dec
	bl	endl
	bl	endl

	@ Comparing str1
	ldr	r1,=comparePrompt1
	bl	printf
	ldr	r1,=str1
	bl	printf
	@ To
	ldr	r1,=comparePrompt2
	bl	printf
	ldr	r1,=str2
	bl	printf

	@ Load the strings to compare
	ldr	r1,=str1
	ldr	r2,=str2
	@ Compare the strings (case sensitive)
	bl	String_equals

	@ Print the result
	bl	endl
	ldr	r1,=compareResultPrompt
	bl	printf
	mov	r0,r9
	bl	v_dec
	bl	endl
	bl	endl

	@ Comparing str1 INSENSITIVE
	ldr	r1,=comparePrompt1CaseInsensitive
	bl	printf
	ldr	r1,=str1
	bl	printf
	@ To
	ldr	r1,=comparePrompt2CaseInsensitive
	bl	printf
	ldr	r1,=str2
	bl	printf

	@ Load the strings to compare
	ldr	r1,=str1
	ldr	r2,=str2
	@ Compare the strings (case in-sensitive)
	bl	String_equalsIgnoreCase
	
	@ Print the result
	bl	endl
	ldr	r1,=compareResultPrompt
	bl	printf
	mov	r0,r9
	bl	v_dec
	bl	endl
	bl	endl


	
	@ CharAt

	@ Print prompt
	ldr	r1,=theStringIsPrompt
	bl	printf
	
	@ Print the specified string.
	ldr	r1,=str1
	bl	printf
	bl	endl
	
	@ Give r2 the index to search at
	mov	r2,#1
	@ Print prompt
	ldr	r1,=theCharacterAtIndex
	bl	printf
	mov	r0,r2
	bl	v_dec
	@ Is 
	ldr	r1,=is
	bl	printf

	@ Load r1 with the string to search for 
	ldr	r1,=str1
	@ Get the charAt that index 
	bl	String_charAt
	@ Print the character at that index
	ldr	r1,=charAddress
	bl	printf
	bl	endl



	bl	endl
	@ Print prompt
	ldr	r1,=theStringIsPrompt
	bl	printf
	
	@ Print the specified string.
	ldr	r1,=str1
	bl	printf

	@ Prompt
	bl	endl
	ldr	r1,=checkingIfOneStringStartsWithThisSubstring
	bl	printf
	ldr	r1,=strBeginsWith
	bl	printf
	bl	endl

	@ Load the strings to compare
	ldr	r1,=str1
	ldr	r2,=strBeginsWith
	@ Check if str1 starts with str2
	bl	String_startsWith_2
	
	@ Print the result of String_startsWith_2
	ldr	r1,=theResultIs
	bl	printf
	mov	r0,r9
	bl	v_dec

	bl	endl


	@ Test StrBeg1
	ldr	r1,=str1
	ldr	r2,=strBeginsWithAtIndex
	mov	r0,#1
	bl	String_startsWith_1
	mov	r0,r9
	bl	v_dec
	bl	endl

	@ Test StrEndsWith
	ldr	r1,=str1
	ldr	r2,=strEndsWith
	bl	String_endsWith	
	mov	r0,r9
	bl	v_dec
	bl	endl

	ldr	r1,=str1
	bl	String_copy

	ldr	r1,=str1
	mov	r2,#1
	bl	Substring2

	ldr	r1,=str1
	mov	r2,#1
	mov	r3,#2
	bl	Substring1
	bl	endl

	mov	r0,#0
	mov	r7,#1
	svc	0

String_charAt:
	push	{R0-R8,LR}	@ Save contents of registers R0 through R8, LR
	
	ldr	r9,=charAddress	@ Point r9 to strPtr

	@ R3 is the counter
	mov	r3,#0
	@ R7 is the index to look for
	mov	r7,r2	

	sub	R2,R1,#1	@ R2 will be index while searching string for null.
hunt4z:	
	ldrb	R0,[R2,#1]!	@ Load next character from string (and increment R2 by 1)

	@ Have we reached the index to search for?
	cmp	r3,r7
	@ Load destination register with the value

	str	r0,[r9]

	popeq	{r0-R8,LR}	@ Restore saved register contents
	bxeq	LR		@ Return to the calling program
	@ Have we reached the index to search for?

	add	r3,#1
	cmp	R0,#0		@ Set Z status bit if null found
	bne	hunt4z		@ If not null, go examine next character.
	
	pop	{R0-R8,LR}	@ Restore saved register contents
	bx	LR		@ Return to the calling program


@ Iterate until counter = string length of string2
@ Perform string equals
@ Checks if str1 ends with strEndsWith

String_endsWith:
	push	{r0-r8,r10-r11,lr}
    	bl      String_length	@ Get the length of str2.
	mov	r0,r9

    	ldr     r1,=strEndsWith @ Pass strLen string2.
    	bl      String_length	@ Get the length of str2.

	@ The index to start at is
	@ strLen(str1) - strLen(str2)
	cmp	r9,#0
	beq	justReturnIfEndsWithStringIsEmpty
    	sub	r0,r9   	 

	@ Point the strings back to their correct position
	ldr	r1,=str1
	ldr	r2,=strEndsWith

	sub	R3,R1,#1	@ R3 will be index while searching string for null.
	sub	R4,R2,#1	@ R4 will be index while searching string for null.

	mov	r10,#0		@ r0 is the index to search for
	mov	r11,#0

hunt4ze:	
	ldrb	R5,[R3,#1]!	@ R5 = string1[str1Index++]

	@ Have we reached the index to start at?
	cmp	r11,r0
	beq	thisIsALabel
	@ Otherwise
	@ add and continue
	add	r11,#1
	b	hunt4ze
	

return1IfStr2LenGreaterThanZero:
	cmp	r10,#0		@ strLen2 > 0?
	movgt	r9,#1
	popgt	{r0-r8,r10-r11,lr}	@ Restore saved register contents
	bxgt	LR		@ Return to the calling program
	@ Otherwise, return false
	moveq	r9,#0
	popeq	{r0-r8,r10-r11,lr}	@ Restore saved register contents
	bxeq	LR		@ Return to the calling program

stringsNotEqual:
	@ If they are not equal, is it because r6 a null terminator?
	@ If it is 
	cmp	r6,#0
	beq	return1IfStr2LenGreaterThanZero
	@ R6 is not a null terminator, and the strings are not equal. 
	@ Return false.
	movne	r9,#0
	popne	{r0-r8,r10-r11,lr}	@ Restore saved register contents
	bxne	LR		@ Return to the calling program
		
stringsEqual:
	@ If they are equal, is r5 null terminator?
	cmp	r5,#0
	@ If so, return true
	moveq	r9,#1
	popeq	{R0-R8,r10-r11,LR}	@ Restore saved register contents
	bxeq	lr
	@ Otherwise
	b	add1ToCounterAndContinue

add1ToCounterAndContinue:
	add	r10,#1
	b	hunt4ze

thisIsALabel:
	@ Is string1[index] == string2[index] ?
	@ Only want to iterate on str2 when we've reached the index requested in r0
	ldrb	R6,[R4,#1]!	@ R6 = string2[str1Index++]
	cmp	r5,r6
	beq	stringsEqual
	bne	stringsNotEqual

justReturnIfEndsWithStringIsEmpty:
	pop	{R0-R8,r10-r11,LR}	@ Restore saved register contents
	bx	lr
	

@ String to copy is str1 stored in r1
String_copy:
	push	{r0-r8,lr}

    	bl      String_length	@ Get the length of str1.

	mov	r0,r9		@ put the length of str1 into r0

	bl	malloc		@ allocate space

	ldr	r2,=strPtr	@ r2 is a ptr to strPtr
	str	r0,[r2]		@ store the value of r0 into r2

	@ load the address of r2 into r2
	ldr	r2,=strPtr

	mov	r8,#0		@ r8 is the counter used as an offset
copy:
	ldr	r1,=str1
	sub	R3,R1,#1	@ R3 will be index while searching string for null 
hunt4zp:	
	ldrb	R5,[R3,#1]!	@ R5 = string1[str1Index++]

	@ store the character r5, into r2, at an offset of r8
	strb	r5,[r2,r8]

	@ If they are equal are they null terminators?
	cmp	r5,#0
	@ldreq	r9,=strPtr
	ldreq	r1,=strPtr
	bleq	printf
	popeq	{R0-R8,LR}	@ Restore saved register contents
	bxeq	LR		@ Return to the calling program

	@ Otherwise, the strings are equal and more string remains. 
	@ Continue to check the rest of the strings
	add	r8,#1
	b	hunt4zp

@ start index stored in r2
Substring2:
	push	{r0-r10,lr}

    	bl      String_length	@ Get the length of str1.
	mov	r0,r9		@ put the length of str1 into r0


	sub	r0,r2		@ this is the size of the substring
	@ length(subStr) = length(str1) - startingIndex

	push	{r1-r3}

	bl	malloc		@ allocate space

	pop	{r1-r3}

	mov	r7,r2 		@ This is the starting index

	ldr	r2,=strPtrSubStr2	@ r2 is a ptr to strPtr
	str	r0,[r2]		@ store the value of r0 into r2

	mov	r10,#0 @ counter to see if we've reached starting index
	mov	r9,#0 @ offset for substr

	sub	R3,R1,#1	@ R3 will be index while searching string for null

hunt4zs:
	ldrb	R5,[R3,#1]!	@ R5 = string1[str1Index++]
	cmp	r10,r7
	
	bge	startCopying

	add	r10,#1
	b	hunt4zs

startCopying:
	strb	r5,[r2,r9]
	add	r9,#1
	cmp	r5,#0

	ldreq	r1,=strPtrSubStr2
	bleq	printf
	popeq	{R0-R10,LR}	@ Restore saved register contents
	bxeq	LR		@ Return to the calling program
		
	b	hunt4zs

@ start index stored in r2
@ end index stored in r3
Substring1:
	push	{r0-r10,lr}

    	bl      String_length	@ Get the length of str1.

	sub	r0,r2,r9		@ this is the size of the substring
	@ length(subStr) = endIndex -  startingIndex

	push	{r1-r3}

	bl	malloc		@ allocate space

	pop	{r1-r3}

	mov	r7,r2 		@ This is the starting index

	ldr	r2,=strPtrSubStr1	@ r2 is a ptr to strPtr
	str	r0,[r2]		@ store the value of r0 into r2

	mov	r10,#0 @ counter to see if we've reached starting index
	mov	r9,#0 @ offset for substr

	sub	R6,R1,#1	@ R3 will be index while searching string for null

hunt4zsg:
	ldrb	R5,[R6,#1]!	@ R5 = string1[str1Index++]
	cmp	r10,r7
	
	bge	startCopyingg

	add	r10,#1
	b	hunt4zsg

startCopyingg:
	strb	r5,[r2,r9]
	add	r9,#1
	cmp	r10,r3

	ldreq	r1,=strPtrSubStr1
	bleq	printf
	popeq	{R0-R10,LR}	@ Restore saved register contents
	bxeq	LR		@ Return to the calling program
		
	add	r10,#1
	b	hunt4zsg
	
	.data
str1:	.asciz	"H3y0\n" 
str2:	.asciz	"h3Y0" 
@subStr:	.asciz	"H3"
strBeginsWith:	
	.asciz	"H3"
strBeginsWithAtIndex:	
	.asciz	"3y0"
strEndsWith:
	.asciz	"\n"
strEndl:
	.asciz	"\n"
char:	.word	1
charAddress:
	.word	char
strLenPrompt:
	.asciz	"The length of the string is (including whitespace): "
theStringIsPrompt:
	.asciz	"The String is: " 
comparePrompt1:
	.asciz	"Comparing string: " 
comparePrompt2:
	.asciz	" to: "
compareResultPrompt:
	.asciz	"1 if true, 0 if false\n"
theResultIs:
	.asciz 	"The result is: " 
comparePrompt1CaseInsensitive:
	.asciz	"Comparing string (case-insensitive): " 
comparePrompt2CaseInsensitive:
	.asciz	" to (case insensitive): "
theCharacterAtIndex:
	.asciz	"The character at index: "
is:
	.asciz	" is "
checkingIfOneStringStartsWithThisSubstring:
	.asciz	"Checking if the original string starts with the substring: "
checkingIfStringStartsWithAtIndex:
	.asciz	"Checking if the string starts with the substring at index: "
strPtr:	.word	0
strPtrAddress:
	.word	strPtr
strPtrSubStr2:
	.word	0
strPtrSubStr1:
	.word	0
	.end
