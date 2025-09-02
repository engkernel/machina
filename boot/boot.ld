ENTRY(_boot)
SECTIONS
{
	. = 0x7c00;
	.text : ALIGN(4096)
	{
		*(.text)
	}
}
