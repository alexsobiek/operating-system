# include "vga.h"

uint16* VGABuffer;                   // VGA buffer

uint32 VGAPointer;
uint32 VGAIndex;

uint8 gForeground = WHITE;          // default foreground color
uint8 gBackground = BRIGHT_BLUE;    // default background color

/**
 * Sets the default VGA color scheme
 * @param foreground VGA Color
 * @param background VGA Color
 */
void setVGAColorScheme(uint8 foreground, uint8 background) {
    gForeground = foreground;
    gBackground = background;
}

/**
 * Creates a character with proper VGA formatting
 * @param c Character
 * @param foreground VGA Color
 * @param background VGA Color
 * @return unit16
 */
uint16 makeVGAChar(unsigned char c, uint8 foreground, uint8 background) {
    uint16 ax;      // 16 bit video register
    uint8 ah;       // 8 bit video color, first 4 are foreground, second 4 are background
    uint8 al;       // Character

    ah = background;
    ah <<= 4;
    ah |= foreground;
    ax = ah;
    ax <<= 8;
    al = c;
    ax |= al;

    return ax;
}

/**
 * Clears the VGA Buffer with the provided colors
 * @param buffer Buffer to clear
 * @param foreground VGA Color
 * @param background VGA Color
 */
void clearVGABuffer(uint16 **buff, uint8 foreground, uint8 background) {
    for (uint32 i = 0; i < BUFFER_SIZE; i++) (*buff)[i] = makeVGAChar(0x0, foreground, background);
    VGAPointer = 0;
    VGAIndex = 1;
}

/**
 * Initializes the VGA Buffer
 * @param foreground VGA Color
 * @param background VGA Color
 */
void initVGA(uint8 foreground, uint8 background) {
    VGABuffer = (uint16*)VGA_ADDRESS;
    clearVGABuffer(&VGABuffer, foreground, background);
}

void initDefaultVGA() {
    initVGA(gForeground, gBackground);
}
