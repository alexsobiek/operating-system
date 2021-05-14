// ===========================================================================
// Super simple operating system kernel
// Authored by Alexander Sobiek, 2021
// ===========================================================================

# include "kernel.h"
# include "../drivers/vga/vga.h"
# include "../drivers/keyboard/keyboard.h"
# include "../lib/stdio/stdio.h"

void handleInput() {

}

/**
 * Kernel entry point
 * @return int
 */
int main() {
    setVGAColorScheme(GREY, BLUE);
    initDefaultVGA();
    printMOTD();
    handleInput();
    return 0;
}