
# ====================================================================================
# General Purpose
# ====================================================================================

all: run
clean:
	$(RM) -rf build/

# ====================================================================================
# General Variables
# ====================================================================================

BUILD_DIR := build
BOOT_BUILD := $(BUILD_DIR)/boot
KERNEL_BUILD := $(BUILD_DIR)/kernel
BINARY_BUILD := $(BUILD_DIR)/binaries

BOOT_DIR := boot
KERNEL_DIR := kernel

KERNEL_FILES = $(wildcard $(KERNEL_DIR)/*.c)
KERNEL_HEADERS = $(wildcard $(KERNEL_DIR)/*.h)
KERNEL_OBJECTS = $(addprefix $(BUILD_DIR)/, $(KERNEL_FILES:.c=.o))

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
	x86_64-elf-gcc -m32 -ffreestanding -c $< -o $@

# ====================================================================================
# Binaries
# ====================================================================================

$(BINARY_BUILD)/kernel.bin: ${KERNEL_BUILD}/kernel_entry.o $(KERNEL_OBJECTS)
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
