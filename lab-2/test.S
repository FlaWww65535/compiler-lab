	.arch armv7-a
	.eabi_attribute 28, 1
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 2
	.eabi_attribute 30, 6
	.eabi_attribute 34, 1
	.eabi_attribute 18, 4
	.file	"test.c"
	.text
	.global	a
	.bss
	.align	2
	.type	a, %object
	.size	a, 4
a:
	.space	4
	.global	b
	.align	2
	.type	b, %object
	.size	b, 4
b:
	.space	4
	.text
	.align	2
	.global	max
	.arch armv7-a
	.syntax unified
	.arm
	.fpu neon
	.type	max, %function
max:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	str	fp, [sp, #-4]!
	add	fp, sp, #0
	sub	sp, sp, #12
	str	r0, [fp, #-8]
	str	r1, [fp, #-12]
	ldr	r2, [fp, #-8]
	ldr	r3, [fp, #-12]
	cmp	r2, r3
	blt	.L2
	ldr	r3, [fp, #-8]
	b	.L3
.L2:
	ldr	r3, [fp, #-12]
.L3:
	mov	r0, r3
	add	sp, fp, #0
	@ sp needed
	ldr	fp, [sp], #4
	bx	lr
	.size	max, .-max
	.section	.rodata
	.align	2
.LC0:
	.ascii	"%d %d\000"
	.align	2
.LC1:
	.ascii	"max is: %d\012\000"
	.text
	.align	2
	.global	main
	.syntax unified
	.arm
	.fpu neon
	.type	main, %function
main:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{fp, lr}
	add	fp, sp, #4
	movw	r2, #:lower16:b
	movt	r2, #:upper16:b
	movw	r1, #:lower16:a
	movt	r1, #:upper16:a
	movw	r0, #:lower16:.LC0
	movt	r0, #:upper16:.LC0
	bl	__isoc99_scanf
	movw	r3, #:lower16:a
	movt	r3, #:upper16:a
	ldr	r2, [r3]
	movw	r3, #:lower16:b
	movt	r3, #:upper16:b
	ldr	r3, [r3]
	mov	r1, r3
	mov	r0, r2
	bl	max
	mov	r3, r0
	mov	r1, r3
	movw	r0, #:lower16:.LC1
	movt	r0, #:upper16:.LC1
	bl	printf
	mov	r3, #0
	mov	r0, r3
	pop	{fp, pc}
	.size	main, .-main
	.ident	"GCC: (GNU Toolchain for the A-profile Architecture 8.3-2019.03 (arm-rel-8.36)) 8.3.0"
	.section	.note.GNU-stack,"",%progbits
