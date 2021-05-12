// ===========================================================================
// Super simple operating system kernel
// Authored by Alexander Sobiek, 2021
//===========================================================================

#include "kernel.h"

/**
 * Kernel entry point
 * @return int
 */
int main() {
    initDefaultVGA();
    vga_buffer[0] = makeVGAChar('T', WHITE, BRIGHT_BLUE);
    vga_buffer[1] = makeVGAChar('E', WHITE, BRIGHT_BLUE);
    vga_buffer[2] = makeVGAChar('S', WHITE, BRIGHT_BLUE);
    vga_buffer[3] = makeVGAChar('T', WHITE, BRIGHT_BLUE);
}


