.section .init
.globl _start

_start:
b main

.section .text

main:
// www.cl.cam.ac.uk/projects/raspberrypi/tutorials/os/ok03.html#newbeginning
mov sp,#0x8000
mov r0,#4
bl DebugFlash

loop$:
	b loop$
