#include "arch.h"
#include <stdint.h>
#include <stddef.h>


extern uint32_t __kernel_phys_end;
static uint32_t first_free_frame = (uint32_t)&__kernel_phys_end;


static inline void set_bit(uint32_t* bitmap, uint32_t idx)
{
	frame_bitmaps[idx/32] |= (1U << (idx % 32));
}

static inline void clear_bit(uint32_t* bitmap, uint32_t idx)
{
	frame_bitmaps[idx/32] &= ~(1U << (idx % 32));
}

static inline int test_bit(uint32_t *bitmap, uint32_t idx)
{
	return (frame_bitmaps[idx/32] >> (idx % 32)) & 1;
}

uint32_t frame_alloc()
{
	for (uint32_t i = 0; i < MAX_PAGES; i++)
	{
		if (!test_bit(frame_bitmaps, i))
		{
			set_bit(frame_bitmaps, i);
			return first_free_frame + i * PAGE_SIZE;
		}
	}
	return 0;
}

void frame_free(uint32_t phys)
{
	uint32_t frame_idx = phys / PAGE_SIZE;
	clear_bit(frame_bitmaps, frame_idx);
}
