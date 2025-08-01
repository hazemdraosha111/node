.text
.globl	_bn_mul_mont
.type	_bn_mul_mont,@function
.align	4
_bn_mul_mont:
L_bn_mul_mont_begin:
	%ifdef __CET__

.byte	243,15,30,251
	%endif

	pushl	%ebp
	pushl	%ebx
	pushl	%esi
	pushl	%edi
	xorl	%eax,%eax
	movl	40(%esp),%edi
	cmpl	$4,%edi
	jl	L000just_leave
	leal	20(%esp),%esi
	leal	24(%esp),%edx
	addl	$2,%edi
	negl	%edi
	leal	-32(%esp,%edi,4),%ebp
	negl	%edi
	movl	%ebp,%eax
	subl	%edx,%eax
	andl	$2047,%eax
	subl	%eax,%ebp
	xorl	%ebp,%edx
	andl	$2048,%edx
	xorl	$2048,%edx
	subl	%edx,%ebp
	andl	$-64,%ebp
	movl	%esp,%eax
	subl	%ebp,%eax
	andl	$-4096,%eax
	movl	%esp,%edx
	leal	(%ebp,%eax,1),%esp
	movl	(%esp),%eax
	cmpl	%ebp,%esp
	ja	L001page_walk
	jmp	L002page_walk_done
.align	4,0x90
L001page_walk:
	leal	-4096(%esp),%esp
	movl	(%esp),%eax
	cmpl	%ebp,%esp
	ja	L001page_walk
L002page_walk_done:
	movl	(%esi),%eax
	movl	4(%esi),%ebx
	movl	8(%esi),%ecx
	movl	12(%esi),%ebp
	movl	16(%esi),%esi
	movl	(%esi),%esi
	movl	%eax,4(%esp)
	movl	%ebx,8(%esp)
	movl	%ecx,12(%esp)
	movl	%ebp,16(%esp)
	movl	%esi,20(%esp)
	leal	-3(%edi),%ebx
	movl	%edx,24(%esp)
	call	L003PIC_me_up
L003PIC_me_up:
	popl	%eax
	leal	__GLOBAL_OFFSET_TABLE_+[.-L003PIC_me_up](%eax),%eax
	movl	_OPENSSL_ia32cap_P@GOT(%eax),%eax
	btl	$26,(%eax)
	jnc	L004non_sse2
	movl	$-1,%eax
	movd	%eax,%mm7
	movl	8(%esp),%esi
	movl	12(%esp),%edi
	movl	16(%esp),%ebp
	xorl	%edx,%edx
	xorl	%ecx,%ecx
	movd	(%edi),%mm4
	movd	(%esi),%mm5
	movd	(%ebp),%mm3
	pmuludq	%mm4,%mm5
	movq	%mm5,%mm2
	movq	%mm5,%mm0
	pand	%mm7,%mm0
	pmuludq	20(%esp),%mm5
	pmuludq	%mm5,%mm3
	paddq	%mm0,%mm3
	movd	4(%ebp),%mm1
	movd	4(%esi),%mm0
	psrlq	$32,%mm2
	psrlq	$32,%mm3
	incl	%ecx
.align	4,0x90
L0051st:
	pmuludq	%mm4,%mm0
	pmuludq	%mm5,%mm1
	paddq	%mm0,%mm2
	paddq	%mm1,%mm3
	movq	%mm2,%mm0
	pand	%mm7,%mm0
	movd	4(%ebp,%ecx,4),%mm1
	paddq	%mm0,%mm3
	movd	4(%esi,%ecx,4),%mm0
	psrlq	$32,%mm2
	movd	%mm3,28(%esp,%ecx,4)
	psrlq	$32,%mm3
	leal	1(%ecx),%ecx
	cmpl	%ebx,%ecx
	jl	L0051st
	pmuludq	%mm4,%mm0
	pmuludq	%mm5,%mm1
	paddq	%mm0,%mm2
	paddq	%mm1,%mm3
	movq	%mm2,%mm0
	pand	%mm7,%mm0
	paddq	%mm0,%mm3
	movd	%mm3,28(%esp,%ecx,4)
	psrlq	$32,%mm2
	psrlq	$32,%mm3
	paddq	%mm2,%mm3
	movq	%mm3,32(%esp,%ebx,4)
	incl	%edx
