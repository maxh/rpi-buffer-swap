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

/*
// Test for an error response code from the mailbox.
ldr r0,=FrameBufferInitTags
add r0,#4 // The memory address of the response code.
ldr r1,[r0]
mov r0,#3 // Flash three times.
cmp r1,#0x80000000
blne DebugFlash
*/

bl Pause
bl Pause

// Read the frame buffer base address.
// github.com/raspberrypi/firmware/wiki/Mailbox-property-interface#allocate-buffer
ldr r0,=FrameBufferInitTags
ldr r5,[r0,#76]
mov r0,#0xFF
strh r0,[r5]

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
	
drawScreen$:
	mov r8,r5 // Current pixel.
	ldr r6,=1843200 // 1280 * 720 * 2
	add r6,r5
	mov r7,#0xFF
	drawPixel$:
		strh r7,[r8]
		add r8,#2
		cmp r8,r6
		bne drawPixel$
/*	
	// Display the non-offset buffer.
	ldr r0,=FrameBufferSwapTag
	mov r1,#0
	str r1,[r0,#4] // Indicate this is a request.
	str r1,[r0,#24] // Y offset is the 7th word (offset 6*4 = 24).
	and r0,#0xFFFFFFF0
	orr r0,#8
	ldr r1,=0x2000b8a0
	str r0,[r1]
*/
	// Wait for message to get through.
	bl Pause
	bl Pause

	ldr r6,=1843200
	add r6,r6 // Last pixel.
	mov r7,#0xFF00
	drawOffsetPixel$:
		strh r7,[r8]
		add r8,#2
		cmp r8,r6
		bne drawOffsetPixel$

	// Display the offset buffer.
	ldr r0,=FrameBufferSwapTag
//	mov r0,#0
//	str r0,[r0,#4] // Indicate this is a request.
//	mov r1,#720
//	str r1,[r0,#24] // Y offset is the 7th word (offset 6*4 = 24).
	and r0,#0xFFFFFFF0
	orr r0,#8
	ldr r1,=0x2000b8a0
	str r0,[r1]

	// Wait for message to get through.
	bl Pause
	bl Pause

	b drawScreen$
