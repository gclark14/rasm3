
	.global	endl
endl:
	push	{r0-r8,lr}
	
	ldr	r1,=strEndl
	bl	printf
	pop	{r0-r8,lr}
	bx	lr
	.data
strEndl:
	.asciz	"\n"
	.end
