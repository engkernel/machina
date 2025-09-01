/* e820 memory map via int 0x15 
* input: es:di -> buffer for 24-byte entries
* output: bp-> number of entries, entry cound store at 0x8000
*/

.equ mmap_ent, 0x8000

e820_start:
	movw $0x8004, %di	/* buffer offset */
	xorl %ebx, %ebx		/* 0 to start */
	xorw %bp, %bp		/* entry count */
	movl $0x534D4150, %edx	/* "SMAP" sign */
	movl $0xe820, %eax	/* e820 bios call */
	movw $1, %es:20(%di)	/* force valid ACPI 3.x entry */
	movl $24, %ecx		/* request 24 bytes */
	int $0x15
	jc .failed

	movl $0x534D4150, %edx
	cmpl %edx, %eax
	jne .failed
	testl %ebx, %ebx
	je .failed

	jmp .entry_loop

.e820_loop:
	movl $0xe820, %eax
	movw $1, %es:20(%di) 
	movl $24, %ecx
	int $0x15
	jc .done_list
	movl $0x534D4150, %edx

.entry_loop:
	jcxz .skip_entry
	cmpb $20, %cl
	jbe .notext
	testb $1, %es:20(%di)
	je .skip_entry

.notext:
	movl %es:8(%di), %ecx
	orl %es:12(%di), %ecx
	jz .skip_entry
	inc %bp
	addw $24, %di
.skip_entry:
	testl %ebx, %ebx
	jne .e820_loop

.done_list:
	movw %bp, mmap_ent	/* store entry count */
	clc
	ret

.failed:
	stc
	ret
