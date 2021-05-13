// ===========================================================================
// Super simple operating system kernel
// Authored by Alexander Sobiek, 2021
//===========================================================================

# include "kernel.h"
# include "../drivers/vga/vga.h"

/**
 * Kernel entry point
 * @return int
 */
int main() {
    setVGAColorScheme(GREY, BLUE);
    initDefaultVGA();
    printMOTD();
    return 0;
}