.section .init
.globl _start

_start:
b main

.section .text

main:
// www.cl.cam.ac.uk/projects/raspberrypi/tutorials/os/ok03.html#newbeginning
mov sp,#0x8000

/*
mov r0,#1
bl DebugFlash
bl Pause
bl Pause
*/
	
// Send tags to initialize framebuffer.
ldr r0,=FrameBufferInitTags
and r0,#0xFFFFFFF0
orr r0,#8
ldr r1,=0x2000b8a0
str r0,[r1]

// Test for an error response code from the mailbox.
ldr r0,=FrameBufferInitTags
add r0,#4 // The memory address of the response code.
ldr r1,[r0]
mov r0,#3 // Flash three times.
cmp r1,#0x80000000
blne DebugFlash

// Read the frame buffer base address.
// github.com/raspberrypi/firmware/wiki/Mailbox-property-interface#allocate-buffer
ldr r0,=FrameBufferInitTags
add r0,#76
ldr r5,[r0]
mov r2,#0xFF
str r2,[r5]

/*
// Send swap tag.
ldr r0,=FrameBufferSwapTag
and r0,#0xFFFFFFF0
orr r0,#8
ldr r1,=0x2000b8a0
str r0,[r1]

// Test for an error response code from the mailbox.
ldr r0,=FrameBufferSwapTag
add r0,#4 // The memory address of the response code.
ldr r1,[r0]
mov r0,#3 // Flash three times to indicate failure.
cmp r1,#0x80000000
blne DebugFlash
*/
// Get the first byte of the offset framebuffer.
ldr r6,=3686400
add r6,r5

mov r7,#0xFF // Color.
drawScreen$:	
	mov r8,r5 // Current pixel.
	drawPixel$:
		str r7,[r8]
		add r8,#2
		cmp r8,r6
		bne drawPixel$
	add r7,#0xFF
	bl Pause
	b drawScreen$
loop$:
	b loop$
