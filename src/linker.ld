KERNEL_VIRT = 0xC0000000;
OUTPUT_FORMAT("elf32_i386")
ENTRY(start)
SECTIONS
{
	. = 1M;
	__kernel_phys_start = .;
	.boot : ALIGN(4096)
	{
		*(.boot*)
		*(.boot.data*)
		*(.boot.bss*)
	}

	.init : ALIGN(4096)
	{
		*(.init*)
	}

	. = KERNEL_VIRT;
	__kernel_vma_start = .;

	.text : ALIGN(4096) 
	{
		*(.text*)
	}
	
	.rodata : ALIGN(4096)
	{
		*(.rodata*)
	}

	.data : ALIGN(4096)
	{
		*(.data*)
	}

	__kernel_bss = .;
	.bss : ALIGN(4096)
	{
		*(.bss*)
		*(COMMON)
	}
	__kernel_ebss = .;

	__kernel_vma_end = .;
	__kernel_phys_end = __kernel_vma_end - KERNEL_VIRT + __kernel_phys_start;

	/* discard when we are done boot or initialize system */
	/DISCARD/ :
	{
		*(.boot*)
		*(.boot.data*)
		*(.boot.bss*)
		*(.init*)
		*(.init.*)
	}
}
