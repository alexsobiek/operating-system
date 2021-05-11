; ===========================================================================
; Simple assembly program to call our kernel's main function
; ===========================================================================

[bits 32]
[extern main]
call main
jmp $