L006outer:
	xorl	%ecx,%ecx
	movd	(%edi,%edx,4),%mm4
	movd	(%esi),%mm5
	movd	32(%esp),%mm6
	movd	(%ebp),%mm3
	pmuludq	%mm4,%mm5
	paddq	%mm6,%mm5
	movq	%mm5,%mm0
	movq	%mm5,%mm2
	pand	%mm7,%mm0
	pmuludq	20(%esp),%mm5
	pmuludq	%mm5,%mm3
	paddq	%mm0,%mm3
	movd	36(%esp),%mm6
	movd	4(%ebp),%mm1
	movd	4(%esi),%mm0
	psrlq	$32,%mm2
	psrlq	$32,%mm3
	paddq	%mm6,%mm2
	incl	%ecx
	decl	%ebx
L007inner:
	pmuludq	%mm4,%mm0
	pmuludq	%mm5,%mm1
	paddq	%mm0,%mm2
	paddq	%mm1,%mm3
	movq	%mm2,%mm0
	movd	36(%esp,%ecx,4),%mm6
	pand	%mm7,%mm0
	movd	4(%ebp,%ecx,4),%mm1
	paddq	%mm0,%mm3
	movd	4(%esi,%ecx,4),%mm0
	psrlq	$32,%mm2
	movd	%mm3,28(%esp,%ecx,4)
	psrlq	$32,%mm3
	paddq	%mm6,%mm2
	decl	%ebx
	leal	1(%ecx),%ecx
	jnz	L007inner
	movl	%ecx,%ebx
	pmuludq	%mm4,%mm0
	pmuludq	%mm5,%mm1
	paddq	%mm0,%mm2
	paddq	%mm1,%mm3
	movq	%mm2,%mm0
	pand	%mm7,%mm0
	paddq	%mm0,%mm3
	movd	%mm3,28(%esp,%ecx,4)
	psrlq	$32,%mm2
	psrlq	$32,%mm3
	movd	36(%esp,%ebx,4),%mm6
	paddq	%mm2,%mm3
	paddq	%mm6,%mm3
	movq	%mm3,32(%esp,%ebx,4)
	leal	1(%edx),%edx
	cmpl	%ebx,%edx
	jle	L006outer
	emms
	jmp	L008common_tail
.align	4,0x90
L004non_sse2:
	movl	8(%esp),%esi
	leal	1(%ebx),%ebp
	movl	12(%esp),%edi
	xorl	%ecx,%ecx
	movl	%esi,%edx
	andl	$1,%ebp
	subl	%edi,%edx
	leal	4(%edi,%ebx,4),%eax
	orl	%edx,%ebp
	movl	(%edi),%edi
	jz	L009bn_sqr_mont
	movl	%eax,28(%esp)
	movl	(%esi),%eax
	xorl	%edx,%edx
.align	4,0x90
L010mull:
	movl	%edx,%ebp
	mull	%edi
	addl	%eax,%ebp
	leal	1(%ecx),%ecx
	adcl	$0,%edx
	movl	(%esi,%ecx,4),%eax
	cmpl	%ebx,%ecx
	movl	%ebp,28(%esp,%ecx,4)
	jl	L010mull
	movl	%edx,%ebp
	mull	%edi
	movl	20(%esp),%edi
	addl	%ebp,%eax
	movl	16(%esp),%esi
	adcl	$0,%edx
	imull	32(%esp),%edi
	movl	%eax,32(%esp,%ebx,4)
	xorl	%ecx,%ecx
	movl	%edx,36(%esp,%ebx,4)
	movl	%ecx,40(%esp,%ebx,4)
	movl	(%esi),%eax
	mull	%edi
	addl	32(%esp),%eax
	movl	4(%esi),%eax
	adcl	$0,%edx
	incl	%ecx
	jmp	L0112ndmadd
