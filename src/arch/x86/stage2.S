.code32
.section .boot
.global start
.extern kmain

.set KERNEL_DS, 0x10
.set HIGH_KERNEL_BASE, 0xc0000000
start:
	mov $KERNEL_DS, %ax
	mov %ax, %ds
	mov %ax, %es
	mov %ax, %fs
	mov %ax, %gs
	mov %ax, %ss
	mov $0x00200000, %ebp
	mov %ebp, %esp

	/* setup basic paging for kernel higher half */
	call boot_init

	/* setup full paging, heap, stack */
	call setup_memory

	mov $HIGH_KERNEL_BASE + 0x10000, %esp
	mov %esp, %ebp

	jmp kmain
loop:
	jmp loop

.fill 512-(.-start),1,0
