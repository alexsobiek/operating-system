
all: run

kernel.bin: kernel_entry.o kernel.o
	x86_64-elf-ld -m elf_i386 -o $@ -Ttext 0x1000 $^ --oformat binary

kernel_entry.o: kernel.asm
	nasm $< -f elf -o $@

kernel.o: kernel.c
	x86_64-elf-gcc -m32 -ffreestanding -c $< -o $@

kernel.dis: kernel.bin
	ndisasm -b 32 $< > $@

bootloader.bin: boot.asm
	nasm $< -f bin -o $@

operating-system.bin: bootloader.bin kernel.bin
	cat $^ > $@

run: operating-system.bin
	qemu-system-i386 -fda $<

echo: operating-system.bin
	xxd $<

clean:
	$(RM) *.bin *.o *.dis