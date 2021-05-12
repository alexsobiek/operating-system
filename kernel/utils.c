# include "kernel.h"
# include "../lib/stdio/stdio.h"

char* getKernelVersion() {
    return "v0.0.1";
}


void printMOTD() {
    println("==========================================");
    println("Operating System");
    print("Running kernel version ");
    println(getKernelVersion());
    println("Developed by Alex Sobiek");
    println("May 12, 2021");
    println("==========================================");
}