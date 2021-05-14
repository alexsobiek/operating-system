# include "kernel.h"
# include "../lib/stdio/stdio.h"

char* getKernelVersion() {
    return "v0.0.1";
}
char* getBuildType() {
    return "Development Build (May 12, 2021)";
}

void printMOTD() {
    println("==============================================");
    println("Operating System");
    print("Kernel Version: ");
    println(getKernelVersion());
    print("Build Type: ");
    println(getBuildType());
    println("Developed by Alex Sobiek");
    println("==============================================");
}

