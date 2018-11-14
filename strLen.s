
@ Returns the length of the string stored in register 1.
@ Return value in R9.

.global	String_length
String_length:
	push	{r0-r8,lr}
	sub	R2,R1,#1	@ R2 will be index while searching string for null.
hunt4z:	ldrb	R0,[R2,#1]!	@ Load next character from string (and increment R2 by 1)
	cmp	R0,#0		@ Set Z status bit if null found
	bne	hunt4z		@ If not null, go examine next character.
	sub	R2,R1		@ Get number of bytes in message (not counting null)


	sub	r9,r2,#1	@ Exclude the null terminator
	pop	{R0-R8,LR}	@ Restore saved register contents
	bx	LR		@ Return to the calling program
	.end	
