
	.text
	.balign	4
	.global	_start
_start:		@driver
	
	bl	printHeader

	bl	cleanRegisters

loop:

	bl	getString1



	bl	getString2
	
	@ADD AND PRINT THE SUM OF STR1 AND STR2
	mov	r12,#0
	mov	r2,#11
	ldr	r1,=strSum
	bl	printf

	add	r0,r10,r11

	bl	v_dec
	bl	printnl

	mov	r2,#18
	ldr	r1,=strDif
	bl	printf

	sub	r0,r10,r11

	bl	v_dec
	bl	printnl

	mov	r2,#15
	ldr	r1,=strProd
	bl	printf

	mul	r0,r10,r11

	bl	v_dec
	bl	printnl

	mov	r2,#16
	ldr	r1,=strDiv
	bl	printf
	
	@ do division
	mov	r12,#0
	bl	iDiv
	cmp	r8,#420

	@ print division
	mov	r0,r12
	blne	v_dec
	bl	printnl

	@ print remainder
	cmp	r8,#420
	blne	loadR0WithRemainder
	cmp	r8,#420
	movne	r0,r8
	cmp	r8,#420
	movne	r2,#17
	cmp	r8,#420
	ldrne 	r1,=strRem
	cmp	r8,#420
	blne	printf
	cmp	r8,#420
	movne	r0,r8
	blne	v_dec
	cmp	r8,#420
	movne	r2,#1
	cmp	r8,#420
	blne	printnl
	cmp	r8,#420
	blne	printnl

	@ END ADD AND PRINT THE SUM OF STR1 AND STR2

	b	loop

end:
	ldr	r1,=thanks
	mov	r2,#6
	bl	printf
	bl	printnl
	bl	printnl
	@ RETURN
	mov	r0,#0
	mov	r7,#1
	svc	0
@ENDSTART

getString1:
	push	{lr}
	bl	printnl
	ldr	r1,=str1Prompt
	mov	r2,#25
	bl	printf	


	@ Get str1, convert, check it
	ldr	R1,=strInput1	@ R1 =
	mov	R2,#11
	bl	getstring
	cmp	r0,#0
	beq	end
	bl	c_int
	mov	r10,r0
	pop	{lr}
	bx 	lr

getString2:
	push	{lr}
	ldr	r1,=str2Prompt
	mov	r2,#26
	bl	printf	

	@ Get str2, convert, check it
	ldr	R1,=strInput2	@ R1 =
	mov	R2,#11
	bl	getstring

	cmp	r0,#0
	beq	end
	bl	c_int
	mov	r11,r0
	bl	printnl
	pop	{lr}
	bx 	lr

printHeader:
	push	{lr}
	@START HEADER 
	@NAME
	ldr	r1,=name
	mov	r2,#19
	bl	printf	
	@NAME

	@CLASS
	bl	printnl
	ldr	r1,=class
	mov	r2,#11
	bl	printf	
	@CLASS

	@LAB
	bl	printnl
	ldr	r1,=lab
	mov	r2,#10
	bl	printf	
	@LAB

	@DATE
	bl	printnl
	ldr	r1,=date
	mov	r2,#19
	bl	printf	
	bl	printnl
	@DATE
	@END HEADER
	pop	{lr}
	bx 	lr

printf:
	push	{lr}
	mov	r0,#1
	mov	r7,#4
	svc	0
	pop	{lr}
	bx	lr	
printnl:
	push	{lr}
	ldr	r1,=newl
	mov	r2,#1
	mov	r0,#1
	mov	r7,#4
	svc	0
	pop	{lr}
	bx	lr	

getstring:
	push	{R2-R7}		@ Save contents of registers R2 through R6
	mov	R0,#0		@ This is the READ syscall same as Stdin (standard input,i.e., the keyboard)
	mov	R7,#3		@ Linux service command code to read a string.
	svc	0
	mov	R7,#0		@ Null to mark end of string
	sub	R0,#1		@ Remove the line feed '0A' from the input.
	strb	R7,[R1,R0]	@ Put a null at end of input line.
	pop	{R2-R7}		@ Restore saved register contents
	bx	lr

c_int:
	push	{r1-r5}
	mov	r3,#0
	mov	r4,#10
	mov	r5,#0

nxtdig:
	ldrb	r0,[r1],#1
	cmp	r0,#'-'
	moveq	r5,#1
	beq	nxtdig
	subs	r0,#'0'
	blt	notdig
	cmp	r0,#9
	bgt	notdig
	mla	r3,r4,r3,r0
	b	nxtdig

notdig:
	cmp	r0,#-48
	bne	invalidInput
	mov	r0,r3
	cmp	r5,#1
	negeq	r0,r0
	pop	{r1-r5}
	bx	lr


