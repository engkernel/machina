OUTPUT_FORMAT("elf32-i386")
ENTRY(start)
SECTIONS
{
	. = 1M;
	.boot : ALIGN(4096)
	{
		*(.boot*)
		*(.boot.data*)
		*(.boot.bss*)
		*(.init*)
	}

	__kernel_phys_start = .;
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
	__kernel_phys_end = .;

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
