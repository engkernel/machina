include $(PROJECT_ROOT)/mk/common.mk
include $(PROJECT_ROOT)/mk/config.mk

BOOT := $(BUILD_DIR)/boot
SRCS := $(wildcard *.S)

OBJS := $(patsubst %.S, %(BOOT)/%.S.o, $(SRCS))

BOOT_OBJ := $(BOOT)/stage1.S.o

all: $(BOOT)/boot.bin

$(BOOT)/%.S.o: %.S | $(BOOT)
	$(CC) -c $(TARGET) $< -o $@

$(BOOT)/boot.elf: $(BOOT_OBJ)
	$(LD) -m elf_i386 -T boot.ld --Map=$(BOOT)/boot.map -o $@ $^

$(BOOT)/boot.bin: $(BOOT)/boot.elf
	llvm-objcopy-19 -O binary $< $@

$(BOOT):
	mkdir -p $@

.PHONY: clean
clean:
	rm -rf $(BOOT)
