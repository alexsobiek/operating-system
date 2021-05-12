#ifndef KERNEL_H
#define KERNEL_H

typedef unsigned char uint8;
typedef unsigned short uint16;
typedef unsigned int uint32;

#define VGA_ADDRESS 0xB8000
#define BUFFER_SIZE 2200

enum VGA_COLOR {
    BLACK,
    BLUE,
    GREEN,
    CYAN,
    RED,
    MAGENTA,
    BROWN,
    GREY,
    DARK_GREY,
    BRIGHT_BLUE,
    BRIGHT_GREEN,
    BRIGHT_CYAN,
    BRIGHT_RED,
    BRIGHT_MAGENTA,
    YELLOW,
    WHITE
};

// VGA Variables
extern uint16* VGABuffer;
extern uint8 gForeground;
extern uint8 gBackground;
extern uint32 VGAPointer;
extern uint32 VGAIndex;

// VGA Functions
extern uint16 makeVGAChar(unsigned char c, uint8 foreground, uint8 background);
extern void clearVGABuffer(uint16 **buff, uint8 foreground, uint8 background);
extern void setVGAColorScheme(uint8 foreground, uint8 background);
extern void initVGA(uint8 foreground, uint8 background);
extern void initDefaultVGA();

#endif
