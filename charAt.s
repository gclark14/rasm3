	
@ Input string in r1
@ R2 holds the index to retrieve at
@ Return value in r9
@ Returns -1 if index out of range
@ Returns r3 in r9 when r3 = r2
.global	String_charAt
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

	@mov	r9,r0
	str	r0,[r9]

	popeq	{r0-R8,LR}	@ Restore saved register contents
	bxeq	LR		@ Return to the calling program
	@ Have we reached the index to search for?

	add	r3,#1
	cmp	R0,#0		@ Set Z status bit if null found
	bne	hunt4z		@ If not null, go examine next character.

	
	@ Index out of range
	@ldr	r9,=indexOutOfRange
	pop	{R0-R8,LR}	@ Restore saved register contents
	bx	LR		@ Return to the calling program

printTheResultOfCharAt:
	
	ldr	r1,=charAddress
	bl	printf

	.data
char:	.word	1
charAddress:
	.word	char
indexOutOfRange:
	.asciz	"Index out of range"
	.end
