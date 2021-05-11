# $@ = target file
# $< = first dependency
# $^ = all dependencies

all: run

# ===========================================================================
# General Variables
# ===========================================================================

BUILD_DIR := build
BOOT_BUILD := $(BUILD_DIR)/boot
KERNEL_BUILD := $(BUILD_DIR)/kernel
BINARY_BUILD := $(BUILD_DIR)/binaries

BOOT_DIR := boot
KERNEL_DIR := kernel

# ===========================================================================
# Build Directory Creation
# ===========================================================================

$(BUILD_DIR):
	mkdir $(BUILD_DIR)

$(KERNEL_BUILD):
	mkdir $(KERNEL_BUILD)

$(BINARY_BUILD):
	mkdir $(BINARY_BUILD)

make_directories: $(BUILD_DIR) $(KERNEL_BUILD) $(BINARY_BUILD)
	$(MAKE) $(BUILD_DIR)
	$(MAKE) $(KERNEL_BUILD)
	$(MAKE) $(BINARY_BUILD)

# ===========================================================================
# Kernel
# ===========================================================================

$(KERNEL_BUILD)/kernel_entry.o: $(KERNEL_DIR)/kernel.asm
	nasm $< -f elf -o $@

$(KERNEL_BUILD)/kernel.o: $(KERNEL_DIR)/kernel.c
	x86_64-elf-gcc -m32 -ffreestanding -c $< -o $@

$(KERNEL_BUILD)/kernel.dis: $(KERNEL_BUILD)/kernel.bin
	ndisasm -b 32 $< > $@

# ===========================================================================
# Binaries
# ===========================================================================

$(BINARY_BUILD)/kernel.bin: $(KERNEL_BUILD)/kernel_entry.o $(KERNEL_BUILD)/kernel.o
	x86_64-elf-ld -m elf_i386 -o $@ -Ttext 0x1000 $^ --oformat binary

$(BINARY_BUILD)/bootloader.bin: $(BOOT_DIR)/boot.asm
	$(MAKE) make_directories
	nasm $< -f bin -o $@

$(BUILD_DIR)/operating-system.bin: $(BINARY_BUILD)/bootloader.bin $(BINARY_BUILD)/kernel.bin
	cat $^ > $@

run: $(BUILD_DIR)/operating-system.bin
	qemu-system-i386 -fda $<

echo: $(BINARY_BUILD)/operating-system.bin
	xxd $<

# ===========================================================================
# General Purpose
# ===========================================================================

clean:
	$(RM) *.bin *.o *.dis
	$(RM) -rf build/