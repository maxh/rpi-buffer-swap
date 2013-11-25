.section .init
.globl _start

_start:
b main

.section .text

main:
// www.cl.cam.ac.uk/projects/raspberrypi/tutorials/os/ok03.html#newbeginning
mov sp,#0x8000

// Send tags to initialize framebuffer.
ldr r0,=FrameBufferInitTags
and r0,#0xFFFFFFF0
orr r0,#8
ldr r1,=0x2000b8a0
str r0,[r1]

// Test for an error response code from the mailbox.
ldr r0,=FrameBufferInitTags
ldr r1,[r0,#4]
mov r0,#3 // Flash three times.
cmp r1,#0x80000000
blne DebugFlash

bl Pause
bl Pause

// Read the frame buffer base address.
// github.com/raspberrypi/firmware/wiki/Mailbox-property-interface#allocate-buffer
ldr r0,=FrameBufferInitTags
ldr r5,[r0,#76]

	mov r8,r5 // Current pixel.
	ldr r6,=1843200 // 1280 * 720 * 2
	add r6,r5
	mov r7,#0xFF
	drawPixel$:
		strh r7,[r8]
		add r8,#2
		cmp r8,r6
		bne drawPixel$	
	ldr r4,=1843200
	add r6,r4 // Last pixel.
	mov r7,#0xFF00
	drawOffsetPixel$:
		strh r7,[r8]
		add r8,#2
		cmp r8,r6
		bne drawOffsetPixel$

drawScreen$:
/*	mov r8,r5 // Current pixel.
	ldr r6,=1843200 // 1280 * 720 * 2
	add r6,r5
	mov r7,#0xFF
	drawPixel$:
		strh r7,[r8]
		add r8,#2
		cmp r8,r6
		bne drawPixel$
	add r7,#0x8
*/
	// Display the non-offset buffer.
	ldr r0,=FrameBufferSwapTag
	mov r1,#0
	str r1,[r0,#4] // Indicate this is a request.
	str r1,[r0,#20]
	str r1,[r0,#24]
	str r1,[r0,#28]
	mov r1,#32
	str r1,[r0]
	ldr r1,=0x00048009
	str r1,[r0,#8]
	mov r1,#20
	str r1,[r0,#12]
	mov r1,#8
	str r1,[r0,#16]

	and r0,#0xFFFFFFF0
	mov r1,#8
	bl MailboxWrite

//	orr r0,#8
//	ldr r1,=0x2000b8a0
//	str r0,[r1]

	// Test for an error response code from the mailbox.
	ldr r0,=FrameBufferSwapTag
	ldr r1,[r0,#4]
	mov r0,#2 // Flash to indicate failure.
	cmp r1,#0x80000001
	blne DebugFlash

	// Wait for message to get through.
	bl Pause
	bl Pause
/*	
	ldr r4,=1843200
	add r6,r4 // Last pixel.
	mov r7,#0xFF00
	drawOffsetPixel$:
		strh r7,[r8]
		add r8,#2
		cmp r8,r6
		bne drawOffsetPixel$
*/
	// Display the offset buffer.
	ldr r0,=FrameBufferSwapTag
	mov r1,#0
	str r1,[r0,#4] // Indicate this is a request.
	str r1,[r0,#20]
	str r1,[r0,#28]
	mov r1,#32
	str r1,[r0]
	ldr r1,=0x00048009
	str r1,[r0,#8]
	mov r1,#20
	str r1,[r0,#12]
	mov r1,#8
	str r1,[r0,#16]
	mov r1,#720
	str r1,[r0,#24] // Y offset is the 7th word (offset 6*4 = 24).
	and r0,#0xFFFFFFF0
//	orr r0,#8
//	ldr r1,=0x2000b8a0
//	str r0,[r1]
	mov r1,#8
	bl MailboxWrite
	
	// Test for an error response code from the mailbox.
	ldr r0,=FrameBufferSwapTag
	ldr r1,[r0,#4]
	mov r0,#1 // Flash to indicate failure.
	cmp r1,#0x80000001
	blne DebugFlash

	bl Pause
	bl Pause	

	b drawScreen$
