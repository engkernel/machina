ARCH ?= x86
CC=clang-19
LD=ld.lld
OBJCOPY=llvm-objcopy-19
MACHINE=elf_i386

TARGET :=-target i386-pc-none-elf

CCFLAGS := -m32 -g -ffreestanding -fno-builtin -O0 -Wall -Iinc -nostdlib -nodefaultlibs -falign-functions=16 -fomit-frame-pointer -finline-functions -Wno-unused-function -Werror -Wno-unused-label -Wno-cpp -Wno-unused-parameter -I$(PROJECT_ROOT)/src -I. -std=c17 

BUILD_DIR=$(PROJECT_ROOT)/build