.align	4,0x90
L0121stmadd:
	movl	%edx,%ebp
	mull	%edi
	addl	32(%esp,%ecx,4),%ebp
	leal	1(%ecx),%ecx
	adcl	$0,%edx
	addl	%eax,%ebp
	movl	(%esi,%ecx,4),%eax
	adcl	$0,%edx
	cmpl	%ebx,%ecx
	movl	%ebp,28(%esp,%ecx,4)
	jl	L0121stmadd
	movl	%edx,%ebp
	mull	%edi
	addl	32(%esp,%ebx,4),%eax
	movl	20(%esp),%edi
	adcl	$0,%edx
	movl	16(%esp),%esi
	addl	%eax,%ebp
	adcl	$0,%edx
	imull	32(%esp),%edi
	xorl	%ecx,%ecx
	addl	36(%esp,%ebx,4),%edx
	movl	%ebp,32(%esp,%ebx,4)
	adcl	$0,%ecx
	movl	(%esi),%eax
	movl	%edx,36(%esp,%ebx,4)
	movl	%ecx,40(%esp,%ebx,4)
	mull	%edi
	addl	32(%esp),%eax
	movl	4(%esi),%eax
	adcl	$0,%edx
	movl	$1,%ecx
.align	4,0x90
L0112ndmadd:
	movl	%edx,%ebp
	mull	%edi
	addl	32(%esp,%ecx,4),%ebp
	leal	1(%ecx),%ecx
	adcl	$0,%edx
	addl	%eax,%ebp
	movl	(%esi,%ecx,4),%eax
	adcl	$0,%edx
	cmpl	%ebx,%ecx
	movl	%ebp,24(%esp,%ecx,4)
	jl	L0112ndmadd
	movl	%edx,%ebp
	mull	%edi
	addl	32(%esp,%ebx,4),%ebp
	adcl	$0,%edx
	addl	%eax,%ebp
	adcl	$0,%edx
	movl	%ebp,28(%esp,%ebx,4)
	xorl	%eax,%eax
	movl	12(%esp),%ecx
	addl	36(%esp,%ebx,4),%edx
	adcl	40(%esp,%ebx,4),%eax
	leal	4(%ecx),%ecx
	movl	%edx,32(%esp,%ebx,4)
	cmpl	28(%esp),%ecx
	movl	%eax,36(%esp,%ebx,4)
	je	L008common_tail
	movl	(%ecx),%edi
	movl	8(%esp),%esi
	movl	%ecx,12(%esp)
	xorl	%ecx,%ecx
	xorl	%edx,%edx
	movl	(%esi),%eax
	jmp	L0121stmadd
.align	4,0x90
L009bn_sqr_mont:
	movl	%ebx,(%esp)
	movl	%ecx,12(%esp)
	movl	%edi,%eax
	mull	%edi
	movl	%eax,32(%esp)
	movl	%edx,%ebx
	shrl	$1,%edx
	andl	$1,%ebx
	incl	%ecx
.align	4,0x90
L013sqr:
	movl	(%esi,%ecx,4),%eax
	movl	%edx,%ebp
	mull	%edi
	addl	%ebp,%eax
	leal	1(%ecx),%ecx
	adcl	$0,%edx
	leal	(%ebx,%eax,2),%ebp
	shrl	$31,%eax
	cmpl	(%esp),%ecx
	movl	%eax,%ebx
	movl	%ebp,28(%esp,%ecx,4)
	jl	L013sqr
	movl	(%esi,%ecx,4),%eax
	movl	%edx,%ebp
	mull	%edi
	addl	%ebp,%eax
	movl	20(%esp),%edi
	adcl	$0,%edx
	movl	16(%esp),%esi
	leal	(%ebx,%eax,2),%ebp
	imull	32(%esp),%edi
	shrl	$31,%eax
	movl	%ebp,32(%esp,%ecx,4)
	leal	(%eax,%edx,2),%ebp
	movl	(%esi),%eax
	shrl	$31,%edx
	movl	%ebp,36(%esp,%ecx,4)
	movl	%edx,40(%esp,%ecx,4)
	mull	%edi
	addl	32(%esp),%eax
	movl	%ecx,%ebx
	adcl	$0,%edx
	movl	4(%esi),%eax
	movl	$1,%ecx
