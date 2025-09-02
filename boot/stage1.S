.code16
.global _boot

.set KERNEL_CS, 0x08
.set KERNEL_DS, 0x10

_boot:
	ljmp $0, $real_mode
	nop

/* 16-bit code, _boot does long jump to prevent overwriting */
#include "e820.S"

real_mode:
	/* intel docs page 3353 */
	cli
	call e820_start
	xor %ax, %ax
	movw %ax, %dx
	movw %ax, %es
	movw %ax, %ss
	movw $0x7c00, %sp /* we do not use sp */
	
	/* load gdtr */
	lgdt gdtr

	/* enable protected mode */
	movl %cr0, %eax
	xorl $0x1, %eax
	movl %eax, %cr0

	/* long jump, switches to protected mode */
	ljmp $KERNEL_CS, $protected_mode
		
/* gdt table */
gdt:
null:
	.quad 0x0000000000000000	/* NULL */ 
	.quad 0x00cf9b000000ffff	/* KERNEL_CS */ 
	.quad 0x00cf93000000ffff 	/* KERNEL_DS */
gdt_end:
gdtr:
	.word gdt_end - gdt - 1   	/* gdtr limit - 1 */
	.long gdt			/* gdtr base */

.code32
/* sector to read */
.set START_SECT, 1
/* how many to read */
.set TOTAL_SECT, 100
.set TOTAL_WORD, 256
/* where in memory write */
.set DEST_ADDR, 0x00100000

protected_mode:
	/* enable A20 line */
	in $0x92, %al
	or $2, %al
	outb %al, $0x92
	
	mov $START_SECT, %eax
	mov $TOTAL_SECT, %ecx
	mov $DEST_ADDR, %edi

	call read_disk
	ljmp $KERNEL_CS, $DEST_ADDR

	/* start to read disk 
	*  read from second sector and load kernel
	* into specific memory address.
	* we use ATA LBA read
	*/	
read_disk:
	mov %eax, %ebx
		
	mov $0x01f6, %dx
	shrl $24, %eax 
	or $0xe0, %eax
	out %al, %dx

	mov $0x01f2, %dx
	mov %cl, %al
	out %al, %dx

	mov $0x1f3, %dx
	mov %ebx, %eax
	out %al, %dx

	mov $0x1f4, %dx
	mov %ebx, %eax
	shrl $8, %eax
	out %al, %dx

	mov $0x1f5, %dx
	mov %ebx, %eax
	shrl $16, %eax
	out %al, %dx
	
	mov $0x1f7, %dx
	mov $0x20, %al
	out %al, %dx

next_sector:
	push %ecx
try_read:
	mov $0x1f7, %dx
	in %dx, %al
	test $8, %al
	jz try_read	
	
	mov $TOTAL_WORD, %ecx
	mov $0x1F0, %dx
	rep insw
	pop %ecx
	loop next_sector
	ret

.org 510
	.word 0xaa55