invalidInput:
	push	{lr}
	ldr	r1,=strInvalid
	mov	r2,#23
	bl	printf
	bl	printnl	
	bl	printnl	

	pop	{lr}
	b	loop

loadR0WithRemainder:
	push	{lr}

	cmp	r8,#0
	moveq	r0,r8
	popeq	{lr}
	bxeq	lr

	blt	addWithNegativeRemainder
	bgt	addWithPositiveRemainder

	pop	{lr}
	bx	lr

@ if num neg
addWithNegativeRemainder:
	push	{lr}

	cmp	r11,#0

	addgt	r8,r11
	mov	r0,r8
	popgt	{lr}
	bxgt	lr

	sublt	r8,r11
	mov	r0,r8
	poplt	{lr}
	bxlt	lr

	mov	r0,r8
	poplt	{lr}
	bxlt	lr

addWithPositiveRemainder:

	cmp	r11,#0

	subgt	r8,r11
	mov	r0,r8
	bxgt	lr

	addlt	r8,r11
	mov	r0,r8
	bxlt	lr

	mov	r0,r8
	bxlt	lr

v_dec:	push	{R0-R7}		@ Save contents of registers R0 through R7

	mov	R3,R0		@ R3 will hold a copy of input word to be displayed.
	mov	R2,#1		@ Number of characters to be displayed at a time.
	mov	R0,#1		@ Code for stdout (standard output, i.e., monitor display)
	mov	R7,#4		@ Linux service command code to write string.

@	If bit-31 is set, then register contains a negative number and "-" should be output.

	cmp	R3,#0		@ Determine if minus sign is needed.
	bge	absval		@ If positive number, then just display it.
	ldr	R1,=msign	@ Address of minus sign in memory
	svc	0		@ Service call to write string to stdout device
	rsb	R3,R3,#0	@ Get absolute value (negative of negative) for display.
absval:	cmp	R3,#10		@ Test whether only one's column is needed
	blt	onecol		@ Go output "final" column of display

@	Get highest power of ten this number will use (i.e., is it greater than 10?, 100?, ...)

	ldr	R6,=pow10+8	@ Point to hundred's column of power of ten table.
high10:	ldr	R5,[R6],#4	@ Load next higher power of ten
	cmp	R3,R5		@ Test if we've reached the highest power of ten needed
	bge	high10		@ Continue search for power of ten that is greater.
	sub	R6,#8		@ We stepped two integers too far.

@	Loop through powers of 10 and output each to the standard output (stdout) monitor display.

nxtdec:	ldr	R1,=dig-1	@ Point to 1 byte before "0123456789" string
	ldr	R5,[R6],#-4	@ Load next lower power of 10 (move right 1 dec column) 

@	Loop through the next base ten digit to be displayed (i.e., thousands, hundreds, ...)

mod10:	add	R1,#1		@ Set R1 pointing to the next higher digit '0' through '9'.
	subs	R3,R5		@ Do a count down to find the correct digit.
	bge	mod10		@ Keep subtracting current decimal column value
	addlt	R3,R5		@ We counted one too many (went negative)
	svc	0		@ Write the next digit to display
	cmp	R5,#10		@ Test if we've gone all the way to the one's column.
	bgt	nxtdec		@ If 1's column, go output rightmost digit and return.

@	Finish decimal display by calculating the one's digit.

onecol:	ldr	R1,=dig		@ Pointer to "0123456789"
	add	R1,R3		@ Generate offset into "0123456789" for one's digit.
	svc	0		@ Write out the final digit.

	pop	{R0-R7}		@ Restore saved register contents
	bx	LR		@ Return to the calling program

iDiv:
	push	{lr}
	push	{r0-r7}
	mov	r8,r10
	mov	r9,r11
	cmp	r9,#0
	beq	divByZero
	cmp	r8,#0
	blt	divWithNumeratorLessThanZero
	bgt	divWithNumeratorGreaterThanZero
	
	pop	{r0-r7}
	pop	{lr}
	bx	lr

@ x / 0
divByZero:
	push	{lr}
	@@ print undefined behavior caca
	
	bl	printnl

	mov	r8,#420
	mov	r2,#66
	ldr	r1,=strUnd
	bl	printf
	bl	printnl
	
	pop	{lr}
	bx	lr

@ (-x) / [(+/-)y]
divWithNumeratorLessThanZero:
	push	{lr}
	cmp	r11,#0
	blt	divWithNumeratorLessThanZeroAndDenominatorLessThanZero

	@ (-x) / y
	add	r8,r9
	cmp	r8,#0
	popgt	{lr}
	bxgt	lr
	sub	r12,#1

	pop	{lr}
	b	divWithNumeratorLessThanZero

