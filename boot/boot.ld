ENTRY(_boot)
SECTIONS
{
	. = 0x7c00;
	.bootloader :
	{
		*(.bootloader)
	}
}
