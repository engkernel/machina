#ifndef X86_H
#define X86_H

#include <stdint.h>

/* paging */
#define PAGE_SIZE 	4096
#define PAGE_ENTRIES 	1024
#define HIGH_HALF_KERNEL 0xC0000000
#define PAGE_PRESENT_RW	0x3

extern uint32_t page_directory[PAGE_ENTRIES] __attribute__((aligned(PAGE_SIZE)));
extern uint32_t page_table[PAGE_ENTRIES][PAGE_ENTRIES] __attribute__((aligned(PAGE_SIZE)));

/* map vma to phys */
#define VIRT_PDE_INDEX(virt) (virt >> 22) & 0x3FF
#define VIRT_PTE_INDEX(virt) (virt >> 12) & 0x3FF

static inline void map_page(uint32_t virt, uint32_t phys, uint32_t flags)
{
	uint32_t pde_index = VIRT_PDE_INDEX(virt);
	uint32_t pte_index = VIRT_PTE_INDEX(virt);
	if (!(page_directory[pde_index] & PAGE_PRESENT_RW))	
	{
		page_directory[pde_index] = ((uint32_t)&page_table[pde_index]) | PAGE_PRESENT_RW;

		/* clean page table */
		for (int i = 0; i < PAGE_ENTRIES; i++)
			page_table[pde_index][i] = 0;
	}

	page_table[pde_index][pte_index] = (phys & 0xFFFFF000) | (flags & 0xFFF);
}

#endif /* X86_H */