.align	4,0x90
L0143rdmadd:
	movl	%edx,%ebp
	mull	%edi
	addl	32(%esp,%ecx,4),%ebp
	adcl	$0,%edx
	addl	%eax,%ebp
	movl	4(%esi,%ecx,4),%eax
	adcl	$0,%edx
	movl	%ebp,28(%esp,%ecx,4)
	movl	%edx,%ebp
	mull	%edi
	addl	36(%esp,%ecx,4),%ebp
	leal	2(%ecx),%ecx
	adcl	$0,%edx
	addl	%eax,%ebp
	movl	(%esi,%ecx,4),%eax
	adcl	$0,%edx
	cmpl	%ebx,%ecx
	movl	%ebp,24(%esp,%ecx,4)
	jl	L0143rdmadd
	movl	%edx,%ebp
	mull	%edi
	addl	32(%esp,%ebx,4),%ebp
	adcl	$0,%edx
	addl	%eax,%ebp
	adcl	$0,%edx
	movl	%ebp,28(%esp,%ebx,4)
	movl	12(%esp),%ecx
	xorl	%eax,%eax
	movl	8(%esp),%esi
	addl	36(%esp,%ebx,4),%edx
	adcl	40(%esp,%ebx,4),%eax
	movl	%edx,32(%esp,%ebx,4)
	cmpl	%ebx,%ecx
	movl	%eax,36(%esp,%ebx,4)
	je	L008common_tail
	movl	4(%esi,%ecx,4),%edi
	leal	1(%ecx),%ecx
	movl	%edi,%eax
	movl	%ecx,12(%esp)
	mull	%edi
	addl	32(%esp,%ecx,4),%eax
	adcl	$0,%edx
	movl	%eax,32(%esp,%ecx,4)
	xorl	%ebp,%ebp
	cmpl	%ebx,%ecx
	leal	1(%ecx),%ecx
	je	L015sqrlast
	movl	%edx,%ebx
	shrl	$1,%edx
	andl	$1,%ebx
.align	4,0x90
L016sqradd:
	movl	(%esi,%ecx,4),%eax
	movl	%edx,%ebp
	mull	%edi
	addl	%ebp,%eax
	leal	(%eax,%eax,1),%ebp
	adcl	$0,%edx
	shrl	$31,%eax
	addl	32(%esp,%ecx,4),%ebp
	leal	1(%ecx),%ecx
	adcl	$0,%eax
	addl	%ebx,%ebp
	adcl	$0,%eax
	cmpl	(%esp),%ecx
	movl	%ebp,28(%esp,%ecx,4)
	movl	%eax,%ebx
	jle	L016sqradd
	movl	%edx,%ebp
	addl	%edx,%edx
	shrl	$31,%ebp
	addl	%ebx,%edx
	adcl	$0,%ebp
L015sqrlast:
	movl	20(%esp),%edi
	movl	16(%esp),%esi
	imull	32(%esp),%edi
	addl	32(%esp,%ecx,4),%edx
	movl	(%esi),%eax
	adcl	$0,%ebp
	movl	%edx,32(%esp,%ecx,4)
	movl	%ebp,36(%esp,%ecx,4)
	mull	%edi
	addl	32(%esp),%eax
	leal	-1(%ecx),%ebx
	adcl	$0,%edx
	movl	$1,%ecx
	movl	4(%esi),%eax
	jmp	L0143rdmadd
.align	4,0x90
L008common_tail:
	movl	16(%esp),%ebp
	movl	4(%esp),%edi
	leal	32(%esp),%esi
	movl	(%esi),%eax
	movl	%ebx,%ecx
	xorl	%edx,%edx
.align	4,0x90
L017sub:
	sbbl	(%ebp,%edx,4),%eax
	movl	%eax,(%edi,%edx,4)
	decl	%ecx
	movl	4(%esi,%edx,4),%eax
	leal	1(%edx),%edx
	jge	L017sub
	sbbl	$0,%eax
	movl	$-1,%edx
	xorl	%eax,%edx
	jmp	L018copy
.align	4,0x90
L018copy:
	movl	32(%esp,%ebx,4),%esi
	movl	(%edi,%ebx,4),%ebp
	movl	%ecx,32(%esp,%ebx,4)
	andl	%eax,%esi
	andl	%edx,%ebp
	orl	%esi,%ebp
	movl	%ebp,(%edi,%ebx,4)
	decl	%ebx
	jge	L018copy
	movl	24(%esp),%esp
	movl	$1,%eax
L000just_leave:
	popl	%edi
	popl	%esi
	popl	%ebx
	popl	%ebp
	ret
.byte	77,111,110,116,103,111,109,101,114,121,32,77,117,108,116,105
.byte	112,108,105,99,97,116,105,111,110,32,102,111,114,32,120,56
.byte	54,44,32,67,82,89,80,84,79,71,65,77,83,32,98,121
.byte	32,60,97,112,112,114,111,64,111,112,101,110,115,115,108,46
.byte	111,114,103,62,0
.comm	_OPENSSL_ia32cap_P,40
