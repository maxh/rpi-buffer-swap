.section .data
.align 4

.globl FrameBufferInitTags
FrameBufferInitTags:
	.int 88 // Buffer size in bytes.  22*8
	.int 0 // Indicates this is a request.

	.int 0x00048003 // Tag id for set physical size.
	.int 8 // Value buffer size (bytes)
	.int 8 // Req. + value length (bytes)
	.int 1280
	.int 720

	.int 0x00048004 // Tag id for set virtual size
	.int 8 // Value buffer size (bytes)
	.int 8 // Req. + value length (bytes)
	.int 1280
	.int 1440 // 720 * 2.

	.int 0x00048005 // Tag id for set depth
	.int 4 // Value buffer size (bytes)
	.int 4 // Req. + value length (bytes)
	.int 16 // 16 bits per pixel

	.int 0x00040001 // Tag id for allocate framebuffer
	.int 8 // Value buffer size (bytes)
	.int 4 // Req. + value length (bytes)
	.int 16 // Alignment = 16 ; 20th element in list
	.int 0 // Space for response

	.int 0 // Terminating tag

.align 4	

.globl FrameBufferSwapTag
FrameBufferSwapTag:
	.word 28 // 7*4 = request length in bytes.
	.word 0 // Indicates this is a request
	
	.word 0x00048009 // Set virtual offset
	.word 20 // Tag buffer size in bytes
	.word 8 // Tag value size in bytes
	.word 0 // X in pixels
	.word 720 // Y in pixels
	
	.int 0
	
.section .text
