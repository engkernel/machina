include mk/common.mk
include mk/config.mk

export PROJECT_ROOT

BOOT_BIN := $(BUILD_DIR)/boot/boot.bin
KERNEL_ELF := $(BUILD_DIR)/kernel.elf
KERNEL_BIN := $(BUILD_DIR)/kernel.bin
MACHINA_BIN := $(BUILD_DIR)/machina.bin

all: subdirs link bin

subdirs:
	$(MAKE) -C boot
	$(MAKE) -C src

link:
	$(LD) -m $(MACHINE) -T src/linker.ld --Map=$(BUILD_DIR)/kernel.map -nostdlib -o $(KERNEL_ELF) $(shell find $(BUILD_DIR) -name '*.o' ! -path '$(BUILD_DIR)/boot/*')
	$(OBJCOPY) -O binary $(KERNEL_ELF) $(BUILD_DIR)/kernel.bin

bin: $(KERNEL_ELF) $(BOOT_BIN)
	rm -rf $(MACHINA_BIN)
	dd if=$(BOOT_BIN) >> $(MACHINA_BIN)
	dd if=$(KERNEL_BIN) >> $(MACHINA_BIN)
	dd if=/dev/zero bs=1048576 count=16 >> $(MACHINA_BIN)

.PHONY: clean
clean:
	$(MAKE) -C boot clean
	$(MAKE) -C src clean
	rm -f $(BUILD_DIR)/kernel.elf
	rm -f $(BUILD_DIR)/kernel.bin
	rm -f $(BUILD_DIR)/machina.bin
