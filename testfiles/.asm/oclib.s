	.file	"oclib.c"
	.text
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"%s:%d: assert (%s) failed\n"
	.text
	.p2align 4,,15
	.globl	fail
	.type	fail, @function
fail:
.LFB32:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movq	%rdi, %r8
	movq	stderr(%rip), %rdi
	movl	%edx, %ecx
	xorl	%eax, %eax
	movq	%rsi, %rdx
	movl	$.LC0, %esi
	call	fprintf
	call	abort
	.cfi_endproc
.LFE32:
	.size	fail, .-fail
	.section	.rodata.str1.1
.LC1:
	.string	"../oclib.c"
.LC2:
	.string	"result != nullptr"
	.text
	.p2align 4,,15
	.globl	xcalloc
	.type	xcalloc, @function
xcalloc:
.LFB33:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movslq	%esi, %rsi
	movslq	%edi, %rdi
	call	calloc
	testq	%rax, %rax
	je	.L7
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L7:
	.cfi_restore_state
	movl	$20, %edx
	movl	$.LC1, %esi
	movl	$.LC2, %edi
	call	fail
	.cfi_endproc
.LFE33:
	.size	xcalloc, .-xcalloc
	.p2align 4,,15
	.globl	putchr
	.type	putchr, @function
putchr:
.LFB34:
	.cfi_startproc
	jmp	putchar
	.cfi_endproc
.LFE34:
	.size	putchr, .-putchr
	.section	.rodata.str1.1
.LC3:
	.string	"%d"
	.text
	.p2align 4,,15
	.globl	putint
	.type	putint, @function
putint:
.LFB35:
	.cfi_startproc
	movl	%edi, %esi
	xorl	%eax, %eax
	movl	$.LC3, %edi
	jmp	printf
	.cfi_endproc
.LFE35:
	.size	putint, .-putint
	.section	.rodata.str1.1
.LC4:
	.string	"%s"
	.text
	.p2align 4,,15
	.globl	putstr
	.type	putstr, @function
putstr:
.LFB36:
	.cfi_startproc
	movq	%rdi, %rsi
	xorl	%eax, %eax
	movl	$.LC4, %edi
	jmp	printf
	.cfi_endproc
.LFE36:
	.size	putstr, .-putstr
	.p2align 4,,15
	.globl	getchr
	.type	getchr, @function
getchr:
.LFB37:
	.cfi_startproc
	movq	stdin(%rip), %rdi
	jmp	_IO_getc
	.cfi_endproc
.LFE37:
	.size	getchr, .-getchr
	.section	.rodata.str1.1
.LC5:
	.string	"%%%zds"
	.text
	.p2align 4,,15
	.globl	getstr
	.type	getstr, @function
getstr:
.LFB38:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movl	$.LC5, %esi
	movl	$format.3364, %edi
	xorl	%eax, %eax
	movl	$4095, %edx
	call	sprintf
	xorl	%eax, %eax
	movl	$get_buffer, %esi
	movl	$format.3364, %edi
	call	__isoc99_scanf
	cmpl	$1, %eax
	je	.L15
	xorl	%eax, %eax
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L15:
	.cfi_restore_state
	movl	$get_buffer, %edi
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	jmp	__strdup
	.cfi_endproc
.LFE38:
	.size	getstr, .-getstr
	.p2align 4,,15
	.globl	getln
	.type	getln, @function
getln:
.LFB39:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movq	stdin(%rip), %rdx
	movl	$4096, %esi
	movl	$get_buffer, %edi
	call	fgets
	testq	%rax, %rax
	je	.L16
	movq	%rax, %rdi
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	jmp	__strdup
	.p2align 4,,10
	.p2align 3
.L16:
	.cfi_restore_state
	xorl	%eax, %eax
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE39:
	.size	getln, .-getln
	.local	format.3364
	.comm	format.3364,16,16
	.local	get_buffer
	.comm	get_buffer,4096,32
	.ident	"GCC: (GNU) 8.2.1 20180905 (Red Hat 8.2.1-3)"
	.section	.note.GNU-stack,"",@progbits
