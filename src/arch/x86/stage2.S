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
	//mov $0x00200000, %esp
	//mov %esp, %ebp

	/* setup basic paging for kernel higher half */
	mov $boot_init, %eax
	call *%eax	

	mov $mm_init, %eax
	call *%eax

	mov $kmain, %eax
	call *%eax
loop:
	jmp loop

.fill 512-(.-start),1,0
