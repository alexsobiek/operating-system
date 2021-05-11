; ===========================================================================
; Boot Loader for my simple operating system
;
; A large portion of this assembly code is credited to Frank Rosner:
; https://github.com/FRosner/FrOS/tree/minimal-c-kernel
; ===========================================================================

[bits 16]
[org 0x7C00]                            ; Load the boot loader into 0x7C00

KERNEL_OFFSET equ 0x1000                ; Define kernel offset where it should be loaded to

mov [BOOT_DRIVE], dl                    ; Move the boot drive stored in dl (by the BIOS) into BOOT_DRIVE

mov bp, 0x9000                          ; Setup the stack
mov sp, bp                              ; Move sp (top of the stack) into bp (bottom of the stack)

call kernel                             ; Begin loading the kernel
call switch_to_32bit                    ; Switch to 32 bit mode

jmp $

[bits 16]
kernel:
    mov bx, KERNEL_OFFSET
    mov dh, 2
    mov dl, [BOOT_DRIVE]
    call disk_load
    ret

; ===========================================================================
; Global Descriptor Table
; ===========================================================================
gdt_start:
    dq 0x0


gdt_code:                               ; code segment descriptor
    dw 0xffff                           ; segment length, bits 0-15
    dw 0x0                              ; segment base, bits 0-15
    db 0x0                              ; segment base, bits 16-23
    db 10011010b                        ; flags (8 bits)
    db 11001111b                        ; flags (4 bits) + segment length, bits 16-19
    db 0x0                              ; segment base, bits 24-31


gdt_data:                               ; data segment descriptor
    dw 0xffff                           ; segment length, bits 0-15
    dw 0x0                              ; segment base, bits 0-15
    db 0x0                              ; segment base, bits 16-23
    db 10010010b                        ; flags (8 bits)
    db 11001111b                        ; flags (4 bits) + segment length, bits 16-19
    db 0x0                              ; segment base, bits 24-31

gdt_end:

; GDT descriptor
gdt_descriptor:
    dw gdt_end - gdt_start - 1           ; size (16 bit)
    dd gdt_start                         ; address (32 bit)

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

; ===========================================================================
; 32 bit mode handling
; ===========================================================================

[bits 16]
switch_to_32bit:
    cli                                 ; Disable Interrupts
    lgdt [gdt_descriptor]               ; Load GDT descriptor
    mov eax, cr0
    or eax, 0x1                         ; Enable protected mode
    mov cr0, eax
    jmp CODE_SEG:init_32bit             ; Jump  to init_32bit

[bits 32]
init_32bit:
    mov ax, DATA_SEG
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x90000                    ; Setup stack
    mov esp, ebp

    call BEGIN_32BIT

[bits 32]
BEGIN_32BIT:                            ; Called from 32bit.asm
    call KERNEL_OFFSET                  ; give control to the kernel
    jmp $                               ; loop in case kernel returns


; ===========================================================================
; Disk Handling
; ===========================================================================

disk_load:
    pusha
    push dx

    mov ah, 0x02                        ; read mode
    mov al, dh                          ; read dh number of sectors
    mov cl, 0x02                        ; start from sector 2
                                        ; (as sector 1 is our boot sector)
    mov ch, 0x00                        ; cylinder 0
    mov dh, 0x00                        ; head 0

                                        ; dl = drive number is set as input to disk_load
                                        ; es:bx = buffer pointer is set as input as well

    int 0x13                            ; BIOS interrupt
    jc disk_error                       ; check carry bit for error

    pop dx                              ; get back original number of sectors to read
    cmp al, dh                          ; BIOS sets 'al' to the # of sectors actually read
                                        ; compare it to 'dh' and error out if they are not equal

    jne sectors_error
    popa
    ret

disk_error:
    jmp disk_loop

sectors_error:
    jmp disk_loop

disk_loop:
    jmp $

BOOT_DRIVE db 0                         ; Boot drive

; ===========================================================================
; Boot Sector
; ===========================================================================

times 510 - ($-$$) db 0                 ; Create 510 empty bytes
dw 0xAA55                               ; Append bytes 55 and AA (boot signature)