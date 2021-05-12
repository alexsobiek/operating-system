// ===========================================================================
// Super simple operating system kernel
// Authored by Alexander Sobiek, 2021
//===========================================================================

# include "kernel.h"
# include "../lib/stdio/stdio.h"

/**
 * Kernel entry point
 * @return int
 */
int main() {
    setVGAColorScheme(YELLOW, BLACK);
    initDefaultVGA();
    println("Simple Operating System");
    println("Developed by Alex Sobiek");
    println("May 12, 2021");
    return 0;
}