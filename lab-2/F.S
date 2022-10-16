.arch armv7-a


.section .rodata
._STR_1:
	.ascii "%d\0"
._STR_2:
	.ascii "res: %d\n\0"

.text
.align 2
.global fib
.type fib,%function

fib:
	push {fp}
	mov fp,sp @create a new frame
	sub sp,sp,#-32
	str r0,[fp,#-28]@n
	ldr r0,[fp,#-28]@check n
	cmp r0,#0
	bgt .L2
	mov r3,#0 @return 0;
	b .L5

.L2:
	mov r1,#0
	str r1,[fp,#-24]@pre0
	mov r1,#1
	str r1,[fp,#-20]@pre1
	mov r1,#0
	str r1,[fp,#-16]@temp
	mov r1,#1
	str r1,[fp,#-12]@i
.L3:
	ldr r1,[fp,#-12]@get i
	ldr r0,[fp,#-28]@get n
	cmp r1,r0
	ldr r3,[fp,#-20]@get return value
	bgt .L5 @check the loop condition
.L4:
	ldr r1,[fp,#-24]@get pre0
	ldr r2,[fp,#-20]@get pre1
	add r2,r1,r2 @temp=pre0+pre1
	str r2,[fp,#-16]
	ldr r2,[fp,#-20]
	str r2,[fp,#-24]@pre0=pre1
    ldr r2,[fp,#-16]
    str r2,[fp,#-20]@pre1=temp 	
	ldr r2,[fp,#-12]
	add r2,r2,#1
	str r2,[fp,#-12]
	b .L3
.L5:
	mov r0,r3
	mov sp,fp
	pop {fp}
	bx lr @return

.text
.align 2
.global main
.type main %function
main:
	push {fp,lr}
	add fp,sp,#4
	sub sp,sp,#8
	sub r3,fp,#12
	mov r1,r3 @&a
	movw	r0,#:lower16:._STR_1
	movt	r0,#:upper16:._STR_1
	bl __isoc99_scanf
	ldr r0,[fp,#-12]@get a
	bl fib
	str r0,[fp,#-8]@b=fib(a)
	ldr r1,[fp,#-8]
	movw	r0,#:lower16:._STR_2
	movt	r0,#:upper16:._STR_2
	bl printf
	mov r3,#0
	mov r2,#0
	mov r1,#0
	mov r0,#0
	sub sp,fp,#4
	pop {fp,pc}


	

