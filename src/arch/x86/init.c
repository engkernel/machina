#include "arch.h"

uint32_t page_directory[PAGE_ENTRIES] __attribute__((aligned(PAGE_SIZE)));
uint32_t* page_table[PAGE_ENTRIES] __attribute__((aligned(PAGE_SIZE)));

#define SECTION_INIT __attribute__((section(".init")))
#define HEAP_16MB (16 * 1024 * 1024)

/* early paging and heap initialize */
SECTION_INIT
void mm_init()
{
	extern uint32_t __kernel_phys_start;
	extern uint32_t __kernel_phys_end;

	uint32_t kernel_size = (uint32_t)&__kernel_phys_end - (uint32_t)&__kernel_phys_start;
	/* clear page directory */
	for (int i = 0; i < PAGE_ENTRIES; i++)
		page_directory[i] = 0;

	/* FIX map low memory for devices and bios in case of need 
	 * identity map 
	 */
	for (uint32_t addr = 0; addr < 0x400000; addr += PAGE_SIZE)
		map_page(addr, addr, PAGE_PRESENT_RW);

	/* map kernel to high half */
	for (uint32_t offset = 0; offset < kernel_size; offset += PAGE_SIZE)
		map_page(HIGH_HALF_KERNEL + offset, __kernel_phys_start + offset, PAGE_PRESENT_RW);

	/* 16 MB heap for expand */
	uint32_t heap_start = HIGH_HALF_KERNEL + (kernel_size);
	uint32_t heap_end = heap_start + HEAP_16MB;
	for (uint32_t addr = heap_start; addr < heap_end; addr += PAGE_SIZE)
		map_page(addr, addr, PAGE_PRESENT_RW);

	/* load CR3 with our kenrel page directory */
	__asm__ volatile("mov %0, %%cr3" :: "r"(page_directory));
} 


