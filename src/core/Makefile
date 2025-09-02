include $(PROJECT_ROOT)/mk/common.mk
include $(PROJECT_ROOT)/mk/config.mk

CORE_DIR := $(BUILD_DIR)/core

C_SRCS := $(wildcard *.c)
C_OBJS := $(patsubst %.c, $(CORE_DIR)/%.o, $(C_SRCS))

all: $(C_OBJS)

$(CORE_DIR)/%.o: %.c | $(CORE_DIR)
	$(CC) -c $(TARGET) $(CCFLAGS) $< -o $@

$(CORE_DIR):
	mkdir -p $@

.PHONY: clean
clean:
	rm -rf $(CORE_DIR)
