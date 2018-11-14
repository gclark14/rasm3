@ String_equals returns 1 if the strings in registers 1 and 2 are equal.
@ Return value in register 9.


@ R1 = string1
@ R2 = string2
@ R3 = index of string1
@ R4 = index of string2
@ R5 = string1[R3]
@ R6 = string2[R4]

.global	String_equalsIgnoreCase
String_equalsIgnoreCase:
	push	{r0-r8,lr}
	sub	R3,R1,#1	@ R3 will be index while searching string for null.
	
	sub	R4,R2,#1	@ R4 will be index while searching string for null.

hunt4z:	
	ldrb	R5,[R3,#1]!	@ R5 = string1[str1Index++]
	ldrb	R6,[R4,#1]!	@ R6 = string2[str1Index++]


	@ Is the character in the first string lowercase?
	mov	r8,r5
	bl	isLowerCase
	cmp	r7,#1
	@ Make uppercase
	subeq	r5,#32
	
	@ Is the character in the second string lowercase?
	mov	r8,r6
	bl	isLowerCase
	cmp	r7,#1
	@ Make uppercase
	subeq	r6,#32

	@ Is string1[index] == string2[index] ?
	cmp	r5,r6
	@ If they are not equal then return false.
	movne	r9,#0
	popne	{R0-R8,LR}	@ Restore saved register contents
	bxne	LR		@ Return to the calling program
	

	@ If they are equal are they null terminators?
	cmpeq	r5,#0
	@ They are equal and they are null terminators.
	@ Thus,	we have reached the end of the string and they are equivalent.
	moveq	r9,#1
	popeq	{R0-R8,LR}	@ Restore saved register contents
	bxeq	LR		@ Return to the calling program

	@ Otherwise, the strings are equal and more string remains. 
	@ Continue to check the rest of the strings
	b	hunt4z


@ Checks to see if the string is lowercase
@ The input string is in R8
@ Returns 1 in r7 if lowercase
isLowerCase:
	@ Default to 0 (false)
	mov	r7,#0
	@ Assume the char is lowercase
	cmp	r8,#97
	movge	r7,#1
	@ Check if it's ascii value is > than 'z'
	cmp	r8,#122
	movgt	r7,#0

	bx	lr
	.end