@ (-x) / (-y)
divWithNumeratorLessThanZeroAndDenominatorLessThanZero:
	push	{lr}

	sub	r8,r9
	cmp	r8,#0
	popgt	{lr}
	bxgt	lr
	add	r12,#1

	pop	{lr}
	b	divWithNumeratorLessThanZeroAndDenominatorLessThanZero
	
@ x / [(+/-)y]
divWithNumeratorGreaterThanZero:
	push	{lr}
	cmp	r11,#0
	blt	divWithNumeratorGreaterThanZeroAndDenominatorLessThanZero
	
	@ x / y
	sub	r8,r9
	cmp	r8,#0
	poplt	{lr}
	bxlt	lr
	add	r12,#1

	pop	{lr}
	b	divWithNumeratorGreaterThanZero
	
@ x / (-y)
divWithNumeratorGreaterThanZeroAndDenominatorLessThanZero:
	push	{lr}

	@ x / (-y)
	add	r8,r9
	cmp	r8,#0
	poplt	{lr}
	bxlt	lr
	sub	r12,#1
	
	pop	{lr}
	b	divWithNumeratorGreaterThanZeroAndDenominatorLessThanZero

cleanRegisters:
	
	push	{lr}
	@ initialize registers to zero
	mov	r0,#0
	mov	r1,#0
	mov	r2,#0
	mov	r3,#0
	mov	r4,#0
	mov	r5,#0
	mov	r6,#0
	mov	r7,#0
	mov	r8,#0
	mov	r9,#0
	mov	r10,#0
	mov	r11,#0
	mov	r12,#0
	@end initialize registers to zero

	pop	{lr}
	bx	lr

	
	.data
dig:	.ascii	"0123456789"	@ ASCII string of digits 0 through 9
	.ascii	"ABCDEF"	@ ASCII string of digits A through F
newl:
	.ascii	"\n"				@ 1  byte
name:
	.ascii	"Name: Gabriel Clark"		@ 19 bytes
class:
	.ascii	"Class: CS3B"			@ 11 bytes
lab:
	.ascii	"Lab: RASM2"			@ 10 bytes
date:
	.ascii	"Date: 31 October 18"		@ 19 bytes
str1Prompt:				
	.ascii	"Enter your first number: "	@ 26 bytes ?
str2Prompt:				
	.ascii	"Enter your second number: "	@ 30 bytes ?
thanks:
	.ascii	"Thanks"
openparen:
	.ascii	"("				@ 1 byte
closeparen:
	.ascii	")"				@ 1 byte
minus:
	.ascii	"-"				@ 1 byte
equals:
	.ascii	"="				@ 1 byte
space:		
	.ascii	" "				@ 1 byte
plus:		
	.ascii	"+"				@ 1 byte

strInput1:	
	.byte	0,0,0,0,0,0,0,0,0,0,0   	@ 00000004	 00 00 00 00
strInput2:	
	.byte	0,0,0,0,0,0,0,0,0,0,0   	@ 00000004	 00 00 00 00
strInput3:	
	.byte	0,0,0,0,0,0,0,0,0,0,0   	@ 00000004	 00 00 00 00
strInput4:	
	.byte	0,0,0,0,0,0,0,0,0,0,0   	@ 00000004	 00 00 00 00
aStr1:	
	.word	strInput1  @ holds input one 
aStr2:	
	.word	strInput2 @ holds input two
pow10:	.word	1		@ 10^0
	.word	10		@ 10^1
	.word	100		@ 10^2
	.word	1000		@ 10^3  (thousand)
	.word	10000		@ 10^4
	.word	100000		@ 10^5
	.word	1000000		@ 10^6  (million)
	.word	10000000	@ 10^7
	.word	100000000	@ 10^8
	.word	1000000000	@ 10^9  (billion)
	.word	0x7FFFFFFF	@ Largest integer in 31 bits (2,147,483,647)
msign:	.ascii	"-"		@ needed for negative decimal numbers.

strSum:				@ 11 bytes
	.ascii	"The sum is "	

strDif:			        @ 18 bytes
	.ascii	"The difference is "

strProd:			@ 15 bytes
	.ascii	"The product is " @product prompt
strUnd: 			@ undefined prompt
	.ascii	"You cannot divide by zero. Thus, there is NO quotient or remainder"
strDiv:				@ division prompt
	.ascii 	"The quotient is "
strRem:				@ remainder prompt
	.ascii	"The remainder is "
strInvalid:			@ invalid input
	.ascii	"Invalid input try again\n"
	.end	
