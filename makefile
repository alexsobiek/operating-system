
# ====================================================================================
# General Purpose
# ====================================================================================

all: run
clean:
	$(RM) -rf build/
rebuild:
	$(MAKE) clean
	$(MAKE) all

# ====================================================================================
# General Variables
# ====================================================================================

BUILD_DIR := build
BOOT_BUILD := $(BUILD_DIR)/boot
KERNEL_BUILD := $(BUILD_DIR)/kernel
LIB_BUILD := $(BUILD_DIR)/lib
BINARY_BUILD := $(BUILD_DIR)/binaries


BOOT_DIR := boot
KERNEL_DIR := kernel
LIB_DIR := lib

recursiveWildcard = $(foreach d,$(wildcard $(1:=/*)),$(call rwildcard,$d,$2) $(filter $(subst *,%,$2),$d))

KERNEL_FILES = $(wildcard $(KERNEL_DIR)/*.c)
KERNEL_HEADERS = $(wildcard $(KERNEL_DIR)/*.h)
KERNEL_OBJECTS = $(addprefix $(BUILD_DIR)/, $(KERNEL_FILES:.c=.o))

LIB_FILES = $(shell find $(LIB_DIR) -name "*.c")
LIB_HEADERS = $(call recursiveWildcard, $(LIB_DIR), *.h)
LIB_OBJECTS = $(addprefix $(BUILD_DIR)/, $(LIB_FILES:.c=.o))

OBJECTS := $(KERNEL_OBJECTS)$(LIB_OBJECTS)

# ====================================================================================
# Build Directory Creation
# ====================================================================================

$(shell mkdir -p $(BUILD_DIR) && mkdir -p $(KERNEL_BUILD) && mkdir -p $(BINARY_BUILD))

# ====================================================================================
# Kernel
# ====================================================================================

${KERNEL_BUILD}/kernel_entry.o: $(KERNEL_DIR)/kernel.asm
	nasm $< -f elf -o $@

$(KERNEL_OBJECTS): $(KERNEL_FILES)
	x86_64-elf-gcc -g -m32 -ffreestanding -c $(<D)/$(basename $(@F)).c -o $@

# ====================================================================================
# C Libraries
# ====================================================================================

$(LIB_OBJECTS): $(LIB_FILES)
	mkdir -p $(@D)
	x86_64-elf-gcc -g -m32 -ffreestanding -c $(<D)/$(basename $(@F)).c -o $@

# ====================================================================================
# Binaries
# ====================================================================================

$(BINARY_BUILD)/kernel.bin: ${KERNEL_BUILD}/kernel_entry.o $(KERNEL_OBJECTS) $(LIB_OBJECTS)
	x86_64-elf-ld -m elf_i386 -o $@ -Ttext 0x1000 $^ --oformat binary

$(BINARY_BUILD)/boot.bin: $(BOOT_DIR)/boot.asm
	nasm $< -f bin -o $@

$(BUILD_DIR)/operating-system.bin: $(BINARY_BUILD)/boot.bin $(BINARY_BUILD)/kernel.bin
	cat $^ > $@

# ====================================================================================
# Running with QEMU
# ====================================================================================

run: $(BUILD_DIR)/operating-system.bin
	qemu-system-i386 -fda $<
