.globl GetMailboxBase
GetMailboxBase:
	ldr r0,=0x2000B880
	mov pc,lr

// Writes the value in the top 28 bits of r0 to the mailbox channel in r1.
.globl MailboxWrite
MailboxWrite:
	// Validate input.
	tst r0,#0b1111
	movne pc,lr
	cmp r1,#15
	movhi pc,lr
	
	push {lr}
	channel .req r1	
	message .req r2
	mov message,r0
	
	bl GetMailboxBase
	mailboxAddr .req r0

	// Combine the channel and the message into a single 4-byte value.
	add message,channel

	// Loop until top bit of status code is 0.
	// What happens if it's never 0?
	loop0$:
		push {r0,r1,r2,lr}
		mov r0,#1
		bl DebugFlash
		pop {r0,r1,r2,lr}
		status .req r3
		ldr status,[mailboxAddr,#0x18]
		tst status,#0x80000000
		.unreq status
		bne loop0$

	str message,[mailboxAddr,#0x20]
	.unreq channel
	.unreq message
	.unreq mailboxAddr
	
	pop {pc}
	
// Read one message from mailbox channel r0.
.globl MailboxRead
MailboxRead:
	cmp r0,#15
	movhi pc,lr

	channel .req r1
	mov channel,r0

	push {lr}
	bl GetMailboxBase
	mailboxAddr .req r0

	// Loop until 30th bit of status code is 0.
	loop1$:
		status .req r2
		ldr status,[mailboxAddr,#0x18]
		tst status,#0x40000000
		.unreq status
		bne loop1$

	message .req r2
	ldr message,[mailboxAddr,#0] // Read address is offset 0 bytes.

	// Check to see if the message came on the right channel.
	inchannel .req r3
	and inchannel,message,#0xf
	teq channel,inchannel
	.unreq inchannel
	bne loop1$ // If it's the wrong channel, loop again.

	.unreq channel
	.unreq mailboxAddr
	
	and r0,message,#0xfffffff0
	
	.unreq message	

	pop {pc}
