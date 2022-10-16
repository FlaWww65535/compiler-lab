	.arch armv7-a
	.text
	.global	fib
fib:
	str	fp, [sp, #-4]!
	add	fp, sp, #0
	sub	sp, sp, #28
	str	r0, [fp, #-24]
	ldr	r3, [fp, #-24]
	cmp	r3, #0
	bgt	.L2
	mov	r3, #0 @123 
	b	.L3
.L2:
	mov	r3, #0
	str	r3, [fp, #-8]
	mov	r3, #1
	str	r3, [fp, #-12]
	mov	r3, #0
	str	r3, [fp, #-20]
	mov	r3, #1
	str	r3, [fp, #-16]
	b	.L4
.L5:
	ldr	r2, [fp, #-8]
	ldr	r3, [fp, #-12]
	add	r3, r2, r3
	str	r3, [fp, #-20]
	ldr	r3, [fp, #-12]
	str	r3, [fp, #-8]
	ldr	r3, [fp, #-20]
	str	r3, [fp, #-12]
	ldr	r3, [fp, #-16]
	add	r3, r3, #1
	str	r3, [fp, #-16]
.L4:
	ldr	r2, [fp, #-16]
	ldr	r3, [fp, #-24]
	cmp	r2, r3
	ble	.L5
	ldr	r3, [fp, #-12]
.L3:
	mov	r0, r3
	add	sp, fp, #0
	@ sp needed
	ldr	fp, [sp], #4
	bx	lr
	.section	.rodata
.LC0:
	.ascii	"%d\000"
.LC1:
	.ascii	"result: %d\000"
	.text
	.global	main
main:
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #8
	sub	r3, fp, #12
	mov	r1, r3
	movw	r0, #:lower16:.LC0
	movt	r0, #:upper16:.LC0
	bl	__isoc99_scanf
	ldr	r3, [fp, #-12]
	mov	r0, r3
	bl	fib
	str	r0, [fp, #-8]
	ldr	r1, [fp, #-8]
	movw	r0, #:lower16:.LC1
	movt	r0, #:upper16:.LC1
	bl	printf
	mov	r3, #0
	mov	r0, r3
	sub	sp, fp, #4
	pop	{fp, pc}
