# include "kernel.h"

uint16* vga_buffer;

/**
 * Creates a character with proper VGA formatting
 * @param c Character
 * @param foreground VGA Color
 * @param background VGA Color
 * @return unit16
 */
uint16 makeVGAChar(unsigned char c, uint8 foreground, uint8 background) {
    uint16 ax = 0;      // 16 bit video register
    uint8 ah = 0;       // 8 bit video color, first 4 are foreground, second 4 are background
    uint8 al = 0;       // Character

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
void clearVGABuffer(uint16 **buffer, uint8 foreground, uint8 background) {
    for (uint32 i = 0; i < BUFFER_SIZE; i++) (*buffer)[i] = makeVGAChar(' ', foreground, background);
}

/**
 * Initializes the VGA Buffer
 * @param foreground VGA Color
 * @param background VGA Color
 */
void initVGA(uint8 foreground, uint8 background) {
    vga_buffer = (uint16*)VGA_ADDRESS;
    clearVGABuffer(&vga_buffer, foreground, background);
}

void initDefaultVGA() {
    initVGA(BLACK, BRIGHT_BLUE);
}



