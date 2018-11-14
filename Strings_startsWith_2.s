






.global	String_startsWith_2
@ Loops while string1[index] == string2[index]
String_startsWith_2:
	push	{r0-r8,r10,r11,lr}
	mov	r0,r11
	sub	R3,R1,#1	@ R3 will be index while searching string for null.
	
	sub	R4,R2,#1	@ R4 will be index while searching string for null.
	mov	r10,#0

hunt4ze:	
	ldrb	R5,[R3,#1]!	@ R5 = string1[str1Index++]
	ldrb	R6,[R4,#1]!	@ R6 = string2[str1Index++]

	@ Is string1[index] == string2[index] ?
	cmp	r5,r6
	beq	stringsEqual
	bne	stringsNotEqual

return1IfStr2LenGreaterThanZero:
	cmp	r10,#0		@ strLen2 > 0?
	movgt	r9,#1
	popgt	{r0-r8,r10,r11,lr}	@ Restore saved register contents
	bxgt	LR		@ Return to the calling program
	@ Otherwise, return false
	moveq	r9,#0
	popeq	{r0-r8,r10,r11,lr}	@ Restore saved register contents
	bxeq	LR		@ Return to the calling program

stringsNotEqual:
	@ If they are not equal, is it because r6 a null terminator?
	@ If it is 
	cmp	r6,#0
	beq	return1IfStr2LenGreaterThanZero
	@ R6 is not a null terminator, and the strings are not equal. 
	@ Return false.
	movne	r9,#0
	popne	{r0-r8,r10,r11,lr}	@ Restore saved register contents
	bxne	LR		@ Return to the calling program
		
stringsEqual:
	@ If they are equal, is r5 null terminator?
	cmp	r5,#0
	@ If so, return true
	moveq	r9,#1
	popeq	{R0-R8,r10,r11,LR}	@ Restore saved register contents
	bxeq	lr
	@ Otherwise
	b	add1ToCounterAndContinue

add1ToCounterAndContinue:
	add	r10,#1
	b	hunt4ze
	.end
