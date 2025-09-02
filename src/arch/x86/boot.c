#include "arch.h"

#include <stdint.h>

#define SECTION_BOOT __attribute__((section(".boot")))
#define TOTAL_PG_DIR	1024
#define TOTAL_PTE0	1024
#define BOOT_PAGE_SIZE	4096
#define BOOT_STACK_SIZE (BOOT_PAGE_SIZE/4)

#define HIGH_HALF_PDE (HIGH_HALF_KERNEL >> 22)

__attribute__((aligned(BOOT_PAGE_SIZE), section(".boot.data")))
static uint32_t boot_pd[TOTAL_PG_DIR];

__attribute__((aligned(BOOT_PAGE_SIZE), section(".boot.data")))
static uint32_t boot_pt0[TOTAL_PTE0];

//__attribute__((aligned(BOOT_PAGE_SIZE), section(".boot.data")))
//static uint32_t boot_stack[BOOT_STACK_SIZE];

SECTION_BOOT
void boot_init()
{
	uint32_t cr0;

	/* clear bss to make sure no data exist */
	extern uint32_t* __kernel_bss;
	extern uint32_t* __kernel_ebss;
	for (uint32_t* p = __kernel_bss; p < __kernel_ebss; p++)
		*p = 0;

	/* clear pg, pte */
	for (int i = 0; i < TOTAL_PG_DIR; ++i)
		boot_pd[i] = 0;

	for (int i = 0; i < TOTAL_PTE0; ++i)
		boot_pt0[i] = 0;

	for (int i = 0; i < TOTAL_PTE0; ++i)
		boot_pt0[i] = (BOOT_PAGE_SIZE * i) | PAGE_PRESENT_RW;

	/* install pt at pd for identity mapping */
	boot_pd[0] = ((uint32_t)boot_pt0 | PAGE_PRESENT_RW);

	/* install same pt at pd for 0xC0000000
	 * PDE index = (0xC0000000 >> 22) = 768
	 * for high half kernel access through paging
	 */
	boot_pd[HIGH_HALF_PDE] = ((uint32_t)boot_pt0 | PAGE_PRESENT_RW);
	
	/* now we start mapping the physical kernel to vma so we could read really higher half */
	/* load cr3 */
	__asm__ volatile("mov %0, %%cr3" :: "r"(boot_pd));

	/* enable paging */
	__asm__ volatile("mov %%cr0, %0" : "=r"(cr0));
	cr0 |= 0x80000000u;
	__asm__ volatile("mov %0, %%cr0" :: "r"(cr0));
}
