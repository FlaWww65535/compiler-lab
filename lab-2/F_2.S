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
	sub sp,sp,#-28
	str r0,[fp,#-24]@n
	ldr r0,[fp,#-24]@check n
	cmp r0,#0
	bgt .L2
	mov r3,#0 @return 0;
	b .L5

.L2:
	mov r1,#1
	str r1,[fp,#-20]@temp
	mov r1,#2
	str r1,[fp,#-16]@i
.L3:
	ldr r1,[fp,#-16]@get i
	ldr r0,[fp,#-24]@get n
	cmp r1,r0
	ldr r3,[fp,#-20]@get return value
	bgt .L5 
.L4:
	ldr r1,[fp,#-16]
	ldr r2,[fp,#-20]
	mul r1,r1,r2 
	str r1,[fp,#-20]
	ldr r2,[fp,#-16]
	add r2,r2,#1
	str r2,[fp,#-16]
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
	mov r0,#10 @get a
	bl fib
	str r0,[fp,#-8]@b=fib(a)
	ldr r0,[fp,#-8]
	mov r3,#0
	mov r2,#0
	mov r1,#0
	mov r0,#0
	sub sp,fp,#4
	pop {fp,pc}


	

