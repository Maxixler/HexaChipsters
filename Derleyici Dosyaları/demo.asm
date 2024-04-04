	.file	"demo.c"
	.option nopic
	.attribute arch, "rv32i2p0_m2p0_a2p0_f2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	2
	.globl	gpio_write
	.type	gpio_write, @function
gpio_write:
	addi	sp,sp,-32
	sw	s0,28(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	sw	a1,-24(s0)
	lw	a5,-24(s0)
	beq	a5,zero,.L2
	li	a5,-2147479552
	lw	a4,0(a5)
	lw	a5,-20(s0)
	li	a3,1
	sll	a5,a3,a5
	mv	a3,a5
	li	a5,-2147479552
	or	a4,a4,a3
	sw	a4,0(a5)
	j	.L4
.L2:
	li	a5,-2147479552
	lw	a4,0(a5)
	lw	a5,-20(s0)
	li	a3,1
	sll	a5,a3,a5
	not	a5,a5
	mv	a3,a5
	li	a5,-2147479552
	and	a4,a4,a3
	sw	a4,0(a5)
.L4:
	nop
	lw	s0,28(sp)
	addi	sp,sp,32
	jr	ra
	.size	gpio_write, .-gpio_write
	.align	2
	.globl	delay_ms
	.type	delay_ms, @function
delay_ms:
	addi	sp,sp,-48
	sw	s0,44(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	li	a5,-2147471360
	lw	a5,0(a5)
	lw	a3,-36(s0)
	li	a4,49152
	addi	a4,a4,848
	mul	a4,a3,a4
	add	a5,a5,a4
	sw	a5,-20(s0)
	nop
.L6:
	li	a5,-2147471360
	lw	a5,0(a5)
	lw	a4,-20(s0)
	bgtu	a4,a5,.L6
	nop
	nop
	lw	s0,44(sp)
	addi	sp,sp,48
	jr	ra
	.size	delay_ms, .-delay_ms
	.align	2
	.globl	put_char
	.type	put_char, @function
put_char:
	addi	sp,sp,-48
	sw	s0,44(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	sw	zero,-20(s0)
	li	a5,-2147475456
	lw	a4,-36(s0)
	sw	a4,0(a5)
	j	.L8
.L9:
	li	a5,-2147475456
	lw	a5,4(a5)
	sw	a5,-20(s0)
.L8:
	lw	a5,-20(s0)
	beq	a5,zero,.L9
	nop
	nop
	lw	s0,44(sp)
	addi	sp,sp,48
	jr	ra
	.size	put_char, .-put_char
	.align	2
	.globl	put_str
	.type	put_str, @function
put_str:
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	s0,40(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	lw	a5,-36(s0)
	sw	a5,-20(s0)
	j	.L11
.L12:
	lw	a5,-20(s0)
	lbu	a5,0(a5)
	mv	a0,a5
	call	put_char
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
.L11:
	lw	a5,-20(s0)
	lbu	a5,0(a5)
	bne	a5,zero,.L12
	nop
	nop
	lw	ra,44(sp)
	lw	s0,40(sp)
	addi	sp,sp,48
	jr	ra
	.size	put_str, .-put_str
	.align	2
	.globl	get_char
	.type	get_char, @function
get_char:
	addi	sp,sp,-32
	sw	s0,28(sp)
	addi	s0,sp,32
	sb	zero,-21(s0)
	sw	zero,-20(s0)
	j	.L14
.L15:
	li	a5,-2147475456
	lw	a5,12(a5)
	sw	a5,-20(s0)
.L14:
	lw	a5,-20(s0)
	beq	a5,zero,.L15
	li	a5,-2147475456
	lw	a5,8(a5)
	sb	a5,-21(s0)
	lbu	a5,-21(s0)
	mv	a0,a5
	lw	s0,28(sp)
	addi	sp,sp,32
	jr	ra
	.size	get_char, .-get_char
	.align	2
	.globl	get_str
	.type	get_str, @function
get_str:
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	s0,40(sp)
	sw	s1,36(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	sw	a1,-40(s0)
	sw	zero,-20(s0)
	j	.L18
.L19:
	lw	a5,-20(s0)
	lw	a4,-36(s0)
	add	s1,a4,a5
	call	get_char
	mv	a5,a0
	sb	a5,0(s1)
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
.L18:
	lw	a4,-20(s0)
	lw	a5,-40(s0)
	blt	a4,a5,.L19
	nop
	nop
	lw	ra,44(sp)
	lw	s0,40(sp)
	lw	s1,36(sp)
	addi	sp,sp,48
	jr	ra
	.size	get_str, .-get_str
	.globl	arr
	.section	.sbss,"aw",@nobits
	.align	2
	.type	arr, @object
	.size	arr, 4
arr:
	.zero	4
	.section	.rodata
	.align	2
.LC0:
	.string	"HexaChipsters\n"
	.align	2
.LC1:
	.string	"Marmara Universitesi\n"
	.align	2
.LC2:
	.string	"Elektrik Elektronik Muhendisligi\n"
	.align	2
.LC3:
	.string	"2024 \n"
	.text
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	s0,40(sp)
	addi	s0,sp,48
	lui	a5,%hi(.LC0)
	addi	a0,a5,%lo(.LC0)
	call	put_str
	lui	a5,%hi(.LC1)
	addi	a0,a5,%lo(.LC1)
	call	put_str
	lui	a5,%hi(.LC2)
	addi	a0,a5,%lo(.LC2)
	call	put_str
	lui	a5,%hi(.LC3)
	addi	a0,a5,%lo(.LC3)
	call	put_str
	li	a5,97
	sb	a5,-17(s0)
	li	a5,1701601280
	addi	a5,a5,1351
	sw	a5,-32(s0)
	li	a5,1700143104
	addi	a5,a5,110
	sw	a5,-28(s0)
	li	a5,4026368
	addi	a5,a5,-1678
	sw	a5,-24(s0)
.L23:
	li	a0,1000
	call	delay_ms
	addi	a5,s0,-32
	mv	a0,a5
	call	put_str
	sw	zero,-40(s0)
	sb	zero,-36(s0)
	addi	a5,s0,-40
	li	a1,5
	mv	a0,a5
	call	get_str
	addi	a5,s0,-40
	mv	a0,a5
	call	put_str
	li	a0,10
	call	put_char
	sb	zero,-18(s0)
	lbu	a5,-39(s0)
	mv	a4,a5
	mv	a5,a4
	slli	a5,a5,1
	add	a5,a5,a4
	sb	a5,-18(s0)
	lbu	a5,-18(s0)
	mv	a0,a5
	call	put_char
	li	a0,10
	call	put_char
	lbu	a5,-38(s0)
	srli	a5,a5,1
	sb	a5,-18(s0)
	lbu	a5,-18(s0)
	mv	a0,a5
	call	put_char
	li	a0,10
	call	put_char
	lbu	a4,-37(s0)
	li	a5,10
	remu	a5,a4,a5
	sb	a5,-18(s0)
	lbu	a5,-18(s0)
	mv	a0,a5
	call	put_char
	li	a0,10
	call	put_char
	lbu	a4,-40(s0)
	li	a5,29
	bleu	a4,a5,.L21
	li	a1,1
	li	a0,2
	call	gpio_write
	j	.L23
.L21:
	li	a1,0
	li	a0,2
	call	gpio_write
	j	.L23
	.size	main, .-main
	.ident	"GCC: (g1ea978e3066) 12.1.0"
