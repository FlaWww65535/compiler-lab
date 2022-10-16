.arch armv7-a


.section .rodata
._STR_1:
	.ascii "%d\0"
._STR_2:
	.ascii "res: %d\n\0"

.text
.align 2
.global fib
.type frac,%function

frac:
    push {fp}
    mov fp,sp @创建新的栈帧
    sub sp,sp,#-28
    str r0,[fp,#-24]@将n的值存入局部变量
    ldr r0,[fp,#-24]
    cmp r0,#0@若n<=0则返回0
    bgt .L2
    mov r3,#0 @return 0;
    b .L5

.L2:	@数据初始化环节
    mov r1,#1
    str r1,[fp,#-20]@temp
    mov r1,#2
    str r1,[fp,#-16]@i
.L3:	@循环条件的判断
    ldr r1,[fp,#-16]
    ldr r0,[fp,#-24]
    cmp r1,r0
    ldr r3,[fp,#-20]
    bgt .L5
.L4:	@循环体
    ldr r1,[fp,#-16]
    ldr r2,[fp,#-20]
    mul r1,r1,r2
    str r1,[fp,#-20]
    ldr r2,[fp,#-16]
    add r2,r2,#1 @i自增
    str r2,[fp,#-16]
    b .L3
.L5:@返回
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


	

