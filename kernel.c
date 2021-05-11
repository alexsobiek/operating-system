// ===========================================================================
// Super simple operating system kernel
// Authored by Alexander Sobiek, 2021
//===========================================================================

void print(unsigned int color, const char *string) {
    volatile char *video = (volatile char*)0xB8000;
    unsigned int i = 0;
    unsigned int j = 0;
    unsigned int vSize = 4000;      // 25 lines, 80 columns, 2 bytes each (25 * 80 * 2)

    while(i < vSize) {              // Fill up video memory with blank characters
        video[i] = ' ';             // Set blank character to clear the screen
        video[i+1] = 0x07;          // Write light grey color as next byte
        i += 2;                     // Increase 2 bytes
    }
    i = 0;

    while(string[i] != '\0') {      // Write string to video memory
        video[j] = string[i];       // Print the character
        video[j+1] = color;         // Write the color as the next byte
        i++;                        // Increase i to move onto the next char
        j += 2;                     // Increase 2 bytes
    }
    return;
}

/**
 * Kernel entry point
 * @return int
 */
int main() {
    print(2, "Super simple operating system!"); // Print string with color 2 (Green)
}


