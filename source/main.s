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
mov r1,#8
bl MailboxWrite

bl Pause

// Read the frame buffer base address.
// github.com/raspberrypi/firmware/wiki/Mailbox-property-interface#allocate-buffer
ldr r0,=FrameBufferInitTags
ldr r5,[r0,#76]

/* Set each pixel in the non-offset frame buffer to blue. */
mov r8,r5 // Current pixel.
ldr r6,=1843200 // 1280 * 720 * 2
add r6,r5
mov r7,#0xFF // Blue.
drawPixel$:
	strh r7,[r8]
	add r8,#2
	cmp r8,r6
	bne drawPixel$	

/* Set each pixel in the offset frame buffer to yellow. */
ldr r4,=1843200
add r6,r4 // Last pixel
mov r7,#0xFF00 // Yellow
drawOffsetPixel$:
	strh r7,[r8]
	add r8,#2
	cmp r8,r6
	bne drawOffsetPixel$

toggleBuffer$:
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

	bl Pause // Wait for message to get through.

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
	mov r1,#8
	bl MailboxWrite

	bl Pause	

	b toggleBuffer$
