# Operating System
My attempt at making a very basic operating system. Eventually, I have hopes of naming this project other than 
"Operating System", but I always find myself with a lack of creativity when it comes to naming.

## Project Goals
As I've been learning assembly and finding interest in C, I've decided it would be a nice challenge for me to create a 
*very* basic operating system. The current goal is to boot, call some C methods, and create an echo command which will 
print out any string supplied on a new line. I will document significant progress in this README below.

## Booting with QEMU
As my main development machine runs Mac OS, I've followed 
[ordmilko/i686-elf-tools](https://github.com/lordmilko/i686-elf-tools#mac-os-x) for Mac OS to get the cross-compiler 
and linker working happily. If installed properly, running `make` will assemble, compile, link, and boot QEMU. 

## Progress
I moved the progress to its own dedicated file so this README isn't overly crowded.
[Click here here for the timeline](https://github.com/alexsobiek/operating-system/blob/main/docs/progress.md)